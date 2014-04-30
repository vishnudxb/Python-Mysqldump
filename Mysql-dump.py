#!/usr/bin/env python


# 1. Import
from time import strftime
import subprocess
import ConfigParser
import sys, os
import MySQLdb

# if not root...kick out
if not os.geteuid()==0:
    sys.exit("\nOnly root can run this script\n")


# 2. Config
config = ConfigParser.ConfigParser()
config.read(os.path.expanduser('~/.my.cnf'))
username = config.get('client', 'user')
password = config.get('client', 'password')
hostname = config.get('client', 'host')

#Delete database and create it

DBHOST = "staging-dbhostname"
con = MySQLdb.connect(host=DBHOST,read_default_file='~/.my.cnf')
cur = con.cursor()
print strftime("%Y-%m-%d-%H:%M:%S") + ": Process start to Delete database staging_database_name"
cur.execute('DROP DATABASE staging_database_name;')
print strftime("%Y-%m-%d-%H:%M:%S") + ": Process start to Create database staging_database_name"
cur.execute('CREATE DATABASE staging_database_name;')

# 4. Process
print strftime("%Y-%m-%d-%H:%M:%S") + ": Mysqldump started"
#Enter your Live and staging dbhost,databasename 
os.system("mysqldump -h live-dbhostname --no-data live_database_name | mysql -h staging-dbhostname  staging_database_name")
#If you want ignore any tables from live when you take the dump to staging
os.system("mysqldump -h live-dbhostname --single-transaction --ignore-table=live_database.live-table-name1 --ignore-table=live_database.live-table-name2  live_database_name | mysql -h staging-dbhostname staging_databse_name")
#If you want to sanitize
os.system("mysql -h staging-dbhostname staging_databse_name < /home/vishnu/live-database-sanitizer.sql")
print strftime("%Y-%m-%d-%H-%M-%S") + ": Mysqldump finished"

