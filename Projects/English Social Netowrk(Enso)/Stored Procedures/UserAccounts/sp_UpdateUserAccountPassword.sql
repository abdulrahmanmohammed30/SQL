CREATE OR ALTER PROC sp_UpdateUserAccountPassword
    @UserAccountID INT,
    @PasswordHash CHAR(64)
AS
BEGIN
    SET NOCOUNT ON
    IF  @UserAccountID IS NULL
        OR @PasswordHash IS NULL
        OR LTRIM(RTRIM(@PasswordHash)) = ''
		BEGIN
    THROW 50003, '@UserAccountID and @PasswordHash  are required and cannot be empty.', 16;
END
IF NOT EXISTS(SELECT 1
FROM UserAccounts
WHERE UserAccountID = @UserAccountID)
		BEGIN
THROW 50004, 'UserAccount With provided ID does not exist', 1;
END

IF LEN(@PasswordHash) <> 64 
	  BEGIN
THROW 50005, 'Password is invalid. Provide a valid hashed password', 1;
END
BEGIN TRY 
	   UPDATE UserAccounts
        SET PasswordHash= @PasswordHash
	   WHERE UserAccountID=@UserAccountID
	
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

        -- Return an error message to the caller
        SELECT 'Unable to update User Account password. Check ErrorLog for details.' AS ErrorMessage;
        RETURN;
	END CATCH
END 
GO


EXEC UpdateUserAccountPassword 
    @UserAccountID = 52, 
    @PasswordHash = '1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF';

EXEC UpdateUserAccountPassword 
    @UserAccountID = 999, 
    @PasswordHash = '1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF';

EXEC UpdateUserAccountPassword 
    @UserAccountID = NULL, 
    @PasswordHash = '1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF';

EXEC UpdateUserAccountPassword 
    @UserAccountID = 1, 
    @PasswordHash = NULL;

EXEC UpdateUserAccountPassword 
    @UserAccountID = 1, 
    @PasswordHash = '';

EXEC UpdateUserAccountPassword 
    @UserAccountID = 53, 
    @PasswordHash = '12345';  

