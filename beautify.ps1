# Variables
$downloadUrl = "https://pbs.twimg.com/media/G2cP3lOWwAAd-87?format=jpg&name=4096x4096"
$wallpaperPath = "$env:Temp\wallpaper.jpg"

# Function to download wallpaper image
function Download-Wallpaper {
    try {
        Write-Output "Downloading wallpaper from $downloadUrl..."
        Invoke-WebRequest -Uri $downloadUrl -OutFile $wallpaperPath -ErrorAction Stop
        Write-Output "Wallpaper downloaded successfully to $wallpaperPath"
        return $true
    }
    catch {
        Write-Error "Failed to download wallpaper: $_"
        return $false
    }
}

# Function to set desktop background
function Set-DesktopBackground {
    param(
        [string]$ImagePath
    )
    
    try {
        if (-not (Test-Path $ImagePath)) {
            Write-Error "Image file not found: $ImagePath"
            return $false
        }
        
        Write-Output "Setting desktop background..."
        
        # Set wallpaper using registry
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Wallpaper" -Value $ImagePath -ErrorAction Stop
        
        # Set wallpaper style (0 = Tile, 2 = Stretch, 6 = Fit, 10 = Fill, 22 = Span)
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallpaperStyle" -Value "10" -ErrorAction Stop
        
        # Refresh desktop to apply changes
        Add-Type -TypeDefinition @"
        using System;
        using System.Runtime.InteropServices;
        public class Wallpaper {
            [DllImport("user32.dll", CharSet=CharSet.Auto)]
            public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
        }
"@
        [Wallpaper]::SystemParametersInfo(20, 0, $ImagePath, 3)
        
        Write-Output "Desktop background has been set successfully."
        return $true
    }
    catch {
        Write-Error "Failed to set desktop background: $_"
        return $false
    }
}

# Function to set Windows theme to pink
function Set-PinkTheme {
    try {
        Write-Output "Setting Windows theme to pink..."
        
        # Pink color in BGR format (Deep Pink: RGB(255, 20, 147) = BGR 0x9314FF)
        $pinkColor = 0x9314FF
        
        # Ensure the Personalize registry path exists
        $personalizePath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        if (-not (Test-Path $personalizePath)) {
            New-Item -Path $personalizePath -Force | Out-Null
        }
        
        # Set accent color (Windows 10/11)
        Set-ItemProperty -Path $personalizePath -Name "AccentColor" -Value $pinkColor -ErrorAction Stop
        
        # Enable color prevalence (use accent color in title bars and taskbar)
        Set-ItemProperty -Path $personalizePath -Name "ColorPrevalence" -Value 1 -ErrorAction Stop
        
        # Set accent color in start menu and taskbar
        Set-ItemProperty -Path $personalizePath -Name "EnableTransparency" -Value 0 -ErrorAction Stop
        
        Write-Output "Windows theme has been set to pink successfully."
        return $true
    }
    catch {
        Write-Error "Failed to set pink theme: $_"
        return $false
    }
}

# Main script logic
Write-Output "Desktop Background and Theme Script"
Write-Output "===================================="

if (Download-Wallpaper) {
    if (Set-DesktopBackground -ImagePath $wallpaperPath) {
        if (Set-PinkTheme) {
            Write-Output "Script completed successfully."
        } else {
            Write-Error "Failed to set pink theme."
            exit 1
        }
    } else {
        Write-Error "Failed to set desktop background."
        exit 1
    }
} else {
    Write-Error "Failed to download wallpaper."
    exit 1
}

Write-Host "Press any key to continue..."
[System.Console]::ReadKey() > $null

