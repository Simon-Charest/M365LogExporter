function Show-Menu()
{
	$menu = @"
╔═════════════════════════╗
║    Main Menu            ║
╟─────────────────────────╢
║ 1. Change tenant        ║
║ 2. Check log status     ║
║ 3. Export log metrics   ║
║ 4. Export all logs      ║
║ 5. Export group logs    ║
║ 6. Export specific logs ║
║ 7. Show README          ║
║ 8. Show LICENSE         ║
║ 9. Show ABOUT           ║
║ 0. Exit                 ║
╚═════════════════════════╝
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
	while ($menuInput -notin 0..9)

	return $menuInput
}
