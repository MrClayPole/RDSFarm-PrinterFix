<#
 Script: MyFresh RDS Printers Fix.ps1

 PowerShell Script to remove bad printer
 registry values from RDS Servers
 local registry

 By Mat Clarke & Jim Wallace (K3 Starcom)

 Version: 0.8 (testing required)

#>
Write-Host "Removing HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM" -ForegroundColor Yellow
Remove-Item -path "HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM" -Recurse -Force

Write-Host "Adding HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM" -ForegroundColor Yellow
New-Item -path "HKLM:\SYSTEM\CurrentControlSet\Enum\SWD\PRINTENUM"

Write-Host "Removing HKLM:\SYSTEM\CurrentControlSet\Control\DeviceClasses\{0ecef634-6ef0-472a-8085-5ad023ecbccd}" -ForegroundColor Yellow
Remove-Item -path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceClasses\{0ecef634-6ef0-472a-8085-5ad023ecbccd}" -Recurse -Force

Write-Host "Adding HKLM:\SYSTEM\CurrentControlSet\Control\DeviceClasses\{0ecef634-6ef0-472a-8085-5ad023ecbccd}" -ForegroundColor Yellow
New-Item -path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceClasses\{0ecef634-6ef0-472a-8085-5ad023ecbccd}"

Write-Host "Removing HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider" -ForegroundColor Yellow
Remove-Item -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider" -Recurse -Force

Write-Host "Adding HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider" -ForegroundColor Yellow
New-Item -path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Print\Providers\Client Side Rendering Print Provider"