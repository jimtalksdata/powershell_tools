# Master asset updater script
# Runs selected PowerShell scripts

$logFileDT = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logFileDir = "F:\Assets\Scripts\Logs"

# if dir does not exist, create it
if (!(Test-Path $logFileDir))
{
    write-host "Log file directory does not exist, creating it"
    New-Item -ItemType Directory -Path $logFileDir
}

# create log file
$logFile = $logFileDir + "\assetUpdates_" + $logFileDT + ".log"

# powershell_copy_files_with_extension_to_dest - PNG preview images for XNA Data
write-host "Copying PNG preview images for 3D assets"
./scripts/powershell_copy_files_with_extension_to_dest.ps1 "F:\Assets\3D\XNA Data" "F:\Assets\--Index\3D\XNA Data" "png" | Out-File $logFile -Append
./scripts/powershell_copy_files_with_extension_to_dest.ps1 "F:\Assets\3D\Game Content (Models)" "F:\Assets\--Index\3D\Game Content (Models)" png | Out-File $logFile -Append