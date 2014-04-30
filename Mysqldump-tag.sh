#!/bin/sh
DB=""
HOST=""
printhelp() {

echo "

Usage: sh mysql.sh [OPTION]...
  -db,    --database   The database name which you need to take the backup
		       
  -host, --hostname    The hostname

  -h, --help           Display help file

"

}
while [ "$1" != "" ]; do
  case "$1" in
    -db   | --database )        DB=$2; shift 2 ;;
    -host | --hostname )        HOST=$2; shift 2 ;;
    -h    | --help )	        echo "$(printhelp)"; exit; shift; break ;;
  esac
done

#### BEGIN CONFIGURATION ####
NOWDATE=`date +%Y-%m-%d`
LASTDATE=$(date +%Y-%m-%d --date='1 week ago')

# set dump directory variables
SRCDIR='/tmp/s3backups'
DESTDIR='test'
BUCKET='mysqlbackup'

# database access details
USER='root'


#### END CONFIGURATION ####

# make the temp directory if it doesn't exist and cd into it
mkdir -p $SRCDIR
cd $SRCDIR

# dump the selected sql file and upload it to s3
mysqldump -h$HOST -u$USER --single-transaction $DB > $DB.sql
tar -czPf $DB.tar.gz $DB.sql
mv $DB.tar.gz $NOWDATE-$DB.tar.gz
/usr/bin/s3cmd put $SRCDIR/$NOWDATE-$DB.tar.gz s3://$BUCKET/$DESTDIR/ 

# delete old backups from s3
/usr/bin/s3cmd del --recursive s3://$BUCKET/$DESTDIR/$LASTDATE-$DB.tar.gz

# remove all files in our source directory
cd
rm -rf $SRCDIR/*

