# Script to sync explorer.exe internal caches to disk on Windows 10 and later.

$HKEY_CURRENT_USER = [IntPtr]0x80000001
$KEY_QUERY_VALUE = 0x0001
$KEY_ENUMERATE_SUB_KEYS = 0x0008
$KEY_NOTIFY = 0x0010
$STANDARD_RIGHTS_READ = 0x00020000
$KEY_READ = ($STANDARD_RIGHTS_READ -bor $KEY_QUERY_VALUE -bor $KEY_ENUMERATE_SUB_KEYS -bor $KEY_NOTIFY)

$TypeExists = [Type]::GetType("WinRegRc.ExplorerCacheSync") -ne $null

if (-not $TypeExists) {
    $Signature = @'
    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern IntPtr PostMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern int RegFlushKey(IntPtr hKey);

    [DllImport("advapi32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern int RegOpenKeyEx(IntPtr hKey, string lpSubKey, uint ulOptions, int samDesired, out IntPtr phkResult);

    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern int RegCloseKey(IntPtr hKey);
'@

    [void](Add-Type -MemberDefinition $Signature -Name "ExplorerCacheSync" -Namespace "WinRegRc" -PassThru)
}

$NtUserPath = "$env:USERPROFILE\NTUSER.DAT"
$UsrClassPath = "$env:USERPROFILE\AppData\Local\Microsoft\Windows\UsrClass.dat"

# Target the System Tray window (Shell_TrayWnd).
$ShellHandle = [WinRegRc.ExplorerCacheSync]::FindWindow("Shell_TrayWnd", $null)

if ($ShellHandle -eq [IntPtr]::Zero) {
    Write-Host -ForegroundColor Red "[-] Unable to locate System Tray window (Shell_TrayWnd)."
} else {
    $NtUserInitialTimestamp   = (Get-Item -Path $NtUserPath -Force).LastWriteTime
    $UsrClassInitialTimestamp = (Get-Item -Path $UsrClassPath -Force).LastWriteTime

    # Posting a WM_CLOSE message to explorer.exe will trigger the shutdown dialog.
    [void][WinRegRc.ExplorerCacheSync]::PostMessage($ShellHandle, $WM_CLOSE, [IntPtr]::Zero, [IntPtr]::Zero)
    Write-Host "[*] WM_CLOSE message dispatched to System Tray window."

    $UiTimeout = 8
    $DialogHandle = [IntPtr]::Zero

    while ($UiTimeout -gt 0) {
        # #32770 is the class identifier for the Windows Shut Down dialog window
        $DialogHandle = [WinRegRc.ExplorerCacheSync]::FindWindow("#32770", "Shut Down Windows")
        
        if ($DialogHandle -ne [IntPtr]::Zero) {
            # Hide the Shut Down dialog from the user.
            [void][WinRegRc.ExplorerCacheSync]::ShowWindow($DialogHandle, $SW_HIDE)
            break
        }
        Start-Sleep -Milliseconds 100
        $UiTimeout -= 0.1
    }
    if ($DialogHandle -ne [IntPtr]::Zero) {
        Start-Sleep -Seconds 3
        
        # Abort the Windows Shut Down dialog.
        [void][WinRegRc.ExplorerCacheSync]::PostMessage($DialogHandle, $WM_CLOSE, [IntPtr]::Zero, [IntPtr]::Zero)
    }
    $NtUserFlushResult = [WinRegRc.ExplorerCacheSync]::RegFlushKey($HKEY_CURRENT_USER)
    
    # Force a sync of UsrClass.dat (HKEY_CURRENT_USER\Software\Classes) to disk.
    $ClassesHandle = [IntPtr]::Zero
    $OpenResult = [WinRegRc.ExplorerCacheSync]::RegOpenKeyEx($HKEY_CURRENT_USER, "Software\Classes", 0, $KEY_READ, [ref]$ClassesHandle)
    
    if ($OpenResult -ne 0 -or $ClassesHandle -eq [IntPtr]::Zero) {
        Write-Host -ForegroundColor Red "[-] Failed to open 'Software\Classes' key with exit code: $OpenResult"
        $UsrClassFlushResult = -1
    } else {
        $UsrClassFlushResult = [WinRegRc.ExplorerCacheSync]::RegFlushKey($ClassesHandle)
        [void][WinRegRc.ExplorerCacheSync]::RegCloseKey($ClassesHandle)
    }
    Start-Sleep -Seconds 2
    
    if ($NtUserFlushResult -ne 0) {
        Write-Host -ForegroundColor Red "[-] Failed to sync to disk NTUSER.DAT with exit code: $NtUserFlushResult"
    } else {
        $CurrentTimestamp = (Get-Item -Path $NtUserPath -Force).LastWriteTime.ToString($Iso8601Format)
        Write-Host "[+] Flushed NTUSER.DAT at $CurrentTimestamp"
    }
    if ($UsrClassFlushResult -ne 0) {
        Write-Host -ForegroundColor Red "[-] Failed to sync to disk UsrClass.dat with exit code: $UsrClassFlushResult"
    } else {
        $CurrentTimestamp = (Get-Item -Path $UsrClassPath -Force).LastWriteTime.ToString($Iso8601Format)
        Write-Host "[+] Flushed UsrClass.dat at $CurrentTimestamp"
    }
}
