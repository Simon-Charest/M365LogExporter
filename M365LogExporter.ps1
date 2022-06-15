. "$($PSScriptRoot)\Functions\Connect-ExchangeOnlineOnce.ps1"
. "$($PSScriptRoot)\Functions\Export-ByRecordset.ps1"
. "$($PSScriptRoot)\Functions\Export-Hashes.ps1"
. "$($PSScriptRoot)\Functions\Export-Logs.ps1"
. "$($PSScriptRoot)\Functions\Export-Metrics.ps1"
. "$($PSScriptRoot)\Functions\Get-EndDate.ps1"
. "$($PSScriptRoot)\Functions\Get-RecordType.ps1"
. "$($PSScriptRoot)\Functions\Get-ResultCount.ps1"
. "$($PSScriptRoot)\Functions\Get-StartDate.ps1"
. "$($PSScriptRoot)\Functions\Get-Users.ps1"
. "$($PSScriptRoot)\Functions\Install-Prerequisites.ps1"
. "$($PSScriptRoot)\Functions\Invoke-Menu.ps1"
. "$($PSScriptRoot)\Functions\Invoke-Pause.ps1"
. "$($PSScriptRoot)\Functions\New-Directory.ps1"
. "$($PSScriptRoot)\Functions\Select-Users.ps1"
. "$($PSScriptRoot)\Functions\Show-Content.ps1"
. "$($PSScriptRoot)\Functions\Show-Intro.ps1"
. "$($PSScriptRoot)\Functions\Show-Menu.ps1"
. "$($PSScriptRoot)\Functions\Write-ToFile.ps1"

[int]$Global:resultSize = 5000 # Maximum number of results, per page, allowed by Microsoft
[string[]]$Global:recordTypes = @("ExchangeAdmin","ExchangeItem","ExchangeItemGroup","SharePoint","SyntheticProbe","SharePointFileOperation","OneDrive","AzureActiveDirectory","AzureActiveDirectoryAccountLogon","DataCenterSecurityCmdlet","ComplianceDLPSharePoint","Sway","ComplianceDLPExchange","SharePointSharingOperation","AzureActiveDirectoryStsLogon","SkypeForBusinessPSTNUsage","SkypeForBusinessUsersBlocked","SecurityComplianceCenterEOPCmdlet","ExchangeAggregatedOperation","PowerBIAudit","CRM","Yammer","SkypeForBusinessCmdlets","Discovery","MicrosoftTeams","ThreatIntelligence","MailSubmission","MicrosoftFlow","AeD","MicrosoftStream","ComplianceDLPSharePointClassification","ThreatFinder","Project","SharePointListOperation","SharePointCommentOperation","DataGovernance","Kaizala","SecurityComplianceAlerts","ThreatIntelligenceUrl","SecurityComplianceInsights","MIPLabel","WorkplaceAnalytics","PowerAppsApp","PowerAppsPlan","ThreatIntelligenceAtpContent","LabelContentExplorer","TeamsHealthcare","ExchangeItemAggregated","HygieneEvent","DataInsightsRestApiAudit","InformationBarrierPolicyApplication","SharePointListItemOperation","SharePointContentTypeOperation","SharePointFieldOperation","MicrosoftTeamsAdmin","HRSignal","MicrosoftTeamsDevice","MicrosoftTeamsAnalytics","InformationWorkerProtection","Campaign","DLPEndpoint","AirInvestigation","Quarantine","MicrosoftForms","ApplicationAudit","ComplianceSupervisionExchange","CustomerKeyServiceEncryption","OfficeNative","MipAutoLabelSharePointItem","MipAutoLabelSharePointPolicyLocation","MicrosoftTeamsShifts","MipAutoLabelExchangeItem","CortanaBriefing","Search","WDATPAlerts","MDATPAudit")
[string]$Global:dateFormat = "yyyy-MM-dd HH:mm:ss"
[string]$Global:filenameDateFormat = "yyyy-MM-dd_HH-mm-ss"
[string]$Global:exportDirectory = "$($PSScriptRoot)\Export\$(Get-Date -Format:$($Global:filenameDateFormat))"
[string]$Global:metrics = "$($exportDirectory)\metrics.txt"
[string]$Global:metadata = "$($exportDirectory)\metadata.txt"
[string]$Global:data = "$($exportDirectory)\data.csv"
[string]$Global:hashes = "$($exportDirectory)\hashes.csv"
[string]$Global:informationColor = "White"
[string]$Global:successColor = "Green"
[string]$Global:warningColor = "Yellow"
[string]$Global:errorColor = "Red"
[string]$Global:backgroundColor = "Black"

function Invoke-Main()
{
	do
	{
		Clear-Host
		Show-Intro
		# Install-Prerequisites
		Connect-ExchangeOnlineOnce
		New-Directory $Global:exportDirectory
		[int]$menuInput = Show-Menu
		Invoke-Menu $menuInput
	}
	while ($menuInput -ne 13)
}

Invoke-Main
