CREATE DATABASE Enso
GO

USE Enso
GO

CREATE TABLE UserAccounts
(
    UserAccountID INT IDENTITY(1,1),
    Username VARCHAR(255) NOT NULL CHECK(LTRIM(RTRIM(Username)) <> ''),
    Email VARCHAR(255) NOT NULL CHECK(LTRIM(RTRIM(Email)) <> ''),
    PasswordHash CHAR(64) NOT NULL CHECK(LTRIM(RTRIM(PasswordHash)) <> ''),
    
    CONSTRAINT PK_UserAccounts PRIMARY KEY(UserAccountID),
    CONSTRAINT UQ_UserAccounts_Username UNIQUE(Username),
    CONSTRAINT UQ_UserAccounts_Email UNIQUE(Email)
)
GO

CREATE TABLE Users (
    UserID    INT,
    FirstName NVARCHAR(50) NOT NULL CHECK(LTRIM(RTRIM(FirstName)) <> ''),
    LastName NVARCHAR(50) NOT NULL CHECK(LTRIM(RTRIM(LastName)) <> ''),
    Phone CHAR(13) CHECK(Phone NOT LIKE '%[^0-9]%'),
    DateOfBirth DATE NOT NULL CHECK(DateOfBirth < GETDATE() AND DATEDIFF(YEAR, DateOfBirth, GETDATE()) <= 100),
    Gender CHAR(1) NOT NULL,
    Bio NVARCHAR(255),
    Country NVARCHAR(50) NOT NULL CHECK(LTRIM(RTRIM(Country)) <> ''),
    ProfileImage NVARCHAR(255),
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    NumOfPosts INT NOT NULL DEFAULT 0,
    TotalFollowers INT NOT NULL DEFAULT 0,
    TotalFriends INT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 0,
    PhotoURL VARCHAR(255) CHECK(LTRIM(RTRIM(PhotoURL)) <> ''),

    CONSTRAINT PK_Users PRIMARY KEY (UserID),
    CONSTRAINT CK_Users_Gender CHECK(Gender IN ('F', 'M')),
    CONSTRAINT FK_Users_UserAccounts FOREIGN KEY (UserID) REFERENCES UserAccounts(UserAccountID) ON UPDATE CASCADE ON DELETE CASCADE
)
GO

CREATE TABLE Interests (
    InterestId INT NOT NULL IDENTITY(1,1),
    InterestName NVARCHAR(50) NOT NULL CHECK(LTRIM(RTRIM(InterestName)) <> ''),

    CONSTRAINT PK_Interests PRIMARY KEY(InterestId),
    CONSTRAINT UQ_Interests_InterestName UNIQUE(InterestName)
)
GO

CREATE TABLE UserInterests (
    UserInterestId INT Identity(1,1),
    InterestId INT NOT NULL,
    UserId INT NOT NULL,

    CONSTRAINT PK_UserInterests PRIMARY KEY(UserInterestId),
    CONSTRAINT FK_UserInterests_Interests FOREIGN KEY(InterestId) REFERENCES Interests(InterestId),
    CONSTRAINT FK_UserInterests_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
)
GO

CREATE TABLE Posts
(
    PostID INT,
    UserID INT,
    Title NVARCHAR(500) NOT NULL  CHECK(LTRIM(RTRIM(Title)) !=''),
    Content NVARCHAR(MAX) NOT NULL CHECK(LTRIM(RTRIM(Content)) !=''),
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    TotalComments INT NOT NULL DEFAULT 0,
    TotalLikes INT NOT NULL DEFAULT 0,
    MediaURL NVARCHAR(255),
    PrivacySetting CHAR(1) NOT NULL DEFAULT 'P' CHECK(PrivacySetting IN ('P','F','O')),
    CONSTRAINT PK_Posts PRIMARY KEY(PostID),
    CONSTRAINT FK_Posts_Users FOREIGN KEY (UserID) REFERENCES Users(UserID) ON UPDATE CASCADE ON DELETE SET NULL
);
GO

CREATE TABLE Tags
(
    TagID INT NOT NULL,
    TagName NVARCHAR(250) NOT NULL,
    
    CONSTRAINT PK_Tags PRIMARY KEY(TagID)
)
GO

CREATE TABLE PostTags
(
    PostTagID INT NOT NULL Identity(1,1),
    TagID INT NOT NULL,
    PostID INT NOT NULL,
    
    CONSTRAINT PK_PostTags PRIMARY KEY (PostTagID),
    CONSTRAINT FK_PostTags_Tags FOREIGN KEY(TagID) REFERENCES Tags(TagID),
    CONSTRAINT FK_PostTags_Posts FOREIGN KEY(PostID) REFERENCES Posts(PostID)
)
GO

CREATE TABLE Friendships (
    FriendshipID INT NOT NULL Identity(1,1),
    UserID1 INT NOT NULL,
    UserID2 INT NOT NULL,
    FriendshipStatus VARCHAR(10) CHECK(FriendshipStatus IN ('requested', 'accepted', 'blocked', 'terminated')),
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_Friendships PRIMARY KEY(FriendshipID),
    CONSTRAINT CK_Friendships_NoSelfReference CHECK(UserID1 <> UserID2),
    CONSTRAINT FK_Friendships_Users_1 FOREIGN KEY (UserID1) REFERENCES Users(UserID) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_Friendships_Users_2 FOREIGN KEY (UserID2) REFERENCES Users(UserID) ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT UQ_Friendships_UserID1_UserID2 UNIQUE(UserID1, UserID2)
)
GO

