$bginfoExe = "C:\ProgramData\BGInfo\Bginfo.exe"
$bgiFile = "C:\ProgramData\BGInfo\CinnTech-Hostname.bgi"
$startupFolder = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
$shortcutPath = "$startupFolder\BGInfo.lnk"

# Create a shortcut to run BGInfo with delay at startup
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-WindowStyle Hidden -Command `"Start-Sleep 45; Start-Process '`"$bginfoExe`"' -ArgumentList '`"$bgiFile`" /silent /accepteula /timer:0'`""
$shortcut.WorkingDirectory = "C:\ProgramData\BGInfo"
$shortcut.Save()
