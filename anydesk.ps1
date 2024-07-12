# Variables
# Variables
$downloadUrl = "https://download.anydesk.com/AnyDesk.exe"
$installerPath = "$env:Temp\AnyDesk.exe"
$installDir = "C:\Program Files (x86)\AnyDesk"
$anydeskPath = "$installDir\AnyDesk.exe"
$passwordSecure = Read-Host -Prompt "Enter the password for unattended access" -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordSecure))

# Function to check if AnyDesk is installed
function Test-AnyDeskInstalled {
    return Test-Path $anydeskPath
}

# Function to install AnyDesk
function Install-AnyDesk {
    try {
        # Download the latest AnyDesk version
        Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath -ErrorAction Stop

        # Install AnyDesk silently
        $installArgs = "--install `"$installDir`" --start-with-win --create-shortcuts --create-desktop-icon --silent"
        Start-Process -FilePath $installerPath -ArgumentList $installArgs -Wait
    } catch {
        Write-Error "Failed to install AnyDesk: $_"
        exit 1
    }
}

# Function to configure unattended access
function Configure-UnattendedAccess {
    try {
        # Set up passworded unattended access
        Start-Process -FilePath $anydeskPath -ArgumentList "--set-password", $password -Wait -ErrorAction Stop

        # Ensure AnyDesk starts with Windows
        # Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "AnyDesk" -Value "`"$anydeskPath`"" -ErrorAction Stop

        # Start AnyDesk
        # Start-Process -FilePath $anydeskPath -ErrorAction Stop
    } catch {
        Write-Error "Failed to configure unattended access: $_"
        exit 1
    }
}

# Function to get AnyDesk ID
function Get-AnyDeskID {
    try {
        $anydeskID = & $anydeskPath --get-id
        Write-Output "AnyDesk has been installed, configured for unattended access, and set to run with Windows."
        Write-Output "The AnyDesk ID is: $anydeskID"
    } catch {
        Write-Error "Failed to get AnyDesk ID: $_"
        exit 1
    }
}

# Main script logic
try {
    if (Test-AnyDeskInstalled) {
        Write-Output "AnyDesk is already installed."
        Configure-UnattendedAccess
        Get-AnyDeskID
    } else {
        Write-Output "AnyDesk is not installed. Installing now..."
        Install-AnyDesk
        Configure-UnattendedAccess
        Get-AnyDeskID
    }
} catch {
    Write-Error "An unexpected error occurred: $_"
    exit 1
}

Write-Host "Press any key to continue..."
[System.Console]::ReadKey() > $null
