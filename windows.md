    + [Chocolatey](#chocolatey)
- [Powershell](#powershell)
    + [Basics](#basics)
    + [IIS Administration](#iis-administration)
    + [IIS ASP.NET Administration](#iis-aspnet-administration)
    + [IIS FTP Administration](#iis-ftp-administration)
    + [Windows 10](#windows-10)
____

##### Shortcuts

- [Windows 10 Shortcuts](http://www.hanselman.com/blog/CollectingWindows10AnniversaryEditionKeyboardShortcuts.aspx)
- [Keyboard shortcuts for Windows](https://support.microsoft.com/en-gb/help/126449/keyboard-shortcuts-for-windows)

##### Commands

- [Windows CMD Commands](https://ss64.com/nt/)

##### To install a service on Windows Server

```bat
C:\Windows\Microsoft.NET\Framework64\v4.0.30319>InstallUtil.exe D:\Alex.Scheduler.exe
```

##### To check version of Windows
```bat
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
```

#### To loop through files [documentation](https://technet.microsoft.com/zh-tw/library/cc753551.aspx)

##### To delete log files more than 30 days old

```cmd
forfiles /p D:\Logs\IISLogs /s /m *.log /d –30 /c "cmd /c delete @path"
```

##### To list files with relative paths

```bat
forfiles /p D:\ParentPath /s /c "cmd /c echo @relpath"
```

### Chocolatey

To list installed packages

```console
choco list --localonly
```

# Powershell

### Basics

##### Show examples of a command

```ps1
Get-Help -Example dir
```

##### Look for a command with certain wording

```ps1
Get-Command "-website*
```

##### Get members (or properties, in .NET terms) of a command

```ps1
Get-Member -Input-Object(Get-Date)
```

##### Accessing a NET property

```ps1
[DateTime]::UtcNow
```

##### Piping

```ps1
ls main -Recurse -Include bin | rmdir -Recurse -Force
```

##### To dump all file paths in specified directory

```ps1
Get-ChildItem -Path C:\ -Recurse -Directory -Force -ErrorAction SilentlyContinue | Select-Object FullName
```

### IIS Administration

Make sure the helper module is install (this enables more useful commands)

```console
Import-Module WebAdministration
```

To create an application pool

```console
New-WebAppPool -name "NewWebSiteAppPool" -force
$appPool = Get-Item -name "NewWebSiteAppPool"
$appPool.processModel.identityType = "NetworkService"
$appPool.enable32BitAppOnWin64 = 0
$appPool | Set-Item
```

To create a web site (assuming an application pool is created)

```console
mkdir "c:\Web Sites\NewWebSite"
$site = $site = new-WebSite -name "NewWebSite"
                            -PhysicalPath "c:\Web Sites\NewWebSite"
                            -HostHeader "app.example.com"
                            -ApplicationPool "NewWebSiteAppPool"
                            -force
```

To check state of a web site

```console
Get-Website -Name "My Web Site Name"
```

To Download a file

```console
Invoke-WebRequest "https://example.com/file.txt" -OutFile "output.txt -UseBasicParsing
```

### IIS ASP.NET Administration

##### To enable IIS preloadEnabled and AlwaysRunning

```ps1
$siteName = "MyWebSite"
$webAppInit = Get-WindowsFeature -Name "Web-AppInit"
Install-WindowsFeature $webAppInit -ErrorAction Stop
$site = Get-Website -Name $siteName
$appPool = Get-ChildItem IIS:\AppPools\ | Where-Object { $_.Name -eq $site.applicationPool }
$appPool | Set-ItemProperty -name "startMode" -Value "AlwaysRunning"
Set-ItemProperty "IIS:\Sites\$siteName" -Name applicationDefaults.preloadEnabled -Value True
```

### IIS FTP Administration

##### To create a SSL certificate for FTP server

```ps1
New-SelfSignedCertificate -certstorelocation cert:\localmachine\mycertname -dnsname ftp.example.com
# you get a fingerprint: 40CHARLONGFINGERPRINT0000001123234AAAAAA
$yourpwd = ConvertTo-SecureString -String "YourStrongPassword" -Force -AsPlainText
Export-PfxCertificate -cert cert:\localMachine\mycertname\40CHARLONGFINGERPRINT0000001123234AAAAAA -FilePath c:\temp\cert.pfx -Password $yourpwd
```

##### Adding features

Examples

```console
Add-WindowsFeature Web-Server
Add-WindowsFeature NET-Framework-45-ASPNET
Add-WindowsFeature Web-Asp-Net45
```

### Windows 10

###### To list available features

```console
Get-WindowsOptionalFeature -Online
```

###### To check if a feature is installed

```console
Get-WindowsOptionalFeature -Online | where {$_.state -eq "Enabled"} | ft -Property A-Feature-Name
```

###### To check if a feature is not installed

```console
Get-WindowsOptionalFeature -Online | where {$_.state -eq "Disabled"} | ft -Property A-Feature-Name
```

###### To enable a Windows feature

```console
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpCompressionStatic
```

###### To disable a Windows feature

```console
Disable-WindowsOptionalFeature -Online -FeatureName IIS-DirectoryBrowsing
```

###### To list installed applications

```console
Get-AppxPackage | Select Name, PackageFullName
```

###### To remove an application

```console
Get-AppxPackage Microsoft.Print3D | Remove-AppxPackage
```

###### To enable administrator account, in a command prompt with administrative privileges

```console
net user Administrator /active:yes
net user Administrator [Password] /active:yes
```

and replace `[Password]` with a secure password.


###### To dump a list of applications installed,

```sh
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table –AutoSize
```

###### To compare two list dumped by Powershell

```sh
Compare-Object -ReferenceObject (Get-Content listA.txt) -DifferenceObject (Get-Content listB.txt)
```

# Troubleshooting

## Bootloader

In case of the corrupted master boot record (MBR) or Windows Bootloader, one
may see the following error message.

```console
The Boot Configuration Data file is missing some required information
File: \BCD
Error code: 0xc0000034
```

The solution is to use a boot-able USB Windows installer (Windows 10 installer
can be used to repair Windows 8.1 installlation) and boot the machine with the
USB. Select `repair` instead of install option. Try to find option `Command
Prompt` (and it may be hidden in advanced options/tools) and select it. In the
command prompt execute the following commands.

```cmd
bootrec /RebuildBcd
bootrec /fixMbr
bootrec /fixboot
exit
```

Remove the USB drive and the MBR or bootloader should have been fixed by this
time.
