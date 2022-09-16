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
			Invoke-Pause
		}
		3
		{
			[string]$userIds = Select-Users
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
			
			Export-Logs $endDate $startDate $null $Global:resultSize $userIds $minutes $Global:dateFormat $Global:metadata $Global:data $Global:informationColor $Global:successColor $Global:warningColor $Global:errorColor
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
			Write-Host "AuditLogRecordType: https://docs.microsoft.com/en-us/office/office-365-management-api/office-365-management-activity-api-schema#auditlogrecordtype"
			$recordTypes = -1

			do
			{
				if ($recordTypes -ne -1)
				{
					Write-Host "Unexpected input. Please try again." -ForegroundColor:$Global:errorColor
				}
				
				$recordTypes = Select-RecordTypes
			}
			while ([string]::IsNullOrWhiteSpace($recordTypes))

			Export-RecordType $recordTypes
		}
		10 { Show-Content $null "README.md" $true }
		11 { Show-Content $null "LICENSE.txt" $true }
		12 { Show-Content $null "ABOUT.md" $true }
		13 { Write-Host "** DONE **" -ForegroundColor:$Global:successColor }
	}
}
