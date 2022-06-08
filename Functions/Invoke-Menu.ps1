function Invoke-Menu([int]$menuInput)
{
	switch ($menuInput)
	{
		1
		{
			Disconnect-ExchangeOnline -Confirm:$false
			Connect-ExchangeOnlineOnce
		}
		2
		{
			$userIds = Select-Users
			Export-Metrics $userIds $Global:metrics $Global:recordTypes
		}
		3
		{
			$userIds = Select-Users
			Export-All $userIds $Global:metadata $Global:data $Global:properties
			Export-Hashes $Global:hashes
		}
		4
		{
			$userIds = Select-Users
			Export-Group $userIds
		}
		5 { Export-Specific }
		6 { Show-Content $null "README.txt" $true }
		7 { Show-Content $null "LICENSE.txt" $true }
		8 { Show-Content $null "ABOUT.txt" $true }
		9 { Write-Host "** DONE **" -ForegroundColor:"Green" }
	}
}
