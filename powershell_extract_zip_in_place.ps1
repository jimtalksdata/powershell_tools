# For use with: Powershell
# Extracts all archive (zip, rar, 7z, etc) files in a folder provided by the command line argument
# to the same folder as the archive file.  The archive files are optionally deleted after extraction.

# Usage: powershell_extract_zip_in_place.ps1 "C:\path\to\folder\with\archives"

$folderPath=$args[0]
$folderPath=$folderPath.Trim('"')
$deleteArchiveFiles=$false
if ($args[1] -eq "true") { $deleteArchiveFiles=$true }

# valid archive types that will be extracted
$validArchiveTypes=@('zip','rar','7z')

# path to 7-zip
$sevenZipPath="C:\Program Files\7-Zip\7z.exe"

$countExtracted=0

# check if is a folder
if(!(Test-Path $folderPath))
{
    write-host "Folder path does not exist, exiting"
    exit
}
else {
    Get-ChildItem $folderPath -recurse | %{ 

        if($_.Name -match "\.($($validArchiveTypes -join "|"))$")
        {
            write-host "Extracting $($_.FullName) to $($_.Directory.FullName)"
            $arguments=@("x", "`"$($_.FullName)`"", "-o`"$($_.Directory.FullName)`"", "-y");
            $ex = start-process -FilePath "`"$sevenZipPath`"" -ArgumentList $arguments -wait -PassThru;

            if( $ex.ExitCode -eq 0)
            {
                write-host "Extraction successful"
                $countExtracted++
                if ($deleteArchiveFiles) {
                    write-host "Deleting $($_.FullName)"
                    Remove-Item -Path $_.FullName -Force
                }
            }
            # $parent="$(Split-Path $_.FullName -Parent)";    
            # write-host "Extracting $($_.FullName) to $parent"

            # $arguments=@("e", "`"$($_.FullName)`"", "-o`"$($parent)\$($_.BaseName)`"");
            # $ex = start-process -FilePath "`"C:\Program Files\7-Zip\7z.exe`"" -ArgumentList $arguments -wait -PassThru;

            # if( $ex.ExitCode -eq 0)
            # {
            #     write-host "Extraction successful, deleting $($_.FullName)"
            #     rmdir -Path $_.FullName -Force
            #     $arguments1="$($parent)\$($_.BaseName)\*.pdf"
            #     rmdir -Recurse -Path $arguments1
            # }
        }
    }
}