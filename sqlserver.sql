# 外部表视图
SELECT * FROM sys.external_data_sources;
SELECT * FROM sys.external_file_formats;
SELECT * FROM sys.external_tables;

# 查看表是否是外部表
SELECT name, type, is_external FROM sys.tables WHERE name='myTableName';
