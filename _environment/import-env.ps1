# List of environment files to load
$envFiles = @("credential.env", "notification.env", "jwt.env")

foreach ($envFile in $envFiles) {
    if (-Not (Test-Path $envFile)) {
        Write-Host "File not found: $envFile"
        continue
    }

    Write-Host "Loading $envFile..."

    Get-Content $envFile | ForEach-Object {
        $_ = $_.Trim()
        if ($_ -match '^#' -or $_ -eq '') { return }

        $parts = $_ -split '=', 2
        if ($parts.Count -ne 2) {
            Write-Host "Skipping invalid line: $_"
            return
        }

        $key = $parts[0].Trim()
        $value = $parts[1].Trim()

        if ($key -and $value) {
            [System.Environment]::SetEnvironmentVariable($key, $value, "User")
            Write-Host "Set $key=$value"
        }
    }
}
