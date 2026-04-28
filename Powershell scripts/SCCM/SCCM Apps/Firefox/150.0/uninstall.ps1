$logPath = "C:\LOGS"
if (!(Test-Path $logPath)) { New-Item -Path $logPath -ItemType Directory }

$logFile = "$logPath\Firefox_Uninstall_Log.txt"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Add-Content -Path $logFile -Value "[$timestamp] Starting uninstallation process..."

$uninstallPath = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" | 
                 Where-Object { $_.DisplayName -like "*Mozilla Firefox*" } | 
                 Select-Object -ExpandProperty UninstallString -ErrorAction SilentlyContinue

if ($uninstallPath) {
    try {
        Start-Process -FilePath $uninstallPath -ArgumentList "/S" -Wait
        Add-Content -Path $logFile -Value "[$(Get-Date -Format 'HH:mm:ss')] Firefox successfully uninstalled."
    } catch {
        Add-Content -Path $logFile -Value "[$(Get-Date -Format 'HH:mm:ss')] Error: $($_.Exception.Message)"
    }
} else {
    Add-Content -Path $logFile -Value "[$(Get-Date -Format 'HH:mm:ss')] Firefox not found in registry."
}

# 2-second delay
Start-Sleep -Seconds 2
Add-Content -Path $logFile -Value "[$(Get-Date -Format 'HH:mm:ss')] Script execution finished."