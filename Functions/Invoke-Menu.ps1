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
			Export-Metrics $Global:recordTypes $userIds $Global:metrics
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
			
			Export-Logs $endDate $startDate $null $Global:resultSize $userIds $Global:properties $minutes $Global:dateFormat $Global:jsonData $Global:csvData $Global:metadata $Global:informationColor $Global:successColor $Global:warningColor $Global:errorColor $Global:debug
			Export-Hashes $Global:hashes
		}
		5
		{
			$recordTypes = @("AzureActiveDirectory","AzureActiveDirectoryAccountLogon","AzureActiveDirectoryStsLogon")
			Export-ByRecordset $recordTypes
		}
		6
		{
			$recordTypes = @("ExchangeAdmin","ExchangeAggregatedOperation","ExchangeItem","ExchangeItemGroup","ExchangeItemAggregated","ComplianceDLPExchange","ComplianceSupervisionExchange","MipAutoLabelExchangeItem")
			Export-ByRecordset $recordTypes
		}
		7
		{
			$recordTypes = @("ComplianceDLPSharePoint","SharePoint","SharePointFileOperation","SharePointSharingOperation","SharepointListOperation", "ComplianceDLPSharePointClassification","SharePointCommentOperation", "SharePointListItemOperation", "SharePointContentTypeOperation", "SharePointFieldOperation","MipAutoLabelSharePointItem","MipAutoLabelSharePointPolicyLocation")
			Export-ByRecordset $recordTypes
		}
		8
		{
			$recordTypes = @("SkypeForBusinessCmd","SkypeForBusinessPSTNUsage","SkypeForBusinessUsersBlocked")
			Export-ByRecordset $recordTypes
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
