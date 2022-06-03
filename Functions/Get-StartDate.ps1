function Get-StartDate()
{
    $inputDate = $null

    do
    {
        if ($null -ne $inputDate)
        {
            Write-Host "Unexpected input. Please try again." -ForegroundColor:"Red"
			Write-Host
        }

	    Write-Host "Enter start date (format: yyyy-MM-dd) or leave empty for 90 days ago."
        $inputDate = Read-Host "Input"

		if ([string]::IsNullOrWhiteSpace($inputDate))
		{
			$inputDate = [DateTime]::Now.ToUniversalTime().AddDays(-90)
		}
	}
	while ($inputDate -isnot [DateTime])
	
	[string]$dateString = Get-Date $inputDate -Format "yyyy-MM-dd HH:mm:ss"

    return $dateString
}
