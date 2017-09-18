<#
 Script: MyFresh UPD Printers Fix.ps1

 PowerShell Script to remove bad printer
 registry values from user profiles inside
 User profile disks.

 By Mat Clarke & Jim Wallace (K3 Starcom)

 Version: 0.9 (testing required)

#>

$StartingDIR = Get-Location

Set-Location -Path 'D:\RDSProfileDisks'

#Loop around any UPD files
Get-ChildItem -Path *.vhdx | ForEach-Object {

$VHDPath = $_.FullName
$VHDShortName = $_.Name

Write-Host
Write-Host Mounting $VHDPath -ForegroundColor Yellow
$MountResult = Mount-DiskImage -ImagePath $VHDPath -StorageType VHDX 
$DriveLetter=(Get-Partition -DiskNumber (DiskImage $VHDPath).Number).Driveletter

$UserSID=$VHDShortname.TrimEnd(".vhdx")
$UserSID=$UserSID.TrimStart("UVHD-")

$RegLocation = $DriveLetter + ":\NTUSER.dat"

# Abort this iteration if NTUSER.dat doesn't exist
If (!(Test-Path $RegLocation)) {
	Write-Host 
	Write-Host "$UserSID Registry Modification not required as no NTUSER.DAT found. Unmounting $VHDPath" -ForegroundColor Yellow
	Dismount-DiskImage $VHDPath
	return
}

$Result = New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
Write-Host "Loading Registry Hive for $UserSID to HKU\TempUser" -ForegroundColor Yellow
reg load HKU\TempUser $RegLocation

    <#
    **************************************************************************************************************************************** 
    delete \Software\Microsoft\Windows NT\CurrentVersion\Devices - Delete all the entries on the right plane except XPS Document writer
    ****************************************************************************************************************************************
    #>
$RegPath = "HKU:\TempUser\Software\Microsoft\Windows NT\CurrentVersion\Devices"
$ExcludeItems = @("Send To OneNote 16","Microsoft XPS Document Writer","CutePDF Writer")

$arrayItem = Get-Item -Path $RegPath | Select-Object -ExpandProperty Property
$CompareList = $arrayItem.Split(",")
Foreach ($CompareItem in $CompareList)
{
if ($ExcludeItems -Match ([RegEx]::Escape($CompareItem))) 
    {
    Write-Host "$RegPath\$CompareItem Excluded ... not deleted" -ForegroundColor Cyan
    }
else
   {
   Write-Host "Remove-ItemProperty -Path $RegPath -Name $CompareItem"
   Remove-ItemProperty -Path $RegPath -Name $CompareItem
   }
}

    <# 
    ****************************************************************************************************************************************
    delete \Software\Microsoft\Windows NT\CurrentVersion\PrinterPorts - Delete all the entries on the right plane except XPS Document writer
    ****************************************************************************************************************************************
    #>
$RegPath = "HKU:\TempUser\Software\Microsoft\Windows NT\CurrentVersion\PrinterPorts"
$ExcludeItems = @("Send To OneNote 16","Microsoft XPS Document Writer","CutePDF Writer")

$arrayItem = Get-Item -Path $RegPath | Select-Object -ExpandProperty Property
$CompareList = $arrayItem.Split(",")
Foreach ($CompareItem in $CompareList)
{
if ($ExcludeItems -Match ([RegEx]::Escape($CompareItem))) 
    {
    Write-Host "$RegPath\$CompareItem Excluded ... not deleted" -ForegroundColor Cyan
    }
else
   {
   Write-Host "Remove-ItemProperty -Path $RegPath -Name $CompareItem"
   Remove-ItemProperty -Path $RegPath -Name $CompareItem
   }
}

    <# 
    ****************************************************************************************************************************************
    delete \Printers\Connections ... All the Sub Keys
    ****************************************************************************************************************************************
    #>
$RegPath = "HKU:\TempUser\Printers\Connections"
$arrayItem = @()
$arrayItem = Get-ChildItem -Path $RegPath
if ($arrayItem.Count -gt 0) {
    $arrayItem.Handle.Close()
    Foreach ($namedItem in $arrayItem) {
        $RegItem = $namedItem.PSChildName
        Write-Host "Remove-Item -Path $RegPath\$RegItem"
        Remove-Item -Path $RegPath\$RegItem
    }
}

    <#
    ****************************************************************************************************************************************
    Tidyup
    ****************************************************************************************************************************************
    #>
Write-Host 
Write-Host "$UserSID Registry Modification Complete. Unloading Registry Hive and Disk Image" -ForegroundColor Yellow
[gc]::collect()
Remove-PSDrive -Name HKU
reg unload HKU\TempUser
Dismount-DiskImage $VHDPath
}

Set-Location -Path $StartingDIR