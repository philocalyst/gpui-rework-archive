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
        "run" => run_command(&rest, false),
        "bench" => run_command(&rest, true),
        "check" => check_command(&rest),
        "help" | "--help" | "-h" => usage(),
        other => bail!("unknown command {other:?}; use `gpui-test help`"),
    }
}

fn run_command(args: &[String], benchmark: bool) -> Result<()> {
    let parsed = parse_args(args)?;
    let selected = select_scenarios(&parsed.names)?;
    let harness = if benchmark {
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
    write_report(
        &suite,
        &parsed.output,
        ReportOptions {
            baseline_dir: parsed.baseline.clone(),
            selected_ids: parsed.names.clone(),
        },
    )?;
    println!(
        "wrote {} scenarios to {}",
        suite.scenarios.len(),
        parsed.output.display()
    );
    Ok(())
}

fn check_command(args: &[String]) -> Result<()> {
    let parsed = parse_args(args)?;
    let baseline = parsed
        .baseline
        .as_ref()
        .context("`check` requires --baseline <report-dir>")?;
    ensure!(
        baseline.is_dir(),
        "baseline report directory does not exist: {}",
        baseline.display()
    );
    ensure!(
        baseline != &parsed.output,
        "--output must differ from --baseline"
    );
    let selected = select_scenarios(&parsed.names)?;
    let harness = match parsed.samples {
        Some(samples) => Harness::new().timing_samples(samples)?,
        None => Harness::new(),
    };
    let mut captures = Vec::with_capacity(selected.len());
    for scenario in selected {
        captures.push(scenario.run(&harness)?);
    }
    let suite = RenderedSuite {
        scenarios: captures,
    };
    let current = parsed.output;
    write_report(
        &suite,
        &current,
        ReportOptions {
            baseline_dir: Some(baseline.clone()),
            selected_ids: parsed.names.clone(),
        },
    )?;
    let changes = gpui_test::compare_reports_selected(baseline, &current, &parsed.names)?;
    if changes.is_empty() {
        println!(
            "{} scenarios match baseline {}; report: {}",
            suite.scenarios.len(),
            baseline.display(),
            current.display()
        );
        return Ok(());
    }
    for change in &changes {
        println!("changed: {change}");
    }
    bail!(
        "{} visual regression change(s) found; current captures: {}",
        changes.len(),
        current.display()
    )
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
        "gpui-test list\ngpui-test run [SCENARIO ...] [--output DIR] [--baseline DIR] [--samples N]\ngpui-test bench [SCENARIO ...] [--output DIR] [--samples N]\ngpui-test check [SCENARIO ...] --baseline DIR [--output DIR] [--samples N]\n\nOmitting scenario IDs runs the full built-in suite. `check` compares scene JSON, exact PNG bytes, and checkpoint metadata. `bench` defaults to 20 repeated frames; `run` and `check` default to one."
    );
    Ok(())
}
