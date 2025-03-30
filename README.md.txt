# BGInfo Deployment for Windows Endpoints

This repository provides everything needed to deploy [BGInfo](https://learn.microsoft.com/en-us/sysinternals/downloads/bginfo) via SuperOps or any RMM to show hostname and key info on the desktop background.

---

## ✅ Features
- Displays Windows computer name, username, and IP on desktop
- Branded with "Managed by CinnTech"
- Silent install and runs at every user login
- Compatible with SuperOps scripting engine

---

## 📦 Files Included

| File                    | Purpose                                                      |
|-------------------------|--------------------------------------------------------------|
| `Deploy-BGInfo.ps1`     | Installs BGInfo and runs it silently                         |
| `Startup-Shortcut.ps1`  | Creates a shortcut to run BGInfo at user login              |
| `CinnTech-Hostname.bgi` | Preconfigured layout file with desired fields and branding  |
| `LICENSE`               | MIT License                                                  |

---

## 🛠️ How to Deploy with SuperOps

### Step 1: Upload Files
Upload all files to a public location (your GitHub raw URLs or private storage with direct links).

### Step 2: Adjust URLs in `Deploy-BGInfo.ps1`
Update the URLs in the script to point to your hosted copies of:
- `Bginfo.exe`
- `CinnTech-Hostname.bgi`
- `Startup-Shortcut.ps1`

### Step 3: Create Script in SuperOps
Paste the contents of `Deploy-BGInfo.ps1` into a new script in SuperOps.

### Step 4: Set Execution
- Run **once on install**
- Then, **create a script schedule to run at every user login** (if not using the startup shortcut method)

### Optional: Deploy `Startup-Shortcut.ps1` via SuperOps or include it in the first script
This ensures BGInfo re-applies on every user login.

---

## 🎨 Screenshot (Optional)
Add a screenshot here showing what the BGInfo overlay looks like.

---

## 🔐 Fields in Use (from .BGI)
- Computer Name
- Username
- IP Address
- Custom Text: `Managed by CinnTech`

---

## 🤝 License
MIT — free to use, modify, and distribute.

---

For questions or customization:
**https://cinntech.com**

> Professional, automated desktop info overlays — powered by CinnTech.

---

## 🔧 Deploy-BGInfo.ps1
```powershell
$destPath = "C:\ProgramData\BGInfo"
$bginfoExe = "$destPath\Bginfo.exe"
$bgiFile = "$destPath\CinnTech-Hostname.bgi"
$startupScript = "$destPath\Startup-Shortcut.ps1"

# URLs to download BGInfo and config (replace with your raw GitHub URLs)
$bginfoUrl = "https://raw.githubusercontent.com/cinntech/bginfo/main/Bginfo.exe"
$bgiUrl = "https://raw.githubusercontent.com/cinntech/bginfo/main/CinnTech-Hostname.bgi"
$startupScriptUrl = "https://raw.githubusercontent.com/cinntech/bginfo/main/Startup-Shortcut.ps1"

# Create destination directory if it doesn't exist
if (-not (Test-Path $destPath)) {
    New-Item -ItemType Directory -Path $destPath -Force
}

# Download files
Invoke-WebRequest -Uri $bginfoUrl -OutFile $bginfoExe -UseBasicParsing
Invoke-WebRequest -Uri $bgiUrl -OutFile $bgiFile -UseBasicParsing
Invoke-WebRequest -Uri $startupScriptUrl -OutFile $startupScript -UseBasicParsing

# Run BGInfo once immediately
Start-Process -FilePath $bginfoExe -ArgumentList "`"$bgiFile`" /silent /timer:0 /accepteula" -WindowStyle Hidden

# Run the startup shortcut script to create login automation
powershell -ExecutionPolicy Bypass -File $startupScript
```

---

## 🔁 Startup-Shortcut.ps1
```powershell
$bginfoPath = "C:\ProgramData\BGInfo\Bginfo.exe"
$bgiFile = "C:\ProgramData\BGInfo\CinnTech-Hostname.bgi"
$startupShortcut = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\BGInfo.lnk"

$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut($startupShortcut)
$shortcut.TargetPath = $bginfoPath
$shortcut.Arguments = "`"$bgiFile`" /silent /timer:0 /accepteula"
$shortcut.IconLocation = "$bginfoPath, 0"
$shortcut.Save()
```

---

## 📄 LICENSE
```text
MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---
