function Export-All()
{
    If(!(test-path $OutputFile)){
        Write-host "Creating the following file:" $OutputFile}
    else{
        $date = [datetime]::Now.ToString('HHmm') 
        $OutputFile = "Log_Directory\"+$date+"AuditRecords.csv"
        $OutputDirectory = Join-Path $PSScriptRoot $OutputFile}
    echo ""

    [DateTime]$StartDate = Get-StartDate
    [DateTime]$EndDate = Get-EndDate

    echo ""
    write-host "Recommended interval: 60"
    Write-host "Lower the time interval for environments with a high log volume"
    echo ""


    $IntervalMinutes = read-host "Please enter a time interval or ENTER for 60"
    if ([string]::IsNullOrWhiteSpace($IntervalMinutes)) { $IntervalMinutes = "60" }

    $ResetInterval = $IntervalMinutes

    Write-LogFile "Start date provided by user: $StartDate"
    Write-LogFile "End date provided by user: $EndDate"
    Write-Logfile "Time interval provided by user: $IntervalMinutes"
    [DateTime]$CurrentStart = $StartDate
    [DateTime]$CurrentEnd = $EndDate

    echo ""
    Write-Host "------------------------------------------------------------------------------------------"
    Write-Host "|Extracting all available audit logs between "$StartDate" and "$EndDate                "|"
    write-host "|Time interval: $IntervalMinutes                                                                        |"
    Write-Host "------------------------------------------------------------------------------------------" 
    echo ""
        
    while ($true){
        $CurrentEnd = $CurrentStart.AddMinutes($IntervalMinutes)
        
        $AmountResults = Search-UnifiedAuditLog -StartDate $CurrentStart -EndDate $CurrentEnd -UserIds $script:Userstoextract -ResultSize 1 | out-string -Stream | select-string ResultCount
        if($AmountResults){
            $number = $AmountResults.tostring().split(":")[1]
            $script:integer = [int]$number
            
            while ($script:integer -gt 5000){
                $AmountResults = Search-UnifiedAuditLog -StartDate $CurrentStart -EndDate $CurrentEnd -UserIds $script:Userstoextract -ResultSize 1 | out-string -Stream | select-string ResultCount
                if($AmountResults){
                    $number = $AmountResults.tostring().split(":")[1]
                    $script:integer = [int]$number
                    if ($script:integer -lt 5000){
                        if ($IntervalMinutes -eq 0){
                            Exit
                            }
                        else{
                            write-host "INFO: Temporary lowering time interval to $IntervalMinutes minutes" -ForegroundColor Yellow
                            }}
                    else{
                        $IntervalMinutes = $IntervalMinutes / 2
                        $CurrentEnd = $CurrentStart.AddMinutes($IntervalMinutes)}}
                        
                else{
                    Write-LogFile "INFO: Retrieving audit logs between $($CurrentStart) and $($CurrentEnd)"
                    Write-Host "INFO: Retrieving audit logs between $($CurrentStart) and $($CurrentEnd)" -ForegroundColor green
                    $Intervalmin = $IntervalMinutes
                    $CurrentStart = $CurrentStart.AddMinutes($Intervalmin)
                    $CurrentEnd = $CurrentStart.AddMinutes($Intervalmin)
                    $AmountResults = Search-UnifiedAuditLog -StartDate $CurrentStart -EndDate $CurrentEnd -UserIds $script:Userstoextract -ResultSize 1 | out-string -Stream | select-string ResultCount
                    if($AmountResults){
                        $number = $AmountResults.tostring().split(":")[1]
                        $script:integer = [int]$number}}}
                }
                        
        ELSE{
            $IntervalMinutes = $ResetInterval}
            
        
        if ($CurrentEnd -gt $EndDate){				
            $DURATION = $EndDate - $Backupdate
            $durmin = $DURATION.TotalMinutes
            
            $CurrentEnd = $Backupdate
            $CurrentStart = $Backupdate
            
            $IntervalMinutes = $durmin /2
            if ($IntervalMinutes -eq 0){
                Exit}
            else{
                write-host "INFO: Temporary lowering time interval to $IntervalMinutes minutes" -ForegroundColor Yellow
                $CurrentEnd = $CurrentEnd.AddMinutes($IntervalMinutes)}
                }
        
        ELSEIF($CurrentEnd -eq $EndDate){
            Write-LogFile "INFO: Retrieving audit logs between $($CurrentStart) and $($CurrentEnd)"
            Write-Host "INFO: Retrieving audit logs between $($CurrentStart) and $($CurrentEnd)" -ForegroundColor green
            
            [Array]$results = Search-UnifiedAuditLog -StartDate $CurrentStart -EndDate $CurrentEnd -SessionID $SessionID -UserIds $script:Userstoextract -SessionCommand ReturnNextPreviewPage -ResultSize $ResultSize
            if($results){
                $results | epcsv $OutputFile -NoTypeInformation -Append
            }
            write-host "Quiting.." -ForegroundColor Red
            break
        }
            
        $CurrentTries = 0
        $SessionID = [DateTime]::Now.ToString().Replace('/', '_')
        Write-LogFile "INFO: Retrieving audit logs between $($CurrentStart) and $($CurrentEnd)"
        Write-Host "INFO: Retrieving audit logs between $($CurrentStart) and $($CurrentEnd)" -ForegroundColor green
        
            
        while ($true){		
            $CurrentEnd = $CurrentEnd.AddSeconds(-1)				
            [Array]$results = Search-UnifiedAuditLog -StartDate $CurrentStart -EndDate $CurrentEnd -SessionID $SessionID -UserIds $script:Userstoextract -SessionCommand ReturnNextPreviewPage -ResultSize $ResultSize
            $CurrentEnd = $CurrentEnd.AddSeconds(1)
            $CurrentCount = 0
            
            if ($results -eq $null -or $results.Count -eq 0){
                if ($CurrentTries -lt $RetryCount){
                    $CurrentTries = $CurrentTries + 1
                    continue}
                else{
                    Write-LogFile "WARNING: Empty data set returned between $($CurrentStart) and $($CurrentEnd). Retry count reached. Moving forward!"
                    break}}
                    
            $CurrentTotal = $results[0].ResultCount
            $CurrentCount = $CurrentCount + $results.Count
            
            if ($CurrentTotal -eq $results[$results.Count - 1].ResultIndex){
                $message = "INFO: Successfully retrieved $($CurrentCount) records out of total $($CurrentTotal) for the current time range. Moving on!"
                $results | epcsv $OutputFile -NoTypeInformation -Append
                write-host $message
                Write-LogFile $message
                break}}
        
        $CurrentStart = $CurrentEnd
        [DateTime]$Backupdate = $CurrentEnd}

    #SHA256 hash calculation for the output files
    $HASHValues = Join-Path $PSScriptRoot "\Log_Directory\Hashes.csv"
    Get-ChildItem $LogDirectoryPath -Filter *AuditRecords.csv | Get-FileHash -Algorithm SHA256 | epcsv $HASHValues
}
