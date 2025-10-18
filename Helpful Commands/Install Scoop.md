

Open a PowerShell terminal (version 5.1 or later) and from the PS C:\> prompt, run:

```Powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```