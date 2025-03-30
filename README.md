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
