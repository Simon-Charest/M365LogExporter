function Export-All
(
    [DateTime]$endDate = $null, [DateTime]$startDate = $null, [string]$recordType = $null, [int]$resultSize = 5000, [string]$userIds = $null,
    [string]$properties = @("CreationTime","Workload","RecordType","Operation","UserId","UserType","DeviceProperties","UserAgent","ExtendedProperties","ClientIP","MailboxOwnerUPN","ClientInfoString","AffectedItems","Parameters","Policy","Subject","Verdict","PolicyAction","SiteUrl","SourceFileName"),
    [int]$minutes = 60, [string]$dateFormat = "yyyy-MM-dd HH:mm:ss",
    [string]$data = "data.csv", [string]$metadata = "metadata.txt",
    [string]$informationColor = "White", [string]$successColor = "Green", [string]$warningColor = "Yellow", [string]$errorColor = "Red"
)
{
    # Setting default values
    if ($endDate -eq $null)
    {
        $endDate = Get-Date
    }

    if ($startDate -eq $null)
    {
        $startDate = (Get-date).AddDays(-90)
    }

    [int]$currentMinutes = $minutes
    Write-ToFile "Fetching all logs between $($startDate.ToString($dateFormat)) (UTC) and $($endDate.ToString($dateFormat)) (UTC), by $($currentMinutes) minutes intervals, for $(Get-Users $userIds)..." $metadata $informationColor 

    # Loop on each time interval, until there is no more data to fetch
    do
    {
        # Loop on each result set, until correct
        do
        {
            # Setting time interval
            [DateTime]$endDateInterval = $startDate.AddMinutes($currentMinutes).AddSeconds(-1)
            [string]$interval = "$($startDate.ToString($dateFormat)) - $($endDateInterval.ToString($dateFormat))"
            
            # Fetching results
            $results = Search-UnifiedAuditLog -EndDate:$endDateInterval -StartDate:$startDate -RecordType:$recordType -ResultSize:$resultSize -UserIds:$userIds
            
            # Extracting result counts
            $resultCount = ($results | Measure-Object).Count
            $estimatedCount = Get-ResultCount $results
            
            # If the results are incorrect
            if (($resultCount -ge $resultSize) -or ($resultCount -ne $estimatedCount))
            {
                if ($resultCount -ne $estimatedCount)
                {
                    Write-ToFile "$($interval) => The result counts do not match." $metadata $errorColor
                }

                # Lowering time interval
                $currentMinutes = [int]($currentMinutes / 2)
                Write-ToFile "Temporarily lowering the time interval to $($currentMinutes) minutes." $metadata $warningColor
            }

            # If the results are correct
            else
            {
                # Converting results from JSON to object
                $auditData = $results |
                    Select-Object -ExpandProperty:"AuditData" |
                    ConvertFrom-Json

                # Exporting object to CSV
                $auditData |
                    Select-Object $properties |
                    Export-Csv $data -Append -NoTypeInformation

                # Writing metadata to log file
                Write-ToFile "$($interval) => $($resultCount)" $metadata $successColor

                # Moving forward
                $startDate = $startDate.AddMinutes($currentMinutes)

                 # Resetting time interval
                if (($currentMinutes -ne $minutes) -and ($resultCount -lt [int]($resultSize / 5)))
                {
                    $currentMinutes = $minutes
                    Write-ToFile "Resetting the time interval to $($currentMinutes) minutes." $metadata $informationColor
                }
            }
        }
        while (($resultCount -ge $resultSize) -or ($resultCount -ne $estimatedCount))
    }
    while ($startDate -lt $endDate)
}
