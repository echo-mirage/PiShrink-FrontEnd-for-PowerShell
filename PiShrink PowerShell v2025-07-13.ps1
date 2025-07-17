<#

=== Windows WSL FrontEnd for PiShrink.sh ===

Version 2025.07.13 
Author: EchoMirage

Description: 
FrontEnd PowerShell script to show all .img files within its directory, then quickly pass the selected filename to PiShrink.sh for compression

From PiShrink readme: 
PiShrink is a bash script that automatically shrink a pi image that will then resize to the max size of the SD card on boot. 
This will make putting the image back onto the SD card faster and the shrunk images will compress better.

Notes:
You need PiShrink.sh https://github.com/Drewsif/PiShrink
You need Windows Subsystem for Linux (WSL) with a Debian variant installed
You need at least Windows 10 v1903, or Windows 11, to install the Windows Subsystem for Linux. See PiShrink readme for details

Run in the same directory as PiShrink.sh
This display all available .img files in the script's directory
Select an .img file and it will be passed to PiShrink to compress, then output appended with "_Shrunk.img" to same directory

#>



# Display Title 

Write-Host ""
Write-Host "`n================================" -ForegroundColor DarkGray
Write-Host "  WSL FrontEnd for PiShrink.sh" -ForegroundColor DarkCyan                
Write-Host "================================`n" -ForegroundColor DarkGray

Write-Host "Lists all .img files within the script's directory, then passes the selected" -ForegroundColor DarkGreen
Write-Host "file's path to to PiShrink.sh for compression.`n" -ForegroundColor DarkGreen




# List All .img Files in Current Directory

$imgFiles = @(Get-ChildItem -Filter *.img | Select-Object -ExpandProperty Name)

	if ($imgFiles.Count -eq 0) {
		Write-Host "`nNo .img files found in current directory." -ForegroundColor DarkRed
		Read-Host -Prompt "Press Enter to quit"
		exit
	}

	Write-Host "Available .img files:" -ForegroundColor DarkCyan
	for ($i = 0; $i -lt $imgFiles.Count; $i++) {
		Write-Host "$($i + 1). $($imgFiles[$i])"
}




# Prompt for File Choice

Write-Host ""

$selection = Read-Host "`nChoose file to shrink"
	if (-not ($selection -match '^\d+$') -or [int]$selection -lt 1 -or [int]$selection -gt $imgFiles.Count) {
		Write-Host "Invalid selection." -ForegroundColor DarkRed
		exit
}

$selectedFile = $imgFiles[[int]$selection - 1]
$outputFile = [System.IO.Path]::GetFileNameWithoutExtension($selectedFile) + "_Shrunk.img"

Write-Host "`nSelected input file: $selectedFile" -ForegroundColor Green
Write-Host "Output file will be: $outputFile`n" -ForegroundColor Green




# Find PiShrink.sh script

$pishrinkPath = Join-Path (Get-Location) "pishrink.sh"

	if (-not (Test-Path $pishrinkPath)) {
		$pishrinkPath = Read-Host "Enter full path to pishrink.sh"
		if (-not (Test-Path $pishrinkPath)) {
			Write-Host "pishrink.sh not found at specified path." -ForegroundColor DarkRed
			exit
		}
	} else {
		Write-Host "Found pishrink.sh in current directory" -ForegroundColor DarkGray
}

function Convert-ToWslPath {
    param([string]$winPath)
    $drive, $rest = $winPath -split ":", 2
    return "/mnt/" + $drive.ToLower() + ($rest -replace "\\", "/")
}

$wslImagePath = Convert-ToWslPath (Resolve-Path $selectedFile)
$wslShrinkPath = Convert-ToWslPath (Resolve-Path $pishrinkPath)
$wslOutputPath = $wslImagePath -replace ".img$", "_Shrunk.img"




# Create Temporary Bash Script

$tempScriptPath = "$env:TEMP\run-pishrink.sh"
$bashCommand = "sudo `"$wslShrinkPath`" `"$wslImagePath`" `"$wslOutputPath`""
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($tempScriptPath, $bashCommand, $utf8NoBom)

$wslTempScriptPath = Convert-ToWslPath (Resolve-Path $tempScriptPath)

Write-Host "`nPrepared command:" -ForegroundColor DarkGray
Write-Host $bashCommand
Write-Host "`nRunning PiShrink.sh in WSL..." -ForegroundColor Green




# Run the Bash Script Using WSL Path
bash $wslTempScriptPath




# Finish

Write-Host "`nDone." -ForegroundColor Green
Read-Host -Prompt "Press Enter to exit"