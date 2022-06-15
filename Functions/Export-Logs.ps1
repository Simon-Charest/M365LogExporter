function Export-Logs
(
    [DateTime]$endDate = $null, [DateTime]$startDate = $null, $recordType = $null, [int]$resultSize = 5000, $userIds = $null,
    [string[]]$properties = $null,
    [int]$minutes = 60, [string]$dateFormat = "yyyy-MM-dd HH:mm:ss",
    [string]$metadata = "metadata.txt", [string]$data = "data.csv",
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

    # Display header information
    Write-ToFile "Fetching logs..." $metadata $informationColor
    Write-ToFile "Start (UTC): $($startDate.ToString($dateFormat))" $metadata $informationColor
    Write-ToFile "End (UTC): $($endDate.ToString($dateFormat))" $metadata $informationColor
    Write-ToFile "Interval (minutes): $($currentMinutes)" $metadata $informationColor
    Write-ToFile "Record type: $(Get-RecordType $recordType)" $metadata $informationColor
    Write-ToFile "User ids: $(Get-Users $userIds)" $metadata $informationColor
    
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
            try
            {
                # Building the command to be executed
                $command = "Search-UnifiedAuditLog -EndDate:'$($endDateInterval)' -StartDate:'$($startDate)'"

                if ($null -ne $recordType)
                {
                    $command += " -RecordType:$($recordType)"
                }

                $command += " -ResultSize:$($resultSize)"

                if (-not [string]::IsNullOrWhiteSpace($userIds))
                {
                    $command += " -UserIds:$($userIds)"
                }

                $results = Invoke-Expression -Command:$command
            }

            catch
            {
                Write-ToFile "An error occurred." $metadata $errorColor
                Invoke-Pause

                return
            }

            # Extracting result counts
            [int]$resultCount = ($results | Measure-Object).Count
            [int]$estimatedCount = Get-ResultCount $results
            
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
                # Exporting object to CSV
                if ($null -ne $properties)
                {
                    $results |
                        Select-Object $properties |
                        Export-Csv -Path:$data -Append -NoTypeInformation
                }

                else
                {
                    $results |
                        Export-Csv -Path:$data -Append -NoTypeInformation
                }

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
