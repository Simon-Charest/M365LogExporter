function Show-Menu
{
	$menu = @"
╔═════════════════════════╗
║    Main Menu            ║
╟─────────────────────────╢
║ 1. Show log metrics     ║
║ 2. Export all logs      ║
║ 3. Export group logs    ║
║ 4. Export specific logs ║
║ 5. Show README          ║
║ 6. Show LICENSE         ║
║ 7. Show ABOUT           ║
║ 8. Exit                 ║
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
