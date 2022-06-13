function Export-Logs
(
    [DateTime]$endDate = $null, [DateTime]$startDate = $null, $recordType = $null, [int]$resultSize = 5000, [string]$userIds = $null,
    [string]$properties = @("CreationTime","Workload","RecordType","Operation","UserId","UserType","DeviceProperties","UserAgent","ExtendedProperties","ClientIP","MailboxOwnerUPN","ClientInfoString","AffectedItems","Parameters","Policy","Subject","Verdict","PolicyAction","SiteUrl","SourceFileName"),
    [int]$minutes = 60, [string]$dateFormat = "yyyy-MM-dd HH:mm:ss",
    [string]$jsonData = "data.json", [string]$csvData = "data.csv", [string]$metadata = "metadata.txt",
    [string]$informationColor = "White", [string]$successColor = "Green", [string]$warningColor = "Yellow", [string]$errorColor = "Red",
    [bool]$debug = $false
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
    Write-ToFile "Fetching logs..." $metadata $informationColor
    Write-ToFile "Start (UTC): $($startDate.ToString($dateFormat))" $metadata $informationColor
    Write-ToFile "End (UTC): $($endDate.ToString($dateFormat))" $metadata $informationColor
    Write-ToFile "Interval (minutes): $($currentMinutes)" $metadata $informationColor
    Write-ToFile "Record type: $($recordType)" $metadata $informationColor
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
            if ($debug -eq $true)
            {
                $results =
                @(
                    [PSCustomObject]@{
                        RunspaceId = 'RunspaceId'
                        RecordType = 'RecordType'
                        CreationDate = '2022-06-10T14:10:00'
                        UserIds = 'test@test.local'
                        Operations = 'FileDeleted'
                        ResultIndex = 1
                        ResultCount = 1
                        Identity = 'test'
                        IsValid = $true
                        ObjectState = 'Unchanged'
                        AuditData = [PSCustomObject]@{
                            SourceLocationType = 1
                            Platform = 1
                            Application = 'RuntimeBroker.exe'
                            FileExtension = 'txt'
                            DeviceName = 'test.test.local'
                            MDATPDeviceId = '7b17070ac2891e24269e626e51747e0000000000'
                            FileSize = 0
                            FileType = 'TEXT'
                            Hidden = $false
                            ObjectId = 'C:\\Users\\user1\\test.txt'
                            UserId = 'test@test.local'
                            ClientIP = '192.168.224.185'
                            Id = 'da61484b-9ded-46e7-b996-000000000000'
                            RecordType = 63
                            CreationTime = '2022-06-10T14:10:00'
                            Operation = 'FileDeleted'
                            OrganizationId = 'd06dbdaf-cc36-4812-922d-000000000000'
                            UserType = 0
                            UserKey = 'test@test.local'
                            Workload = 'Endpoint'
                            Version = 1
                            Scope = 1
                        }
                    }
                )
            }

            else
            {
                $results = Search-UnifiedAuditLog -EndDate:$endDateInterval -StartDate:$startDate -RecordType:$recordType -ResultSize:$resultSize -UserIds:$userIds
            }

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
                $auditData = $results |
                    Select-Object -ExpandProperty:"AuditData"

                # Converting results from JSON to object
                if ($debug -ne $true)
                {
                    $auditData = $auditData |
                        ConvertFrom-Json
                }

                # Exporting object to JSON
                $auditData |
                    Out-File $jsonData -Append

                # Exporting object to CSV
                $auditData |
                    Select-Object $properties |
                    Export-Csv $csvData -Append -NoTypeInformation

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
