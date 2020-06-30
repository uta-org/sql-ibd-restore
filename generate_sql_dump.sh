#!/bin/bash
cd ~

# YOU CAN CREATE A dbs.txt FILE IN ORDER TO FILTER WHICH FOLDERS TO PROCESS.
# DO: ls /var/lib/mysql > dbs.txt AND REMOVE THE FOLDERS AND FILES THAT YOU WON'T USE.

if [ ! -f dbsake ]; then
	curl -s http://get.dbsake.net > dbsake
	chmod u+x dbsake
fi

cd /var/lib/mysql
echo "" > ~/db_discard.sql
echo "" > ~/db_import.sql

shopt -s globstar
current_dir=""
for i in **/*.frm; do
    dir=$(dirname "$i")
    file=$(basename "$i")

    if [ ! -e ~/dbs.txt ] || grep -Fxq "$dir" ~/dbs.txt; then
	    dbname="${dir//\@002d/-}"
        if [ "$current_dir" != "$dir" ]; then
            echo ""
            echo "CREATE DATABASE \`$dbname\`;"
            echo "USE \`$dbname\`;"
            echo ""
	    fi

        sql=$(~/dbsake frmdump "$i")
        echo "${sql/;/ ROW_FORMAT=compact;}"

        tablename="${file/.frm/}"
        echo "ALTER TABLE \`$dbname\`.\`$tablename\` DISCARD TABLESPACE;" >> ~/db_discard.sql
    	echo "ALTER TABLE \`$dbname\`.\`$tablename\` IMPORT TABLESPACE;" >> ~/db_import.sql

        current_dir="$dir"
    fi
done