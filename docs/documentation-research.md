# GPUI documentation research

Research brief for the Zola/docs.rs documentation refactor. Sources were checked on 2026-10-07 UTC. The supplied ecosystem review is treated as a useful field report, not as authority: claims below distinguish what was actually inspected from what the article merely links.

## Editorial north star

The review's strongest finding is that an API index is a map, not a journey. GPUI needs a small, deliberate path from “I have a window” to “I can build and debug a real interface,” while keeping every claim and symbol one click from its source of truth. Use Diátaxis as four reader intents: tutorials teach by doing; how-to guides solve a concrete problem; reference states exact behavior; explanations give reasons and trade-offs. A page may link across quadrants, but it should have one primary job.

Score every page against four independent axes: comprehensiveness (does it cover the necessary behavior and failure modes?), discoverability (can a reader find the next useful idea?), philosophy (does it explain why this API exists and what it trades away?), and approachability (can the intended reader start without guessing?). The article's conclusion is especially useful here: “bad docs are bugs,” and long, unannotated examples are not tutorials. A tutorial should evolve one runnable program in small steps, with prose explaining the decision at each step.

The proposed site should make those axes visible in its information architecture:

* **Learn:** one progressive, tested tutorial with checkpoints and a working artifact.
* **Build:** task-led recipes (input, layout, async work, text, rendering, debugging, hot reload).
* **Understand:** short design notes for GPUI's retained tree, entities, dispatch, display list, platform boundary, and rendering choices.
* **Reference:** docs.rs API pages, linked from every code symbol and indexed by concept as well as module.
* **Examples:** a searchable catalog of runnable examples. Each example has a stable slug, source link, API links, expected behavior, and copy/run controls.

The docs.rs crate should carry the implementation explanation that rustdoc can own: invariants, lifetimes, error/panic behavior, thread and platform assumptions, and links to exact example anchors. The Zola site should carry narrative context and complete applications. A post-processor can add links from rustdoc symbol anchors to example pages using a checked manifest; fail the build on a missing symbol or example slug rather than emitting a dead link.

## Example format and implementation contract

Use a small comment DSL in Rust source, designed to remain valid Rust and useful in an editor. Prefer explicit markers over line-number magic:

```rust
// docs:step start=window
Application::new()
// docs:step end=window
```

The renderer should produce a numbered, copyable listing, a focused explanation for the active step, and links to the corresponding API symbols. Keep the source canonical: the example must compile in CI (prefer doctests or a workspace example), and the rendered page must include the commit/version it was built from. The DSL parser should report duplicate names, unclosed ranges, unknown references, and stale symbol links as build errors.

Admonitions are semantic, not decoration: `note` adds context, `tip` gives a shortcut, `warning` names a footgun, and `error` describes a failure or unsupported assumption. Every warning should say what happens, when it happens, and the safe alternative.

## Lessons from the supplied ecosystem review

The article surveys `rand`, `fastrand`, `chrono`, `time`, `jiff`, `axum`, `actix-web`, `rocket`, `bevy`, `macroquad`, `fyrox`, `thiserror`, `anyhow`, `snafu`, `clap`, `pico-args`, `ratatui`, `egui`, `iced`, `wgpu`, `tokio`, `smol`, `embassy`, and Rust's official documentation. It praises `rand`'s book and migration material; `chrono`'s detailed recipes and domain links; `ratatui`'s incremental tutorials, examples, recipes, and “under the hood” pages; `embassy`'s user-problem-oriented guides; and the standard library's unusually rich behavior notes. It criticizes quick starts that are one large snippet, empty or misleading book navigation, module docs that merely repeat a name, and references that omit errors, panics, edge cases, and relationships.

