"""Parse the small documentation DSL embedded in Rust source files.

The parser is intentionally strict. A source file either contains no docs
markers or contains complete, non-nested steps with prose and code.
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


_STEP = re.compile(r"^\s*//\s*docs:step\s+([a-z0-9][a-z0-9-]*)\s*\|\s*(\S.*)$")
_API = re.compile(r"^\s*//\s*docs:api\s+(.+?)\s*$")
_CODE = re.compile(r"^\s*//\s*docs:code\s*$")
_END = re.compile(r"^\s*//\s*docs:end\s*$")
_ANY = re.compile(r"docs:(?:step|api|code|end)\b")
_RAW_START = re.compile(r"r(#+)?\"")


def _lexical_marker_state(line: str, block_depth: int, raw_end: str | None, quote: bool = False):
    """Return state after a line, ignoring strings and block comments.

    This is a deliberately small lexer, sufficient to prevent accidental
    marker recognition in Rust raw/multiline strings and block comments while
    leaving ordinary `// docs:*` comments available to the DSL.
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
        if line.startswith("//", i):
            break
        if line.startswith("/*", i):
            block_depth += 1; i += 2; continue
        if quote:
            if line[i] == '\\': i += 2; continue
            if line[i] == '"': quote = False
            i += 1
            continue
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


def parse_source(path: str | Path, text: str | None = None) -> list[Step]:
    path = Path(path)
    text = path.read_text(encoding="utf-8") if text is None else text
    text = text.replace("\r\n", "\n").replace("\r", "\n")
    lines = text.splitlines()
    steps: list[Step] = []
    current: Step | None = None
    mode: str | None = None
    seen: set[str] = set()
    block_depth, raw_end, quote = 0, None, False

    for number, line in enumerate(lines, 1):
        marker_allowed = block_depth == 0 and raw_end is None
        if marker_allowed and _ANY.search(line) and not (
            _STEP.match(line) or _API.match(line) or _CODE.match(line) or _END.match(line)
        ):
            # Marker-looking text in an ordinary Rust line is almost certainly
            # a typo; marker text in a string/comment is diagnosed below.
            if "docs:" in line and not line.lstrip().startswith("//"):
                raise DocumentationError(path, number, "documentation marker must be a line comment")

        if marker_allowed:
            if line.lstrip().startswith("//") and _ANY.search(line) and not (
                _STEP.match(line) or _API.match(line) or _CODE.match(line) or _END.match(line)
            ):
                raise DocumentationError(path, number, "malformed documentation directive")
            match = _STEP.match(line)
            if match:
                if current:
                    raise DocumentationError(path, number, "nested step; close the previous step first")
                slug, title = match.groups()
                if slug in seen:
                    raise DocumentationError(path, number, f"duplicate step id {slug!r}")
                seen.add(slug)
                current = Step(slug, title.strip(), number)
                mode = "prose"
                steps.append(current)
                block_depth, raw_end, quote = _lexical_marker_state(line, block_depth, raw_end, quote)
                continue
            match = _API.match(line)
            if match:
                if not current or mode != "prose":
                    raise DocumentationError(path, number, "docs:api must appear inside a step before docs:code")
                symbols = [s for s in match.group(1).split() if s]
                if not symbols:
                    raise DocumentationError(path, number, "docs:api requires at least one API symbol")
                current.api.extend(symbols)
                block_depth, raw_end, quote = _lexical_marker_state(line, block_depth, raw_end, quote)
                continue
            if _CODE.match(line):
                if not current:
                    raise DocumentationError(path, number, "unmatched docs:code")
                if mode != "prose":
                    raise DocumentationError(path, number, "duplicate docs:code")
                if not current.prose:
                    raise DocumentationError(path, number, "step has no markdown prose")
                mode = "code"
                current.code_start = number + 1
                block_depth, raw_end, quote = _lexical_marker_state(line, block_depth, raw_end, quote)
                continue
            if _END.match(line):
                if not current:
                    raise DocumentationError(path, number, "unmatched docs:end")
                if mode != "code":
                    raise DocumentationError(path, number, "step has no code block")
                if not current.code:
                    raise DocumentationError(path, number, "step has empty code")
                current.source_end = number
                current = None
                mode = None
                block_depth, raw_end, quote = _lexical_marker_state(line, block_depth, raw_end, quote)
                continue

        if current and mode == "prose":
            if not line.lstrip().startswith("//"):
                raise DocumentationError(path, number, "step prose must use line comments")
            current.prose.append(line.lstrip()[2:].lstrip())
        elif current and mode == "code":
            current.code.append(line)
        block_depth, raw_end, quote = _lexical_marker_state(line, block_depth, raw_end, quote)
        if not marker_allowed and _ANY.search(line):
            raise DocumentationError(path, number, "documentation marker appears inside a string or block comment")

    if current:
        raise DocumentationError(path, len(lines) or 1, "unterminated documentation step")
    return steps
