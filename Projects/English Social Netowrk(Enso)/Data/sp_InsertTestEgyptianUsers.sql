CREATE OR ALTER PROCEDURE sp_InsertTestEgyptianUsers
AS
BEGIN
    SET NOCOUNT ON;
    
    DELETE FROM UserInterests;
    DELETE FROM Users;
    DELETE FROM UserAccounts;
    DELETE FROM Interests;
    
    INSERT INTO Interests (InterestName) VALUES 
    ('Football'),
    ('Reading'),
    ('Cooking'),
    ('Photography'),
    ('Travel'),
    ('Music'),
    ('Art'),
    ('Technology'),
    ('Fashion'),
    ('Fitness');

    DECLARE @DummyHash CHAR(64) = 'e6c3da5b206634d7f3f3586d747ffdb36b5c675757b380c6a5fe5c570c714349';
    
    INSERT INTO UserAccounts (Username, Email, PasswordHash)
    VALUES 
    ('ahmed_hassan', 'ahmed.hassan@email.com', @DummyHash),
    ('mariam_ali', 'mariam.ali@email.com', @DummyHash),
    ('mohamed_ibrahim', 'mohamed.ibrahim@email.com', @DummyHash),
    ('nour_el_din', 'nour.din@email.com', @DummyHash),
    ('fatma_mahmoud', 'fatma.mahmoud@email.com', @DummyHash),
    ('karim_nasser', 'karim.nasser@email.com', @DummyHash),
    ('amira_salem', 'amira.salem@email.com', @DummyHash),
    ('youssef_hamdy', 'youssef.hamdy@email.com', @DummyHash),
    ('hana_ahmed', 'hana.ahmed@email.com', @DummyHash),
    ('omar_khaled', 'omar.khaled@email.com', @DummyHash),
    ('layla_mohamed', 'layla.mohamed@email.com', @DummyHash),
    ('tarek_essam', 'tarek.essam@email.com', @DummyHash),
    ('dina_samy', 'dina.samy@email.com', @DummyHash),
    ('hesham_gamal', 'hesham.gamal@email.com', @DummyHash),
    ('rana_mostafa', 'rana.mostafa@email.com', @DummyHash),
    ('ahmad_fawzy', 'ahmad.fawzy@email.com', @DummyHash),
    ('sara_hassan', 'sara.hassan@email.com', @DummyHash),
    ('mahmoud_said', 'mahmoud.said@email.com', @DummyHash),
    ('nada_ibrahim', 'nada.ibrahim@email.com', @DummyHash),
    ('mostafa_kamel', 'mostafa.kamel@email.com', @DummyHash),
    ('yasmin_ali', 'yasmin.ali@email.com', @DummyHash),
    ('hassan_mohamed', 'hassan.mohamed@email.com', @DummyHash),
    ('mona_ahmed', 'mona.ahmed@email.com', @DummyHash),
    ('amr_hassan', 'amr.hassan@email.com', @DummyHash),
    ('heba_salem', 'heba.salem@email.com', @DummyHash),
    ('khaled_mahmoud', 'khaled.mahmoud@email.com', @DummyHash),
    ('noura_adel', 'noura.adel@email.com', @DummyHash),
    ('tamer_hosny', 'tamer.hosny@email.com', @DummyHash),
    ('amal_maher', 'amal.maher@email.com', @DummyHash),
    ('sherif_mounir', 'sherif.mounir@email.com', @DummyHash),
    ('reem_ahmed', 'reem.ahmed@email.com', @DummyHash),
    ('fady_ibrahim', 'fady.ibrahim@email.com', @DummyHash),
    ('mai_ezz', 'mai.ezz@email.com', @DummyHash),
    ('kareem_abdel', 'kareem.abdel@email.com', @DummyHash),
    ('salma_samir', 'salma.samir@email.com', @DummyHash),
    ('hamza_ali', 'hamza.ali@email.com', @DummyHash),
    ('ghada_adel', 'ghada.adel@email.com', @DummyHash),
    ('waleed_fawzy', 'waleed.fawzy@email.com', @DummyHash),
    ('dalia_mohamed', 'dalia.mohamed@email.com', @DummyHash),
    ('sameh_hussein', 'sameh.hussein@email.com', @DummyHash),
    ('malak_omar', 'malak.omar@email.com', @DummyHash),
    ('ziad_ahmed', 'ziad.ahmed@email.com', @DummyHash),
    ('rahma_salem', 'rahma.salem@email.com', @DummyHash),
    ('bassem_youssef', 'bassem.youssef@email.com', @DummyHash),
    ('nadia_ali', 'nadia.ali@email.com', @DummyHash),
    ('mazen_hamza', 'mazen.hamza@email.com', @DummyHash),
    ('farida_mohamed', 'farida.mohamed@email.com', @DummyHash),
    ('hossam_hassan', 'hossam.hassan@email.com', @DummyHash),
    ('lina_kareem', 'lina.kareem@email.com', @DummyHash),
    ('adam_sherif', 'adam.sherif@email.com', @DummyHash);

    INSERT INTO Users (UserID, FirstName, LastName, Phone, DateOfBirth, Gender, Bio, Country, ProfileImage, PhotoURL, IsActive)
    SELECT 
        UserAccountID,
        SUBSTRING(Username, 1, CHARINDEX('_', Username + '_') - 1),
        SUBSTRING(Username, CHARINDEX('_', Username) + 1, LEN(Username)),
        '2' + RIGHT('0' + CAST(ABS(CHECKSUM(NEWID())) % 10 AS VARCHAR), 1) + 
        '1' + RIGHT('0' + CAST(ABS(CHECKSUM(NEWID())) % 10 AS VARCHAR), 1) +
        RIGHT('0' + CAST(ABS(CHECKSUM(NEWID())) % 10000000000 AS VARCHAR), 9),
        DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % (365 * 40) + 365 * 18), GETDATE()),
        CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN 'M' ELSE 'F' END,
        'Bio for ' + Username,
        'Egypt',
        'profile_' + CAST(UserAccountID AS VARCHAR) + '.jpg',
        'https://example.com/photos/' + CAST(UserAccountID AS VARCHAR) + '.jpg',
        1
    FROM UserAccounts;

    ;WITH NumberedUsers AS (
        SELECT UserID, ABS(CHECKSUM(NEWID())) % 3 + 2 AS NumInterests
        FROM Users
    )
    INSERT INTO UserInterests (UserId, InterestId)
    SELECT DISTINCT 
        u.UserID,
        i.InterestId
    FROM NumberedUsers u
    CROSS APPLY (
        SELECT TOP (u.NumInterests) InterestId 
        FROM Interests 
        ORDER BY NEWID()
    ) i;

    UPDATE Users
    SET NumOfPosts = ABS(CHECKSUM(NEWID())) % 100,
        TotalFollowers = ABS(CHECKSUM(NEWID())) % 1000,
        TotalFriends = ABS(CHECKSUM(NEWID())) % 500;
END
GO