CREATE TABLE PostComments (
    CommentID INT NOT NULL IDENTITY(1,1),
    ParentID INT,
    PostID INT NOT NULL,
    UserID INT,
    Content NVARCHAR(MAX) NOT NULL CHECK(LTRIM(RTRIM(Content)) <> ''),
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_PostComments PRIMARY KEY(CommentID),
    CONSTRAINT CK_PostComments_NotSelfReferencing CHECK(ParentID <> PostID),
    CONSTRAINT FK_PostComments_PostComments FOREIGN KEY (ParentID) REFERENCES PostComments(CommentID) ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT FK_PostComments_Users FOREIGN KEY (UserID) REFERENCES Users(UserID) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT FK_PostComments_Posts FOREIGN KEY (PostID) REFERENCES Posts(PostID) ON UPDATE NO ACTION ON DELETE NO ACTION
)
GO

CREATE TABLE PostLikes (
    LikeID INT NOT NULL Identity(1,1),
    PostID INT NOT NULL,
    UserID INT NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_PostLikes PRIMARY KEY(LikeID),
    CONSTRAINT FK_PostLikes_Posts FOREIGN KEY (PostID) REFERENCES Posts(PostID),
    CONSTRAINT FK_PostLikes_Users FOREIGN KEY(UserID) REFERENCES Users(UserID),
    CONSTRAINT UQ_PostLikes_UserCannotLikePostMoreThanOnce UNIQUE(PostID,UserID)
);
GO

CREATE TABLE PrivateMessages (
    MessageID INT NOT NULL IDENTITY(1,1),
    SenderID INT,
    ReceiverID INT,
    Content NVARCHAR(MAX) NOT NULL CHECK(LTRIM(RTRIM(Content)) <> ''),
    SentDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    IsRead BIT NOT NULL DEFAULT 0,

    CONSTRAINT PK_PrivateMessages PRIMARY KEY(MessageID),
    CONSTRAINT FK_PrivateMessages_Users_Sender FOREIGN KEY(SenderID) REFERENCES Users(UserID) ,
    CONSTRAINT FK_PrivateMessages_Users_Receiver FOREIGN KEY(ReceiverID) REFERENCES Users(UserID)
)
GO

CREATE TABLE Notifications (
    NotificationID INT NOT NULL IDENTITY(1,1),
    UserID INT NOT NULL,
    Type VARCHAR(255) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    IsRead BIT NOT NULL DEFAULT 0,

    CONSTRAINT PK_Notifications PRIMARY KEY (NotificationID),
    CONSTRAINT FK_Notifications_Users FOREIGN KEY(UserID) REFERENCES Users(UserID)
)
GO

CREATE TABLE Groups (
    GroupID INT NOT NULL IDENTITY(1,1),
    Name NVARCHAR(50) NOT NULL CHECK(LTRIM(RTRIM(Name)) <>''),
    Description NVARCHAR(255) CHECK(LTRIM(RTRIM(Description)) <>''),
    AdminID INT,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    PrivacySetting CHAR(1) NOT NULL DEFAULT 'P' CHECK(PrivacySetting IN ('P','F','O')),
    MemberCount INT NOT NULL DEFAULT 0,
    PhotoURL NVARCHAR(255) CHECK(LTRIM(RTRIM(PhotoURL)) <>''),
    CONSTRAINT PK_Groups PRIMARY KEY(GroupID),
    CONSTRAINT FK_Groups_Users FOREIGN KEY (AdminID) REFERENCES Users(UserID) ,
    CONSTRAINT UQ_Groups_Name UNIQUE(Name)
)
GO

CREATE TABLE GroupMembers (
    GroupMemberID INT NOT NULL IDENTITY(1,1),
    GroupID INT NOT NULL,
    UserID INT NOT NULL,
    JoinedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    Role VARCHAR(9) NOT NULL CHECK(Role IN ('member', 'admin', 'moderator')),

    CONSTRAINT PK_GroupMembers PRIMARY KEY(GroupMemberID),
    CONSTRAINT FK_GroupMembers_Groups FOREIGN KEY (GroupID) REFERENCES Groups(GroupID),
    CONSTRAINT FK_GroupMembers_Users FOREIGN KEY(UserID) REFERENCES Users(UserID)
)
GO

CREATE TABLE GroupPosts(
	GroupPostID INT NOT NULL, 
	PostID INT NOT NULL, 
	GroupID INT NOT NULL, 
	CONSTRAINT FK_GroupPosts PRIMARY KEY (GroupPostID), 
	CONSTRAINT FK_GroupPosts_Posts FOREIGN KEY (PostID) References Posts(PostID),
	CONSTRAINT FK_GroupPosts_Users FOREIGN KEY (GroupID) References Groups(GroupID)
)
GO 

CREATE TABLE ErrorLogs (
    ErrorLogID INT NOT NULL IDENTITY(1,1),
    ErrorTime DATETIME NOT NULL,
    ErrorNumber INT,
    ErrorSeverity INT,
    ErrorState INT,
    ErrorProcedure NVARCHAR(128),
    ErrorLine INT,
    ErrorMessage NVARCHAR(4000),
    UserName NVARCHAR(128),

    CONSTRAINT PK_ErrorLogs PRIMARY KEY(ErrorLogID)
);
GO