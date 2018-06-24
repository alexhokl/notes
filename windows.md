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

### Powershell

##### IIS Administration

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

##### Adding features

Examples

```console
Add-WindowsFeature Web-Server
Add-WindowsFeature NET-Framework-45-ASPNET
Add-WindowsFeature Web-Asp-Net45
```

##### Windows 10

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
