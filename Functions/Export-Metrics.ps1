function Export-Metrics([string]$userIds, [string]$filePath, $recordTypes)
{
    # Setup
    [DateTime]$startDate = Get-StartDate
    [DateTime]$endDate = Get-EndDate
    [int]$resultSize = 1
    
    # Export header information
    Write-ToFile "Fetching log count between $($startDate.ToString($Global:dateFormat)) (UTC) and $($endDate.ToString($Global:dateFormat)) (UTC), for $(Get-Users $userIds)..." $filePath $Global:informationColor

    # Fetch total result count
    $results = Search-UnifiedAuditLog -EndDate:$EndDate -StartDate:$StartDate -ResultSize:$resultSize -UserIds:$userIds
    [int]$resultCount = Get-ResultCount $results

    # Export total result count
    Write-ToFile "Total: $($resultCount)" $filePath $Global:successColor
    
    foreach ($recordType in $recordTypes)
    {
        # Fetch result count by record type
        $results = Search-UnifiedAuditLog -EndDate:$endDate -StartDate:$startDate -RecordType:$recordType -ResultSize:$resultSize -UserIds:$userIds
        $resultCount = Get-ResultCount $results

        # Export result count by record type
        Write-ToFile "$($recordType): $($resultCount)" $filePath $Global:successColor
    }
}
