function Select-RecordTypes()
{
	[string]$recordTypes = Read-Host "Enter comma-separated record types (e.g., SecurityComplianceCenterEOPCmdlet,SecurityComplianceAlerts) or leave empty for all"

	if ([string]::IsNullOrWhiteSpace($recordTypes))
    {
        return $null
    }

	return $recordTypes
}
