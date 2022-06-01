function New-Directory([string]$path)
{
	if (!(Test-Path $path))
	{
		New-Item -Path:$path -ItemType:"Directory" -Force
	}
}
