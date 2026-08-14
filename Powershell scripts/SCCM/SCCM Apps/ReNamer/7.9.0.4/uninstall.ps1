# Automatically re-launches itself in a hidden background window if opened normally
if ($args[0] -ne 'HiddenInstance') {
    Start-Process powershell.exe -ArgumentList "-WindowStyle Hidden -ExecutionPolicy Bypass -File `"$PSCommandPath`" HiddenInstance" -WindowStyle Hidden
    exit
}

$LogDir = "c:\LOGS"
$LogFile = "$LogDir\ReNamer_uninstall.log"

if (!(Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
}

function Write-Log {
    param($Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "[$Timestamp] $Message"
}

Write-Log "Script started."

$Uninstaller = "C:\Program Files (x86)\ReNamer\unins000.exe"

if (Test-Path $Uninstaller) {
    Write-Log "Found uninstaller. Starting ReNamer uninstallation..."
    
    # Run uninstaller silently and wait for it to complete
    Start-Process -FilePath $Uninstaller -ArgumentList "/verysilent /suppressmsgboxes /norestart" -Wait
    
    Write-Log "Uninstallation process finished."
} else {
    Write-Log "ERROR: $Uninstaller not found."
}

Write-Log "Waiting 3 seconds before exit..."
Start-Sleep -Seconds 3

Write-Log "Script finished."