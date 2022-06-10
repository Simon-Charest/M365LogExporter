function Export-Metrics($recordTypes, [string]$userIds, [string]$filePath)
{
    # Setup
    [DateTime]$startDate = Get-StartDate
    [DateTime]$endDate = Get-EndDate
    [int]$resultSize = 1
    [int]$total = 0

    # Export header information
    Write-ToFile "Fetching log count between $($startDate.ToString($Global:dateFormat)) (UTC) and $($endDate.ToString($Global:dateFormat)) (UTC), for $(Get-Users $userIds)..." $filePath $Global:informationColor
    
    foreach ($recordType in $recordTypes)
    {
        # Fetch result count by record type
        $results = Search-UnifiedAuditLog -EndDate:$endDate -StartDate:$startDate -RecordType:$recordType -ResultSize:$resultSize -UserIds:$userIds
        [int]$resultCount = Get-ResultCount $results
        $total = $total + $resultCount

        # Export result count by record type
        Write-ToFile "$($recordType): $($resultCount)" $filePath $Global:successColor
    }

    # Export total result count
    Write-ToFile "Total: $($resultCount)" $filePath $Global:successColor
}
