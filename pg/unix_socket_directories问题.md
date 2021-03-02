
### 问题介绍

一个测试环境在装了rpm包的情况下，又编译源码安装了新版本的pg测试其它问题，后来卸载rpm包重新安装后出现一下问题：

	[postgres@sndsdevdb01 data]$ psql
	psql: could not connect to server: No such file or directory
		Is the server running locally and accepting
		connections on Unix domain socket "/tmp/.s.PGSQL.5432"?

而其它同样配置的机器，同样的rpm包安装都没有问题，最总找到是源码编码的残留文件导致，清理后重新安装rpm问题解决

pg rpm 和 源码编译安装 socket 的文件位置不一样，源码编译的 socket 会放到 /tmp 下，rpm包安装的默认放在 /var/run/postgresql 和 /tmp 两处。


### 清理pg

不同的环境安装目录可能不同，根据实际情况自行修改

	yum remove postgresql*
	yum remove timescaledb*
	yum remove snpgsql*
	
	rm -rf /usr/pgsql/*
