#Create Sysprep task and reboot
$action = New-ScheduledTaskAction -Execute 'C:\Windows\System32\Sysprep\Sysprep.exe' -Argument '/oobe /generalize /shutdown /quiet'
$trigger = New-ScheduledTaskTrigger -AtStartup -RandomDelay 00:03:00
$principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName 'RunSysprepAfterReboot' -Action $action -Trigger $trigger -Principal $principal -Force
Write-Output 'Scheduled task created, rebooting...'
Restart-Computer -Force
