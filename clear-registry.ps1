# Removes the Windows Registry keys used for testing.

. .\shared-windows.ps1

ForEach ($KeyPath in $TestKeys) {
    Remove-Item -ErrorAction SilentlyContinue -Path $KeyPath -Recurse
}
