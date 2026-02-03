# Extension to keep (876)
$ExtRetain = ".png"

# Path
$Directory1 = "ES-DE\downloaded_media\$env:SystemFolderName\3dboxes"
$Directory2 = "ES-DE\downloaded_media\$env:SystemFolderName\marquees"
$Directory3 = "ES-DE\downloaded_media\$env:SystemFolderName\physicalmedia"
$Directory4 = "ES-DE\downloaded_media\$env:SystemFolderName\covers"

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

write-host "`n"
write-host "Removing duplicates from $Directory3"
write-host "`n"
# Get files to keep
$FilesToKeep3 = Get-ChildItem -Path $Directory3 -Filter *$ExtRetain

# Delete duplicates with different extension
ForEach ($File in $FilesToKeep3) {
    Get-ChildItem -Path $Directory3 | Where {$_.BaseName -eq $File.BaseName -and $_.Extension -ne $ExtRetain} | Remove-Item -Force
}

write-host "`n"
write-host "Removing duplicates from $Directory4"
write-host "`n"
# Get files to keep
$FilesToKeep4 = Get-ChildItem -Path $Directory4 -Filter *$ExtRetain

# Delete duplicates with different extension
ForEach ($File in $FilesToKeep4) {
    Get-ChildItem -Path $Directory4 | Where {$_.BaseName -eq $File.BaseName -and $_.Extension -ne $ExtRetain} | Remove-Item -Force
}
