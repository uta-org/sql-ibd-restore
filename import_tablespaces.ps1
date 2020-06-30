Start-Process mysql -ArgumentList "-uroot", "-e `"source db_import.sql;`"" -Wait -RedirectStandardOutput "import_out.log" -RedirectStandardError "import_err.log"
Start-Process mysqldump -ArgumentList "--user=root --all-databases --result-file=output.sql" -Wait -RedirectStandardOutput "dump_out.log" -RedirectStandardError "dump_err.log"
exit