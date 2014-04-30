#Mysql dump from One server to the Other directly 

*This Script is used to update the staging database from the Live ones.*

*From Linux CLI we can do it with one command*

  ```
mysqldump -u root -pPASSWORD --all-databases | ssh USER@NEW.HOST.COM 'cat - | mysql -u root -pPASSWORD'

  ```
#Mysqldump-tag.sh
*This script is used to  take mysql backup to Amazon S3. In this script we can pass parameter like database and dbhost*

	
  ```
./Mysqldump-tag.sh -db database-name -h dbhost

  ```
