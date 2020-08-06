# Databases Installation in Docker

### Oracle

https://github.com/oracle/docker-images

    # create image
    ./buildDockerImage.sh -v 19.3.0 -e

    docker run --name ora-19.3-ee -p 1521:1521 -p 5500:5500 -e ORACLE_SID=oracle -e ORACLE_PDB=test1 -e ORACLE_PWD=MyDBPwd -e ORACLE_CHARACTERSET=AL32UTF8 oracle/database:19.3.0-ee

### PostgreSQL

https://hub.docker.com/_/postgres

    docker pull postgres
    docker run --name postgres-dev -p 5432:5432 -e POSTGRES_PASSWORD=mysecretpassword -d postgres

### MySQL

https://hub.docker.com/_/mysql

    docker pull mysql
    docker run --name mysql-dev -p 3306:3306 -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:latest

### MSSQL

https://hub.docker.com/_/microsoft-mssql-server

    docker pull mcr.microsoft.com/mssql/server:2017-latest

    docker run --name mssql-2017-dev -p 1433:1433 -e 'ACCEPT_EULA=Y' -e 'SSQL_PID=Developer' -e 'MSSQL_AGENT_ENABLED=True' -e 'SA_PASSWORD=yourStrong(!)Password' -d mcr.microsoft.com/mssql/server:2017-latest


### Docker commands

    docker container ls -a
    docker container start ora-19.3-ee
    docker container stop ora-19.3-ee
    docker exec -it ora-19.3-ee /bin/bash
