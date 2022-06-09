function Write-ToFile([string]$object, [string]$filePath, $foregroundColor = $Global:informationColor, $dateFormat = $Global:dateFormat)
{
    [string]$now = [DateTime]::Now.ToString($dateFormat)
    $value = "[$now] $($object)"

    # Print to screen
    Write-Host $value -ForegroundColor:$foregroundColor
    
    # Append to file
    $value | Out-File $filePath -Append
}
