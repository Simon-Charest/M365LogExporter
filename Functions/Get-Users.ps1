function Get-Users($userIds)
{
    if ($userIds -eq "*")
    {
        $users = "all users"
    }

    else
    {
        $users = "users $($userIds)"
    }

    return $users
}