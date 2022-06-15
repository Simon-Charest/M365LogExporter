function Write-ToFile([string]$object, [string]$filePath, [string]$foregroundColor = $Global:informationColor, [string]$dateFormat = $Global:dateFormat)
{
    [string]$now = [DateTime]::Now.ToString($dateFormat)
    [string]$value = "[$now] $($object)"

    # Print to screen
    Write-Host $value -ForegroundColor:$foregroundColor
    
    # Append to file
    $value |
        Out-File $filePath -Append
}
