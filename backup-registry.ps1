# Backup Windows Registry keys using RegSaveKeyEx.

$HKEY_CURRENT_USER = [IntPtr]0x80000001
$KEY_READ = 0x00020019
$REG_STANDARD_FORMAT = 0x00000001

function BackupRegistryKey {
    param (
        [Parameter(Mandatory = $true)]
        [IntPtr]$BaseKeyHandle,

        [Parameter(Mandatory = $false)]
        [string]$SubKeyPath = $null,

        [Parameter(Mandatory = $true)]
        [string]$DestinationPath,

        [Parameter(Mandatory = $true)]
        [string]$HiveName
    )
    $TargetHandle = $BaseKeyHandle

    if (-not [string]::IsNullOrEmpty($SubKeyPath)) {
        $SubKeyHandle = [IntPtr]::Zero
        $OpenResult = [WinRegRc.BackupKey]::RegOpenKeyEx($BaseKeyHandle, $SubKeyPath, 0, $KEY_READ, [ref]$SubKeyHandle)
        
        if ($OpenResult -ne 0 -or $SubKeyHandle -eq [IntPtr]::Zero) {
            Write-Host -ForegroundColor Red "[-] Failed to bind subkey handle for '$SubKeyPath', with error: $OpenResult"
            return
        }
        $TargetHandle = $SubKeyHandle
    }
    [void][WinRegRc.BackupKey]::RegFlushKey($TargetHandle)

    $SaveResult = [WinRegRc.BackupKey]::RegSaveKeyEx($TargetHandle, $DestinationPath, [IntPtr]::Zero, $REG_STANDARD_FORMAT)

    if (-not [string]::IsNullOrEmpty($SubKeyPath)) {
        [void][WinRegRc.BackupKey]::RegCloseKey($TargetHandle)
    }
    if ($SaveResult -ne 0) {
        Write-Host -ForegroundColor Red "[-] Failed to back up '$HiveName', with WIN32 Error Code: $SaveResult"
    } else {
        Write-Host "[+] Success: '$HiveName' safely backed up to: '$DestinationPath'"
    }
}

$TypeExists = [Type]::GetType("WinRegRc.BackupKey") -ne $null

if (-not $TypeExists) {
    Write-Host "[*] Compiling native backup Win32 API endpoints into memory..."
    $Signature = @'
    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern int RegFlushKey(IntPtr hKey);

    [DllImport("advapi32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern int RegOpenKeyEx(IntPtr hKey, string lpSubKey, uint ulOptions, int samDesired, out IntPtr phkResult);

    [DllImport("advapi32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern int RegSaveKeyEx(IntPtr hKey, string lpFile, IntPtr lpSecurityAttributes, uint Flags);

    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern int RegCloseKey(IntPtr hKey);
'@

    [void](Add-Type -MemberDefinition $Signature -Name "BackupKey" -Namespace "WinRegRc" -PassThru)
}

# Enforce Administrator Rights & Enable SeBackupPrivilege
$TokenSignature = @'
[DllImport("ntdll.dll")]
public static extern int RtlAdjustPrivilege(ulong Privilege, bool Enable, bool CurrentThread, out bool Enabled);
'@

$NtDll = Add-Type -MemberDefinition $TokenSignature -Name "NtPrivilege" -Namespace "WinRegRc" -PassThru

$OutputPriv = $false
[void]$NtDll::RtlAdjustPrivilege(17, $true, $false, [ref]$OutputPriv)

$CurrentTime = (Get-Date).ToString("yyyyMMddTHHmmssZ")

$BackupDir = "${Pwd}\RegistryBackups_$CurrentTime"

if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

Write-Host "[*] Backup directory: $BackupDir"

BackupRegistryKey `
    -BaseKeyHandle $HKEY_CURRENT_USER `
    -DestinationPath (Join-Path $BackupDir "NTUSER.DAT") `
    -HiveName "NTUSER.DAT"

BackupRegistryKey `
    -BaseKeyHandle $HKEY_CURRENT_USER `
    -SubKeyPath "Software\Classes" `
    -DestinationPath (Join-Path $BackupDir "UsrClass.dat") `
    -HiveName "USRCLASS.DAT"
