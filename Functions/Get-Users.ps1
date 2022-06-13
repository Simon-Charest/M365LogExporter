function Get-Users($userIds)
{
    if ([string]::IsNullOrWhiteSpace($userIds))
    {
        return "all users"
    }

    return $userIds
}
