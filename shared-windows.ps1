# Shared functionality for scripts.

# Powershell requires the use of "HKCU:" instead of "HKEY_CURRENT_USER" 

$TestKeys = @(
    "HKCU:\Software\Microsoft\Windows\Currentversion\Explorer\RecentDocs"
    "HKCU:\Software\Microsoft\Windows\Currentversion\Explorer\TypedPaths"
    "HKCU:\Software\Microsoft\Windows\Currentversion\Explorer\UserAssist"
    "HKCU:\Software\Microsoft\Windows\Currentversion\Explorer\WordWheelQuery"
    "HKCU:\Local Settings\Software\Microsoft\Windows\Shell\BagMRU"
    "HKCU:\Local Settings\Software\Microsoft\Windows\Shell\Bags"
    "HKCU:\Local Settings\Software\Microsoft\Windows\ShellNoRoam\BagMRU"
    "HKCU:\Local Settings\Software\Microsoft\Windows\ShellNoRoam\Bags"
    "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\BagMRU"
    "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags"
    "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\ShellNoRoam\BagMRU"
    "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\ShellNoRoam\Bags"
    "HKCU:\Software\Microsoft\Windows\Shell\BagMRU"
    "HKCU:\Software\Microsoft\Windows\Shell\Bags"
    "HKCU:\Software\Microsoft\Windows\ShellNoRoam\BagMRU"
    "HKCU:\Software\Microsoft\Windows\ShellNoRoam\Bags"
)
