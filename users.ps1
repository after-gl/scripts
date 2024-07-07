# Define new admin user credentials
$newUsername = "Admin"
# Prompt for the new admin user password
$newPassword = Read-Host -AsSecureString "Enter the password for the new admin user"

# Convert the secure string to plain text (use with caution)
$plainPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPassword))


# Create the new user
New-LocalUser -Name $newUsername -Password (ConvertTo-SecureString $plainPassword -AsPlainText -Force) -FullName "Admin" -Description "Administrator account for remote access"

# Add the new user to the Administrators group
Add-LocalGroupMember -Group "Administrators" -Member $newUsername

# Get the current username
$currentUser = $env:USERNAME

# Remove the current user from the Administrgators group if they are a member
if (Get-LocalGroupMember -Group "Administrators" -Member $currentUser -ErrorAction SilentlyContinue) {
    Remove-LocalGroupMember -Group "Administrators" -Member $currentUser
}

# Add the current user to the Users group if they are not already a member
if (-not (Get-LocalGroupMember -Group "Users" -Member $currentUser -ErrorAction SilentlyContinue)) {
    Add-LocalGroupMember -Group "Users" -Member $currentUser
}
