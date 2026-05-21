# Script to preserving generated Windows Registry resources test data

$Path = "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\RecentDocs\"
Get-ChildItem -ErrorAction SilentlyContinue -Path ${Path} -Recurse | Get-ItemProperty

$Path = "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\TypedPaths\"
Get-ChildItem -ErrorAction SilentlyContinue -Path ${Path} -Recurse | Get-ItemProperty

$Path = "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\UserAssist\"
Get-ChildItem -ErrorAction SilentlyContinue -Path ${Path} -Recurse | Get-ItemProperty

$Path = "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\WordWheelQuery\"
Get-ChildItem -ErrorAction SilentlyContinue -Path ${Path} -Recurse | Get-ItemProperty

$Path = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\Shell\BagMRU"
Get-ChildItem -ErrorAction SilentlyContinue -Path ${Path} -Recurse | Get-ItemProperty

$Path = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\Shell\Bags"
Get-ChildItem -ErrorAction SilentlyContinue -Path ${Path} -Recurse | Get-ItemProperty

