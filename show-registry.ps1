# Shows the contents (subkeys and values) of the Windows Registry keys used for testing.

. .\shared-windows.ps1

ForEach ($KeyPath in $TestKeys) {
    Get-ChildItem -ErrorAction SilentlyContinue -Path $KeyPath -Recurse | Get-ItemProperty | Out-Host
}
