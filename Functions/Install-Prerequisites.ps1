function Install-Prerequisites()
{
	Set-ExecutionPolicy RemoteSigned
	Install-Module -Name PowerShellGet -Force

	# Close and re-open PowerShell
	
	Install-Module -Name ExchangeOnlineManagement -Force
}
