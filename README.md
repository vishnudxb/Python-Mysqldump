#Mysql dump from One server to the Other directly 

*This Script is used to update the staging database from the Live ones.*

*From Linux CLI we can do it with one command*

  ```
mysqldump -u root -pPASSWORD --all-databases | ssh USER@NEW.HOST.COM 'cat - | mysql -u root -pPASSWORD'

  ```

