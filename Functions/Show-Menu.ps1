function Show-Menu
{
	$menu = @"
╔════════════════════════════════════════════╗
║    Main Menu                               ║
╟────────────────────────────────────────────╢
║ 1. Show available log sources and quantity ║
║ 2. Export all Unified Audit Logs           ║
║ 3. Export group Unified Audit Logs         ║
║ 4. Export specific Unified Audit Logs      ║
║ 5. Show README                             ║
║ 6. Show LICENSE                            ║
║ 7. Show ABOUT                              ║
║ 8. Exit                                    ║
╚════════════════════════════════════════════╝
"@
	$action = $null

	do
	{
		if ($null -ne $action)
		{		
			Write-Host "Unexpected input. Please try again." -ForegroundColor:"Red"
			Write-Host
		}

		else
		{
			Write-Host $menu -ForegroundColor:"Gray" -BackgroundColor:"Black"
		}

		$action = Read-Host "Input"
		
	}
	while ($action -notin 1..8)

	return $action
}
