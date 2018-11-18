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