The article's best case study is Jiff. Its README advertises documentation, comparison, design rationale, platform support, changelog, features, limitations, MSRV, and policy. Jiff exposes long Markdown documents through an internal `_documentation` module using `include_str!`, giving docs.rs readers the same source as repository readers. Its API pages explain common operations, exceptional cases, and alternatives without repeating shared material. GPUI should adopt the principle (one source, many surfaces), not blindly copy the module layout: keep long explanations in versioned Markdown and include them in rustdoc where that improves discovery.

The article also cautions against unqualified self-comparison. GPUI's comparison pages should state scope, version, and criteria; link competing projects; identify cases where GPUI is a poor fit; and separate observed behavior from opinion. A “limitations and non-goals” page is a feature, not an apology.

The per-project takeaways are useful as a compact test matrix:

| Surveyed project | Keep | Correct for GPUI |
| --- | --- | --- |
| `rand` | A real book, platform/reproducibility notes, migration pages, and domain vocabulary. | Do not hide the conceptual map behind the API index. |
| `fastrand` | Several tiny examples and explicit feature/WASM notes. | Avoid repeating the same sentence as documentation. |
| `chrono` | Recipes, rich type descriptions, caveats, and links to calendar concepts. | Put domain edge cases beside the task that triggers them. |
| `time` | An external book and explicit reference/how-to split. | Never publish empty chapters or leave high-value modules with one vague sentence. |
| `jiff` | Design/comparison/limitations, `include_str!` single source, substantive methods, errors, and alternatives. | Make rationale a first-class, versioned surface and compare fairly. |
| `axum`, `actix-web`, `rocket` | Framework guides, examples, and operational topics (state, requests, testing, deployment). | Organize GPUI recipes around user outcomes and lifecycle, not only modules. |
| `bevy` | A substantial book and community FAQ/discussions. | Add the missing explanation of why the architecture fits the problem. |
| `macroquad` | Very approachable visual examples and a dedicated site. | Pair visual payoff with the underlying event/layout/rendering explanation. |
| `fyrox` | A book with philosophy and data-management chapters. | Keep engine-wide concepts discoverable from every central type. |
| `thiserror`, `anyhow`, `snafu` | Guide material, comparison pages, feature notes, troubleshooting, and generated-code explanation. | Document error semantics and generated behavior, not just derive syntax. |
| `clap`, `pico-args` | Cookbook/FAQ/tutorial layering versus a minimal API. | Offer both the happy path and focused recipes for configuration and failure. |
| `ratatui` | Incremental tutorials, recipes, examples with visual output, showcase, FAQ, and under-the-hood notes. | Make every rendered GPUI example runnable, inspectable, and linked to a concept. |
| `egui`, `iced` | Multiple entry points and book material around application/element concepts. | Explain the relationship between framework objects before listing methods. |
| `wgpu` | A rich example/demo ecosystem and API reference. | Add narrative around the minimum rendering pipeline and its constraints. |
| `tokio`, `smol` | Tutorials, topic pages, blog-level design explanation, and executor comparison. | Explain scheduling, ownership, and responsiveness where async meets UI. |
| `embassy` | Short, user-problem-focused guides and a book for deeper learning. | Write recipes from the reader's observed problem, with platform-specific warnings. |
| Rust official docs | Layered Book, Reference, Rust by Example, Nomicon, standard library behavior notes. | Link concepts, not only symbols; make safety and failure behavior explicit. |

### Direct primary-page survey (2026-10-07 UTC)

I fetched and read the linked landing page or guide for each project below. Version numbers are what the live page exposed on the survey date; they are deliberately not treated as the article's 2025 snapshot. This is the concrete evidence behind the matrix above.

