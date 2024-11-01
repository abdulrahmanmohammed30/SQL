CREATE TRIGGER UserInterestsUniqueInterests
ON UserInterests
INSTEAD OF INSERT, UPDATE
AS 
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Check for null or empty 'Interest' field in the inserted data
        IF EXISTS (SELECT 1 FROM inserted WHERE Interest IS NULL OR LTRIM(RTRIM(Interest)) = '')
        BEGIN
            THROW 50001, 'Interest cannot be null or empty.', 1;
        END

        -- Check for duplicate 'Interest' entries (case-insensitive)
        IF EXISTS (
            SELECT 1 
            FROM UserInterests
            JOIN inserted 
            ON LOWER(LTRIM(RTRIM(UserInterests.Interest))) = LOWER(LTRIM(RTRIM(inserted.Interest)))
            AND UserInterests.UserId = inserted.UserId
        )
        BEGIN
            THROW 50002, 'Duplicate interest found. Interest must be unique per user.', 1;
        END

        -- Use MERGE to handle INSERT and UPDATE
        MERGE INTO UserInterests AS target
        USING inserted AS source
        ON target.InterestId = source.InterestId
        WHEN MATCHED THEN 
            UPDATE SET target.Interest = source.Interest
        WHEN NOT MATCHED THEN
            INSERT (UserId, Interest) VALUES (source.UserId, source.Interest);

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        -- Capture error details
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @ErrorSeverity = ERROR_SEVERITY();
        SET @ErrorState = ERROR_STATE();

        -- Log the error
        INSERT INTO ErrorLog (
            ErrorTime,
            ErrorNumber,
            ErrorSeverity,
            ErrorState,
            ErrorProcedure,
            ErrorLine,
            ErrorMessage,
            UserName
        )
        VALUES (
            GETDATE(),
            ERROR_NUMBER(),
            @ErrorSeverity,
            @ErrorState,
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            @ErrorMessage,
            SYSTEM_USER
        );

        -- Raise specific errors for known cases
        IF ERROR_NUMBER() = 50001 
        BEGIN
            RAISERROR('Invalid input: Interest cannot be null or empty.', 16, 1);
            RETURN;
        END;
        ELSE IF ERROR_NUMBER() = 50002
        BEGIN
            RAISERROR('Duplicate interest found. Each interest must be unique per user.', 16, 1);
            RETURN;
        END;
        ELSE
        BEGIN
            RAISERROR('An unexpected error occurred while updating user interests: %s', 16, 1, @ErrorMessage);
            RETURN;
        END;
    END CATCH
END;
