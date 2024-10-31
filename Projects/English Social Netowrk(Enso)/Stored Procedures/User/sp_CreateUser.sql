
CREATE OR ALTER PROC sp_CreateUser
    @UserID INT,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @DateOfBirth DATE,
    @Gender CHAR(1),
    @Country NVARCHAR(50),
    @Phone CHAR(13),
    @Bio NVARCHAR(255),
    @ProfileImage NVARCHAR(255)
AS
BEGIN
    IF  @UserID IS NULL
	    OR @FirstName IS NULL
        OR LTRIM(RTRIM(@FirstName)) = ''
        OR @LastName IS NULL
        OR LTRIM(RTRIM(@LastName)) = ''
        OR @DateOfBirth IS NULL
        OR @Gender IS NULL
        OR @Country IS NULL
        OR LTRIM(RTRIM(@Country)) = '' 
     BEGIN
    THROW 50003, 'Missing values for some requried fields. Required fields are: @FirstName, @LastName, @DateOfBirth, @Gender, @Country',16
END

IF  @DateOfBirth >= GETDATE()
    OR DATEDIFF(YEAR, @DateOfBirth, GETDATE()) > 100
	 BEGIN
THROW 50004, 'Provided Brith data value is invalid',16
END

IF @Phone IS NOT NULL
    AND LEN(@Phone) <> 13 
	 BEGIN
THROW 50005, 'Provided Pone Number is invalid',16
END

IF @Bio IS NOT NULL 
AND LTRIM(RTRIM(@Bio)) = ''
BEGIN 
   SET @Bio = NULL 
END 

IF @ProfileImage IS NOT NULL 
AND LTRIM(RTRIM(@ProfileImage)) = ''
BEGIN 
   SET @ProfileImage = NULL 
END 


BEGIN TRY 
    INSERT INTO Users
    (UserID, FirstName, LastName , DateOfBirth, Gender, Country, Phone, Bio, ProfileImage)
VALUES
    (@UserID, @FirstName, @LastName , @DateOfBirth, @Gender, @Country, @Phone, @Bio, @ProfileImage)
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
        SELECT 'Unable to Create User. Check ErrorLog for details.' AS ErrorMessage;
        RETURN;
  END CATCH
END 
GO

---
EXEC sp_CreateUserAccount 
    @Username = 'aminamuhmmad7',
    @Email = 'amina7@example.com',
    @PasswordHash = '0E51A8B3C66CE9A8C571B645F1B1234567890ABCDEF1234567890ABCDEF1234';
GO
SELECT @@IDENTITY
EXEC sp_CreateUser
    @UserID = @@IDENTITY,
    @FirstName = 'Amina', 
    @LastName = 'Muhammad', 
    @DateOfBirth = '1985-05-15', 
    @Gender = 'F', 
    @Country = 'USA', 
    @Phone = '1234567890123', 
    @Bio = 'Software Developer', 
    @ProfileImage = 'profile.jpg';
GO 
----

EXEC sp_CreateUser 
    @FirstName = NULL, 
    @LastName = 'Doe', 
    @DateOfBirth = '1985-05-15', 
    @Gender = 'M', 
    @Country = 'USA', 
    @Phone = '+1234567890123', 
    @Bio = 'Software Developer', 
    @ProfileImage = 'profile.jpg';

EXEC sp_CreateUser 
    @FirstName = 'John', 
    @LastName = 'Doe', 
    @DateOfBirth = '2025-05-15', 
    @Gender = 'M', 
    @Country = 'USA', 
    @Phone = '+1234567890123', 
    @Bio = 'Software Developer', 
    @ProfileImage = 'profile.jpg';

EXEC sp_CreateUser 
    @FirstName = 'John', 
    @LastName = 'Doe', 
    @DateOfBirth = '1985-05-15', 
    @Gender = 'M', 
    @Country = 'USA', 
    @Phone = '+12345678901', 
    @Bio = 'Software Developer', 
    @ProfileImage = 'profile.jpg'


;