| Project / page read | Observed affordance and lesson for GPUI | Article-version contradiction or status |
| --- | --- | --- |
| [`rand`](https://docs.rs/rand/latest/rand/) 0.10.3 | Top-level quick start links to a book; distribution and RNG traits are explained before the item index. | Article inspected 0.9.1; current page is newer. |
| [`fastrand`](https://docs.rs/fastrand/latest/fastrand/) 2.5.0 | Multiple tiny, copyable examples (coin, choose, shuffle, seed, generated strings) make the simple crate legible. | Article's “repetitive” criticism remains a useful warning; current page fetched. |
| [`chrono`](https://docs.rs/chrono/latest/chrono/) 0.4.45 | Proleptic Gregorian scope, feature flags, signed duration distinction, timezone examples, and fallible constructors are visible in the overview. | Article saw 0.4.40; current page has same broad pattern with newer API. |
| [`time`](https://docs.rs/time/latest/time/) 0.3.55 | The landing page is feature-oriented and concise; reference navigation carries much of the burden. | Article saw 0.3.41 and reported sparse module prose; survey confirms concise landing page. |
| [`jiff`](https://docs.rs/jiff/latest/jiff/) 0.2.38 | Long conceptual overview, organized “remainder of documentation,” timestamp/zoned examples, and explicit type distinctions. | Article saw the then-current 0.1-era material; current page preserves the rationale-first approach. |
| [`axum`](https://docs.rs/axum/latest/axum/) 0.8.9 | Overview explains the Tower `Service` relationship, then routes, extractors, responses, state, middleware, and examples. | Article linked 0.8-era APIs; current page is 0.8.9 and confirms the layering. |
| [`actix-web`](https://docs.rs/actix-web/latest/actix_web/) 4.15.0 | Macro-based first example, followed by links to handlers, extractors, errors, and application structure. | Current live version postdates article; direct docs read. |
| [`Rocket` guide](https://rocket.rs/guide/v0.5/) | A guide-level table of contents covers requests, responses, state, fairings, testing, configuration, and deployment. | Article's v0.5 guide remains reachable; direct guide read. |
| [`bevy`](https://docs.rs/bevy/latest/bevy/) 0.19.1 | Quick code plus feature profiles, ECS concepts, schedules, resources, and system behavior in one landing page. | Article's version was older; current docs expose more feature detail. |
| [`macroquad`](https://macroquad.rs/) | Homepage leads with a tiny visible game loop and direct links to examples, articles, and “This Week in Quad.” | Article's accessibility observation holds; direct homepage read. |
| [`Fyrox Book`](https://fyrox-book.github.io/) | mdBook navigation supplies chapter search and keyboard navigation; book is the conceptual layer over rustdoc. | Article discussed 0.36.2; book remains accessible; version was not asserted from landing page. |
| [`thiserror`](https://docs.rs/thiserror/latest/thiserror/) 2.0.21 | Derive examples show `Display`, `source`, `from`, transparent errors, and formatted fields directly in code. | Article saw 2.0.12; newer page confirms behavior-focused examples. |
| [`anyhow`](https://docs.rs/anyhow/latest/anyhow/) 1.0.104 | A minimal `Result` example is followed by `Context`, rendered error chains, and guidance on when to define typed errors. | Article saw 1.0.98; current page newer and same task progression. |
| [`snafu`](https://docs.rs/snafu/latest/snafu/guide/) 0.9.2 | The guide URL resolves, but the docs.rs landing extraction is terse; guide navigation is less visible than Jiff/clap. | Article saw guide subpages and philosophy; current top guide was fetched, individual guide claims need link-level checks. |
| [`clap`](https://docs.rs/clap/latest/clap/) 4.6.7 | Quick Links explicitly expose tutorial, derive reference, cookbook, FAQ, feature flags, and command output. | Article saw 4.5.37; current page demonstrates the strongest task/reference split in the survey. |
| [`pico-args`](https://docs.rs/pico-args/latest/pico_args/) 0.5.0 | Small API reference with compact argument parsing examples; deliberately minimal surface. | Article saw 0.5.0; direct page confirms minimalism is the product promise. |
| [`Ratatui`](https://ratatui.rs/) site | Homepage combines API links, visual showcase, example exploration, video, recipes, tutorials, and community links. | Article's praise holds; direct site read. |
| [`egui`](https://docs.rs/egui/latest/egui/) 0.36.2 | Explains immediate-mode frame phases, links a live demo, gives a small UI example, and points to source demos and the “why immediate mode” essay. | Article saw an earlier 0.x version; current page remains unusually explanatory for API docs. |
| [`Iced Book`](https://book.iced.rs/) | mdBook has a compact “what this book will…” orientation and keyboard/search affordances. | Article's book reference remains reachable; landing page read. |
| [`wgpu`](https://docs.rs/wgpu/latest/wgpu/) 30.0.1 | Reference embeds conceptual pipeline explanations, feature/spec links, HDR caveats, error cases, and stepwise surface/device setup. | Article's “examples and demos but explanation gap” should be revisited; current reference is more explanatory. |
| [`Tokio tutorial`](https://tokio.rs/tokio/tutorial) | Dedicated tutorial navigation and a separate topics/blog/API structure make learning versus reference explicit. | Article saw the same architecture; current tutorial fetched. |
| [`smol`](https://docs.rs/smol/latest/smol/) 2.0.2 | Minimal executor/network examples and direct `block_on` use; intentionally little conceptual scaffolding. | Article saw 2.0.2; direct page confirms the small-library trade-off. |
| [`Embassy Book`](https://embassy.dev/book/) | Contents explicitly introduces async, DMA, examples, real-world uses, resources, and hardware setup/error recovery. | Article's user-problem praise holds; current book read. |
| [Rust Book](https://doc.rust-lang.org/book/) | mdBook orientation with offline/stable links and a linear, tested learning path; adjacent Reference, Nomicon, and Rust by Example fill other intents. | Article's official-docs conclusion holds; current landing page read. |

The survey found no contradiction that invalidates the article's core recommendation, but it did find drift: `rand`, `chrono`, `jiff`, `axum`, `bevy`, `thiserror`, `anyhow`, `clap`, `egui`, and `wgpu` all expose newer live versions than the article cites. Any GPUI comparison must pin a release or commit and display that pin beside examples.

## Reference systems surveyed

### fasterthanli.me

The site is a useful model for voice and deep explanation, not a template to reproduce. Its article/series/tag structure gives readers several entry points; visible reading time sets expectations; long essays mix a concrete project with implementation reasoning; and articles link out to source, tools, and adjacent concepts. The 2025 “Introducing arborium” article is especially relevant because it discusses the docs.rs relationship and asks what a documentation site can add. Apply the lesson with GPUI series pages and stable topic tags, but keep the product documentation quieter and more task-oriented than a personal blog. Avoid making personality, chronology, or a huge essay the only route to an answer.

### Jiff

Jiff is the editorial model: state the goal of a page, explain the domain before the API, name unsupported features, show competing designs fairly, and answer “why?” questions with concrete consequences. API docs include examples and exceptional behavior; links are deep and reciprocal. For GPUI, each central type should answer: what state does it represent, what invariant does it protect, how is it created, what can fail, what is the common path, and where is a complete example?

### Gwern's style guide

Gwern's Manual of Style (accessed at `https://gwern.net/style-guide`) argues for principles over rigid rules, durable hypertext, deep links, an “iceberg” hierarchy (abstract → main text → notes/collapses → appendix), explicit metadata, one source line per sentence, and code that actually runs. Its warnings against link clutter and decorative admonitions matter: dense references need progressive disclosure, meaningful link text, and accessible keyboard behavior. Its LLM section is a useful anti-collapse checklist: make concrete commitments, remove generic transitions, preserve authorial judgment, and edit every generated sentence against evidence. Borrow the structure and discipline; do not borrow Gwern's bespoke HTML or citation density wholesale.

### Wikipedia's guidance on AI-generated prose

Wikipedia's “Signs of AI writing” page (`https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing`, accessed 2026-10-07) is a heuristic, not a detector. It flags inflated significance, generic “in conclusion” framing, repetitive headings, vague attribution, overuse of em dashes and parenthetical asides, canned enthusiasm, unearned “not X but Y” contrasts, and claims without sources. Treat those as review prompts. Do not infer authorship from a style quirk; require source links, a maintainer's technical judgment, runnable examples, and a human editorial pass instead. The page itself points readers to Wikipedia's broader neutral-point-of-view and style guidance.

### Pangram / “panagram”

The name in the request is ambiguous. `https://pangram.com` resolves and presents Pangram's AI-text detection service; `panagram.dev` did not resolve when checked. Pangram's score can be an adversarial signal during editorial review, never a quality gate or proof of authorship. The useful practice is to inspect passages that score as generic and ask whether they contain specific GPUI observations, links, counterexamples, and tested code. Keep this process private to review tooling; do not expose a detector score to readers or contributors as a judgment.

## Rubric for adversarial review

For every public symbol and every site page, a reviewer should be able to answer “who is this for?”, “what can I do next?”, “what can go wrong?”, “why this design?”, “which version was tested?”, and “where is the complete example?” A page fails review when it requires source spelunking for a behavior that affects correctness, uses a snippet that cannot compile, links only to a homepage, hides a limitation, or leaves the reader at a dead end.

Run these checks before release:

1. Search by a user goal (“draw text”, “handle a key”, “reload a view”) and by every public type/function name; each should reach one canonical page within two clicks.
2. Follow every code link in generated docs and examples at the pinned commit. Check mobile layout, keyboard navigation, heading order, code copying, dark mode, and reduced motion.
3. Build every tutorial/example on CI for supported targets. Exercise error paths and document expected output, not only the happy path.
4. Compare docs.rs and Zola pages for contradictory names, versions, feature flags, and guarantees. Generate a link report and fail on stale example IDs.
5. Ask a reviewer unfamiliar with the implementation to complete a task using only the site. Record every search, backtrack, and unanswered question; turn recurring misses into pages or links.
6. Repeat the pass with a skeptical maintainer: challenge unsupported claims, benchmark language, platform promises, and “easy” wording. A second reviewer should audit whether design rationale fairly describes alternatives.

## Source inventory and status

The supplied article was downloaded to `/tmp/gpui-docs-review.html`; its 276 absolute `href` values were extracted with a URL parser into `/tmp/article-urls.txt`, then all 276 were fetched read-only with a short timeout. The complete inventory is retained in `docs/documentation-reference-links.json`, with HTTP status and separate `read`, `surveyed`, `fetched`, and `inaccessible` labels. The article itself was accessible and readable. Direct checks on 2026-10-07 UTC: current site `https://gpui-ce.github.io` returned 200; `/docs` returned 404; `https://www.gwern.net/style` redirected to `https://gwern.net/style-guide` and returned 200; Wikipedia's signs page returned 200; `https://pangram.com` returned 200; `https://panagram.dev` failed DNS; docs.rs Jiff design returned 200; `https://jiff.github.io/jiff/design/` was inaccessible to the browser tool. A fetch status is not a claim that page content was read. Recheck versioned crate links at build time.

## Primary links

* [Article: A Rust Documentation Ecosystem Review](https://www.harudagondi.space/blog/rust-documentation-ecosystem-review/)
* [Diátaxis](https://diataxis.fr/)
* [Jiff API documentation](https://docs.rs/jiff/latest/jiff/), [design](https://docs.rs/jiff/latest/jiff/_documentation/design/index.html), [comparison](https://docs.rs/jiff/latest/jiff/_documentation/comparison/index.html)
* [Gwern Manual of Style](https://gwern.net/style-guide)
* [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing)
* [fasterthanli.me](https://fasterthanli.me/), [Rust tag](https://fasterthanli.me/tags/rust), [arborium article](https://fasterthanli.me/articles/introducing-arborium-a-tree-sitter-distribution)
* [Zola documentation](https://www.getzola.org/documentation/)
* [Rustdoc book](https://doc.rust-lang.org/rustdoc/)
