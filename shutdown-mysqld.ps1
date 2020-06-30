Get-Process | Where-Object {$_.Path -like "*mysqld*"} | Stop-Process -Force -processname {$_.ProcessName}
exit