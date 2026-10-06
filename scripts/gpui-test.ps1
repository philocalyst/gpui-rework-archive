$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$cargoConfig = Join-Path $repoRoot '.cargo/config.toml'
$cargoArgs = @()
if (Test-Path -LiteralPath $cargoConfig -PathType Leaf) {
    $cargoArgs += @('--config', $cargoConfig)
}
$cargoArgs += @('run', '--manifest-path', (Join-Path $repoRoot 'Cargo.toml'), '--package', 'gpui_ce_test', '--bin', 'gpui-test', '--')
$cargoArgs += $args

& cargo @cargoArgs
exit $LASTEXITCODE
