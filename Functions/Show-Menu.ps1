function Show-Menu()
{
	$menu = @"
╔═════════════════════════╗
║    Main Menu            ║
╟─────────────────────────╢
║ 1. Change tenant        ║
║ 2. Export log metrics   ║
║ 3. Export all logs      ║
║ 4. Export group logs    ║
║ 5. Export specific logs ║
║ 6. Show README          ║
║ 7. Show LICENSE         ║
║ 8. Show ABOUT           ║
║ 9. Exit                 ║
╚═════════════════════════╝
"@
	$menuInput = $null

	do
	{
		if ($null -ne $menuInput)
		{		
			Write-Host "Unexpected input. Please try again." -ForegroundColor:"Red"
			Write-Host
		}

		else
		{
			Write-Host $menu -ForegroundColor:"Gray" -BackgroundColor:"Black"
		}

		$menuInput = Read-Host "Input"
		
	}
	while ($menuInput -notin 1..8)

	return $menuInput
}
