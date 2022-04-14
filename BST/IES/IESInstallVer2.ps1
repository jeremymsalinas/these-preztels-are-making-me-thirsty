

If(Test-Path -Path "$env:ProgramData\Chocolatey") {
	choco install logmein.client --params="'/DEPLOYID= /INSTALLMETHOD=5 /FQDNDESC=1'"
	choco install eset-antivirus --params="'/ACTIVATION_DATA=key: /PRODUCT_LANG=1033 /PRODUCT_LANG_CODE=en-us'"
	choco install duo-authentication --params="'/IKEY=key /SKEY=key /HOST=api.duosecurity.com /AUTOPUSH=#1 /FAILOPEN=#1 /SMARTCARD=#0 /RDPONLY=#0'"
	choco install adobereader filezilla 7zip notepadplusplus cutepdf vlc foxitreader microsoft-office-deployment -y
	}
Else {
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
	refreshenv
	choco install logmein.client --params="'/DEPLOYID=00_1jjwrmcrj2bxoad7hqncbdkuy961ctczd1ua3 /INSTALLMETHOD=5 /FQDNDESC=1'"
	choco install eset-antivirus --params="'/ACTIVATION_DATA=key: /PRODUCT_LANG=1033 /PRODUCT_LANG_CODE=en-us'"
	choco install duo-authentication --params="'/IKEY=key /SKEY=key /HOST=api.duosecurity.com /AUTOPUSH=#1 /FAILOPEN=#1 /SMARTCARD=#0 /RDPONLY=#0'"
	choco install adobereader filezilla 7zip notepadplusplus cutepdf vlc foxitreader microsoft-office-deployment -y
    }

# Set local admin password to never expire
Set-LocalUser -Name "bst.tech" -PasswordNeverExpires 1

# ComputerName Variables
$string1 = "naming convention"
$string2 = Get-WmiObject win32_bios | Select-Object -Expand Serialnumber | Out-String
$computerName = $string1 + $string2.Trim()
Rename-Computer -NewName $computerName

#Install Cisco anyconnect
Start-Process -Wait msiexec -ArgumentList "/package","anyconnect-win-4.10.01075-core-vpn-predeploy-k9.msi","/norestart","/passive","/lvx*","vpninstall.log" -PassThru

# Set lid close to do nothing on ac power
powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0

# Disable IPv6 on WiFi adapter
Disable-NetAdapterBinding -InterfaceAlias "Wi-Fi" -ComponentID ms_tcpip6

