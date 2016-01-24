delete from mysql.user where User='' or Password='';
update mysql.user set Password='pippo' where user='root';
GRANT ALL PRIVILEGES ON wp_project.* TO 'wp_user'@'%' IDENTIFIED BY PASSWORD 'Gow3H3JA';
flush privileges;
