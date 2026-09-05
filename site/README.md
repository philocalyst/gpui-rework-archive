# GPUI Community Edition — the field guide

A real Zola publication: 39 recovered documentation pages, project notes, and interactive Rust/WebAssembly experiments. The original `gpui-ce-docs` checkout is source material and is not modified. The working site lives here.

## Preview and build

Install **Zola 0.23.4** (for example, `brew install zola`). This version uses Tera 2 components; older Zola shortcode syntax is intentionally not used.

From the repository root:

```sh
zola --root site serve --interface 127.0.0.1 --port 1111
# Open http://127.0.0.1:1111
./site/scripts/build.sh
```

The production output is `site/public/`. Serve that directory with any static HTTP server. The committed WASM distribution means publishing or editing Markdown requires no Rust compilation, Node, client framework, runtime CDN, or database.

The production URL is configured in `site/zola.toml`. For another host, run `zola --root site build --base-url https://your-host.example`. The actual GPUI renderer distribution currently expects to be hosted at the site root; see the WASM notes below when using a URL subdirectory.

## Authoring

Write chapters under `content/guide/`, and experiments under `content/examples/`. Front matter contains `title`, `description`, `weight`, and `extra.category`. Transparent subsections flatten the original documentation into the field guide while preserving its paths. The navigation is derived from those pages.

A reusable Tera 2 component embeds an experiment directly in Markdown:

```text
{{ <playground example="counter" title="The observable counter" number="01" label="Entity state" /> }}
```

Available experiments: `counter`, `layout`, and `interaction`. The same component is used by tutorial chapters and the landing page. The live counter’s Source is loaded from its compiled Rust entry point; browser studies show their corresponding GPUI pattern and the actual Rust/WASM state module. Zola highlights all of it at build time. The component definitions currently live in `templates/shortcodes/` as the successor to the old Typst disclosure component, but use Zola 0.23 component syntax.

```text
{% <disclosure title="A little more detail"> %}
Markdown goes here.
{% </disclosure> %}
```

Use `@/guide/...md` internal links so Zola validates their targets. `page.toc` supplies the chapter contents. Legacy `.html` URLs are preserved with Zola aliases. Root-level page titles and weights come from Markdown, not duplicated navigation arrays.

## WebAssembly and JavaScript

`wasm/` contains the Rust state module. `wasm/gpui-demo/` builds the actual GPUI counter as an isolated iframe document, accommodating the backend’s one-window-per-document constraint. The native `<gpui-playground>` element manages the example controls and source/result switch. The other experiments explicitly identify their semantic HTML previews as browser studies driven by compiled Rust/WASM.

To regenerate the checked-in distributions, install the Rust `wasm32-unknown-unknown` target and Trunk, then run:

```sh
./site/scripts/build-wasm.sh
```

The background field uses native WebGL and the Rust module’s `field_phase` export. Browser JavaScript is limited to this draw loop, WASM loading, and the custom element. It respects reduced motion and pauses when the browser tab is hidden. No animation library or client-side syntax highlighter is shipped.

The GPUI renderer’s Trunk `--public-url` must match its deployment location (`/components/gpui-demo/` for root deployments). If publishing under a subdirectory, rebuild it with the corresponding prefix. Zola-managed links, fonts, styles, and the lightweight WASM loader resolve through the configured base URL or relative module URLs.

## Design constraints

Semantic elements carry layout and content. No authored generic `div` or `span` wrappers are used in the publication. Generated syntax tokens are the deliberate exception: Giallo emits spans and classes, and `static/syntax.css` supplies their OKLCH palette. The framework’s own Rust `div()` elements are GPUI elements, not HTML wrappers.

All authored CSS colors use OKLCH. Flex wrapping, intrinsic grids, `min()`, and `clamp()` provide responsive behavior without CSS media queries. Fonts are self-hosted and include their licenses. The full-screen GPU halftone field degrades to an etched CSS background. The landing page is tested to fit in one 900px-high desktop screen at 1024px and 1440px widths.

## Verification

```sh
./site/scripts/build.sh
# Browser checks (development-only dependency):
cd site
npm ci
npx playwright install chromium
npm test
```

`check-site.py` audits every generated page for local assets, internal links and anchors, duplicate IDs, semantic structure, and CSS constraints. Browser tests exercise source/result switching, actual GPUI canvas redraws, keyboard controls, Rust/WASM studies, viewport overflow, shader acceleration and pause, reduced motion, and no-JavaScript reading. `wasm-build-manifest.json` detects stale source or compiled distributions and is regenerated by the WASM build script.

`migration-manifest.json` maps every recovered original page to its Markdown destination and records the original code-block count (141 total). Original technical prose and source snippets are preserved; editorial metadata, source links, and interactive inserts are new. Recovery was from the complete `gpui-ce-docs/build/html` publication because only the initial shell remained in its Typst source directory.

## Delivery

The repository workflow builds and checks the static site, then uploads `site/public` as a downloadable artifact. It does not change the public website. To publish, deploy that directory to your static host with `.wasm` served as `application/wasm` (the loader also has a byte-buffer fallback).
