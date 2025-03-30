# BGInfo Deployment by CinnTech

This repository contains a pre-configured BGInfo deployment setup to display the Windows hostname and other useful information directly on the desktop background.

BGInfo is a lightweight, trusted tool by Microsoft Sysinternals that overlays system info on the user's desktop – perfect for identification, remote support, and audits.

---

## ✅ What This Shows

- **Computer Name**
- **Username**
- **IP Address (IPv4)**
- **OS Version**
- **Last Reboot**
- **Managed by CinnTech** (branding)

---

## 📦 Files

- `Deploy-BGInfo.ps1`: Deploys BGInfo, downloads files, and runs it silently.
- `Startup-Shortcut.ps1`: Adds a startup shortcut so BGInfo applies on every login.
- `CinnTech-Hostname.bgi`: Preconfigured BGInfo layout.
- `BGInfo.exe`: Official executable (or use a direct download link).
- `LICENSE`: MIT License.

---

## 🚀 Deployment via SuperOps

1. Upload all files to a public GitHub repo or internal file share.
2. Modify URLs in `Deploy-BGInfo.ps1` to reflect your hosted paths.
3. Deploy via SuperOps using a script task.

**Recommended:** Run once at install + a scheduled task for login, or add to startup.

---

## 💡 Why This?

- Easy identification of machines during support
- Clean, branded display of key info
- Lightweight and non-intrusive
- Ideal for managed IT environments

---

© CinnTech. For client inquiries or issues, visit [https://cinntech.com](https://cinntech.com)
