function Select-Users()
{
	$action = $null

	do
	{
		if ($null -ne $action)
		{		
			Write-Host "Please pick between option 1 or 2" -ForegroundColor:"Red"
		}

		Write-Host "Would you like to extract log events for [1]All users or [2]Specific users"
		$AllorSingleUse = Read-Host ">"

		Write-Host $menu
		$action = Read-Host "Select an action" 
		
	}
	while ($action -notin 1..2)

	if ($AllorSingleUse -eq 1)
	{
		Write-Host "Extracting the Unified Audit Log for all users..."
		$script:Userstoextract = "*"
	}

	else
	{
		Write-Host "Provide accounts that you wish to acquire, use comma separated values for multiple accounts, example (bob@acmecorp.onmicrosoft.com,alice@acmecorp.onmicrosoft.com)"
		$script:Userstoextract = Read-Host ">"
	}
}
