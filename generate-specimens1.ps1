# Script to generate Windows Registry resources test data
# Opens notepad by running notepad.exe

New-Item -Force -ItemType "File" -Name "text1.txt" | Out-Null

$WindowsShell = New-Object -ComObject "wscript.shell"

$WindowsShell.Run("notepad.exe ${Pwd}\text1.txt")

# Bring the window named "Notepad" in focus
$WindowsShell.AppActivate("text1.txt - Notepad")

Start-Sleep -Seconds 2.0

# $WindowsShell.SendKeys("%Y")

$WindowsShell.SendKeys("First line of text in notepad")
$WindowsShell.SendKeys("{ENTER}")
$WindowsShell.SendKeys("Some more text")

# Send Alt+F4
$WindowsShell.SendKeys("%{F4}")

Start-Sleep -Seconds 1.0

$WindowsShell.SendKeys("%S")
