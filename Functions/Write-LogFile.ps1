function Write-LogFile([string]$value, [string]$filePath)
{
    "[$([DateTime]::Now.ToString())] $($value)" |
        Out-File $filePath -Append
}
