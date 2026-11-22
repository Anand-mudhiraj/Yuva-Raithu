$ErrorActionPreference = "SilentlyContinue"
$deviceId = "10BDAJ31SE00190"

Write-Host "Starting persistent ADB reverse daemon for $deviceId on port 8080..."
while ($true) {
    adb -s $deviceId reverse tcp:8080 tcp:8080 2>&1 | Out-Null
    Start-Sleep -Seconds 3
}
