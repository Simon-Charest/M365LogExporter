function Get-Users([string]$userIds)
{
    if ([string]::IsNullOrWhiteSpace($userIds))
    {
        return "all users"
    }

    return $userIds
}
