# TODO: Refactor this
function Export-All($filePath)
{
    $startDate = Get-StartDate
    $endDate = Get-EndDate
    Write-Host "Note: Reduce time interval for environments with high log volume."
    Write-Host "Recommended interval, in minutes: 60"
    $minutes = Read-Host "Enter time interval or leave empty for 60"
    $currentMinutes = $minutes
    $resultSize = 1
    $sessionCommand = "ReturnNextPreviewPage"
    $properties = @("CreationTime","Workload","RecordType","Operation","UserId","UserType","DeviceProperties","UserAgent","ExtendedProperties","ClientIP","MailboxOwnerUPN","ClientInfoString","AffectedItems","Parameters","Policy","Subject","Verdict","PolicyAction","SiteUrl","SourceFileName")

    if ([string]::IsNullOrWhiteSpace($minutes))
    {
        $minutes = "60"
    }

    Write-Host "Fetching all logs between $($startDate) and $($endDate), by $($minutes) minutes intervals..." -ForegroundColor:"Yellow"
    
    # Writing metadata headers to log file
    Write-LogFile("StartDate;EndDate;Minutes;SessionId;PreviewCount;ResultCount;Status;UserIds;", $Global:metadata)
        
    do
    {
        # Setup for preview
        $previewCount = 0
        $intervalEndDate = $startDate.AddMinutes($currentMinutes)

        # Preview
        do
        {
            # Lowering time interval
            if ($previewCount -ne 0)
            {
                $currentMinutes = [int]($currentMinutes / 2)
                Write-Host "Temporary lowering of the time interval to $($currentMinutes) minutes" -ForegroundColor:"Yellow"
            }
            
            # Fetching result counts
            $results = Search-UnifiedAuditLog -EndDate:$intervalEndDate -StartDate:$startDate -ResultSize:$resultSize -UserIds:$Global:userIds

            if ($results)
            {
                $previewCount = [int]($results | Select-Object -ExpandProperty:"ResultCount" -First:1)
            }
        }
        while ($previewCount -ge $Global:resultSize)

        # Setup for actual results
        $sessionId = $(Get-Date -Format "yyyy-MM-dd_HH-mm-ss")
        $resultCount = 0
        $status = "ERR"

        # Fetching actual results
        $results = Search-UnifiedAuditLog -EndDate:$intervalEndDate -StartDate:$startDate -ResultSize:$resultSize -SessionCommand:$sessionCommand -SessionId:$sessionId -UserIds:$Global:userIds

        if ($results)
        {
            $resultCount = [Int]($results | Select-Object -ExpandProperty:"ResultCount" -First:1)
        }

        # Exporting results
        if ($resultCount -eq $previewCount)
        {
            # Converting from JSON to object
            $auditData = $results |
                Select-Object -ExpandProperty:"AuditData" |
                ConvertFrom-Json

            # Exporting object to CSV
            $auditData |
                Select-Object $properties |
                Export-Csv $Global:data -Append -NoTypeInformation
            $status = "OK"
        }

        # Writing metadata to log file
        Write-LogFile("$($startDate);$($intervalEndDate);$($currentMinutes);$($sessionId);$($previewCount);$($resultCount);$($status);$($Global:userIds);", $Global:metadata)

        # Resetting time interval
        if ($previewCount -lt [int]($Global:resultSize / 2))
        {
            $currentMinutes = $minutes
            Write-Host "Resetting time interval to $($currentMinutes) minutes" -ForegroundColor:"Yellow"
        }
        
        # Moving forward
        $startDate = $startDate.AddMinutes($currentMinutes)
    }
    while ($startDate -lt $endDate)

    # Exporting hashes
    Get-ChildItem $Global:exportDirectory -Filter:"*.csv" |
        Get-FileHash -Algorithm:"SHA256" |
        Export-Csv $Global:hashes
}
