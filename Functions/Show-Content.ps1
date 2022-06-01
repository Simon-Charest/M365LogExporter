function Show-Content([string]$content = $null, [string]$path = $null, [boolean]$pause = $false)
{
    if ($path)
    {
        $content = Get-Content -Path:$path -Raw
    }

    Write-Host $content

    if ($pause)
    {
        Write-Host "Press any key to continue" -ForegroundColor:"Yellow"
        [Console]::ReadKey()
    }
}
