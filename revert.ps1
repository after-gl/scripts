# Variables
$wallpaperPath = "$env:Temp\wallpaper.jpg"

# Function to restore desktop background
function Restore-DesktopBackground {
    try {
        Write-Output "Restoring desktop background to default..."
        
        # Remove wallpaper registry entry (setting to empty string restores default)
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Wallpaper" -Value "" -ErrorAction Stop
        
        # Reset wallpaper style to default (2 = Stretch is Windows default)
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WallpaperStyle" -Value "2" -ErrorAction Stop
        
        # Refresh desktop to apply changes
        Add-Type -TypeDefinition @"
        using System;
        using System.Runtime.InteropServices;
        public class Wallpaper {
            [DllImport("user32.dll", CharSet=CharSet.Auto)]
            public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
        }
"@
        [Wallpaper]::SystemParametersInfo(20, 0, "", 3)
        
        # Optionally delete the downloaded wallpaper file
        if (Test-Path $wallpaperPath) {
            Remove-Item -Path $wallpaperPath -Force -ErrorAction SilentlyContinue
            Write-Output "Downloaded wallpaper file removed."
        }
        
        Write-Output "Desktop background has been restored to default."
        return $true
    }
    catch {
        Write-Error "Failed to restore desktop background: $_"
        return $false
    }
}

# Function to restore Windows theme to default
function Restore-DefaultTheme {
    try {
        Write-Output "Restoring Windows theme to default..."
        
        $personalizePath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        
        if (Test-Path $personalizePath) {
            # Remove or reset accent color (Windows will use default)
            if (Get-ItemProperty -Path $personalizePath -Name "AccentColor" -ErrorAction SilentlyContinue) {
                Remove-ItemProperty -Path $personalizePath -Name "AccentColor" -ErrorAction Stop
            }
            
            # Reset color prevalence to default (0 = disabled, use system default)
            Set-ItemProperty -Path $personalizePath -Name "ColorPrevalence" -Value 0 -ErrorAction Stop
            
            # Restore transparency setting to default (1 = enabled)
            Set-ItemProperty -Path $personalizePath -Name "EnableTransparency" -Value 1 -ErrorAction Stop
            
            Write-Output "Windows theme has been restored to default."
            return $true
        } else {
            Write-Output "No custom theme settings found. Theme is already at default."
            return $true
        }
    }
    catch {
        Write-Error "Failed to restore default theme: $_"
        return $false
    }
}

# Main script logic
Write-Output "Revert Beautify Changes Script"
Write-Output "=============================="

$success = $true

if (Restore-DesktopBackground) {
    Write-Output "Desktop background restored successfully."
} else {
    Write-Error "Failed to restore desktop background."
    $success = $false
}

if (Restore-DefaultTheme) {
    Write-Output "Theme restored successfully."
} else {
    Write-Error "Failed to restore theme."
    $success = $false
}

if ($success) {
    Write-Output "All changes have been reverted successfully."
} else {
    Write-Error "Some changes could not be reverted."
    exit 1
}

Write-Host "Press any key to continue..."
[System.Console]::ReadKey() > $null

