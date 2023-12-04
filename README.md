RDP Connection Utility
Overview
This utility is designed to simplify the process of connecting to remote desktops (RDP) by providing a user-friendly interface. The primary objective of the utility is to streamline and automate shadow connections to RDP. It includes a PowerShell script (rdpX.X.X.ps1), a batch file to start the PowerShell script (StartRDP.bat), and a batch file to create a desktop shortcut for the script (Create Shortcut.bat).

Features
User-friendly Interface: The PowerShell script presents a graphical user interface (GUI) allowing users to easily select a computer, user group, and user credentials for RDP connections.

Configuration Database: The program utilizes a configuration file (config.json) acting as a database. It stores information about different user groups, each containing multiple users with specific connection details.

Dynamic User Selection: The script dynamically populates user options based on the selected user group, making it easy to manage multiple user configurations.

Shadow Connection Support: The ability to perform shadow connections is included, allowing users to monitor or assist remote sessions.

Delay Timer: Users can set a delay timer before the script enters login credentials, providing flexibility based on specific network or system requirements.

Password Show/Hide Option: The script includes an option to show/hide the entered password.

Additional Scripts
1. StartRDP.bat
This batch file launches the PowerShell script (rdpX.X.X.ps1). It ensures proper execution with required PowerShell parameters, allowing for a seamless RDP connection experience.

2. Create Shortcut.bat
This batch file creates a desktop shortcut (StartRDP.lnk) for the RDP utility. Users can execute this script to conveniently place a shortcut on their desktop for quick access to the RDP connection utility.

Usage
Installation:

Ensure PowerShell script execution policy allows script execution (Set-ExecutionPolicy Unrestricted).
Run StartRDP.bat to initiate the RDP connection utility.
Creating Desktop Shortcut:

Run Create Shortcut.bat to generate a desktop shortcut (StartRDP.lnk).
Connecting via RDP:

Launch the RDP utility using the desktop shortcut or by executing StartRDP.bat.
Select the desired user group, user, and enter the necessary details.
Click "Connect" to initiate the RDP connection.
Shadow Connection (Optional):

To perform a shadow connection, check the "Shadow Connection" checkbox before connecting.
Customization:

Customize the configuration file (config.json) to add or modify user groups and user details.
For any assistance or inquiries, please refer to the Issues section of this repository.

Note: Ensure that the necessary security precautions are taken when using or sharing this utility. Passwords and connection details stored in the configuration file should be handled securely.