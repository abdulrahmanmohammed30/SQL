CREATE OR ALTER PROC sp_CreateUserAccount
    @Username VARCHAR(255),
    @Email VARCHAR(255),
    @PasswordHash CHAR(64)
AS
BEGIN
    SET NOCOUNT ON

    IF  @Username IS NULL
        OR LTRIM(RTRIM(@Username)) = ''
        OR @Email IS NULL
        OR LTRIM(RTRIM(@Email)) = ''
        OR @PasswordHash IS NULL
        OR LTRIM(RTRIM(@PasswordHash)) = ''
		    THROW 50003, 'All Parameters are required and cannot be empty.', 16;

    BEGIN TRY 
    
      INSERT INTO UserAccounts
        (Username, Email, PasswordHash)
    VALUES(@Username, @Email, @PasswordHash);
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
            getdate()
        );
		SELECT 'Unable to insert User Account record. Check ErrorLog for details.' AS ErrorMessage;
		        RETURN;
END CATCH
END
GO 