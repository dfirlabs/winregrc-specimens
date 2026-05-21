# Script to prepare for generating Windows Registry resources test data

$Path = "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\RecentDocs\"
Remove-Item -ErrorAction SilentlyContinue -Path ${Path} -Recurse

$Path = "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\TypedPaths\"
Remove-Item -ErrorAction SilentlyContinue -Path ${Path} -Recurse

$Path = "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\UserAssist\"
Remove-Item -ErrorAction SilentlyContinue -Path ${Path} -Recurse

$Path = "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\WordWheelQuery\"
Remove-Item -ErrorAction SilentlyContinue -Path ${Path} -Recurse

$Path = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\Shell\BagMRU"
Remove-Item -ErrorAction SilentlyContinue -Path ${Path} -Recurse

$Path = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\Shell\Bags"
Remove-Item -ErrorAction SilentlyContinue -Path ${Path} -Recurse
