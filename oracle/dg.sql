alter database set standby database to maximize performance;
alter database set standby database to maximize availability;
alter database set standby database to maximize protection;

alter database recover managed standby database using current logfile disconnect;
alter database recover managed standby database cancel;
