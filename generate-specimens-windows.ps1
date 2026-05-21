# Script to generate Windows Registry resources test data

# Open notepad via the Windows shell

$WindowsShell = New-Object -ComObject "wscript.shell"

New-Item -ItemType "File" -Name "text1.txt" -Force | Out-Null

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

# Open notepad via its Start Menu shortcut with the Windows shell

$NotepadLnkPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\Notepad.lnk"

$WindowsShell = New-Object -ComObject "wscript.shell"

New-Item -ItemType "File" -Name "text2.txt" -Force | Out-Null

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

# TODO: open non exe using LNK

# Open notepad via the PIDL in the Start Menu shortcut with the Windows shell

$ShellApp = New-Object -ComObject "Shell.Application"
$WindowsShell = New-Object -ComObject "wscript.shell"

# %CommonPrograms% => "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
$ProgramsPath = [Environment]::GetFolderPath("CommonPrograms")
$AccessoriesPath = Join-Path $ProgramsPath "Accessories"

if (-not (Test-Path $AccessoriesPath)) {
    New-Item -ItemType "Directory" -Path $AccessoriesPath -Force | Out-Null
}

$LnkFilePath = Join-Path $AccessoriesPath "Notepad.lnk"
if (-not (Test-Path $LnkFilePath)) {
    $Shortcut = $WindowsShell.CreateShortcut($LnkFilePath)
    $Shortcut.TargetPath = "C:\Windows\System32\notepad.exe"
    $Shortcut.Save()
}

$ShortcutFolder = $ShellApp.NameSpace($AccessoriesPath)
$ShortcutItem = $ShortcutFolder.ParseName("Notepad.lnk")

# InvokeVerb("open") evaluates the internal tracking structure (PIDL stream metadata) 
# This emulates double-clicking an explorer item
$ShortcutItem.InvokeVerb("open")

Start-Sleep -Seconds 1.5

New-Item -ItemType "File" -Name "text3.txt" -Force | Out-Null

$WindowsShell.AppActivate("Untitled - Notepad")

$WindowsShell.SendKeys("First line of text in notepad via PIDL")
$WindowsShell.SendKeys("{ENTER}")
$WindowsShell.SendKeys("Some more text")

# Send Ctrl+S
$WindowsShell.SendKeys("^s")
Start-Sleep -Seconds 3.0

$WindowsShell.SendKeys("${Pwd}\text3.txt")
$WindowsShell.SendKeys("{ENTER}")
Start-Sleep -Seconds 1.0

# Send Alt+F4
$WindowsShell.SendKeys("%{F4}")

# Prevent "Error: The operation was canceled."
Get-Process -ErrorAction SilentlyContinue -Name "notepad" | Stop-Process -Force
