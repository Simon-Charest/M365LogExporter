function Invoke-Menu([int]$menuInput)
{
	switch ($menuInput)
	{
		1
		{
			Disconnect-ExchangeOnline -Confirm:$false
			Connect-ExchangeOnlineOnce
		}
		2
		{
			Get-AdminAuditLogConfig |
				Format-List UnifiedAuditLogIngestionEnabled
			Write-Host "Press any key to continue" -ForegroundColor:$Global:informationColor
        	[Console]::ReadKey()
		}
		3
		{
			$userIds = Select-Users
			Export-Metrics $userIds $Global:metrics $Global:recordTypes
		}
		4
		{
			[DateTime]$startDate = Get-StartDate
			[DateTime]$endDate = Get-EndDate
			$minutes = Read-Host "Enter time interval in minutes or leave empty for 60"
		
			if ([string]::IsNullOrWhiteSpace($minutes))
			{
				$minutes = 60
			}

			$userIds = Select-Users
			Export-All $startDate $endDate $Global:dateFormat $minutes $Global:resultSize $userIds $Global:properties $Global:data $Global:metadata
			Export-Hashes $Global:hashes
		}
		5
		{
			$userIds = Select-Users
			Export-Group $userIds
		}
		6 { Export-Specific }
		7 { Show-Content $null "README.txt" $true }
		8 { Show-Content $null "LICENSE.txt" $true }
		9 { Show-Content $null "ABOUT.txt" $true }
		0 { Write-Host "** DONE **" -ForegroundColor:$Global:successColor }
	}
}
