function Export-All([DateTime]$startDate, [DateTime]$endDate, [string]$dateFormat, [int]$minutes, [int]$resultSize, [string]$userIds, $properties, $data, $metadata)
{
    [int]$currentMinutes = $minutes
    [string]$object = "Fetching all logs between $($startDate.ToString($Global:dateFormat)) (UTC) and $($endDate.ToString($Global:dateFormat)) (UTC), by $($currentMinutes) minutes intervals, for $(Get-Users $userIds)..."
    Write-Host $object -ForegroundColor:$Global:informationColor
    Write-LogFile $object  $Global:metadata
    
    # Loop on each time interval, until there is no more data to fetch
    do
    {
        # Loop on each result set, until correct
        do
        {
            # Setting time interval
            [DateTime]$endDateInterval = $startDate.AddMinutes($currentMinutes).AddSeconds(-1)
            
            # Fetching results
            $results = Search-UnifiedAuditLog -EndDate:$endDateInterval -StartDate:$startDate -ResultSize:$resultSize -UserIds:$userIds
            
            # Extracting result counts
            $resultCount = ($results | Measure-Object).Count
            $estimatedCount = Get-ResultCount $results

            # If the results are incorrect
            if (($resultCount -ge $resultSize) -or ($resultCount -ne $estimatedCount))
            {
                if ($resultCount -ne $estimatedCount)
                {
                    Write-Host "The result counts do not match." -ForegroundColor:$Global:errorColor
                }

                # Lowering time interval
                $currentMinutes = [int]($currentMinutes / 2)
                Write-Host "Temporarily lowering of the time interval to $($currentMinutes) minutes." -ForegroundColor:$Global:warningColor
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
                $object = "$($startDate.ToString($dateFormat)) - $($endDateInterval.ToString($dateFormat)) => $($resultCount)"
                Write-LogFile $object $metadata
                Write-Host $object -ForegroundColor:$Global:successColor

                # Moving forward
                $startDate = $startDate.AddMinutes($currentMinutes)

                 # Resetting time interval
                if (($currentMinutes -ne $minutes) -and ($resultCount -lt [int]($resultSize / 5)))
                {
                    $currentMinutes = $minutes
                    Write-Host "Resetting time interval to $($currentMinutes) minutes." -ForegroundColor:$Global:informationColor
                }
            }
        }
        while (($resultCount -ge $resultSize) -or ($resultCount -ne $estimatedCount))
    }
    while ($startDate -lt $endDate)
}
