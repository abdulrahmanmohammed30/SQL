CREATE SCHEMA UserManagement;
GO
CREATE SCHEMA ContentManagement;
GO
CREATE SCHEMA NotificationManagement;
GO

ALTER SCHEMA UserManagement TRANSFER dbo.Users;
ALTER SCHEMA UserManagement TRANSFER Interests;
ALTER SCHEMA UserManagement TRANSFER dbo.UserAccounts;
ALTER SCHEMA UserManagement TRANSFER dbo.UserInterests;
ALTER SCHEMA UserManagement TRANSFER dbo.Friendships;
ALTER SCHEMA UserManagement TRANSFER dbo.PrivateMessages;
ALTER SCHEMA ContentManagement TRANSFER dbo.Posts;
ALTER SCHEMA ContentManagement TRANSFER dbo.PostComments;
ALTER SCHEMA ContentManagement TRANSFER dbo.PostLikes;
ALTER SCHEMA ContentManagement TRANSFER dbo.PostTags;
ALTER SCHEMA ContentManagement TRANSFER dbo.PostTypes;
ALTER SCHEMA ContentManagement TRANSFER dbo.Tags;
ALTER SCHEMA ContentManagement TRANSFER dbo.Groups;
ALTER SCHEMA ContentManagement TRANSFER dbo.GroupMembers;
ALTER SCHEMA ContentManagement TRANSFER dbo.GroupPosts;
ALTER SCHEMA NotificationManagement TRANSFER dbo.Notifications;
ALTER SCHEMA NotificationManagement TRANSFER dbo.ErrorLogs;
GO

-- UserManagement synonyms
CREATE SYNONYM dbo.Users FOR UserManagement.Users;
CREATE SYNONYM dbo.Interests FOR UserManagement.Interests;
CREATE SYNONYM dbo.UserAccounts FOR UserManagement.UserAccounts;
CREATE SYNONYM dbo.UserInterests FOR UserManagement.UserInterests;
CREATE SYNONYM dbo.Friendships FOR UserManagement.Friendships;
CREATE SYNONYM dbo.PrivateMessages FOR UserManagement.PrivateMessages;



-- ContentManagement synonyms
CREATE SYNONYM dbo.Posts FOR ContentManagement.Posts;
CREATE SYNONYM dbo.PostComments FOR ContentManagement.PostComments;
CREATE SYNONYM dbo.PostLikes FOR ContentManagement.PostLikes;
CREATE SYNONYM dbo.PostTags FOR ContentManagement.PostTags;
CREATE SYNONYM dbo.PostTypes FOR ContentManagement.PostTypes;
CREATE SYNONYM dbo.Tags FOR ContentManagement.Tags;
CREATE SYNONYM dbo.Groups FOR ContentManagement.Groups;
CREATE SYNONYM dbo.GroupMembers FOR ContentManagement.GroupMembers;
CREATE SYNONYM dbo.GroupPosts FOR ContentManagement.GroupPosts;

-- Notification synonyms
CREATE SYNONYM dbo.Notifications FOR NotificationManagement.Notifications;
CREATE SYNONYM dbo.ErrorLogs FOR NotificationManagement.ErrorLogs;
