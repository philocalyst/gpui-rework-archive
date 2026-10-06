$ErrorActionPreference = 'Stop'

if ($args.Count -lt 1) {
    Write-Error 'usage: scripts/gpui-example.ps1 <example-name> [-- example arguments...]'
    exit 2
}

$exampleName = [string]$args[0]
$exampleArgs = @($args | Select-Object -Skip 1)
if ($exampleArgs.Count -gt 0 -and $exampleArgs[0] -eq '--') {
    $exampleArgs = @($exampleArgs | Select-Object -Skip 1)
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$cargoConfig = Join-Path $repoRoot '.cargo/config.toml'
$cargoArgs = @()
if (Test-Path -LiteralPath $cargoConfig -PathType Leaf) {
    $cargoArgs += @('--config', $cargoConfig)
}
$cargoArgs += @('run', '--manifest-path', (Join-Path $repoRoot 'Cargo.toml'), '--package', 'gpui-ce', '--example', $exampleName, '--')
$cargoArgs += $exampleArgs

& cargo @cargoArgs
exit $LASTEXITCODE
