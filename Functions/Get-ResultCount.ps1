function Get-ResultCount($results)
{
    [int]$resultCount = 0

    if ($results)
    {
        $resultCount = [int]($results | Select-Object -ExpandProperty:"ResultCount" -First:1)
    }

    return $resultCount
}