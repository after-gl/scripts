Notice: you can always find the latest build of this script on [Releases page](https://github.com/after-gl/scripts/releases/)

# Admin scripts

## ad.exe: 
AnyDesk Installation and Configuration Script

This PowerShell script automates the process of downloading, installing, and configuring AnyDesk for unattended access on a Windows machine. The script performs the following actions:
1. Checks if AnyDesk is already installed.
2. Downloads the latest version of AnyDesk if it is not already installed.
3. Installs AnyDesk silently.
4. Configures AnyDesk for unattended access with a specified password.
5. Ensures AnyDesk starts with Windows.
6. Retrieves and displays the AnyDesk ID.

### Prerequisites
- PowerShell 5.0 or later.
- Administrator privileges.

-----
## users.exe: Admin User Management Script
This PowerShell script automates the process of creating a new local admin user, adding them to the Administrators group, and demoting the current user from the Administrators group to the Users group on a Windows machine.

### ⚠️ Important Warning

### **Current User Demotion**

**This script will demote the current user from the Administrators group to the Users group.**

- **Verify New Admin Credentials**: Ensure that the new admin user credentials are verified and that you can log in with the new admin user before running this script.
- **Loss of Administrative Access**: Once the current user is removed from the Administrators group, they will lose the ability to perform administrative tasks. Ensure all necessary administrative tasks are completed prior to executing the script.
- **Impact on System Operations**: Demoting the current user can affect their ability to manage the system and perform privileged operations. Plan accordingly.

**Proceed with caution and make sure you have appropriate backups and recovery options available.**

---

Use this script at your own risk. The author is not responsible for any damage or data loss that may occur as a result of using this script.


### Prerequisites
- PowerShell 5.0 or later.
- Administrator privileges.
