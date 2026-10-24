$ErrorActionPreference = 'Stop'
$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$dest = Join-Path $root 'build\sim'
New-Item -Force -ItemType Directory -Path $dest | Out-Null
$src = Get-ChildItem -Path (Join-Path $root 'hdl\src') -Filter '*.sv' | ForEach-Object { $_.FullName }
$tb = Join-Path $root 'hdl\sim\testbench_basys3.sv'
& iverilog -g2012 -s testbench_basys3 -o (Join-Path $dest 'fsm_tb.vvp') @src $tb
if ($LASTEXITCODE -ne 0) { throw 'Icarus compile failed' }
& vvp (Join-Path $dest 'fsm_tb.vvp')
if ($LASTEXITCODE -ne 0) { throw 'Icarus simulation failed' }
