'Script to prepare a Windows system before generating specimens

Set WindowsShell = WScript.CreateObject("WScript.Shell")

WindowsShell.RegDelete "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\RecentDocs\"
WindowsShell.RegDelete "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\TypedPaths\"
WindowsShell.RegDelete "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\UserAssist\"
WindowsShell.RegDelete "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\WordWheelQuery\"

WindowsShell.RegDelete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\Shell\BagMRU"
WindowsShell.RegDelete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\Shell\Bags"

