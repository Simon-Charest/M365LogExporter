function Invoke-Pause($object = "Press any key to continue", $foregroundColor = "Yellow")
{
    Write-Host $object -ForegroundColor:$foregroundColor
    [Console]::ReadKey()
}
