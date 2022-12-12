# For use with: Powershell
# Copies files with a specific extension to a destination folder, preserving the folder structure
# First argument is the source folder
# Second argument is the destination folder
# All arguments after the second are the file extensions to copy, separated by commas

$sourceFolder=$args[0]
$destFolder=$args[1]
$fileExtension=$args[2]

$extArray = $fileExtension -split ","
$fileExtension = $extArray -join "|"

$copiedFiles = 0
$skippedFiles = 0

Add-Type -AssemblyName System.Drawing

# check if is a folder
if (!(Test-Path $sourceFolder))
{
    write-host "Source folder path does not exist, exiting"
    exit
}
else {
    # if destination folder does not exist, create it
    if (!(Test-Path $destFolder))
    {
        write-host "Destination folder does not exist, creating it"
        New-Item -ItemType Directory -Path $destFolder
    }
    # loop through all files in source folder
    Get-ChildItem $sourceFolder -recurse | %{ 
        # check if child item exists at destination path of the item is a file
        if (! $_.PSIsContainer) {
            $destPath = $destFolder + $_.DirectoryName.Substring($sourceFolder.Length)
            $destPathFile = $destPath + "\" + $_.Name
        }
        else {
            $destPathFile = $destFolder + "\" + $_.Name
        }
        if (!(Test-Path $destPathFile)) 
        {
            if($_.Name -match "\.($fileExtension)$")
            {
                # get height and width of image, check if aspect ratio is 1:1
                $image = [System.Drawing.Image]::FromFile($_.FullName)
                $width = $image.Width
                $height = $image.Height
                $aspectRatio = $width / $height
                $widthIsPowerOfTwo = [Math]::Log($width, 2) % 1 -eq 0
                if ($aspectRatio -eq 1 -or $aspectRatio -eq 2 -or $aspectRatio -eq 0.5)
                {
                    if ($widthIsPowerOfTwo) {
                        write-host "Image $($_.FullName) is probably a texture, skipping"
                        $skippedFiles++
                    }
                }
                else {
                    if (!(Test-Path $destPath))
                    {
                        write-host "Destination folder does not exist, creating it"
                        New-Item -ItemType Directory -Path $destPath
                    }
                    else {
                        write-host "Copying $($_.FullName) to $destPath"
                        Copy-Item -Path $_.FullName -Destination $destPath -Force
                        $copiedFiles++
                    }
                }
            }
        }
        else {
            $skippedFiles++
        }
    }
    write-host "Copied $copiedFiles files and skipped $skippedFiles files"
}