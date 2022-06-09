function Get-StartDate()
{
    $inputDate = $null

    do
    {
        if ($null -ne $inputDate)
        {
            Write-Host "Unexpected input. Please try again." -ForegroundColor:$Global:errorColor
        }

        $inputDate = Read-Host "Enter start date (format: yyyy-MM-dd) or leave empty for 90 days ago"

        if ([string]::IsNullOrWhiteSpace($inputDate))
		{
			$inputDate = [DateTime]::Now.ToUniversalTime().AddDays(-90)
		}

        $inputDate = $inputDate -as [DateTime]
	}
	while ($inputDate -isnot [DateTime])
	
	[string]$dateString = Get-Date $inputDate -Format:"yyyy-MM-dd 00:00:00"

    return $dateString  
}
