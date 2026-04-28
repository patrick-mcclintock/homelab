# Define the possible paths for the Firefox uninstaller
$paths = @(
    "${env:ProgramFiles}\Mozilla Firefox\uninstall\helper.exe",
    "${env:ProgramFiles(x86)}\Mozilla Firefox\uninstall\helper.exe"
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        Write-Host "Found Firefox uninstaller at: $path" -ForegroundColor Cyan
        Write-Host "Uninstalling..." -ForegroundColor Yellow
        
        # Start the uninstaller with the silent flag (-ms) and wait for it to finish
        Start-Process -FilePath $path -ArgumentList "-ms" -Wait
        
        Write-Host "Uninstall process completed." -ForegroundColor Green
        break
    }
}

# 2-second delay at the end
Write-Host "Waiting for 2 seconds before exiting..."
Start-Sleep -Seconds 2