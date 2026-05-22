# Script to generate Windows Registry resources test data
# Opens notepad via the (graphical) File Browser.

Remove-Item -ErrorAction SilentlyContinue -Force -Path text4.txt

$WindowsShell = New-Object -ComObject "wscript.shell"

# %CommonPrograms% => "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
$ProgramsPath = [Environment]::GetFolderPath("CommonPrograms")
$AccessoriesPath = Join-Path $ProgramsPath "Accessories"

if (-not (Test-Path $AccessoriesPath)) {
    New-Item -Force -ItemType "Directory" -Path $AccessoriesPath | Out-Null
}

$LnkFilePath = Join-Path $AccessoriesPath "Notepad.lnk"
if (-not (Test-Path $LnkFilePath)) {
    $Shortcut = $WindowsShell.CreateShortcut($LnkFilePath)
    $Shortcut.TargetPath = "C:\Windows\System32\notepad.exe"
    $Shortcut.Save()
}

$ShellApp = New-Object -ComObject "Shell.Application"
$ShortcutFolder = $ShellApp.NameSpace($AccessoriesPath)
$ShortcutItem = $ShortcutFolder.ParseName("Notepad.lnk")

# InvokeVerb("open") emulates double-clicking an explorer item
$ShortcutItem.InvokeVerb("open")

Start-Sleep -Seconds 1.5

$WindowsShell.AppActivate("Untitled - Notepad")

$WindowsShell.SendKeys("First line of text in notepad via Shell.Application")
$WindowsShell.SendKeys("{ENTER}")
$WindowsShell.SendKeys("Some more text")

# Send Ctrl+S
$WindowsShell.SendKeys("^s")
Start-Sleep -Seconds 1.0

$WindowsShell.SendKeys("${Pwd}\text4.txt")
$WindowsShell.SendKeys("{ENTER}")
Start-Sleep -Seconds 1.0

# Send Alt+F4
$WindowsShell.SendKeys("%{F4}")
