use anyhow::{Context, Result, bail, ensure};
use gpui_test::{Harness, RenderedSuite, ReportOptions, write_report};
use std::{env, path::PathBuf};

fn main() {
    exit_on_error(run_cli());
}

fn exit_on_error(result: Result<()>) {
    if let Err(error) = result {
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
        "collect" => collect_command(&rest),
        "platform" => run_platform_command(&rest),
        "help" | "--help" | "-h" => usage(),
        other => bail!("unknown command {other:?}; use `gpui-test help`"),
    }
}

fn collect_command(args: &[String]) -> Result<()> {
    let parsed = parse_args(args)?;
    ensure!(
        !parsed.names.is_empty(),
        "`collect` requires one or more report directories"
    );
    ensure!(
        parsed.gpu || parsed.samples.is_none(),
        "`collect --samples` requires --gpu; CPU timings come from the source reports"
    );
    if parsed.gpu {
        #[cfg(not(feature = "gpu"))]
        bail!(
            "native GPU replay is unavailable in this build; rebuild with `--features gpui_ce_test/gpu`"
        );
        #[cfg(feature = "gpu")]
        ensure!(
            parsed.samples.unwrap_or(20) > 0,
            "--samples must be positive"
        );
    }
    #[allow(unused_mut)] // Native replay exists only in GPU-enabled builds.
    let mut suite = gpui_test::collect_reports(&parsed.names)?;
    if parsed.gpu {
        #[cfg(feature = "gpu")]
        gpui_test::native::replay_native(&mut suite, parsed.samples.unwrap_or(20))?;
    }
    let manifest = write_report(
        &suite,
        &parsed.output,
        ReportOptions {
            baseline_dir: parsed.baseline,
            selected_ids: Vec::new(),
        },
    )?;
    println!(
        "collected {} scenarios; {} comparison change(s); report: {}",
        suite.scenarios.len(),
        manifest.changes.len(),
        parsed.output.display()
    );
    Ok(())
}

fn run_platform_command(args: &[String]) -> Result<()> {
    let parsed = parse_args(args)?;
    ensure!(
        parsed.names.is_empty(),
        "`platform` does not accept scenario IDs"
    );
    ensure!(
        parsed.baseline.is_none(),
        "`platform` does not accept --baseline"
    );
    ensure!(
        parsed.samples.is_none(),
        "`platform` does not accept --samples"
    );
    ensure!(!parsed.gpu, "`platform` does not accept --gpu");
    #[cfg(not(feature = "platform"))]
    bail!(
        "native platform probes are unavailable in this build; rebuild with `--features gpui_ce_test/platform`"
    );
    #[cfg(feature = "platform")]
    {
        gpui_ce_platform::testing::run_window_checks(move |checks| {
            exit_on_error(write_platform_report(checks, &parsed.output));
        });
        Ok(())
    }
}

#[cfg(feature = "platform")]
fn write_platform_report(checks: gpui::WindowCheckReport, output: &std::path::Path) -> Result<()> {
    let status = checks.status;
    let suite = RenderedSuite::new(Vec::new()).with_platform_checks(checks);
    write_report(&suite, output, ReportOptions::default())?;
    ensure!(
        status == gpui::WindowCheckStatus::Passed,
        "native platform checks failed; report: {}",
        output.display()
    );
    println!(
        "verified native platform checks; report: {}",
        output.display()
    );
    Ok(())
}

#[derive(Clone, Copy, PartialEq, Eq)]
enum Mode {
    Run,
    Benchmark,
    Check,
}

fn run_command(args: &[String], mode: Mode) -> Result<()> {
    let parsed = parse_args(args)?;
    if parsed.gpu {
        #[cfg(not(feature = "gpu"))]
        bail!(
            "native GPU replay is unavailable in this build; rebuild with `--features gpui_ce_test/gpu`"
        );
    }
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
    #[allow(unused_mut)] // The native replay pass exists only in GPU-enabled builds.
    let mut suite = RenderedSuite::new(captures);
    if parsed.gpu {
        #[cfg(feature = "gpu")]
        gpui_test::native::replay_native(&mut suite, harness.timing_sample_count())?;
    }
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
    gpu: bool,
}

fn parse_args(args: &[String]) -> Result<Args> {
    let mut names = Vec::new();
    let mut output = PathBuf::from("target/gpui-test");
    let mut baseline = None;
    let mut samples = None;
    let mut gpu = false;
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
            "--gpu" => gpu = true,
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
        gpu,
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
        "gpui-test list\ngpui-test run [SCENARIO ...] [--output DIR] [--baseline DIR] [--samples N] [--gpu]\ngpui-test bench [SCENARIO ...] [--output DIR] [--baseline DIR] [--samples N] [--gpu]\ngpui-test check [SCENARIO ...] --baseline DIR [--output DIR] [--samples N] [--gpu]\ngpui-test collect REPORT_DIR... [--output DIR] [--baseline DIR] [--samples N] [--gpu]\ngpui-test platform [--output DIR]\n\nOmitting scenario IDs runs the full built-in suite. `check` compares scene JSON, decoded pixels, and checkpoint metadata. `collect` combines existing CPU captures without rerendering them; identical duplicate scenarios keep the first copy. `bench` defaults to 20 repeated frames; `run` and `check` default to one. `collect --gpu` defaults to 20 native replay samples. `--gpu` replays captured scenes through optional native WGPU support; build with `--features gpui_ce_test/gpu`. `platform` runs an opt-in native window lifecycle probe; build with `--features gpui_ce_test/platform`."
    );
    Ok(())
}
