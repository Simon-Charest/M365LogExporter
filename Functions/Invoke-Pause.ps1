function Invoke-Pause($object = "Press any key to continue", $foregroundColor = $Global:informationColor)
{
    Write-Host $object -ForegroundColor:$foregroundColor
    [Console]::ReadKey()
}
