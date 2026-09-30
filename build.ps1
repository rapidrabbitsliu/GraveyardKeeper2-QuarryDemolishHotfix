param(
    [Parameter(Mandatory = $true)]
    [string]$GameDir,

    [Parameter(Mandatory = $true)]
    [string]$BepInExCoreDir
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$managed = Join-Path $GameDir 'GraveyardKeeper2_Data\Managed'
$source = Join-Path $root 'src\QuarryDemolishHotfix.cs'
$output = Join-Path $root 'build\QuarryDemolishHotfix.dll'
$compiler = Join-Path $env:WINDIR 'Microsoft.NET\Framework64\v4.0.30319\csc.exe'

if (-not (Test-Path -LiteralPath $compiler)) { throw "C# compiler not found: $compiler" }
if (-not (Test-Path -LiteralPath $source)) { throw "Source not found: $source" }
New-Item -ItemType Directory -Path (Split-Path -Parent $output) -Force | Out-Null

$references = @(
    (Join-Path $BepInExCoreDir 'BepInEx.dll'),
    (Join-Path $BepInExCoreDir '0Harmony.dll'),
    (Join-Path $managed 'Assembly-CSharp.dll'),
    (Join-Path $managed 'FlowCanvas.dll'),
    (Join-Path $managed 'LazyBearTechnology.dll'),
    (Join-Path $managed 'NodeCanvas.dll'),
    (Join-Path $managed 'ParadoxNotion.dll'),
    (Join-Path $managed 'UnityEngine.CoreModule.dll'),
    (Join-Path $managed 'UnityEngine.dll'),
    (Join-Path $managed 'netstandard.dll')
)
foreach ($reference in $references) {
    if (-not (Test-Path -LiteralPath $reference)) { throw "Reference not found: $reference" }
}

$compilerArgs = @('/nologo', '/target:library', '/optimize+', "/out:$output")
$compilerArgs += $references | ForEach-Object { "/r:$_" }
$compilerArgs += $source
& $compiler @compilerArgs
if ($LASTEXITCODE -ne 0) { throw "Compilation failed with exit code $LASTEXITCODE" }
Write-Output $output
