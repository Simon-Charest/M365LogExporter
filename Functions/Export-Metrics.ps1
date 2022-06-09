function Export-Metrics([string]$userIds, [string]$filePath, $recordTypes)
{
    # Setup
    [DateTime]$startDate = Get-StartDate
    [DateTime]$endDate = Get-EndDate
    [int]$resultSize = 1
    
    # Export header information
    [string]$object = "Fetching log count between $($startDate.ToString($Global:dateFormat)) (UTC) and $($endDate.ToString($Global:dateFormat)) (UTC), for $(Get-Users $userIds)..."
    Write-Host $object -ForegroundColor:$Global:informationColor
    Write-LogFile $object $filePath

    # Fetch total result count
    $results = Search-UnifiedAuditLog -EndDate:$EndDate -StartDate:$StartDate -ResultSize:$resultSize -UserIds:$userIds
    [int]$resultCount = Get-ResultCount $results

    # Export total result count
    $object = "Total: $($resultCount)"
    Write-LogFile $object $filePath
    Write-Host $object -ForegroundColor:$Global:successColor
    
    foreach ($recordType in $recordTypes)
    {
        # Fetch result count by record type
        $results = Search-UnifiedAuditLog -EndDate:$endDate -StartDate:$startDate -RecordType:$recordType -ResultSize:$resultSize -UserIds:$userIds
        $resultCount = Get-ResultCount $results

        # Export result count by record type
        $object = "$($recordType): $($resultCount)"
            Write-LogFile $object $filePath
            Write-Host $object -ForegroundColor:$Global:successColor
    }
}
