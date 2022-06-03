. ".\Functions\Connect-ExchangeOnlineOnce.ps1"
. ".\Functions\Export-All.ps1"
. ".\Functions\Export-Group.ps1"
. ".\Functions\Export-Specific.ps1"
. ".\Functions\Get-EndDate.ps1"
. ".\Functions\Get-StartDate.ps1"
. ".\Functions\Install-Prerequisites.ps1"
. ".\Functions\Invoke-Menu.ps1"
. ".\Functions\New-Directory.ps1"
. ".\Functions\Select-Users.ps1"
. ".\Functions\Show-Content.ps1"
. ".\Functions\Show-Intro.ps1"
. ".\Functions\Show-Log.ps1"
. ".\Functions\Show-Menu.ps1"
. ".\Functions\Write-LogFile.ps1"

$Global:exportDirectory = ".\Export\$(Get-Date -Format "yyyy-MM-dd_HH-mm-ss")"
$Global:metrics = "$($exportDirectory)\metrics.csv"
$Global:metadata = "$($exportDirectory)\metadata.txt"
$Global:data = "$($exportDirectory)\data.csv"

<#
$logDirectoryPath = $exportDirectory
$logFile = $metadata
$outputDirectory = $metrics
$outputFile = $data
#>

$Global:resultSize = 5000 # Maximum record count allowed, by Microsoft, per query, for each session
$Global:retryCount = 3
$Global:currentTries = 0
$Global:userIds = "*"

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
	while ($menuInput -ne 8)
}

Invoke-Main
