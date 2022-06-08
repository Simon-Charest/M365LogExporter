function Get-ResultCount($results)
{
    $resultCount = 0

    if ($results)
    {
        $resultCount = [Int]($results | Select-Object -ExpandProperty:"ResultCount" -First:1)
    }

    return $resultCount
}