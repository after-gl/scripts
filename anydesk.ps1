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
    # Download the latest AnyDesk version
    Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath

    # Install AnyDesk silently
    $installArgs = "--install `"$installDir`" --start-with-win --create-shortcuts --create-desktop-icon --silent"
    Start-Process -FilePath $installerPath -ArgumentList $installArgs -Wait
}

# Function to configure unattended access
function Configure-UnattendedAccess {
    # Set up passworded unattended access
    # Start-Process -FilePath $anydeskPath -ArgumentList "--set-password", $password -Wait
    Start-Process -FilePath $anydeskPath -ArgumentList "--set-password", $password -Wait
    Start-Process -FilePath $anydeskPath -ArgumentList "--admin-settings:access", $password -Wait
    
    # Ensure AnyDesk starts with Windows
    # Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "AnyDesk" -Value "`"$anydeskPath`""

    # Start AnyDesk
    # Start-Process -FilePath $anydeskPath
}

# Function to get AnyDesk ID
function Get-AnyDeskID {
    $anydeskID = & $anydeskPath --get-id
    Write-Output "AnyDesk has been installed, configured for unattended access, and set to run with Windows."
    Write-Output "The AnyDesk ID is: $anydeskID"
}

# Main script logic
if (Test-AnyDeskInstalled) {
    Write-Output "AnyDesk is already installed."
    Configure-UnattendedAccess
    Get-AnydeskID
} else {
    Write-Output "AnyDesk is not installed. Installing now..."
    Install-AnyDesk
    Configure-UnattendedAccess
    Get-AnyDeskID
}
