function Show-Log($filePath)
{
    $startDate = Get-StartDate
    $endDate = Get-EndDate    
    $recordTypes = @("ExchangeAdmin","ExchangeItem","ExchangeItemGroup","SharePoint","SyntheticProbe","SharePointFileOperation","OneDrive","AzureActiveDirectory","AzureActiveDirectoryAccountLogon","DataCenterSecurityCmdlet","ComplianceDLPSharePoint","Sway","ComplianceDLPExchange","SharePointSharingOperation","AzureActiveDirectoryStsLogon","SkypeForBusinessPSTNUsage","SkypeForBusinessUsersBlocked","SecurityComplianceCenterEOPCmdlet","ExchangeAggregatedOperation","PowerBIAudit","CRM","Yammer","SkypeForBusinessCmdlets","Discovery","MicrosoftTeams","ThreatIntelligence","MailSubmission","MicrosoftFlow","AeD","MicrosoftStream","ComplianceDLPSharePointClassification","ThreatFinder","Project","SharePointListOperation","SharePointCommentOperation","DataGovernance","Kaizala","SecurityComplianceAlerts","ThreatIntelligenceUrl","SecurityComplianceInsights","MIPLabel","WorkplaceAnalytics","PowerAppsApp","PowerAppsPlan","ThreatIntelligenceAtpContent","LabelContentExplorer","TeamsHealthcare","ExchangeItemAggregated","HygieneEvent","DataInsightsRestApiAudit","InformationBarrierPolicyApplication","SharePointListItemOperation","SharePointContentTypeOperation","SharePointFieldOperation","MicrosoftTeamsAdmin","HRSignal","MicrosoftTeamsDevice","MicrosoftTeamsAnalytics","InformationWorkerProtection","Campaign","DLPEndpoint","AirInvestigation","Quarantine","MicrosoftForms","ApplicationAudit","ComplianceSupervisionExchange","CustomerKeyServiceEncryption","OfficeNative","MipAutoLabelSharePointItem","MipAutoLabelSharePointPolicyLocation","MicrosoftTeamsShifts","MipAutoLabelExchangeItem","CortanaBriefing","Search","WDATPAlerts","MDATPAudit")
    Write-Host "Fetching log count between $($startDate) and $($endDate)..." -ForegroundColor:"Yellow"
    $resultCount = Search-UnifiedAuditLog -EndDate:$EndDate -StartDate:$StartDate -ResultSize:1 -UserIds:$Global:userIds |
        Out-String -Stream |
        Select-String "ResultCount"
    
    foreach ($recordType in $recordTypes)
    {	
        $results = Search-UnifiedAuditLog -EndDate:$EndDate -StartDate:$StartDate -RecordType:$recordType -ResultSize:1 -UserIds:$Global:userIds |
            Out-String -Stream |
            Select-String "ResultCount"
        
        if ($results)
        {
            $number = $results.ToString().Split(":")[1]
            Write-Output "$($recordType):$($number)"
            Write-Output "$($recordType) - $($number)" |
                Out-File $filePath -Append
        }
    }
    
    
    if ($results)
    {
        $numbertotal = $results.ToString().split(":")[1]
        Write-Host "Total count:"$numbertotal
        Write-host "Count complete file is written to $outputDirectory"
        $StringTotalCount = "Total Count:"
        Write-Output "$StringTotalCount $numbertotal" | Out-File $outputDirectory -Append}
    else{
        Write-host "No records found."}
    }
