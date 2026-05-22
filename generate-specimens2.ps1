# Script to generate Windows Registry resources test data
# Opens notepad via its Start Menu shortcut

New-Item -Force -ItemType "File" -Name "text2.txt" | Out-Null

$NotepadLnkPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Notepad.lnk"

$WindowsShell = New-Object -ComObject "wscript.shell"

# Use escaped quotes to handle spaces correctly
$WindowsShell.Run("cmd /c start `"`" `"$NotepadLnkPath`" `"${Pwd}\text2.txt`"")

$WindowsShell.AppActivate("text2.txt - Notepad")

Start-Sleep -Seconds 2.0

$WindowsShell.SendKeys("First line of text in notepad via shortcut")
$WindowsShell.SendKeys("{ENTER}")
$WindowsShell.SendKeys("Some more text")

# Send Alt+F4
$WindowsShell.SendKeys("%{F4}")

Start-Sleep -Seconds 1.0

$WindowsShell.SendKeys("%S")
