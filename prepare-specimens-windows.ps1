# Script to prepare for generating Windows Registry resources test data

Remove-Item -Recurse -Path "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\RecentDocs\"
Remove-Item -Recurse -Path "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\TypedPaths\"
Remove-Item -Recurse -Path "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\UserAssist\"
Remove-Item -Recurse -Path "HKEY_CURRENT_USER\Software\Microsoft\Windows\Currentversion\Explorer\WordWheelQuery\"

Remove-Item -Recurse -Path "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\Shell\BagMRU"
Remove-Item -Recurse -Path "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\Shell\Bags"

