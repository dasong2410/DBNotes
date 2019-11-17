define db_ip=192.168.56.201
define db_usr=nbpf
define db_passwd=nbpf
define db_sid=ora11g

create database link dblink_nbpf
connect to &db_usr identified by &db_passwd
using '(description=(address=(protocol=TCP) (host=&db_ip)(port=1521))(connect_data=(sid=&db_sid)))';
