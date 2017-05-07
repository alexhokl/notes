##### Shortcuts

- [Windows 10 Shortcuts](http://www.hanselman.com/blog/CollectingWindows10AnniversaryEditionKeyboardShortcuts.aspx)

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
