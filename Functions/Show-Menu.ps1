function Show-Menu()
{
	$menu = @"
╔═══════════════════════════╗
║    Main Menu              ║
╟───────────────────────────╢
║ 1. Change tenant          ║
║ 2. Check log status       ║
║ 3. Export log metrics     ║
║ 4. Export all logs        ║
║ 5. Export Azure logs      ║
║ 6. Export Exchange logs   ║
║ 7. Export SharePoint logs ║
║ 8. Export Skype logs      ║
║ 9. Export specific logs   ║
║ 10. Show README           ║
║ 11. Show LICENSE          ║
║ 12. Show ABOUT            ║
║ 13. Exit                  ║
╚═══════════════════════════╝
"@
	$menuInput = $null

	do
	{
		if ($null -ne $menuInput)
		{		
			Write-Host "Unexpected input. Please try again." -ForegroundColor:$Global:errorColor
		}

		else
		{
			Write-Host $menu -ForegroundColor:$Global:informationColor -BackgroundColor:$Global:backgroundColor
		}

		$menuInput = Read-Host "Input"
		
	}
	while ($menuInput -notin 0..13)

	return $menuInput
}
