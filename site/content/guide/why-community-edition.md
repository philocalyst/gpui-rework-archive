+++
title = "Why a community edition?"
description = "A shared foundation for applications of every size. Familiar roots, independent ambitions."
weight = 40
[extra]
category = "ABOUT THE PROJECT"
playground = false
+++

GPUI Community Edition is a community fork of Zed’s GPU-accelerated UI framework. It keeps the original’s close relationship between Rust, application state, and rendering, while working toward a broader home for GUI development.

## Where we start

The framework is deeply inspired by the web: familiar elements, a fluent styling API, and reactive updates. It blends immediate and retained approaches. Views describe an interface; entities retain its state; the renderer turns the result into pixels.

The project aims to make GUI authoring as approachable as TUI and CLI development while preserving the ability to work at a much lower level when an application needs it. That is an ambition, not a benchmark claim.

## What is different

The fork has its own release cadence, platform organization, and community priorities. Much of the API remains familiar to GPUI users, but compatibility is evolving. Platform construction is provided by `gpui_platform`, so application code can request the current backend without putting every operating system behind its own conditional.

For specific migration work, consult [Migration & FAQ](@/guide/guides/migration-faq.md), the version you actually use, and the source. Do not assume that an arbitrary Zed example will compile unchanged against every GPUI-CE release.

## What stays shared

Zed’s work remains a major influence. The project continues to follow upstream changes and considers useful ideas from other forks. The aim is a reusable foundation for many applications, with room for shared components and platform integration.

Start with the [mental model](@/guide/getting-started/mental-model.md), or go straight to [your first application](@/guide/getting-started/first-app.md).

## Source

This chapter adapts the project’s [README](https://github.com/gpui-ce/gpui-ce/blob/main/README.md). It describes the direction of the project without treating its goals as completed features.
