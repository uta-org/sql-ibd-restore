#!/bin/bash

# THIS MUST BE EXECUTED ON WSL.

if [ ! -d "/mnt/c/xampp/" ]; then
	echo "XAMPP ISN'T INSTALLED! PLEASE INSTALL IT!"
	exit
fi

source vars.sh
echo "Using IP: '$IP'"
echo "Using Port: '$PORT'"

scp -P $PORT generate_sql_dump.sh root@$IP:~
ssh -p $PORT root@$IP 'bash ~/generate_sql_dump.sh > db_dump.sql; exit'
echo "Waiting 5 seconds..."
scp -P $PORT root@$IP:~/db_dump.sql ./db_dump.sql
scp -P $PORT root@$IP:~/db_discard.sql ./db_discard.sql
scp -P $PORT root@$IP:~/db_import.sql ./db_import.sql

if [ ! -d mysql ]; then
	# mkdir mysql
	scp -r -P $PORT root@$IP:/var/lib/mysql ./
fi

echo "Creating databases and discarding tablespaces..."
powershell.exe -File "import.ps1" -Wait

exit

echo "Stopping MySQL..."
powershell.exe -File "shutdown-mysqld.ps1" -Wait

cd mysql
shopt -s globstar
for i in **/*.ibd; do
    dir=$(dirname "$i")
    file=$(basename "$i")
    xamppdir="/mnt/c/xampp/mysql/data/$dir"
    xamppfile="$xamppdir/$file"

    if [ ! -e ../dbs.txt ] || grep -Fxq "$dir" ../dbs.txt; then
	    if [ -d "$xamppdir" ]; then
	    	cp -v "$i" "$xamppfile"
	    fi
    fi
done

cd ..

echo "Starting MySQL..."
powershell.exe -File "start-mysqld.ps1" -Wait

echo "Importing tablespaces from new copied files and dumping all databses..."
powershell.exe -File "import_tablespaces.ps1" -Wait