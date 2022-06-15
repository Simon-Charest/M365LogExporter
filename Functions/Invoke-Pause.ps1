function Invoke-Pause([Object]$object = "Press any key to continue", [string]$foregroundColor = $Global:informationColor)
{
    Write-Host $object -ForegroundColor:$foregroundColor
    [Console]::ReadKey("NoEcho,IncludeKeyDown")
}
