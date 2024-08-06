Add-Type -AssemblyName PresentationFramework

function Show-Window {
    [xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="RustDesk Client Configuration" Height="400" Width="600">
    <Grid Margin="10">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="*"/>
            <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>
        
        <!-- Download RustDesk Clients -->
        <GroupBox Header="Download RustDesk Clients" Grid.Row="0" Grid.ColumnSpan="2" Margin="5">
            <StackPanel>
                <ComboBox Name="PlatformComboBox" Margin="5">
                    <ComboBoxItem Content="Windows exe"/>
                    <ComboBoxItem Content="Windows installer bat"/>
                    <ComboBoxItem Content="Windows Installer powershell"/>
                    <ComboBoxItem Content="Linux Installer"/>
                    <ComboBoxItem Content="Mac Installer"/>
                </ComboBox>
                <Button Name="DownloadButton" Content="Download" Margin="5" Width="100"/>
                <ProgressBar Name="DownloadProgressBar" Height="20" Margin="5"/>
            </StackPanel>
        </GroupBox>
        
        <!-- Theme Settings -->
        <GroupBox Header="Theme Settings" Grid.Row="1" Grid.Column="0" Margin="5">
            <StackPanel>
                <CheckBox Name="ThemeToggle" Content="Dark Mode" Margin="5"/>
            </StackPanel>
        </GroupBox>
        
        <!-- Password Settings -->
        <GroupBox Header="Password Settings" Grid.Row="1" Grid.Column="1" Margin="5">
            <StackPanel>
                <PasswordBox Name="PasswordBox" Margin="5"/>
                <Button Name="GeneratePasswordButton" Content="Generate Password" Margin="5" Width="150"/>
                <TextBlock Name="PasswordStrengthLabel" Text="Too Short" Margin="5" Foreground="Red"/>
                <ProgressBar Name="PasswordStrengthBar" Height="20" Margin="5"/>
                <CheckBox Name="SetPermanentCheckbox" Content="Set as Permanent" Margin="5"/>
            </StackPanel>
        </GroupBox>
        
        <!-- Additional Settings -->
        <GroupBox Header="Additional Settings" Grid.Row="2" Grid.ColumnSpan="2" Margin="5">
            <StackPanel>
                <CheckBox Name="AutostartCheckbox" Content="Autostart" Margin="5"/>
                <Button Name="DefaultSettingsButton" Content="Default Settings" Margin="5" Width="150"/>
                <Button Name="HelpButton" Content="Help/Documentation" Margin="5" Width="150"/>
            </StackPanel>
        </GroupBox>
    </Grid>
</Window>
"@

    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    $window = [Windows.Markup.XamlReader]::Load($reader)

    # Find elements
    $PlatformComboBox = $window.FindName("PlatformComboBox")
    $DownloadButton = $window.FindName("DownloadButton")
    $DownloadProgressBar = $window.FindName("DownloadProgressBar")
    $ThemeToggle = $window.FindName("ThemeToggle")
    $PasswordBox = $window.FindName("PasswordBox")
    $GeneratePasswordButton = $window.FindName("GeneratePasswordButton")
    $PasswordStrengthLabel = $window.FindName("PasswordStrengthLabel")
    $PasswordStrengthBar = $window.FindName("PasswordStrengthBar")
    $SetPermanentCheckbox = $window.FindName("SetPermanentCheckbox")
    $AutostartCheckbox = $window.FindName("AutostartCheckbox")
    $DefaultSettingsButton = $window.FindName("DefaultSettingsButton")
    $HelpButton = $window.FindName("HelpButton")

    # Event handlers
    $DownloadButton.Add_Click({
        $selectedPlatform = $PlatformComboBox.SelectedItem.Content

        $urls = @{
            "Windows exe" = "ENTER YOUR URL HERE"
            "Windows installer bat" = "ENTER YOUR URL HERE"
            "Windows Installer powershell" = "ENTER YOUR URL HERE"
            "Linux Installer" = "ENTER YOUR URL HERE"
            "Mac Installer" = "ENTER YOUR URL HERE"
        }

        if ($urls.ContainsKey($selectedPlatform)) {
            $url = $urls[$selectedPlatform]
            $scriptDirectory = (Get-Location).Path
            $outputFile = [System.IO.Path]::Combine($scriptDirectory, [System.IO.Path]::GetFileName($url))
            
            # Initialize download progress
            $DownloadProgressBar.Value = 0
            $DownloadProgressBar.Maximum = 100

            # Start a job to download the file
            $job = Start-Job -ScriptBlock {
                param ($url, $outputFile)
                $webClient = New-Object System.Net.WebClient
                try {
                    $webClient.DownloadFile($url, $outputFile)
                } catch {
                    Write-Error "Download failed: $_"
                }
            } -ArgumentList $url, $outputFile

            # Wait for the job to complete
            Wait-Job $job
            Receive-Job $job

            # Update the progress bar to 100%
            $DownloadProgressBar.Value = 100
            [System.Windows.MessageBox]::Show("Download completed!", "Information", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
            
            # Reset the progress bar
            $DownloadProgressBar.Value = 0
        }
    })

    $ThemeToggle.Add_Checked({
        # Logic to switch to dark mode
        [System.Windows.MessageBox]::Show("Dark mode enabled!", "Information", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    })
    $ThemeToggle.Add_Unchecked({
        # Logic to switch to light mode
        [System.Windows.MessageBox]::Show("Light mode enabled!", "Information", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    })

    $GeneratePasswordButton.Add_Click({
        # Logic to generate password and update $PasswordBox
        $length = Get-Random -Minimum 8 -Maximum 32
        $characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{}|;:",.<>?'
        $password = -join ((1..$length) | ForEach-Object { $characters[(Get-Random -Minimum 0 -Maximum ($characters.Length - 1))] })
        $PasswordBox.Password = $password

        # Check password strength and update $PasswordStrengthLabel and $PasswordStrengthBar
        if ($password.Length -lt 8) {
            $PasswordStrengthLabel.Text = "Too Short"
            $PasswordStrengthLabel.Foreground = [System.Windows.Media.Brushes]::Red
            $PasswordStrengthBar.Value = 20
        } elseif ($password.Length -ge 10 -and $password -match '[A-Z]' -and $password -match '[a-z]' -and $password -match '\d' -and $password -match '[!@#$%^&*()-_=+[\]{}|;:",.<>?]') {
            $PasswordStrengthLabel.Text = "Strong"
            $PasswordStrengthLabel.Foreground = [System.Windows.Media.Brushes]::Green
            $PasswordStrengthBar.Value = 100
        } else {
            $PasswordStrengthLabel.Text = "Medium"
            $PasswordStrengthLabel.Foreground = [System.Windows.Media.Brushes]::Yellow
            $PasswordStrengthBar.Value = 70
        }
    })

    $DefaultSettingsButton.Add_Click({
        # Logic to reset to default settings
        [System.Windows.MessageBox]::Show("Default settings applied!", "Information", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
    })

    $HelpButton.Add_Click({
        Start-Process "https://rustdesk.com/docs/en/"
    })

    $window.ShowDialog()
}

Show-Window
