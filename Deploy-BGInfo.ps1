# BGInfo Deployment Script - CinnTech Edition
# Includes smart update checking, startup shortcut, logging, and cleanup

$destPath = "C:\ProgramData\BGInfo"
$logBase = "$destPath\bginfo-deploy.log"
$bginfoExe = "$destPath\Bginfo.exe"
$bgiFile = "$destPath\CinnTech-Hostname.bgi"
$startupScript = "$destPath\Startup-Shortcut.ps1"

# Remote URLs (GitHub raw links)
$bginfoUrl   = "https://github.com/cinntech/bginfo/raw/refs/heads/main/Bginfo.exe"
$bgiUrl      = "https://github.com/cinntech/bginfo/raw/refs/heads/main/CinnTech-Hostname.bgi"
$shortcutUrl = "https://github.com/cinntech/bginfo/raw/refs/heads/main/Startup-Shortcut.ps1"

# Ensure folder exists
if (-not (Test-Path $destPath)) {
    New-Item -ItemType Directory -Path $destPath -Force | Out-Null
}

# Rotate old logs (keep last 5)
for ($i = 4; $i -ge 1; $i--) {
    $older = "$logBase.$i"
    $newer = "$logBase." + ($i + 1)
    if (Test-Path $older) {
        Rename-Item -Path $older -NewName $newer -Force
    }
}
if (Test-Path $logBase) {
    Rename-Item -Path $logBase -NewName "$logBase.1" -Force
}

Start-Transcript -Path $logBase -Append

# Hash comparison function
function Get-RemoteHash {
    param($url)
    $temp = "$env:TEMP\bg_dl.tmp"
    Invoke-WebRequest -Uri $url -OutFile $temp -UseBasicParsing -ErrorAction Stop
    $hash = (Get-FileHash $temp -Algorithm SHA256).Hash
    Remove-Item $temp -Force
    return $hash
}

# Compare and update logic
function Compare-And-Update {
    param($url, $localPath)

    try {
        if (Test-Path $localPath) {
            $remoteHash = Get-RemoteHash $url
            $localHash = (Get-FileHash $localPath -Algorithm SHA256).Hash

            if ($remoteHash -ne $localHash) {
                Write-Output "Updating: $localPath"
                Invoke-WebRequest -Uri $url -OutFile $localPath -UseBasicParsing
            } else {
                Write-Output "No update needed for: $localPath"
            }
        } else {
            Write-Output "Downloading (new): $localPath"
            Invoke-WebRequest -Uri $url -OutFile $localPath -UseBasicParsing
        }
    } catch {
        Write-Warning "Error downloading $url → $localPath : $_"
    }
}

# Cleanup legacy .bgi
$oldBGI = "$destPath\cinntechBGinfo.bgi"
if (Test-Path $oldBGI) {
    Write-Output "Removing legacy BGI config: $oldBGI"
    Remove-Item $oldBGI -Force
}

# Update all components
Compare-And-Update -url $bginfoUrl -localPath $bginfoExe
Compare-And-Update -url $bgiUrl -localPath $bgiFile
Compare-And-Update -url $shortcutUrl -localPath $startupScript

# Unblock files if needed
Unblock-File $bginfoExe
Unblock-File $bgiFile
Unblock-File $startupScript

# Run BGInfo once
try {
    Start-Process -FilePath $bginfoExe -ArgumentList "`"$bgiFile`" /silent /accepteula /timer:0" -WindowStyle Hidden
    Write-Output "BGInfo executed successfully."
} catch {
    Write-Warning "Failed to run BGInfo: $_"
}

# Re-install startup shortcut
try {
    powershell -ExecutionPolicy Bypass -File $startupScript
    Write-Output "Startup shortcut script executed."
} catch {
    Write-Warning "Failed to run startup script: $_"
}

Stop-Transcript
