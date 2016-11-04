##### To install a service on Windows Server
```bat
C:\Windows\Microsoft.NET\Framework64\v4.0.30319>InstallUtil.exe D:\Alex.Scheduler.exe
```

#### To loop through files [documentation](https://technet.microsoft.com/zh-tw/library/cc753551(v=ws.10).aspx)

##### To delete log files more than 30 days old
```cmd
forfiles /p D:\Logs\IISLogs /s /m *.log /d –30 /c "cmd /c delete @path"
```

##### To list files with relative paths
```bat
forfiles /p D:\ParentPath /s /c "cmd /c echo @relpath"
```
