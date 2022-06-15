function Get-RecordType([string]$recordType)
{
    if ([string]::IsNullOrWhiteSpace($recordType))
    {
        return "all record types"
    }

    return $recordType
}
