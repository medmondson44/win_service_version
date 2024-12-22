# Get all services and their associated executable files, then get the version info
Get-WmiObject -Class Win32_Service | ForEach-Object {
    $service = $_
    $exePath = $service.PathName
    $exePath = $exePath -replace '"', ''  # Clean up any quotes around the path

    # Exclude services whose file path contains "svchost"
    if ($exePath -notlike "*svchost*") {
        if (Test-Path $exePath) {
            # Try to get the version of the executable
            $fileVersion = (Get-Item $exePath).VersionInfo.FileVersion
        } else {
            $fileVersion = "N/A"
        }

        # Output the service name, display name, and version
        [PSCustomObject]@{
            ServiceName    = $service.Name
            DisplayName    = $service.DisplayName
            FilePath       = $exePath
            Version        = $fileVersion
        }
    }
} | fl *
