$script = Get-Childitem -Path C:\Users\ -Include wipeComputer.ps1 -File -Recurse -ErrorAction SilentlyContinue
If(Test-Path -Path C:\Installs){
	Copy-Item $script C:\Installs\
}
Else{
	Write-Host "Creating C:\Installs"
	try {
		mkdir C:\Installs
		Copy-Item $scrtipt C:\Installs\
	}
	catch {
		Write-Error "Whoops. Something's not right. Some items may be missing."
	}

}


$taskname = "Wipe PC"

$taskdescription = "Factory Wipe PC"

$action = New-ScheduledTaskAction -Execute 'Powershell.exe' `
	-Argument '-NoProfile -WindowStyle Hidden -File "C:\Installs\wipeComputer.ps1"'

$trigger =  New-ScheduledTaskTrigger -AtStartup -RandomDelay (New-TimeSpan -Minutes 5)

$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit `
    	(New-TimeSpan -Minutes 60) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)

Register-ScheduledTask -Action $action -TaskName $taskname `
    	-Description $taskdescription -Settings $settings -User "System"

Start-Sleep 4

shutdown /r
