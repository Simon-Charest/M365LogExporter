function Get-EndDate()
{
    $inputDate = $null

    do
    {
        if ($null -ne $inputDate)
        {
            Write-Host "Unexpected input. Please try again." -ForegroundColor:$Global:errorColor
        }

        $inputDate = Read-Host "Enter end date (format: yyyy-MM-dd) or leave empty for today"

        if ([string]::IsNullOrWhiteSpace($inputDate))
        {
            $inputDate = [DateTime]::Now.ToUniversalTime()
        }

        $inputDate = $inputDate -as [DateTime]
    }
    while ($inputDate -isnot [DateTime])

    [string]$dateString = Get-Date $inputDate -Format:"yyyy-MM-dd HH:mm:ss"

    return $dateString
}
