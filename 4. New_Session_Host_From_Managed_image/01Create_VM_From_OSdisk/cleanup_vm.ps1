# Stop and disable BitLocker service
Stop-Service -Name BDESVC -Force
Set-Service -Name BDESVC -StartupType Disabled

# Uninstall Remote Desktop Services and related agents
Get-WmiObject -Class Win32_Product |
    Where-Object { $_.Name -match 'Remote Desktop Services|Remote Desktop Agent Boot Loader' } |
    ForEach-Object { $_.Uninstall() }

# Wait a few seconds to ensure uninstalls finish
Start-Sleep -Seconds 30

# Restart the VM
Restart-Computer -Force
