+++
aliases = ["colophon/"]
title = "Sources and editorial choices"
description = "Keep the documentation research visible and explain what we borrowed."
weight = 20
+++

The structure follows [Diátaxis](https://diataxis.fr/): tutorials for learning,
guides for a task, reference for a contract, and explanation for the relationships.
[Harudagondi's Rust documentation review](https://harudagondi.space/blog/rust-documentation-ecosystem-review/)
provided the review criteria: comprehensiveness, discoverability, philosophy,
and approachability.

[Jiff](https://docs.rs/jiff/latest/jiff/) is the main prose model. We use direct
summaries, concrete examples, linked alternatives, and explicit limitations.
We keep framework explanations in Markdown included by rustdoc, so docs.rs
publishes them with the code they explain.

[fasterthanli.me](https://fasterthanli.me/) informed the relationship between a
code listing and its explanation. This site uses a smaller mechanism: Rust
comments, a build-time extractor, and Zola. It does not require an article
application or a client framework to read the prose.

[Gwern's style guide](https://gwern.net/style-guide) informed durable deep links,
progressive detail, and revision against evidence.
[Wikipedia's notes on AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing)
provided a useful check against vague significance, repetitive structure,
fabricated support, and polished prose that fails to make a concrete claim.

The repository contains a [survey of all the reviewed projects](https://github.com/gpui-ce/gpui-ce/blob/main/docs/documentation-research.md)
and a separate access inventory. They distinguish pages read from pages merely
fetched and pages that could not be accessed. Those distinctions matter more
than a long list of impressive names.

The former site and earlier Zola prototype were reviewed as prior work. Their
prose and visual design were not carried into this site.
