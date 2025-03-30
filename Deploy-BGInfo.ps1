$destPath = "C:\ProgramData\BGInfo"
$bginfoExe = "$destPath\Bginfo.exe"
$bgiFile = "$destPath\CinnTech-Hostname.bgi"
$shortcutScript = "$destPath\Startup-Shortcut.ps1"

# Hosted file URLs (replace with your GitHub raw URLs or CDN links)
$bginfoUrl = "https://raw.githubusercontent.com/cinntech/bginfo/main/BGInfo.exe"
$bgiUrl = "https://raw.githubusercontent.com/cinntech/bginfo/main/CinnTech-Hostname.bgi"
$shortcutUrl = "https://raw.githubusercontent.com/cinntech/bginfo/main/Startup-Shortcut.ps1"

# Create folder
if (-not (Test-Path $destPath)) {
    New-Item -ItemType Directory -Path $destPath -Force
}

# Download required files
Invoke-WebRequest -Uri $bginfoUrl -OutFile $bginfoExe -UseBasicParsing
Invoke-WebRequest -Uri $bgiUrl -OutFile $bgiFile -UseBasicParsing
Invoke-WebRequest -Uri $shortcutUrl -OutFile $shortcutScript -UseBasicParsing

# Set permissions
Unblock-File $bginfoExe
Unblock-File $bgiFile
Unblock-File $shortcutScript

# Run BGInfo once immediately
Start-Process -FilePath $bginfoExe -ArgumentList "`"$bgiFile`" /silent /accepteula /timer:0" -WindowStyle Hidden

# Add to startup
powershell -ExecutionPolicy Bypass -File $shortcutScript
