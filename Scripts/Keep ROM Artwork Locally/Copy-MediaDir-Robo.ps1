# =========================
# FILL THESE OUT
# =========================
$SourceRomsRoot = "X:\Games\Emulation\RetroBat\roms"			# contains system folders (amiga500, snes, etc.)
$DestRomsRoot   = "X:\Games\Emulation\RetroBat\_media_"			# will receive \system\media

# Copy mode: "MIR" or "E"
$CopyMode       = "MIR"              # "MIR" = mirror (includes deletes), "E" = copy subdirs incl empty

# Multi-threading
$UseMT          = $true
$MTThreads      = 8                 # 1-128

# Optional: logging
$LogPath        = ""                 # e.g. "R:\Test\robocopy-media.log" or "" for none

# Exclusions (directory names matched anywhere under each \media tree)
$ExcludeDirs    = @("manual","manuals","maps") # add/remove names as needed
$ExcludeFiles   = @()                # e.g. @("*.pdf","*.txt") or leave empty

# =========================
# DO NOT EDIT BELOW
# =========================
$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $SourceRomsRoot)) { throw "Source not found: $SourceRomsRoot" }
if (-not (Test-Path -LiteralPath $DestRomsRoot))   { New-Item -ItemType Directory -Path $DestRomsRoot | Out-Null }

$modeSwitch = if ($CopyMode -eq "MIR") { "/MIR" } else { "/E" }

# Good defaults
$common = @(
  "/R:1","/W:1",
  "/Z","/FFT",
  "/COPY:DAT","/DCOPY:DAT",
  "/NP"
)

# Add exclusions if configured
if ($ExcludeDirs.Count -gt 0) {
  $common += "/XD"
  $common += $ExcludeDirs
}
if ($ExcludeFiles.Count -gt 0) {
  $common += "/XF"
  $common += $ExcludeFiles
}

# Extra switches from variables
$extra = @()
if ($UseMT)   { $extra += "/MT:$MTThreads" }
if ($LogPath) { $extra += "/LOG+:$LogPath" }

# Only system folders directly under ROMs root (no recursion)
Get-ChildItem -LiteralPath $SourceRomsRoot -Directory | ForEach-Object {
  $mediaSrc = Join-Path $_.FullName "media"
  if (-not (Test-Path -LiteralPath $mediaSrc)) { return }   # skip systems with no media folder

  $mediaDst = Join-Path (Join-Path $DestRomsRoot $_.Name) "media"
  New-Item -ItemType Directory -Path $mediaDst -Force | Out-Null

  Write-Host "Robocopy $modeSwitch $($extra -join ' ') : $mediaSrc -> $mediaDst"

  # IMPORTANT: no embedded quotes here
  $args = @(
    $mediaSrc,
    $mediaDst,
    "*.*",
    $modeSwitch
  ) + $common + $extra

  & robocopy @args | Out-Host

  # Robocopy: 0-7 = success-ish, >=8 = failure
  if ($LASTEXITCODE -ge 8) {
    throw "Robocopy failed for $mediaSrc -> $mediaDst (ExitCode=$LASTEXITCODE)"
  }
}
