# TODO: Refactor this
function Export-Specific()
{
    #All RecordTypes can be found at:
    #https://docs.microsoft.com/en-us/office/office-365-management-api/office-365-management-activity-api-schema#enum-auditlogrecordtype---type-edmint32
    #https://docs.microsoft.com/en-us/powershell/module/exchange/policy-and-compliance-audit/search-unifiedauditlog?view=exchange-ps
    #Known RecordTypes please check the above links as these types get updated: "SharePointFieldOperation","TeamsHealthcare","LabelExplorer","PowerAppsPlan","HygieneEvent","PowerAppsApp","ExchangeItemAggregated","SecurityComplianceInsights","WorkplaceAnalytics","DataGovernance","ThreatFinder","AeD","ThreatIntelligenceAtpContent","ThreatIntelligenceUrl","MicrosoftStream","Project","SharepointListOperation","SecurityComplianceAlerts","ThreatIntelligenceUrl","AzureActiveDirectory","AzureActiveDirectoryAccountLogon","AzureActiveDirectoryStsLogon","ComplianceDLPExchange","ComplianceDLPSharePoint","CRM","DataCenterSecurityCmdlet","Discovery","ExchangeAdmin","ExchangeAggregatedOperation","ExchangeItem","ExchangeItemGroup","MicrosoftTeamsAddOns","MicrosoftTeams","MicrosoftTeamsSettingsOperation","OneDrive","PowerBIAudit","SecurityComplianceCenterEOPCmdlet","SharePoint", "SharePointFileOperation","SharePointSharingOperation","SkypeForBusinessCmdlets","SkypeForBusinessPSTNUsage","SkypeForBusinessUsersBlocked","Sway","ThreatIntelligence","Yammer"
    write-host "Enter the RecordType(s) that need to be extracted, multiple recordtypes can be entered using comma separated values" -ForegroundColor Green
    write-host "The different RecordTypes can be found on our Github page (https://github.com/PwC-IR/Office-365-Extractor)"
    write-host "Example: SecurityComplianceCenterEOPCmdlet,SecurityComplianceAlerts,SharepointListOperation"
    $RecordTypes = read-host ">"
    echo ""

    [DateTime]$StartDate = Get-StartDate
    [DateTime]$EndDate = Get-EndDate

    echo ""
    write-host "Recommended interval is 60"
    Write-host "Lower the time interval for environments with a high log volume"
    echo ""

    $IntervalMinutes = read-host "Please enter a time interval or ENTER for 60"
    if ([string]::IsNullOrWhiteSpace($IntervalMinutes)) { $IntervalMinutes = "60" }

    $ResetInterval = $IntervalMinutes

    Write-ToFile "Start date provided by user: $StartDate"
    Write-ToFile "End date provided by user: $EndDate"
    Write-ToFile "Time Interval provided by user: $IntervalMinutes"
    
    echo ""
    Write-Host "----------------------------------------------------------------------------"
    Write-Host "|Extracting audit logs between "$StartDate" and "$EndDate"|"
    write-host "|Time interval: $IntervalMinutes                                                                       |"
    Write-Host "----------------------------------------------------------------------------" 
    Write-Host "The following RecordTypes are configured to be extracted:" -ForegroundColor Green

    Foreach ($record in $RecordTypes.Split(",")){
    Write-Host "-$record"}
    echo ""
    Foreach ($record in $RecordTypes.Split(",")){
    $SpecificResult = Search-UnifiedAuditLog -StartDate $StartDate -EndDate $EndDate -RecordType $record -UserIds $script:Userstoextract -ResultSize 1 | out-string -Stream | select-string ResultCount
    if($SpecificResult) {
        $NumberOfLogs = $SpecificResult.tostring().split(":")[1]
        $CSVOutputFile = "\Log_Directory\"+$record+"_AuditRecords.csv"
        $LogFile = Join-Path $PSScriptRoot $AuditLog
        $OutputFile = Join-Path $PSScriptRoot $CSVOutputFile
        
        If(!(test-path $OutputFile)){
                Write-host "Creating the following file:" $OutputFile}
        else{
            $date = [datetime]::Now.ToString('HHmm') 
            $CSVOutputFile = "Log_Directory\"+$date+$record+"_AuditRecords.csv"
            $OutputFile = Join-Path $PSScriptRoot $CSVOutputFile}
            
        [DateTime]$CurrentStart = $StartDate
        [DateTime]$CurrentEnd = $EndDate
        Write-Host "Extracting:  $record"
        Write-ToFile "Extracting:  $record"
        
        while ($true){
        $CurrentEnd = $CurrentStart.AddMinutes($IntervalMinutes)
        
        echo Search-UnifiedAuditLog -StartDate $CurrentStart -EndDate $CurrentEnd -RecordType $record -UserIds $script:Userstoextract -ResultSize 1 | out-string -Stream | select-string ResultCount
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
                    Write-ToFile "INFO: Retrieving audit logs between $($CurrentStart) and $($CurrentEnd)"
                    Write-Host "INFO: Retrieving audit logs between $($CurrentStart) and $($CurrentEnd)" -ForegroundColor green
                    $Intervalmin = $IntervalMinutes
                    $CurrentStart = $CurrentStart.AddMinutes($Intervalmin)
                    $CurrentEnd = $CurrentStart.AddMinutes($Intervalmin)
                    $AmountResults = Search-UnifiedAuditLog -StartDate $CurrentStart -EndDate $CurrentEnd -RecordType $record -UserIds $script:Userstoextract -ResultSize 1 | out-string -Stream | select-string ResultCount
                    if($AmountResults){
                        $number = $AmountResults.tostring().split(":")[1]
                        $script:integer = [int]$number}}
                        }}
            
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
                write-host "INFO: Temporary lowering time interval to $IntervalMinutes minutes" -ForegroundColor Yellow}
                
            $CurrentEnd = $CurrentEnd.AddMinutes($IntervalMinutes)}
        
        ELSEIF($CurrentEnd -eq $EndDate){
            Write-ToFile "INFO: Retrieving audit logs between $($CurrentStart) and $($CurrentEnd)"
            Write-Host "INFO: Retrieving audit logs between $($CurrentStart) and $($CurrentEnd)" -ForegroundColor green
            
            [Array]$results = Search-UnifiedAuditLog -StartDate $CurrentStart -EndDate $CurrentEnd -RecordType $record -UserIds $script:Userstoextract -SessionID $SessionID -SessionCommand ReturnNextPreviewPage -ResultSize $ResultSize
            if($results){
                $results | epcsv $OutputFile -NoTypeInformation -Append
            }
            write-host "Quiting.." -ForegroundColor Red
            break
        }
        $CurrentTries = 0
        $SessionID = [DateTime]::Now.ToString().Replace('/', '_')
        Write-ToFile "INFO: Retrieving audit logs between $($CurrentStart) and $($CurrentEnd)"
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
                    Write-ToFile "WARNING: Empty data set returned between $($CurrentStart) and $($CurrentEnd). Retry count reached. Moving forward!"
                    break}}
                    
            $CurrentTotal = $results[0].ResultCount
            $CurrentCount = $CurrentCount + $results.Count
            
            if ($CurrentTotal -eq $results[$results.Count - 1].ResultIndex){
                $message = "INFO: Successfully retrieved $($CurrentCount) records out of total $($CurrentTotal) for the current time range. Moving on!"
                $results | epcsv $OutputFile -NoTypeInformation -Append
                Write-ToFile $message
                Write-host $message
                break}}
            
        $CurrentStart = $CurrentEnd
        [DateTime]$Backupdate = $CurrentEnd}}
        
        else{
            Write-Host "No logs available for $record"  -ForegroundColor red
            echo ""}}

    #SHA256 hash calculation for the output files
    $HASHValues = Join-Path $PSScriptRoot "\Log_Directory\Hashes.csv"
    Get-ChildItem $LogDirectoryPath -Filter *_AuditRecords.csv | Get-FileHash -Algorithm SHA256 | epcsv $HASHValues -NoTypeInformation -Append	
}
