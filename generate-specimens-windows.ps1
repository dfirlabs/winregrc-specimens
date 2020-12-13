# Script to generate Windows Registry resources test data

$WindowsShell = New-Object -ComObject "wscript.shell"

New-Item -ItemType "File" -Name "text.txt"

$WindowsShell.Run("write.exe ${Pwd}\text.txt")

# Bring the window named "WordPad" in focus
$WindowsShell.AppActivate("text.txt - WordPad")

Start-Sleep -Seconds 2.0

# $WindowsShell.SendKeys("%Y")

$WindowsShell.SendKeys("First line of text")
$WindowsShell.SendKeys("{ENTER}")
$WindowsShell.SendKeys("Some more text")

# Send Alt+F4
$WindowsShell.SendKeys("%{F4}")

Start-Sleep -Seconds 1.0

$WindowsShell.SendKeys("%S")

# TODO: experiment with different focus durations

# TODO: open notepad.exe using Deskop LNK
# TODO: open some using non-Deskop LNK
# TODO: open non exe using LNK
# TODO: open LNK via PIDL

