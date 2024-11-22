SET XACT_ABORT ON 

BEGIN TRAN
BEGIN TRY 
	 SELECT 1  as Column1
	 SELECT 1 / 0 as Column2
	 SELECT 5 
	COMMIT 
	SELECT 'Transaction Executed Successfully' as 'Notification'
END TRY 
BEGIN CATCH 
    ROLLBACK 
  SELECT 'Transaction failed' as ErrorMessage
END CATCH 

