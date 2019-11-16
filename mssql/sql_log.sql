-- listening port
EXEC xp_ReadErrorLog 0, 1, N'Server is listening on', N'any', NULL, NULL, 'DESC'
GO

-- error logs
EXEC sp_readerrorlog 0, 1;
EXEC sp_readerrorlog 0, 2;
