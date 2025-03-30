# BGInfo Deployment Script - CinnTech Edition
# Checks for file changes via hash and updates only if needed

$destPath = "C:\ProgramData\BGInfo"
$bginfoExe = "$destPath\Bginfo.exe"
$bgiFile = "$destPath\cinntechBGinfo.bgi"
$startupScript = "$destPath\Startup-Shortcut.ps1"

# Remote URLs (Updated to GitHub raw refs)
$bginfoUrl   = "https://github.com/cinntech/bginfo/raw/refs/heads/main/Bginfo.exe"
$bgiUrl      = "https://github.com/cinntech/bginfo/raw/refs/heads/main/cinntechBGinfo.bgi"
$shortcutUrl = "https://github.com/cinntech/bginfo/raw/refs/heads/main/Startup-Shortcut.ps1"

# Create destination directory if not present
if (-not (Test-Path $destPath)) {
    New-Item -ItemType Directory -Path $destPath -Force
}

# Function to fetch remote file hash
function Get-RemoteHash {
    param($url)
    $temp = "$env:TEMP\temp_dl"
    Invoke-WebRequest -Uri $url -OutFile $temp -UseBasicParsing -ErrorAction Stop
    $hash = (Get-FileHash $temp -Algorithm SHA256).Hash
    Remove-Item $temp -Force
    return $hash
}

# Compare existing file to remote, only update if different
function Compare-And-Update {
    param($url, $localPath)

    try {
        if (Test-Path $localPath) {
            $remoteHash = Get-RemoteHash $url
            $localHash = (Get-FileHash $localPath -Algorithm SHA256).Hash

            if ($remoteHash -ne $localHash) {
                Write-Output "Updating $localPath..."
                Invoke-WebRequest -Uri $url -OutFile $localPath -UseBasicParsing
            } else {
                Write-Output "$localPath is up to date."
            }
        } else {
            Write-Output "Downloading $localPath (first time)..."
            Invoke-WebRequest -Uri $url -OutFile $localPath -UseBasicParsing
        }
    } catch {
        Write-Warning "Failed to download or compare $url. Error: $_"
    }
}

# Download or update files
Compare-And-Update -url $bginfoUrl -localPath $bginfoExe
Compare-And-Update -url $bgiUrl -localPath $bgiFile
Compare-And-Update -url $shortcutUrl -localPath $startupScript

# Unblock in case of restrictions
Unblock-File $bginfoExe
Unblock-File $bgiFile
Unblock-File $startupScript

# Run BGInfo once immediately
Start-Process -FilePath $bginfoExe -ArgumentList "`"$bgiFile`" /silent /accepteula /timer:0" -WindowStyle Hidden

# Re-install shortcut (in case of changes)
powershell -ExecutionPolicy Bypass -File $startupScript
