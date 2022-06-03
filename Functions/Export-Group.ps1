# TODO: Refactor this
function Export-Group()
{
    Write-host "1: Extract all Exchange logging"
    Write-host "2: Extract all Azure logging"
    Write-host "3: Extract all Sharepoint logging"
    Write-host "4: Extract all Skype logging"
    write-host "5: Back to menu"

    $inputgroup = Read-Host "Select an action"

    IF($inputgroup -eq "1"){
    $RecordTypes = "ExchangeAdmin","ExchangeAggregatedOperation","ExchangeItem","ExchangeItemGroup","ExchangeItemAggregated","ComplianceDLPExchange","ComplianceSupervisionExchange","MipAutoLabelExchangeItem"
    $RecordFile = "AllExchange"}
    ELSEIF($inputgroup -eq "2"){
    $RecordTypes = "AzureActiveDirectory","AzureActiveDirectoryAccountLogon","AzureActiveDirectoryStsLogon"
    $RecordFile = "AllAzure"}
    ELSEIF($inputgroup -eq "3"){
    $RecordTypes = "ComplianceDLPSharePoint","SharePoint","SharePointFileOperation","SharePointSharingOperation","SharepointListOperation", "ComplianceDLPSharePointClassification","SharePointCommentOperation", "SharePointListItemOperation", "SharePointContentTypeOperation", "SharePointFieldOperation","MipAutoLabelSharePointItem","MipAutoLabelSharePointPolicyLocation"
    $RecordFile = "AllSharepoint"}
    ELSEIF($inputgroup -eq "4"){
    $RecordTypes = "SkypeForBusinessCmd","SkypeForBusinessPSTNUsage","SkypeForBusinessUsersBlocked"
    $RecordFile = "AllSkype"}
    ELSE{}

    [DateTime]$StartDate = Get-StartDate
    [DateTime]$EndDate = Get-EndDate

    echo ""
    write-host "Recommended interval is 60"
    Write-host "Lower the time interval for environments with a high log volume"
    echo ""

    $IntervalMinutes = read-host "Please enter a time interval or ENTER for 60"
    if ([string]::IsNullOrWhiteSpace($IntervalMinutes)) { $IntervalMinutes = "60" }

    $ResetInterval = $IntervalMinutes

    Write-LogFile "Start date provided by user: $StartDate"
    Write-LogFile "End date provided by user: $EndDate"
    Write-Logfile "Time interval provided by user: $IntervalMinutes"

    echo ""
    Write-Host "----------------------------------------------------------------------------"
    Write-Host "|Extracting audit logs between "$StartDate" and "$EndDate"|"
    write-host "|Time interval: $IntervalMinutes                                                                       |"
    Write-Host "----------------------------------------------------------------------------" 
    Write-Host "The following RecordTypes are configured to be extracted:" -ForegroundColor Green
    Foreach ($record in $RecordTypes){
    Write-Host "-$record"}
    echo ""

    Foreach ($record in $RecordTypes){
    $SpecificResult = Search-UnifiedAuditLog -StartDate $StartDate -EndDate $EndDate -RecordType $record -UserIds $script:Userstoextract -ResultSize 1 | out-string -Stream | select-string ResultCount

    if($SpecificResult){
    $NumberOfLogs = $SpecificResult.tostring().split(":")[1]
    $CSVOutputFile = "\Log_Directory\"+$RecordFile+"_AuditRecords.csv"
    $OutputFile = Join-Path $PSScriptRoot $CSVOutputFile

    If(!(test-path $OutputFile)){
        Write-host "Creating the following file:" $OutputFile}

    [DateTime]$CurrentStart = $StartDate
    [DateTime]$CurrentEnd = $EndDate
    Write-Host "Extracting:  $record"
    echo ""

    while ($true){
    $CurrentEnd = $CurrentStart.AddMinutes($IntervalMinutes)
    $AmountResults = Search-UnifiedAuditLog -StartDate $CurrentStart -EndDate $CurrentEnd -RecordType $record -UserIds $script:Userstoextract -ResultSize 1 | out-string -Stream | select-string ResultCount

    if($AmountResults){
        $number = $AmountResults.tostring().split(":")[1]
        $script:integer = [int]$number

        while ($script:integer -gt 5000){
            $AmountResults = Search-UnifiedAuditLog -StartDate $CurrentStart -EndDate $CurrentEnd -RecordType $record -UserIds $script:Userstoextract -ResultSize 1 | out-string -Stream | select-string ResultCount
            if($AmountResults){
                    $number = $AmountResults.tostring().split(":")[1]
                    $script:integer = [int]$number
                    if ($script:integer -lt 5000){
                        if ($IntervalMinutes -eq 0){
                            Exit}
                        else{
                            write-host "INFO: Temporary lowering time interval to $IntervalMinutes minutes" -ForegroundColor Yellow}}
                    else{
                        $IntervalMinutes = $IntervalMinutes / 2
                        $CurrentEnd = $CurrentStart.AddMinutes($IntervalMinutes)}}
                    
            else{
                Write-LogFile "INFO: Retrieving audit logs between $($CurrentStart) and $($CurrentEnd)"
                Write-Host "INFO: Retrieving audit logs between $($CurrentStart) and $($CurrentEnd)" -ForegroundColor green
                $Intervalmin = $IntervalMinutes
                $CurrentStart = $CurrentStart.AddMinutes($Intervalmin)
                $CurrentEnd = $CurrentStart.AddMinutes($Intervalmin)
                $AmountResults = Search-UnifiedAuditLog -StartDate $CurrentStart -EndDate $CurrentEnd -RecordType $record -UserIds $script:Userstoextract -ResultSize 1 | out-string -Stream | select-string ResultCount
                if($AmountResults){
                    write-host $AmountResults
                    $number = $AmountResults.tostring().split(":")[1]
                    $script:integer = [int]$number}}}}
            
        ELSE{
            $IntervalMinutes = $ResetInterval}
        if ($CurrentEnd -gt $EndDate){				
            $DURATION = $EndDate - $Backupdate
            $durmin = $DURATION.TotalMinutes
            
            $CurrentEnd = $Backupdate
            $CurrentStart = $Backupdate
            
            $IntervalMinutes = $durmin /2
            if ($IntervalMinutes -eq 0){
                Exit
                }
            else{
                write-host "INFO: Temporary lowering time interval to $IntervalMinutes minutes" -ForegroundColor Yellow
                }
            $CurrentEnd = $CurrentEnd.AddMinutes($IntervalMinutes)}
        
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
        $CurrentCount = 0
        
        while ($true){
            $CurrentEnd = $CurrentEnd.AddSeconds(-1)
            [Array]$results = Search-UnifiedAuditLog -StartDate $CurrentStart -EndDate $CurrentEnd -RecordType $record -UserIds $script:Userstoextract -SessionID $SessionID -SessionCommand ReturnNextPreviewPage -ResultSize $ResultSize
            $CurrentEnd = $CurrentEnd.AddSeconds(1)
            
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
                Write-LogFile $message
                Write-host $message
                break}}
            
        $CurrentStart = $CurrentEnd
        [DateTime]$Backupdate = $CurrentEnd}}
        
        else{
            Write-Host "No logs available for $record"  -ForegroundColor red
            echo ""}}
            
    #SHA256 hash calculation for the output files
    $HASHValues = Join-Path $PSScriptRoot "\Log_Directory\Hashes.csv"
    Get-ChildItem $LogDirectoryPath -Filter *_AuditRecords.csv | Get-FileHash -Algorithm SHA256 | epcsv $HASHValues
}
