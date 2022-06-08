function Export-All([string]$userIds, [string]$metadata, [string]$data, $properties)
{
    # Setup
    [int]$resultSize = 1
    $sessionCommand = "ReturnNextPreviewPage"
    
    # User input
    [DateTime]$startDate = Get-StartDate
    [DateTime]$endDate = Get-EndDate
    $minutes = Read-Host "Enter time interval in minutes or leave empty for 60"

    if ([string]::IsNullOrWhiteSpace($minutes))
    {
        $minutes = 60
    }

    [int]$currentMinutes = $minutes
    [string]$object = "Fetching all logs between $($startDate.ToString($Global:dateFormat)) and $($endDate.ToString($Global:dateFormat)) (UTC), by $($currentMinutes) minutes intervals, for $(Get-Users $userIds)..."
    Write-Host $object -ForegroundColor:"Yellow"
    Write-LogFile $object  $Global:metadata
    
    # Loop on each time interval
    do
    {
        # Setup for preview
        [int]$previewCount = 0

        # Preview
        do
        {
            # Lowering time interval
            if ($previewCount -ne 0)
            {
                $currentMinutes = [int]($currentMinutes / 2)
                Write-Host "Temporary lowering of the time interval to $($currentMinutes) minutes." -ForegroundColor:"Yellow"
            }
            
            # Fetching result counts
            [DateTime]$intervalEndDate = $startDate.AddMinutes($currentMinutes).AddSeconds(-1)
            $results = Search-UnifiedAuditLog -EndDate:$intervalEndDate -StartDate:$startDate -ResultSize:$resultSize -UserIds:$userIds
            $previewCount = Get-ResultCount $results
        }
        while ($previewCount -ge $Global:resultSize)

        ########################################################################

        # Setup for actual results
        [string]$sessionId = $(Get-Date -Format:$Global:filenameDateFormat)
        [string]$status = "ERR"
        $foregroundColor = "Red"

        # Fetching actual results
        $results = Search-UnifiedAuditLog -EndDate:$intervalEndDate -StartDate:$startDate -ResultSize:$resultSize -SessionCommand:$sessionCommand -SessionId:$sessionId -UserIds:$userIds
        [int]$resultCount = Get-ResultCount $results

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
            $foregroundColor = "Green"
        }

        # Writing metadata to log file
        $object = "$($startDate.ToString($Global:dateFormat)) - $($intervalEndDate.ToString($Global:dateFormat)) => $($resultCount) [$($status)]"
        Write-LogFile $object $Global:metadata
        Write-Host $object -ForegroundColor:$foregroundColor

        # Resetting time interval
        if ($previewCount -lt [int]($Global:resultSize / 5 -and $currentMinutes -ne $minutes))
        {
            $currentMinutes = $minutes
            Write-Host "Resetting time interval to $($currentMinutes) minutes." -ForegroundColor:"Yellow"
        }
        
        # Moving forward
        $startDate = $startDate.AddMinutes($currentMinutes)
    }
    while ($startDate -lt $endDate)
}
