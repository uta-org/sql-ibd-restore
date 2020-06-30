Start-Process mysql -ArgumentList "-uroot", "-e `"source db_dump.sql;`"" -Wait -RedirectStandardOutput "dump_out.log" -RedirectStandardError "dump_err.log"
Start-Process mysql -ArgumentList "-uroot", "-e `"source db_discard.sql;`"" -Wait -RedirectStandardOutput "discard_out.log" -RedirectStandardError "discard_err.log"
exit