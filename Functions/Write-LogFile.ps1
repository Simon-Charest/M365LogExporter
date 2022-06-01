function Write-LogFile([String]$Message, [String]$LogFile)
{
    $content = [DateTime]::Now.ToString() + ":" + $Message
    $content | Out-File $LogFile -Append
}
