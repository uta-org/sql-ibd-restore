Start-Process "c:\xampp\mysql\bin\mysqld.exe" "--defaults-file=`"c:\xampp\mysql\bin\my.ini`" --standalone" -NoNewWindow -Wait -RedirectStandardOutput "mysql_out.log" -RedirectStandardError "mysql_err.log"
exit