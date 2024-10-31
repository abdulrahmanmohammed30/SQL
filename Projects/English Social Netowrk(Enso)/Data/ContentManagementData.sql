INSERT INTO Groups (Name, Description, AdminID, CreatedAt, PrivacySetting, MemberCount, PhotoURL) VALUES
(N'Friends of Egypt', N'A group for Egyptian friends to connect and share memories.', 51, GETDATE(), 'P', 150, 'https://example.com/photo1.jpg'),
(N'Coding Enthusiasts', N'A community of coders sharing knowledge.', 52, GETDATE(), 'F', 200, 'https://example.com/photo2.jpg'),
(N'History Buffs', N'Discussions about world history.', 53, GETDATE(), 'O', 75, 'https://example.com/photo3.jpg'),
(N'Foodies United', N'Explore recipes and food photography.', 54, GETDATE(), 'P', 100, 'https://example.com/photo4.jpg'),
(N'Sports Central', N'Sports news, updates, and debates.', 55, GETDATE(), 'F', 250, 'https://example.com/photo5.jpg'),
(N'Book Club', N'A place to share and review books.', 56, GETDATE(), 'O', 80, 'https://example.com/photo6.jpg'),
(N'Travel Diaries', N'Experiences and tips for travelers.', 57, GETDATE(), 'P', 120, 'https://example.com/photo7.jpg'),
(N'Movie Fans', N'Discussions on movies and series.', 58, GETDATE(), 'F', 220, 'https://example.com/photo8.jpg'),
(N'Fitness Goals', N'Sharing fitness journeys and advice.', 59, GETDATE(), 'P', 90, 'https://example.com/photo9.jpg'),
(N'Music Vibes', N'Connecting people through music.', 60, GETDATE(), 'O', 180, 'https://example.com/photo10.jpg'),
-- (Additional similar rows up to 30 entries)
(N'Science Minds', N'A space for science enthusiasts.', 80, GETDATE(), 'F', 60, 'https://example.com/photo30.jpg');

INSERT INTO GroupMembers (GroupID, UserID, JoinedDate, Role) VALUES
(1,51, '2023-01-01', 'admin'),
(5, 52, '2023-01-02', 'member'),
(8, 53, '2023-01-03', 'moderator'),
(2, 54, '2023-01-04', 'admin'),
(2, 55, '2023-01-05', 'member'),
(2, 56, '2023-01-06', 'moderator'),
(3, 57, '2023-01-07', 'admin'),
(3, 58, '2023-01-08', 'member'),
(4, 59, '2023-01-09', 'admin'),
(4, 60, '2023-01-10', 'moderator'),
(5, 61, '2023-01-11', 'admin'),
-- (Continue adding diverse roles and membership up to around 30 entries)
(11, 80, '2023-01-30', 'member');

