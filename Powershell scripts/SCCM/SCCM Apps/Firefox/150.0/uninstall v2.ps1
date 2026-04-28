# This wrapper ensures the entire logic block runs in a hidden process
Start-Process powershell.exe -WindowStyle Hidden -ArgumentList {
    $logDir = "C:\LOGS"
    $logFile = "$logDir\Firefox_Uninstall.txt"
    $paths = @(
        "${env:ProgramFiles}\Mozilla Firefox\uninstall\helper.exe",
        "${env:ProgramFiles(x86)}\Mozilla Firefox\uninstall\helper.exe"
    )

    # Ensure Log Directory exists
    if (!(Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force
    }

    $uninstalled = $false
    foreach ($path in $paths) {
        if (Test-Path $path) {
            # Start the uninstaller silently and wait for it to finish
            $process = Start-Process -FilePath $path -ArgumentList "-ms" -Wait -PassThru
            $uninstalled = $true
            $message = "Success: Firefox uninstalled (Exit Code: $($process.ExitCode))"
            break
        }
    }

    if (-not $uninstalled) {
        $message = "Error: Firefox uninstaller not found."
    }

    # Mandatory 2-second delay
    Start-Sleep -Seconds 2

    # Write log file
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$timestamp] $message" | Out-File -FilePath $logFile -Append
}