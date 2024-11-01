CREATE OR ALTER PROC sp_GetUserAccounts
AS
BEGIN
    SET NOCOUNT ON
BEGIN TRY 
      SELECT * FROM UserAccounts 
   END TRY 
   BEGIN CATCH 
     INSERT INTO dbo.ErrorLogs
    (
    ErrorNumber,
    ErrorSeverity,
    ErrorState,
    ErrorProcedure,
    ErrorLine,
    ErrorMessage,
    ErrorTime
    )
VALUES
    (
        ERROR_NUMBER(),
        ERROR_SEVERITY(),
        ERROR_STATE(),
        ERROR_PROCEDURE(),
        ERROR_LINE(),
        ERROR_MESSAGE(),
        GETDATE()
        );

        SELECT 'Unable to GET UserAccounts. Check ErrorLog for details.' AS ErrorMessage;
        RETURN;
   END CATCH
END 
GO 

EXEC sp_GetUserAccounts;
EXEC sp_rename 'UserAccounts', 'UserAccountsTemp';
EXEC sp_GetUserAccountByID @UserAccountID = 1;
-- Rename the table back to restore functionality
EXEC sp_rename 'UserAccountsTemp', 'UserAccounts';
