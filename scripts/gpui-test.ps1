$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$cargoConfig = Join-Path $repoRoot '.cargo/config.toml'
$cargoArgs = @()
if (Test-Path -LiteralPath $cargoConfig -PathType Leaf) {
    $cargoArgs += @('--config', $cargoConfig)
}
$cargoArgs += 'run'
if ($args.Count -gt 0 -and ($args[0] -eq 'bench' -or $args[0] -eq 'collect')) {
    $cargoArgs += '--release'
}
if ($args.Count -gt 0 -and $args[0] -eq 'platform') {
    $cargoArgs += @('--features', 'gpui_ce_test/platform')
} elseif ($args -contains '--gpu') {
    $cargoArgs += @('--features', 'gpui_ce_test/gpu')
}
$cargoArgs += @('--manifest-path', (Join-Path $repoRoot 'Cargo.toml'), '--package', 'gpui_ce_test', '--bin', 'gpui-test', '--')
$cargoArgs += $args

& cargo @cargoArgs
exit $LASTEXITCODE
