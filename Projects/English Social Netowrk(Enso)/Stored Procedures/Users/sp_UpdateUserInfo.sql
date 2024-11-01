CREATE FUNCTION dbo.ValidateText (@Text VARCHAR(255))
RETURNS BIT
AS
BEGIN
	DECLARE @IsvalidText BIT = 1

	IF @Text IS NULL
		OR LTRIM(RTRIM(@Text)) = ''
		SET @IsvalidText = 0

	RETURN @IsvalidText
END
GO

CREATE
	OR
ALTER PROC sp_UpdateUserInfo @UserID INT
	,@FirstName NVARCHAR(50)=NULL
	,@LastName NVARCHAR(50)=NULL
	,@DateOfBirth DATE=NULL
	,@Gender CHAR(1)=NULL
	,@Country NVARCHAR(50)=NULL
	,@Phone CHAR(13)=NULL
	,@Bio NVARCHAR(255)=NULL
	,@ProfileImage NVARCHAR(255)=NULL
AS
BEGIN
    SET NOCOUNT ON 
	IF @UserID IS NULL THROW 50005
		,'Could not update User Info. User ID was missing.'
		,16
		IF NOT EXISTS (
				SELECT 1
				FROM Users
				WHERE UserID = @UserID
				) THROW 50006
			,'No User With Provided ID EXISTS'
			,16
		BEGIN TRY
			UPDATE Users
			SET FirstName = CASE 
					WHEN dbo.ValidateText(@FirstName) = 1
						THEN @FirstName
					ELSE FirstName
					END
				,LastName = CASE 
					WHEN dbo.ValidateText(@LastName) = 1
						THEN @LastName
					ELSE LastName
					END
				,DateOfBirth = CASE 
					WHEN @DateOfBirth IS NOT NULL
					    AND @DateOfBirth < GETDATE()
						AND DATEDIFF(YEAR, @DateOfBirth, GETDATE()) < 100
						THEN @DateOfBirth
					ELSE DateOfBirth
					END
				,Gender = CASE 
					WHEN @Gender IS NOT NULL
						AND @Gender IN (
							'M'
							,'F'
							)
						THEN @Gender
					ELSE Gender
					END
				,Country = CASE 
					WHEN dbo.ValidateText(@Country) = 1
						THEN @Country
					ELSE Country
					END
				,Phone = CASE 
					WHEN @Phone IS NOT NULL AND LEN(RTRIM(LTRIM(@Phone))) = 13
						THEN @Phone
					ELSE Phone
					END
				,Bio = CASE 
					WHEN dbo.ValidateText(@Bio) = 1
						THEN @Bio
					ELSE Bio
					END
				,ProfileImage = CASE 
					WHEN dbo.ValidateText(@ProfileImage) = 1
						THEN @ProfileImage
					ELSE ProfileImage
					END
			WHERE UserID = @UserID
		END TRY

	BEGIN CATCH
		INSERT INTO dbo.ErrorLogs (
			ErrorNumber
			,ErrorSeverity
			,ErrorState
			,ErrorProcedure
			,ErrorLine
			,ErrorMessage
			,ErrorTime
			)
		VALUES (
			ERROR_NUMBER()
			,ERROR_SEVERITY()
			,ERROR_STATE()
			,ERROR_PROCEDURE()
			,ERROR_LINE()
			,ERROR_MESSAGE()
			,GETDATE()
			);

		SELECT 'Unable to Update User. Check ErrorLog for details.' AS ErrorMessage;

		RETURN;
	END CATCH
END
GO

SELECT * FROM Users  

EXEC sp_UpdateUserInfo @UserID=52, @FirstName='mariam33', @Country='USA'
EXEC sp_UpdateUserInfo @UserID=NULL, @FirstName='mariam33', @Country='USA'
EXEC sp_UpdateUserInfo @UserID=50000, @FirstName='mariam33', @Country='USA'
GO
DECLARE @birth_date date=DATEADD(Year, 5, GETDATE())
EXEC sp_UpdateUserInfo @UserID=52, @DateOfBirth = @birth_date 
GO
DECLARE @birth_date date='1900-01-01'
EXEC sp_UpdateUserInfo @UserID=52, @DateOfBirth = @birth_date 
EXEC sp_UpdateUserInfo @UserID=52, @Phone = '12345'

EXEC sp_UpdateUserInfo @UserID=52, @Bio = NULL


sp_rename 'Users', 'Users30'
GO

EXEC sp_UpdateUserInfo @UserID=52, @FirstName='mariam60', @Country='USA'
GO

sp_rename 'Users30', 'Users'
GO


