function Get-EndDate()
{
    $endDate = $null

    do
    {
        if ($null -ne $endDate)
        {
            Write-Host "Not a valid date and time." -ForegroundColor:"Red"
        }

        $dateEnd = Read-Host "Please enter end date (format: yyyy-MM-dd) or ENTER for today"

        if ([string]::IsNullOrWhiteSpace($dateEnd))
        {
            $dateEnd = [DateTime]::Now.ToUniversalTime()
        }
		
        $endDate = $dateEnd -as [DateTime]
    }
    while ($endDate -isnot [DateTime])

    $dateString = Get-Date $endDate -Format "yyyy-MM-dd HH:mm:ss"

    return $dateString
}
