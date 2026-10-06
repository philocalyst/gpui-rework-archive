use anyhow::{Context, Result, bail, ensure};
use gpui_test::{Harness, RenderedSuite, ReportOptions, write_report};
use std::{env, path::PathBuf};

fn main() {
    if let Err(error) = run_cli() {
        eprintln!("gpui-test: {error:#}");
        std::process::exit(1);
    }
}

fn run_cli() -> Result<()> {
    let mut args = env::args().skip(1);
    let Some(command) = args.next() else {
        return usage();
    };
    let rest: Vec<_> = args.collect();
    match command.as_str() {
        "list" => {
            let scenarios = gpui_test::built_in_scenarios()?;
            for scenario in scenarios {
                println!("{}\t{}", scenario.id(), scenario.title());
            }
            Ok(())
        }
        "run" => run_command(&rest, Mode::Run),
        "bench" => run_command(&rest, Mode::Benchmark),
        "check" => run_command(&rest, Mode::Check),
        "help" | "--help" | "-h" => usage(),
        other => bail!("unknown command {other:?}; use `gpui-test help`"),
    }
}

#[derive(Clone, Copy, PartialEq, Eq)]
enum Mode {
    Run,
    Benchmark,
    Check,
}

fn run_command(args: &[String], mode: Mode) -> Result<()> {
    let parsed = parse_args(args)?;
    if mode == Mode::Check {
        let baseline = parsed
            .baseline
            .as_ref()
            .context("`check` requires --baseline <report-dir>")?;
        ensure!(
            baseline.is_dir(),
            "baseline report directory does not exist: {}",
            baseline.display()
        );
    }
    let selected = select_scenarios(&parsed.names)?;
    let harness = if mode == Mode::Benchmark {
        Harness::benchmark()
    } else {
        Harness::new()
    };
    let harness = match parsed.samples {
        Some(samples) => harness.timing_samples(samples)?,
        None => harness,
    };
    let mut captures = Vec::with_capacity(selected.len());
    for scenario in selected {
        captures.push(scenario.run(&harness)?);
    }
    let suite = RenderedSuite {
        scenarios: captures,
    };
    let manifest = write_report(
        &suite,
        &parsed.output,
        ReportOptions {
            baseline_dir: parsed.baseline,
            selected_ids: parsed.names,
        },
    )?;
    if mode == Mode::Check && !manifest.changes.is_empty() {
        for change in &manifest.changes {
            println!("changed: {change}");
        }
        bail!(
            "{} visual regression change(s) found; current captures: {}",
            manifest.changes.len(),
            parsed.output.display()
        );
    }
    println!(
        "{} {} scenarios; report: {}",
        if mode == Mode::Check {
            "verified"
        } else {
            "captured"
        },
        suite.scenarios.len(),
        parsed.output.display()
    );
    Ok(())
}

struct Args {
    names: Vec<String>,
    output: PathBuf,
    baseline: Option<PathBuf>,
    samples: Option<usize>,
}

fn parse_args(args: &[String]) -> Result<Args> {
    let mut names = Vec::new();
    let mut output = PathBuf::from("target/gpui-test");
    let mut baseline = None;
    let mut samples = None;
    let mut index = 0;
    while index < args.len() {
        match args[index].as_str() {
            "--output" => {
                index += 1;
                output = PathBuf::from(args.get(index).context("--output requires a directory")?);
            }
            "--baseline" => {
                index += 1;
                baseline = Some(PathBuf::from(
                    args.get(index).context("--baseline requires a directory")?,
                ));
            }
            "--samples" => {
                index += 1;
                samples = Some(
                    args.get(index)
                        .context("--samples requires a positive integer")?
                        .parse::<usize>()
                        .context("--samples must be an integer")?,
                );
            }
            name if name.starts_with('-') => bail!("unknown option {name:?}"),
            name => names.push(name.to_owned()),
        }
        index += 1;
    }
    Ok(Args {
        names,
        output,
        baseline,
        samples,
    })
}

fn select_scenarios(names: &[String]) -> Result<Vec<gpui_test::BuiltInScenario>> {
    let mut all = gpui_test::built_in_scenarios()?;
    if names.is_empty() {
        return Ok(all);
    }
    let mut selected = Vec::new();
    let mut seen = std::collections::HashSet::new();
    for name in names {
        ensure!(
            seen.insert(name),
            "scenario ID was specified more than once: {name}"
        );
        let index = all
            .iter()
            .position(|scenario| scenario.id() == name)
            .context(format!("unknown scenario {name:?}; use `gpui-test list`"))?;
        selected.push(all.remove(index));
    }
    Ok(selected)
}

fn usage() -> Result<()> {
    println!(
        "gpui-test list\ngpui-test run [SCENARIO ...] [--output DIR] [--baseline DIR] [--samples N]\ngpui-test bench [SCENARIO ...] [--output DIR] [--baseline DIR] [--samples N]\ngpui-test check [SCENARIO ...] --baseline DIR [--output DIR] [--samples N]\n\nOmitting scenario IDs runs the full built-in suite. `check` compares scene JSON, decoded pixels, and checkpoint metadata. `bench` defaults to 20 repeated frames; `run` and `check` default to one."
    );
    Ok(())
}
