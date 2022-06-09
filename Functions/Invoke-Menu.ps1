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
			[string]$userIds = Select-Users
			$minutes = Read-Host "Enter time interval in minutes or leave empty for 60"
		
			if ([string]::IsNullOrWhiteSpace($minutes))
			{
				$minutes = 60
			}
			
			Export-All $endDate $startDate $null $Global:resultSize $userIds $Global:properties $minutes $Global:dateFormat $Global:data $Global:metadata $Global:informationColor $Global:successColor $Global:warningColor $Global:errorColor
			Export-Hashes $Global:hashes
		}
		5
		{
			$recordTypes = @("AzureActiveDirectory","AzureActiveDirectoryAccountLogon","AzureActiveDirectoryStsLogon")
			
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
				Export-All $endDate $startDate $recordType $Global:resultSize $userIds $Global:properties $minutes $Global:dateFormat $Global:data $Global:metadata $Global:informationColor $Global:successColor $Global:warningColor $Global:errorColor
			}

			Export-Hashes $Global:hashes
		}
		6
		{
			$recordTypes = @("ExchangeAdmin","ExchangeAggregatedOperation","ExchangeItem","ExchangeItemGroup","ExchangeItemAggregated","ComplianceDLPExchange","ComplianceSupervisionExchange","MipAutoLabelExchangeItem")
			
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
				Export-All $endDate $startDate $recordType $Global:resultSize $userIds $Global:properties $minutes $Global:dateFormat $Global:data $Global:metadata $Global:informationColor $Global:successColor $Global:warningColor $Global:errorColor
			}

			Export-Hashes $Global:hashes
		}
		7
		{
			$recordTypes = @("ComplianceDLPSharePoint","SharePoint","SharePointFileOperation","SharePointSharingOperation","SharepointListOperation", "ComplianceDLPSharePointClassification","SharePointCommentOperation", "SharePointListItemOperation", "SharePointContentTypeOperation", "SharePointFieldOperation","MipAutoLabelSharePointItem","MipAutoLabelSharePointPolicyLocation")
			
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
				Export-All $endDate $startDate $recordType $Global:resultSize $userIds $Global:properties $minutes $Global:dateFormat $Global:data $Global:metadata $Global:informationColor $Global:successColor $Global:warningColor $Global:errorColor
			}

			Export-Hashes $Global:hashes
		}
		8
		{
			$recordTypes = @("SkypeForBusinessCmd","SkypeForBusinessPSTNUsage","SkypeForBusinessUsersBlocked")
			
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
				Export-All $endDate $startDate $recordType $Global:resultSize $userIds $Global:properties $minutes $Global:dateFormat $Global:data $Global:metadata $Global:informationColor $Global:successColor $Global:warningColor $Global:errorColor
			}

			Export-Hashes $Global:hashes
		}
		9
		{
			Write-Host "In development" -ForegroundColor:$Global:warningColor
			Write-Host "Press any key to continue" -ForegroundColor:$Global:informationColor
        	[Console]::ReadKey()
		}
		10 { Show-Content $null "README.txt" $true }
		11 { Show-Content $null "LICENSE.txt" $true }
		12 { Show-Content $null "ABOUT.txt" $true }
		13 { Write-Host "** DONE **" -ForegroundColor:$Global:successColor }
	}
}
