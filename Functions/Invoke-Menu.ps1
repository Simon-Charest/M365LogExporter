function Invoke-Menu($menuInput)
{
	switch ($menuInput)
	{
		1
		{
			Select-Users
			Show-Log $Global:metrics
		}
		2
		{
			Select-Users
			Export-All $Global:data
		}
		3
		{
			Select-Users
			Export-Group
		}
		4 { Export-Specific }
		5 { Show-Content $null "README.txt" $true }
		6 { Show-Content $null "LICENSE.txt" $true }
		7 { Show-Content $null "ABOUT.txt" $true }
		8 { Write-Host "** DONE **" -ForegroundColor:"Green" }
	}
}
