. ".\Functions\Connect-ExchangeOnlineOnce.ps1"
. ".\Functions\Export-ByRecordset.ps1"
. ".\Functions\Export-Hashes.ps1"
. ".\Functions\Export-Logs.ps1"
. ".\Functions\Export-Metrics.ps1"
. ".\Functions\Get-EndDate.ps1"
. ".\Functions\Get-ResultCount.ps1"
. ".\Functions\Get-StartDate.ps1"
. ".\Functions\Get-Users.ps1"
. ".\Functions\Install-Prerequisites.ps1"
. ".\Functions\Invoke-Menu.ps1"
. ".\Functions\Invoke-Pause.ps1"
. ".\Functions\New-Directory.ps1"
. ".\Functions\Select-Users.ps1"
. ".\Functions\Show-Content.ps1"
. ".\Functions\Show-Intro.ps1"
. ".\Functions\Show-Menu.ps1"
. ".\Functions\Write-ToFile.ps1"

[int]$Global:resultSize = 5000 # Maximum number of results, per page, allowed by Microsoft
[string]$Global:dateFormat = "yyyy-MM-dd HH:mm:ss"
[string]$Global:filenameDateFormat = "yyyy-MM-dd_HH-mm-ss"
[string]$Global:exportDirectory = ".\Export\$(Get-Date -Format:$($Global:filenameDateFormat))"
[string]$Global:metrics = "$($exportDirectory)\metrics.txt"
[string]$Global:metadata = "$($exportDirectory)\metadata.txt"
[string]$Global:jsonData = "$($exportDirectory)\data.json"
[string]$Global:csvData = "$($exportDirectory)\data.csv"
[string]$Global:hashes = "$($exportDirectory)\hashes.csv"
$Global:recordTypes = @("ExchangeAdmin","ExchangeItem","ExchangeItemGroup","SharePoint","SyntheticProbe","SharePointFileOperation","OneDrive","AzureActiveDirectory","AzureActiveDirectoryAccountLogon","DataCenterSecurityCmdlet","ComplianceDLPSharePoint","Sway","ComplianceDLPExchange","SharePointSharingOperation","AzureActiveDirectoryStsLogon","SkypeForBusinessPSTNUsage","SkypeForBusinessUsersBlocked","SecurityComplianceCenterEOPCmdlet","ExchangeAggregatedOperation","PowerBIAudit","CRM","Yammer","SkypeForBusinessCmdlets","Discovery","MicrosoftTeams","ThreatIntelligence","MailSubmission","MicrosoftFlow","AeD","MicrosoftStream","ComplianceDLPSharePointClassification","ThreatFinder","Project","SharePointListOperation","SharePointCommentOperation","DataGovernance","Kaizala","SecurityComplianceAlerts","ThreatIntelligenceUrl","SecurityComplianceInsights","MIPLabel","WorkplaceAnalytics","PowerAppsApp","PowerAppsPlan","ThreatIntelligenceAtpContent","LabelContentExplorer","TeamsHealthcare","ExchangeItemAggregated","HygieneEvent","DataInsightsRestApiAudit","InformationBarrierPolicyApplication","SharePointListItemOperation","SharePointContentTypeOperation","SharePointFieldOperation","MicrosoftTeamsAdmin","HRSignal","MicrosoftTeamsDevice","MicrosoftTeamsAnalytics","InformationWorkerProtection","Campaign","DLPEndpoint","AirInvestigation","Quarantine","MicrosoftForms","ApplicationAudit","ComplianceSupervisionExchange","CustomerKeyServiceEncryption","OfficeNative","MipAutoLabelSharePointItem","MipAutoLabelSharePointPolicyLocation","MicrosoftTeamsShifts","MipAutoLabelExchangeItem","CortanaBriefing","Search","WDATPAlerts","MDATPAudit")
$Global:properties = @("CreationTime","Workload","RecordType","Operation","UserId","UserType","DeviceProperties","UserAgent","ExtendedProperties","ClientIP","MailboxOwnerUPN","ClientInfoString","AffectedItems","Parameters","Policy","Subject","Verdict","PolicyAction","SiteUrl","SourceFileName")
$Global:informationColor = "White"
$Global:successColor = "Green"
$Global:warningColor = "Yellow"
$Global:errorColor = "Red"
$Global:backgroundColor = "Black"
$Global:debug = $false

function Invoke-Main()
{
	do
	{
		Clear-Host
		Show-Intro
		# Install-Prerequisites
		Connect-ExchangeOnlineOnce
		New-Directory $Global:exportDirectory
		$menuInput = Show-Menu
		Invoke-Menu $menuInput
	}
	while ($menuInput -ne 13)
}

Invoke-Main
