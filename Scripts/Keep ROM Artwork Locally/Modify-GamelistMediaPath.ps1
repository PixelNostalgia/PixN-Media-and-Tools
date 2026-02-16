# =========================
# FILL THESE OUT
# =========================
$SourceRomsRoot = "X:\Games\Emulation\RetroBat\roms"   # folder that contains system subfolders (aleck64, advision, etc.)

# What to replace
$FindText    = "./media/"
$ReplaceText = '~/../_media_/$SysName/media/'   # NOTE: literal template; $SysName is filled per-system in the loop

# Backup filename suffix
$BackupSuffix = ".pixnbk"             # gamelist.xml.pixnbk

# =========================
# DO NOT EDIT BELOW
# =========================
$ErrorActionPreference = "Stop"

function Get-TextEncodingFromBomOrDefault {
  param([byte[]]$Bytes)

  if ($Bytes.Length -ge 3 -and $Bytes[0] -eq 0xEF -and $Bytes[1] -eq 0xBB -and $Bytes[2] -eq 0xBF) {
    return [System.Text.UTF8Encoding]::new($true)   # UTF-8 with BOM
  }
  if ($Bytes.Length -ge 2 -and $Bytes[0] -eq 0xFF -and $Bytes[1] -eq 0xFE) {
    return [System.Text.UnicodeEncoding]::new($false, $true) # UTF-16 LE with BOM
  }
  if ($Bytes.Length -ge 2 -and $Bytes[0] -eq 0xFE -and $Bytes[1] -eq 0xFF) {
    return [System.Text.UnicodeEncoding]::new($true, $true)  # UTF-16 BE with BOM
  }

  # Default if no BOM: UTF-8 without BOM
  return [System.Text.UTF8Encoding]::new($false)
}

if (-not (Test-Path -LiteralPath $SourceRomsRoot)) {
  throw "Source not found: $SourceRomsRoot"
}

# Only immediate subfolders (system folders). No recursion.
$systemDirs = Get-ChildItem -LiteralPath $SourceRomsRoot -Directory

foreach ($sys in $systemDirs) {
  $systemName   = $sys.Name
  $gamelistPath = Join-Path $sys.FullName "gamelist.xml"

  if (-not (Test-Path -LiteralPath $gamelistPath)) {
    continue
  }

  # ---- NEW: SysName is the folder name (ex: amiga500) ----
  $SysName = $sys.Name

  # ---- NEW: Build per-system replacement text from the template above ----
  $ReplaceTextForSys = $ReplaceText.Replace('$SysName', $SysName)

  Write-Host ""
  Write-Host "Found gamelist.xml for system: $systemName"
  Write-Host "  File: $gamelistPath"

  # ---- Backup first (always overwrite) ----
  $backupPath = $gamelistPath + $BackupSuffix
  try {
    Copy-Item -LiteralPath $gamelistPath -Destination $backupPath -Force
    Write-Host "  Backup: $backupPath"
  } catch {
    Write-Host "  ERROR creating backup for $systemName : $($_.Exception.Message)"
    continue
  }

  try {
    # Read bytes so we can preserve encoding (BOM/no-BOM)
    $bytes = [System.IO.File]::ReadAllBytes($gamelistPath)
    $enc   = Get-TextEncodingFromBomOrDefault -Bytes $bytes
    $text  = $enc.GetString($bytes)

    # Detect newline style so we write back consistently
    $newline = if ($text -match "`r`n") { "`r`n" } else { "`n" }

    # Count replacements (total occurrences)
    $totalReplacements = [regex]::Matches($text, [regex]::Escape($FindText)).Count

    # Count "lines changed" (lines that contain the find string at least once)
    $lines = $text -split [regex]::Escape($newline)
    $linesChanged = 0

    for ($i = 0; $i -lt $lines.Count; $i++) {
      if ($lines[$i].Contains($FindText)) {
        $lines[$i] = $lines[$i].Replace($FindText, $ReplaceTextForSys)
        $linesChanged++
      }
    }

    if ($linesChanged -eq 0) {
      Write-Host "  No changes needed (0 lines changed)."
      continue
    }

    # Write back with same encoding choice
    $updatedText = $lines -join $newline
    $writer = New-Object System.IO.StreamWriter($gamelistPath, $false, $enc)
    try {
      $writer.Write($updatedText)
    } finally {
      $writer.Dispose()
    }

    Write-Host "  Updated: $linesChanged line(s) changed, $totalReplacements replacement(s) total."
  }
  catch {
    Write-Host "  ERROR processing $systemName : $($_.Exception.Message)"
    continue
  }
}

Write-Host ""
Write-Host "Done."
