# RustDesk Configuration Tool

## Introduction

The RustDesk Configuration Tool is a PowerShell script designed to facilitate the download and configuration of RustDesk clients. It provides a graphical user interface (GUI) for users to easily download different RustDesk clients, toggle between light and dark themes, manage passwords, and apply default settings.

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [Dependencies](#dependencies)
- [Configuration](#configuration)
- [Documentation](#documentation)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)
- [Contributors](#contributors)
- [License](#license)

## Installation

1. Ensure you have PowerShell installed on your Windows machine.
2. Download the `RustDeskConfig.ps1` script from the repository.

## Usage

1. Open PowerShell.
2. Navigate to the directory containing the `RustDeskConfig.ps1` script.
3. Execute the script by typing:
   ```powershell
   .\RustDeskConfig.ps1
   ```
4. The GUI window will appear, providing various configuration options.
5. Or you can right click and run with powershell

## Features

- **Download RustDesk Clients**: Choose from different platforms (Windows, Linux, Mac) and download the appropriate client.
- **Theme Settings**: Toggle between light and dark modes.
- **Password Settings**: Generate secure passwords and check their strength.
- **Default Settings**: Apply default settings to revert any changes.
- **Help**: Access RustDesk documentation directly from the tool.

## Dependencies

- PowerShell 5.0 or later
- .NET Framework (for GUI components)

## Configuration

The script includes several configurable options within the GUI:
- **Platform Selection**: Choose the platform for which to download the RustDesk client.
- **Theme Toggle**: Switch between light and dark modes.
- **Password Management**: Generate and evaluate the strength of passwords.
- **Default Settings**: Reset all settings to their defaults.

### URLs Configuration

Edit the following section in the `RustDeskConfig.ps1` script to include your own URLs for downloading the RustDesk clients:

```powershell
$urls = @{
    "Windows exe" = "https://your-url-for-windows-exe"
    "Windows installer bat" = "https://your-url-for-windows-installer-bat"
    "Windows Installer powershell" = "https://your-url-for-windows-installer-powershell"
    "Linux Installer" = "https://your-url-for-linux-installer"
    "Mac Installer" = "https://your-url-for-mac-installer"
}
```

Replace each URL with the appropriate link for your environment.

## Documentation

For detailed documentation on RustDesk and its features, visit the [RustDesk Documentation](https://rustdesk.com/docs/en/).

## Examples

### Example 1: Downloading a RustDesk Client

1. Select the desired platform from the dropdown menu.
2. Click the "Download" button.
3. Monitor the progress using the progress bar.

### Example 2: Generating a Strong Password

1. Click the "Generate" button in the Password Settings section.
2. The generated password will be displayed in the password box.
3. Check the password strength indicator to ensure it meets your security requirements.

## Troubleshooting

- If the GUI does not appear, ensure that PowerShell is running with sufficient permissions.
- For issues related to downloading clients, verify your internet connection and the selected platform.

## Just a prototype

- For now all it does is download rustdesk different variants
- In the future I will or someone will add the logic to code in the theme and password generation and setup
- Hopefully there would be a better UI idk how to do it 
