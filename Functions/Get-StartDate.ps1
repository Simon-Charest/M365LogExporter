function Get-StartDate()
{
    $startDate = $null

    do
    {
        if ($null -ne $startDate)
        {
            Write-Host "Not a valid date and time." -ForegroundColor:"Red"
        }

	    $dateStart = Read-Host "Please enter start date (format: yyyy-MM-dd) or ENTER for maximum 90 days"
        
		if ([string]::IsNullOrWhiteSpace($dateStart))
		{
			$dateStart = [DateTime]::Now.ToUniversalTime().AddDays(-90)
		}
		
		$startDate = $dateStart -as [DateTime]
	}
	while ($startDate -isnot [DateTime])
	
	$dateString = Get-Date $startDate -Format "yyyy-MM-dd HH:mm:ss"

    return $dateString
}
