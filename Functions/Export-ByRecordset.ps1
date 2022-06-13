function Export-ByRecordset($recordTypes)
{
	[DateTime]$startDate = Get-StartDate
	[DateTime]$endDate = Get-EndDate
	[string]$userIds = Select-Users
	$minutes = Read-Host "Enter time interval in minutes or leave empty for 60"

	if ([string]::IsNullOrWhiteSpace($minutes))
	{
		$minutes = 60
	}
	
	foreach ($recordType in $recordTypes)
	{
		Export-Logs $endDate $startDate $recordType $Global:resultSize $userIds $Global:properties $minutes $Global:dateFormat $Global:jsonData $Global:csvData $Global:metadata $Global:informationColor $Global:successColor $Global:warningColor $Global:errorColor $Global:debug
	}

	Export-Hashes $Global:hashes
}
