

### 回归测试

#### rhel6（暂未成功）

1. postgis 会使用当前已存在的数据库cluster
2. 需要手动修改 pg_ha 把它创建的数据库 postgis_reg 加进去
3. 创建 postgis_reg 的是时候需要交互的输入 postgres 用户密码

#

	-- postgis
	yum install libtool
	yum install automake
	yum install autoconf
	yum install libxml2-devel
	
	--yum install gcc-c++.x86_64
	
	./autogen.sh
	
	./configure --with-geosconfig=/usr/geos36/bin/geos-config  --with-projdir=/usr/proj49/ --without-raster --with-protobuf-c
	
	# 修改 pg_hba.conf
	local	postgis_reg	       postgres 			trust
