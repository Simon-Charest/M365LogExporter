function Get-Users($userIds)
{
    if ($null -eq $userIds)
    {
        $users = "all users"
    }

    else
    {
        $users = "users $($userIds)"
    }

    return $users
}