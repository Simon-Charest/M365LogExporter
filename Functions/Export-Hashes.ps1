function Export-Hashes([string]$hashes, [string]$filter = "*.csv", [string]$algorithm = "SHA256")
{
    Get-ChildItem $Global:exportDirectory -Filter:$filter |
    Get-FileHash -Algorithm:$algorithm |
    Export-Csv $hashes
}
