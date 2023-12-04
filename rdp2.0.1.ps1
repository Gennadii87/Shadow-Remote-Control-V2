Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Show-RDPForm {
    param (
        [string]$ComputerName,
        [int]$SessionID,
        [string]$Username,
        [string]$Password
    )

    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'RDP Connect'
    $form.Width = 270
    $form.Height = 420
    $form.BackColor = [System.Drawing.Color]::LightSkyBlue 
    $form.StartPosition = 'CenterScreen'

    # Создаем меню "File"
    $menuItemFile = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuItemFile.Text = 'File'

    # Пункт "Open JSON File"
    $menuItemOpen = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuItemOpen.Text = 'Open JSON File'
    $menuItemOpen.Add_Click({
        $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $openFileDialog.Filter = 'JSON files (*.json)|*.json'
        $openFileDialog.InitialDirectory = $scriptPath

        $result = $openFileDialog.ShowDialog()

        if ($result -eq 'OK') {
            $newConfigPath = $openFileDialog.FileName
            $newConfig = Get-Content -Path $newConfigPath -Raw -Encoding UTF8 | ConvertFrom-Json

            # Закрываем предыдущую форму, если она существует
            if ($null -ne $form) {
                $form.Dispose()
            }

            # Обновляем конфигурацию и создаем новую форму
            $config = $newConfig
            Show-RDPForm -ComputerName $config[0].Users[0].ComputerName -SessionID $config[0].Users[0].SessionID -Username $config[0].Users[0].Username -Password $config[0].Users[0].Password
        }
    })
    $menuItemFile.DropDownItems.Add($menuItemOpen) | Out-Null

    # Пункт "Exit"
    $menuItemExit = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuItemExit.Text = 'Exit'
    $menuItemExit.Add_Click({
        $form.Close()
    })
    $menuItemFile.DropDownItems.Add($menuItemExit) | Out-Null

    # Создаем меню-полосу
    $menuStrip = New-Object System.Windows.Forms.MenuStrip
    $menuStrip.Items.Add($menuItemFile) | Out-Null
    $form.Controls.Add($menuStrip) | Out-Null

    # Компьютер
    $labelComputer = New-Object System.Windows.Forms.Label
    $labelComputer.Text = 'Enter computer or IP address:'
    $labelComputer.Width = 200
    $labelComputer.Height = 15
    $labelComputer.Font = New-Object System.Drawing.Font("Arial", 10)
    $labelComputer.Location = New-Object System.Drawing.Point(20, 135)
    $form.Controls.Add($labelComputer)

    $textBoxComputer = New-Object System.Windows.Forms.TextBox
    $textBoxComputer.Location = New-Object System.Drawing.Point(20, 160)
    $textBoxComputer.Width = 210
    $textBoxComputer.Text = $ComputerName  # Устанавливаем значение из параметра
    $form.Controls.Add($textBoxComputer)

    # Группа пользователей
    $labelGroup = New-Object System.Windows.Forms.Label
    $labelGroup.Text = 'Select user group:'
    $labelGroup.Height = 15
    $labelGroup.Font = New-Object System.Drawing.Font("Arial", 10)
    $labelGroup.Location = New-Object System.Drawing.Point(20, 85)
    $form.Controls.Add($labelGroup)

    $comboBoxGroup = New-Object System.Windows.Forms.ComboBox
    $comboBoxGroup.Location = New-Object System.Drawing.Point(20, 105)
    $comboBoxGroup.Width = 210
    $comboBoxGroup.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList

    foreach ($group in $config) {
        $comboBoxGroup.Items.Add($group.GroupName)
    }
    
    $comboBoxGroup.Add_SelectedIndexChanged({
        $selectedGroup = $comboBoxGroup.SelectedItem.ToString()
        $comboBoxUser.Items.Clear()
    
        $config | Where-Object { $_.GroupName -eq $selectedGroup } | ForEach-Object {
            $_.Users | ForEach-Object {
                $comboBoxUser.Items.Add($_.Username)
            }
        }
    })

    $form.Controls.Add($comboBoxGroup)

    # Пользователь
    $labelUser = New-Object System.Windows.Forms.Label
    $labelUser.Text = 'Select user:'
    $labelUser.Font = New-Object System.Drawing.Font("Arial", 10)
    $labelUser.Height =15
    $labelUser.Location = New-Object System.Drawing.Point(20, 193)
    $form.Controls.Add($labelUser)

    $comboBoxUser = New-Object System.Windows.Forms.ComboBox
    $comboBoxUser.Location = New-Object System.Drawing.Point(20, 213)
    $comboBoxUser.Width = 210
    $comboBoxUser.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $form.Controls.Add($comboBoxUser)

    # Пароль
    $labelPassword = New-Object System.Windows.Forms.Label
    $labelPassword.Text = 'Enter your password:'
    $labelPassword.Width = 210
    $labelPassword.Height = 15
    $labelPassword.Font = New-Object System.Drawing.Font("Arial", 10)
    $labelPassword.Location = New-Object System.Drawing.Point(20, 245)
    $form.Controls.Add($labelPassword)

    $textBoxPassword = New-Object System.Windows.Forms.TextBox
    $textBoxPassword.Location = New-Object System.Drawing.Point(20, 267)
    $textBoxPassword.Width =210
    $textBoxPassword.Height = 20
    $textBoxPassword.PasswordChar = '*'
    $form.Controls.Add($textBoxPassword)

    # Кнопка Show Password
    $buttonShowPassword = New-Object System.Windows.Forms.Button
    $buttonShowPassword.Text = 'Show Password'
    $buttonShowPassword.Width = 100
    $buttonShowPassword.Height = 50
    $buttonShowPassword.Location = New-Object System.Drawing.Point(20, 310)
    $buttonShowPassword.BackColor = [System.Drawing.Color]::Black
    $buttonShowPassword.ForeColor = [System.Drawing.Color]::WhiteSmoke
    $buttonShowPassword.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)
    $buttonShowPassword.Add_Click({
        if ($textBoxPassword.PasswordChar -eq '*') {
            $textBoxPassword.PasswordChar = 0
        } else {
            $textBoxPassword.PasswordChar = '*'
        }
    })
    $form.Controls.Add($buttonShowPassword)

    $labelDelay = New-Object System.Windows.Forms.Label
    $labelDelay.Text = 'Timer Delay'
    $labelDelay.Width = 80
    $labelDelay.Height = 40
    $labelDelay.Location = New-Object System.Drawing.Point(166, 48)
    $form.Controls.Add($labelDelay)

    $numericUpDownDelay = New-Object System.Windows.Forms.NumericUpDown
    $numericUpDownDelay.Location = New-Object System.Drawing.Point(114, 45)
    $numericUpDownDelay.Width = 50
    $numericUpDownDelay.Height = 50
    $numericUpDownDelay.DecimalPlaces = 1
    $numericUpDownDelay.Value = 1.3  
    $form.Controls.Add($numericUpDownDelay)

    # чекбокс для переключения между теневым и обычным подключением
    $checkBoxShadow = New-Object System.Windows.Forms.CheckBox
    $checkBoxShadow.Text = 'Shadow Connection'
    $checkBoxShadow.Width = 110
    $checkBoxShadow.Height = 50
    $checkBoxShadow.Checked = $true  # По умолчанию теневое соединение
    $checkBoxShadow.Location = New-Object System.Drawing.Point(20, 30)
    $form.Controls.Add($checkBoxShadow)

    # Обработчик изменения состояния чекбокса
    $checkBoxShadow.Add_CheckedChanged({
        if ($checkBoxShadow.Checked) {
            $buttonConnect.Text = 'Connect (Shadow)'
            $numericUpDownDelay.Value = 1.3
        } else {
            $buttonConnect.Text = 'Connect'
            $numericUpDownDelay.Value = 2.1
        }
    })

    # Кнопка Connect
    $buttonConnect = New-Object System.Windows.Forms.Button
    $buttonConnect.Text = 'Connect'
    $buttonConnect.Location = New-Object System.Drawing.Point(130, 310)  
    $buttonConnect.Width = 100
    $buttonConnect.Height = 50
    $buttonConnect.BackColor = [System.Drawing.Color]::Green
    $buttonConnect.ForeColor = [System.Drawing.Color]::White
    $buttonConnect.Font = New-Object System.Drawing.Font("Arial", 11, [System.Drawing.FontStyle]::Bold)
    $buttonConnect.Add_Click({
        $selectedGroup = $comboBoxGroup.SelectedItem
        $selectedUser = $comboBoxUser.SelectedItem

        if ($selectedGroup -and $selectedUser) {
            $selectedUserConfig = $config | Where-Object { $_.GroupName -eq $selectedGroup } | Select-Object -ExpandProperty Users | Where-Object { $_.Username -eq $selectedUser }

            $username = $selectedUserConfig.Username
            $password = $selectedUserConfig.Password
            $computer = $textBoxComputer.Text

            if ($computer -and $username -and $password) {
                if ($checkBoxShadow.Checked) {
                    
                    Start-Process -FilePath "mstsc.exe" -ArgumentList "/v:$computer /shadow:$SessionID /prompt /control /noConsentPrompt /admin"
                } else {
                    
                    Start-Process -FilePath "mstsc.exe" -ArgumentList "/v:$computer"
                }

                Start-Sleep -Seconds $numericUpDownDelay.Value

                foreach ($char in $username.ToCharArray()) {
                    [System.Windows.Forms.SendKeys]::SendWait($char)
                    Start-Sleep -Milliseconds 20
                }
                
                [System.Windows.Forms.SendKeys]::SendWait("{TAB}")
                Start-Sleep -Milliseconds 150
                
                foreach ($char in $password.ToCharArray()) {
                    [System.Windows.Forms.SendKeys]::SendWait($char)
                    Start-Sleep -Milliseconds 20
                }
                
                Start-Sleep -Milliseconds 400  
                [System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
                
            } else {
                [System.Windows.Forms.MessageBox]::Show("Please fill in all the required fields.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            }
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please select a user group and user before connecting.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    })
    $form.Controls.Add($buttonConnect)

    # Обработчик изменения выбора группы
    $comboBoxGroup.Add_SelectedIndexChanged({
        $selectedGroup = $comboBoxGroup.SelectedItem

        if ($config | Where-Object { $_.GroupName -eq $selectedGroup }) {
            $textBoxComputer.Text = $config | Where-Object { $_.GroupName -eq $selectedGroup } | Select-Object -ExpandProperty Users | Select-Object -First 1 | Select-Object -ExpandProperty ComputerName
        } else {
            $textBoxComputer.Text = ""
        }

        $comboBoxUser.Items.Clear()

        $config | Where-Object { $_.GroupName -eq $selectedGroup } | ForEach-Object {
            $_.Users | ForEach-Object {
                $comboBoxUser.Items.Add($_.Username)
            }
        }
    })

    # Устанавливаем поле для ввода пустым при запуске
    $textBoxComputer.Text = ""

    $comboBoxUser.Add_SelectedIndexChanged({
        $selectedGroup = $comboBoxGroup.SelectedItem.ToString()
        $selectedUser = $comboBoxUser.SelectedItem.ToString()

        $selectedUserConfig = $config | Where-Object { $_.GroupName -eq $selectedGroup } | Select-Object -ExpandProperty Users | Where-Object { $_.Username -eq $selectedUser }
        $textBoxPassword.Text = $selectedUserConfig.Password
    })

    $form.ShowDialog()
}

$scriptPath = $PSScriptRoot
$configPath = Join-Path -Path $scriptPath -ChildPath "config.json"
$config = Get-Content -Path $configPath -Raw -Encoding UTF8 | ConvertFrom-Json

Show-RDPForm -ComputerName $config[0].Users[0].ComputerName -SessionID $config[0].Users[0].SessionID -Username $config[0].Users[0].Username -Password $config[0].Users[0].Password