function Show-Log($filePath)
{
    $startDate = Get-StartDate
    $endDate = Get-EndDate
    $resultSize = 1
    $recordTypes = @("ExchangeAdmin","ExchangeItem","ExchangeItemGroup","SharePoint","SyntheticProbe","SharePointFileOperation","OneDrive","AzureActiveDirectory","AzureActiveDirectoryAccountLogon","DataCenterSecurityCmdlet","ComplianceDLPSharePoint","Sway","ComplianceDLPExchange","SharePointSharingOperation","AzureActiveDirectoryStsLogon","SkypeForBusinessPSTNUsage","SkypeForBusinessUsersBlocked","SecurityComplianceCenterEOPCmdlet","ExchangeAggregatedOperation","PowerBIAudit","CRM","Yammer","SkypeForBusinessCmdlets","Discovery","MicrosoftTeams","ThreatIntelligence","MailSubmission","MicrosoftFlow","AeD","MicrosoftStream","ComplianceDLPSharePointClassification","ThreatFinder","Project","SharePointListOperation","SharePointCommentOperation","DataGovernance","Kaizala","SecurityComplianceAlerts","ThreatIntelligenceUrl","SecurityComplianceInsights","MIPLabel","WorkplaceAnalytics","PowerAppsApp","PowerAppsPlan","ThreatIntelligenceAtpContent","LabelContentExplorer","TeamsHealthcare","ExchangeItemAggregated","HygieneEvent","DataInsightsRestApiAudit","InformationBarrierPolicyApplication","SharePointListItemOperation","SharePointContentTypeOperation","SharePointFieldOperation","MicrosoftTeamsAdmin","HRSignal","MicrosoftTeamsDevice","MicrosoftTeamsAnalytics","InformationWorkerProtection","Campaign","DLPEndpoint","AirInvestigation","Quarantine","MicrosoftForms","ApplicationAudit","ComplianceSupervisionExchange","CustomerKeyServiceEncryption","OfficeNative","MipAutoLabelSharePointItem","MipAutoLabelSharePointPolicyLocation","MicrosoftTeamsShifts","MipAutoLabelExchangeItem","CortanaBriefing","Search","WDATPAlerts","MDATPAudit")
    Write-Host "Fetching log count between $($startDate) and $($endDate)..." -ForegroundColor:"Yellow"
    $resultCount = Search-UnifiedAuditLog -EndDate:$EndDate -StartDate:$StartDate -ResultSize:$resultSize -UserIds:$Global:userIds |
        Out-String -Stream |
        Select-String "ResultCount"
    
    if (!$resultCount)
    {
        Write-host "No results found."
        
        return
    }

    $resultCountString = $resultAll.ToString().Split(":")[1]
    Write-Output "Total: $($resultCountString)"
    Write-Output "Total: $($resultCountString)" |
        Out-File $filePath -Append
    
    foreach ($recordType in $recordTypes)
    {	
        $resultCount = Search-UnifiedAuditLog -EndDate:$endDate -StartDate:$startDate -RecordType:$recordType -ResultSize:$resultSize -UserIds:$Global:userIds |
            Out-String -Stream |
            Select-String "ResultCount"
        
        if ($resultCount)
        {
            $resultCountString = $resultCount.ToString().Split(":")[1]
            Write-Output "$($recordType): $($resultCountString)"
            Write-Output "$($recordType): $($resultCountString)" |
                Out-File $filePath -Append
        }
    }
}
