"""Parse the small documentation DSL embedded in Rust source files.

Authors write Markdown comments followed by ordinary Rust. Headings divide
chapters; Rustdoc-style links supply exact API targets and reciprocal links.
"""

from __future__ import annotations

from dataclasses import dataclass, field
import re
from pathlib import Path


class DocumentationError(ValueError):
    def __init__(self, path: Path, line: int, message: str):
        super().__init__(f"{path}:{line}: {message}")
        self.path, self.line, self.message = path, line, message


@dataclass
class Step:
    slug: str
    title: str
    source_start: int
    source_end: int = 0
    prose: list[str] = field(default_factory=list)
    code: list[str] = field(default_factory=list)
    code_start: int = 0
    api: list[str] = field(default_factory=list)


# A Markdown heading starts a chapter; ordinary Rust starts its code block.
# An optional explicit anchor keeps published links stable when a title changes.
_STEP = re.compile(r"^\s*// ## (.+?)(?: \{#([a-z0-9][a-z0-9-]*)\})?\s*$")
_REFERENCE = re.compile(r"\[`([A-Za-z_][A-Za-z0-9_:]*)`\](?![\[(])")
_RAW_START = re.compile(r"r(#+)?\"")
_CHAR = re.compile(r"'(?:\\(?:u\{[0-9a-fA-F_]+\}|x[0-9a-fA-F]{2}|.)|[^'\\\n])'")


def _lexical_marker_state(line: str, block_depth: int, raw_end: str | None, quote: bool = False):
    """Return state after a line, ignoring strings and block comments.

    This is a deliberately small lexer, sufficient to prevent accidental
    marker recognition in Rust raw/multiline strings and block comments while
    leaving ordinary line comments available for Markdown chapters.
    """
    i = 0
    while i < len(line):
        if raw_end:
            end = line.find(raw_end, i)
            if end < 0:
                return block_depth, raw_end, quote
            i = end + len(raw_end)
            raw_end = None
            continue
        if block_depth:
            if line.startswith("/*", i):
                block_depth += 1; i += 2
            elif line.startswith("*/", i):
                block_depth -= 1; i += 2
            else:
                i += 1
            continue
        if quote:
            if line[i] == '\\': i += 2; continue
            if line[i] == '"': quote = False
            i += 1
            continue
        if line.startswith("//", i):
            break
        if line.startswith("/*", i):
            block_depth += 1; i += 2; continue
        char = _CHAR.match(line, i)
        if char:
            i = char.end(); continue
        if line[i] == '"':
            quote = True; i += 1
            continue
        match = _RAW_START.match(line, i)
        if match:
            hashes = match.group(1) or ""
            raw_end = '"' + hashes
            i = match.end()
            continue
        i += 1
    return block_depth, raw_end, quote


def api_references(prose: str, catalog: dict | None = None) -> list[str]:
    """Resolve Rustdoc-style links against the site's explicit API catalog."""
    symbols = []
    for name in _REFERENCE.findall(prose):
        if catalog is None:
            symbol = name if name.startswith("gpui::") else "gpui::" + name
        else:
            matches = [key for key in catalog if key == name or key == "gpui::" + name]
            if len(matches) != 1:
                raise ValueError(f"unknown API link [`{name}`]; add its exact target to examples.toml")
            symbol = matches[0]
        if symbol not in symbols:
            symbols.append(symbol)
    return symbols


def parse_source(path: str | Path, text: str | None = None, *, catalog: dict | None = None) -> list[Step]:
    """Read Markdown comments followed by ordinary Rust, with no closing markers.

    Comments inside a code block remain Rust comments. Only a top-level `// ##`
    heading begins another step. Strings and block comments cannot create steps.
    """
    path = Path(path)
    text = path.read_text(encoding="utf-8") if text is None else text
    lines = text.replace("\r\n", "\n").replace("\r", "\n").splitlines()
    steps: list[Step] = []
    current: Step | None = None
    seen: set[str] = set()
    block_depth, raw_end, quote = 0, None, False

    def finish(end: int):
        if current is None:
            return
        while current.prose and not current.prose[-1].strip():
            current.prose.pop()
        while current.code and not current.code[-1].strip():
            current.code.pop()
        if not current.prose:
            raise DocumentationError(path, current.source_start, "chapter needs an explanation before its Rust")
        if not current.code:
            raise DocumentationError(path, current.source_start, "chapter needs Rust after its explanation")
        current.source_end = end
        try:
            current.api = api_references("\n".join(current.prose), catalog)
        except ValueError as error:
            raise DocumentationError(path, current.source_start, str(error)) from error

    for number, line in enumerate(lines, 1):
        marker_allowed = block_depth == 0 and raw_end is None and not quote
        heading = _STEP.match(line) if marker_allowed else None
        if heading:
            finish(number - 1)
            title, slug = heading.groups()
            slug = slug or re.sub(r"[^a-z0-9]+", "-", title.lower()).strip("-")
            if not slug or slug in seen:
                raise DocumentationError(path, number, f"duplicate or empty chapter anchor {slug!r}")
            seen.add(slug)
            current = Step(slug, title.strip(), number)
            steps.append(current)
        elif current and not current.code_start:
            if line.lstrip().startswith("//"):
                comment = line.lstrip()[2:]
                current.prose.append(comment[1:] if comment.startswith(" ") else comment)
            elif line.strip():
                current.code_start = number
                current.code.append(line)
        elif current:
            current.code.append(line)
        block_depth, raw_end, quote = _lexical_marker_state(line, block_depth, raw_end, quote)
    finish(len(lines))
    return steps
