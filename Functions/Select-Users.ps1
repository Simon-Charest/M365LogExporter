function Select-Users()
{
	$userInput = $null

	do
	{
		if ($null -ne $userInput)
		{		
			Write-Host "Unexpected input. Please try again." -ForegroundColor:"Red"
			Write-Host
		}

		$menu = @"
╔═══════════════════╗
║ Export logs       ║
╟───────────────────╢
║ 1. All users      ║
║ 2. Specific users ║
╚═══════════════════╝
"@
		Write-Host $menu -ForegroundColor:"Gray" -BackgroundColor:"Black"
		$userInput = Read-Host "Input"
	}
	while ($userInput -notin 1..2)

	if ($userInput -eq 2)
	{
		$Global:userIds = Read-Host "Enter comma-separated user ids (e.g., james@test.onmicrosoft.com,mary@test.onmicrosoft.com)"
	}
}
