#!/bin/bash

FILE=$HOME/.my.cnf

echo "Remember this script must be run as root"
#Check if the user is root or not
if [ "$(whoami)" == "root" ] && [ -f $FILE ];  then
	mysql -h staging-dbhost -e 'drop database staging_database;'
	mysql -h staging-dbhost -e 'create database staging_database;'
	mysqldump -h live-dbhost --no-data live_database | mysql -h staging-dbhost staging_database
    mysqldump -h live-dbhost --single-transaction --ignore-table=live_database.live_table_name1 --ignore-table=live_databse.live_table_name2 \
      --ignore-table=live_database.live_table_name3 live_databse | mysql -h staging-dbhost staging_database
	mysql -h staging-dbhost staging_database < /home/vishnu/dev-dump-sanitizer.sql
else
	echo "You are NOT root, please run as root!"
fi
