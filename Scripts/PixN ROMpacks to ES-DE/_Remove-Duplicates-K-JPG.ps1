# Extension to keep (876)
$ExtRetain = ".jpg"

# Path
$Directory1 = "ES-DE\downloaded_media\$env:SystemFolderName\titlescreens"
$Directory2 = "ES-DE\downloaded_media\$env:SystemFolderName\screenshots"

write-host "`n"
write-host "Removing duplicates from $Directory1"
write-host "`n"
# Get files to keep
$FilesToKeep1 = Get-ChildItem -Path $Directory1 -Filter *$ExtRetain

# Delete duplicates with different extension
ForEach ($File in $FilesToKeep1) {
    Get-ChildItem -Path $Directory1 | Where {$_.BaseName -eq $File.BaseName -and $_.Extension -ne $ExtRetain} | Remove-Item -Force
}

write-host "`n"
write-host "Removing duplicates from $Directory2"
write-host "`n"
# Get files to keep
$FilesToKeep2 = Get-ChildItem -Path $Directory2 -Filter *$ExtRetain

# Delete duplicates with different extension
ForEach ($File in $FilesToKeep2) {
    Get-ChildItem -Path $Directory2 | Where {$_.BaseName -eq $File.BaseName -and $_.Extension -ne $ExtRetain} | Remove-Item -Force
}
