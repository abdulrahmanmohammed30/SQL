
CREATE DATABASE OnlineStore 
GO 

USE OnlineStore
GO


CREATE Table Products
(
    ProductID INT Primary KEY IDENTITY(1,1),
	Name nvarchar(100) NOT NULL,
	Description nvarchar(255), 
	price decimal(10,2)  NOT NULL CHECK (price>=0),
	Quantity INT  NOT NULL CHECK(Quantity >= 0),
	CategoryID INT,
	SupplierID INT NOT NULL, 
	CreatedAt datetime2 NOT NULL default getdate(), 
	UpdatedAt datetime2 NOT NULL default getdate(),                                                                                                                                     
	Constraint FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
	Constraint FK_Products_Suppliers FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
)
GO


CREATE TABLE Categories (
    CategoryID INT Primary KEY IDENTITY(1,1),
	Name nvarchar(50) NOT NULL UNIQUE,
	ParentCategoryID INT ,
	CreatedAt datetime2 NOT NULL default getdate(), 
	UpdatedAt datetime2 NOT NULL default getdate(), 

	CONSTRAINT FK_Categories_Categories FOREIGN KEY (ParentCategoryID) REFERENCES Categories(CategoryID),
	CONSTRAINT CK_Parent_Child_Category CHECK (ParentCategoryID <> CategoryID)
)
GO

CREATE TABLE ProductImages (
  ProductImageID INT Primary KEY IDENTITY(1,1),
  ProductID INT NOT NULL,
  ImageURL NVARCHAR (255) NOT NULL,
  CreatedAt datetime2 NOT NULL default getdate(),
  Constraint FK_ProductImages_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
)
GO

CREATE TABLE Individuals 
(
    IndividualID INT Primary Key Identity(1,1),
	Address nvarchar(80) not null,
	Email varchar(320) not null,
    City NVARCHAR(50),
    State NVARCHAR(50),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(50),
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
)
GO

CREATE TABLE Suppliers (
    SupplierID INT Primary KEY IDENTITY(1,1),
  	Name nvarchar(80) not null,
	ContactNumber VARCHAR(20),
	CONSTRAINT FK_Suppliers_Individuals FOREIGN KEY(SupplierID) REFERENCES Individuals(IndividualID)
)
GO

CREATE TABLE LoginCredentials (
	 LoginCredentialID INT Primary KEY IDENTITY(1,1),
	 Email varchar(255) not null CHECK (dbo.IsValidEmail(Email) = 1),
	 Password varchar(50) not null
)
GO

ALTER TABLE LoginCredentials
DROP CONSTRAINT CK__LoginCred__Email__66603565

Alter TABLE LoginCredentials
ADD CONSTRAINT UQ_Email UNIQUE (Email)

CREATE TABLE Customers (
    CustomerID INT Primary KEY IDENTITY(1,1),
  	FirstName nvarchar(50) not null,
  	LastName nvarchar(50) not null,
	LoginCredentialID INT NOT NULL,
	CONSTRAINT FK_Customers_Individuals FOREIGN KEY(CustomerID) REFERENCES Individuals(IndividualID),
	CONSTRAINT FK_Customers_LoginCredentials FOREIGN KEY(LoginCredentialID) REFERENCES LoginCredentials(LoginCredentialID),
)
GO

CREATE TABLE Orders (
    OrderID INT Primary KEY IDENTITY(1,1),
	CustomerID INT NOT NULL,
	OrderDatetime datetime2 NOT NULL, 
	ShippingMethod nvarchar(50) NOT NULL,
	Status TINYINT not null default 0,
	CONSTRAINT FK_Orders_Customers FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
)
GO

CREATE TABLE OrderProducts (
    OrderProductID INT Primary KEY IDENTITY(1,1),
	OrderID INT NOT NULL,
	ProductID INT NOT NULL,
	Quantity INT NOT NULL CHECK(Quantity > 0), 
	UnitPrice decimal(10,2), 
    CONSTRAINT FK_OrderProducts_Orders FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
	CONSTRAINT FK_OrderProducts_Products FOREIGN KEY(ProductID) REFERENCES Products(ProductID),
)
GO

CREATE Table PaymentMethods(
  	  PaymentMethodID INT Primary KEY IDENTITY(1,1),
	  MethodName nvarchar(50) NOT NULL UNIQUE 
)
GO

CREATE Table Transactions (
	  TransactionID INT Primary KEY IDENTITY(1,1),
	  CustomerID INT NOT NULL,
	  OrderID INT NOT NULL,
	  PaymentAmount decimal(19,2) not null CHECK(PaymentAmount >= 0),
	  PaymentMethodID INT NOT NULL,
	  CreatedAt datetime2 NOT NULL default getdate(), 
	  UpdatedAt datetime2 NOT NULL default getdate(), 

	  CONSTRAINT FK_Transactions_Customers FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
	  CONSTRAINT FK_Transactions_Orders FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
	  CONSTRAINT FK_Transactions_PaymentMethods FOREIGN KEY(PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID),
)
GO

CREATE TABLE ShippingCarriers (
    ShippingCarrierID INT Primary KEY IDENTITY(1,1),
	Name nvarchar(80) not null,
    ContactNumber VARCHAR(20),
	CreatedAt datetime2 NOT NULL default getdate(), 
	UpdatedAt datetime2 NOT NULL default getdate(), 
    CONSTRAINT FK_ShippingCarriers_Individuals FOREIGN KEY(ShippingCarrierID) REFERENCES Individuals(IndividualID)
);


CREATE TABLE Shippings ( 
	ShippingID INT Primary KEY IDENTITY(1,1),
	OrderID INT NOT NULL,
	ShippingCarrierID INT NOT NULL,
	TrackingNumber nvarchar(50) NOT NULL,
	ShippingStatus TINYINT NOT NULL default 0,
	EstimatedDeliveryDate datetime2, 
    ActualDeliveryDate datetime2,
	Notes nvarchar(255),
	CreatedAt datetime2 NOT NULL default getdate(), 
	UpdatedAt datetime2 NOT NULL default getdate(), 
    CONSTRAINT FK_Shipping_ShippingCarriers FOREIGN KEY(ShippingCarrierID) REFERENCES ShippingCarriers(ShippingCarrierID),
    CONSTRAINT FK_Shippings_Orders FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
)
GO

CREATE TABLE Reviews(
	ReviewID INT PRIMARY KEY IDENTITY(1,1),
	ProductID INT NOT NULL, 
	CustomerID INT NOT NULL,
	ReviewText nvarchar(255), 
	RatingScore TINYINT CHECK (RatingScore between 1 and 5),
	CreatedAt datetime2 NOT NULL default getdate(), 
	UpdatedAt datetime2 NOT NULL default getdate(), 
	Constraint UQ_Reviews_Customer_Product UNIQUE(CustomerID, ProductID)
)


INSERT INTO Categories (Name, ParentCategoryID)
VALUES 
('Egyptian Antiques', NULL),
('Pharaonic Replicas', 1),
('Islamic Art', NULL),
('Coptic Artifacts', NULL),
('Jewelry', NULL),
('Papyrus', NULL),
('Home Decor', NULL),
('Textiles', 7),
('Pottery', 7),
('Statues', 2),
('Scarabs', 2),
('Hieroglyphic Art', NULL),
('Modern Egyptian Art', NULL),
('Books on Egypt', NULL),
('Spices', NULL),
('Traditional Clothing', NULL),
('Musical Instruments', NULL),
('Egyptian Cotton Products', 8),
('Perfumes', NULL),
('Souvenirs', NULL);


INSERT INTO Individuals (Address, Email, City, State, PostalCode, Country)
VALUES 
('123 Pyramids St', 'ahmed@example.com', 'Giza', 'Giza', '12345', 'Egypt'),
('456 Nile Rd', 'fatma@example.com', 'Cairo', 'Cairo', '54321', 'Egypt'),
('789 Luxor Ave', 'mohamed@example.com', 'Luxor', 'Luxor', '67890', 'Egypt'),
('101 Alexandria Blvd', 'nour@example.com', 'Alexandria', 'Alexandria', '13579', 'Egypt'),
('202 Aswan St', 'omar@example.com', 'Aswan', 'Aswan', '24680', 'Egypt'),
('303 Hurghada Rd', 'laila@example.com', 'Hurghada', 'Red Sea', '97531', 'Egypt'),
('404 Sharm El Sheikh Ave', 'karim@example.com', 'Sharm El Sheikh', 'South Sinai', '86420', 'Egypt'),
('505 Dahab St', 'amira@example.com', 'Dahab', 'South Sinai', '75319', 'Egypt'),
('606 Siwa Oasis Rd', 'hassan@example.com', 'Siwa', 'Matrouh', '95135', 'Egypt'),
('707 Port Said Ave', 'dina@example.com', 'Port Said', 'Port Said', '15973', 'Egypt'),
('808 Mansoura St', 'youssef@example.com', 'Mansoura', 'Dakahlia', '35791', 'Egypt'),
('909 Tanta Rd', 'rana@example.com', 'Tanta', 'Gharbia', '75319', 'Egypt'),
('1010 Minya Ave', 'ali@example.com', 'Minya', 'Minya', '95135', 'Egypt'),
('1111 Asyut St', 'hoda@example.com', 'Asyut', 'Asyut', '15973', 'Egypt'),
('1212 Suez Rd', 'mahmoud@example.com', 'Suez', 'Suez', '35791', 'Egypt'),
('1313 Ismailia Ave', 'sara@example.com', 'Ismailia', 'Ismailia', '75319', 'Egypt'),
('1414 Fayoum St', 'tarek@example.com', 'Fayoum', 'Fayoum', '95135', 'Egypt'),
('1515 Zagazig Rd', 'mona@example.com', 'Zagazig', 'Sharqia', '15973', 'Egypt'),
('1616 Damietta Ave', 'hesham@example.com', 'Damietta', 'Damietta', '35791', 'Egypt'),
('1717 Marsa Matruh St', 'yasmin@example.com', 'Marsa Matruh', 'Matrouh', '75319', 'Egypt');

INSERT INTO Suppliers (Name, ContactNumber)
VALUES 
('Cairo Antiques', '+20 2 12345678'),
('Luxor Replicas', '+20 95 1234567'),
('Alexandria Art', '+20 3 12345678'),
('Aswan Crafts', '+20 97 1234567'),
('Giza Jewelry', '+20 2 23456789'),
('Nile Papyrus', '+20 2 34567890'),
('Delta Textiles', '+20 50 1234567'),
('Upper Egypt Pottery', '+20 88 1234567'),
('Sinai Perfumes', '+20 69 1234567'),
('Red Sea Souvenirs', '+20 65 1234567'),
('Pharaonic Statues Ltd', '+20 2 45678901'),
('Islamic Artifacts Co', '+20 2 56789012'),
('Coptic Treasures', '+20 2 67890123'),
('Modern Egypt Gallery', '+20 2 78901234'),
('Sphinx Books', '+20 2 89012345'),
('Nefertiti Spices', '+20 2 90123456'),
('Tut''s Clothing', '+20 2 01234567'),
('Pyramids Instruments', '+20 2 12345670'),
('Cleopatra Cotton', '+20 2 23456701'),
('Oasis Dates', '+20 2 34567012');


INSERT INTO Products (Name, Description, Price, Quantity, CategoryID, SupplierID)
VALUES 
('Tutankhamun Mask Replica', 'Golden mask replica of King Tutankhamun', 299.99, 50, 2, 2),
('Handmade Papyrus Painting', 'Traditional Egyptian scene on papyrus', 49.99, 100, 6, 6),
('Silver Ankh Pendant', 'Ancient Egyptian symbol of life', 79.99, 200, 5, 5),
('Egyptian Cotton Bathrobe', 'Luxurious 100% Egyptian cotton bathrobe', 89.99, 150, 18, 19),
('Spice Mix "Dukkah"', 'Traditional Egyptian nut and spice blend', 9.99, 300, 15, 16),
('Mini Alabaster Pyramid', 'Handcrafted pyramid made of Egyptian alabaster', 39.99, 100, 20, 10),
('Book: "Ancient Egypt"', 'Comprehensive guide to ancient Egyptian history', 29.99, 75, 14, 15),
('Scarab Paperweight', 'Decorative scarab beetle paperweight', 19.99, 120, 11, 1),
('Egyptian Oud', 'Traditional Middle Eastern string instrument', 499.99, 20, 17, 18),
('Cartouche Necklace', 'Personalized hieroglyphic nameplate necklace', 69.99, 80, 5, 5),
('Coptic Cross Wall Hanging', 'Ornate Coptic cross for wall decoration', 59.99, 60, 4, 13),
('Egyptian Musk Perfume', 'Traditional Egyptian scent', 39.99, 100, 19, 9),
('Handwoven Kilim Rug', 'Traditional Egyptian flatwoven rug', 199.99, 30, 8, 7),
('Nefertiti Bust Replica', 'Replica of the famous Nefertiti bust', 149.99, 40, 2, 11),
('Shisha Pipe Set', 'Traditional Egyptian water pipe set', 89.99, 50, 20, 10),
('Authentic Pottery Vase', 'Hand-painted pottery vase from Upper Egypt', 79.99, 60, 9, 8),
('Hieroglyphic Alphabet Poster', 'Educational poster with hieroglyphic alphabet', 14.99, 200, 12, 14),
('Egyptian Galabiya', 'Traditional Egyptian loose-fitting garment', 59.99, 100, 16, 17),
('Lotus-Shaped Oil Lamp', 'Decorative oil lamp inspired by lotus flower', 34.99, 80, 7, 3),
('Camel Leather Wallet', 'Handmade wallet from genuine camel leather', 49.99, 150, 20, 10);


INSERT INTO ProductImages (ProductID, ImageURL)
VALUES 
(1, 'https://example.com/images/tutankhamun-mask.jpg'),
(2, 'https://example.com/images/papyrus-painting.jpg'),
(3, 'https://example.com/images/ankh-pendant.jpg'),
(4, 'https://example.com/images/cotton-bathrobe.jpg'),
(5, 'https://example.com/images/dukkah-spice.jpg'),
(6, 'https://example.com/images/alabaster-pyramid.jpg'),
(7, 'https://example.com/images/ancient-egypt-book.jpg'),
(8, 'https://example.com/images/scarab-paperweight.jpg'),
(9, 'https://example.com/images/egyptian-oud.jpg'),
(10, 'https://example.com/images/cartouche-necklace.jpg'),
(11, 'https://example.com/images/coptic-cross.jpg'),
(12, 'https://example.com/images/egyptian-musk.jpg'),
(13, 'https://example.com/images/kilim-rug.jpg'),
(14, 'https://example.com/images/nefertiti-bust.jpg'),
(15, 'https://example.com/images/shisha-pipe.jpg'),
(16, 'https://example.com/images/pottery-vase.jpg'),
(17, 'https://example.com/images/hieroglyphic-poster.jpg'),
(18, 'https://example.com/images/galabiya.jpg'),
(19, 'https://example.com/images/lotus-lamp.jpg'),
(20, 'https://example.com/images/camel-wallet.jpg');


INSERT INTO LoginCredentials (Email, Password)
VALUES 
('ahmed@example.com', 'hashed_password_1'),
('fatma@example.com', 'hashed_password_2'),
('mohamed@example.com', 'hashed_password_3'),
('nour@example.com', 'hashed_password_4'),
('omar@example.com', 'hashed_password_5'),
('laila@example.com', 'hashed_password_6'),
('karim@example.com', 'hashed_password_7'),
('amira@example.com', 'hashed_password_8'),
('hassan@example.com', 'hashed_password_9'),
('dina@example.com', 'hashed_password_10'),
('youssef@example.com', 'hashed_password_11'),
('rana@example.com', 'hashed_password_12'),
('ali@example.com', 'hashed_password_13'),
('hoda@example.com', 'hashed_password_14'),
('mahmoud@example.com', 'hashed_password_15'),
('sara@example.com', 'hashed_password_16'),
('tarek@example.com', 'hashed_password_17'),
('mona@example.com', 'hashed_password_18'),
('hesham@example.com', 'hashed_password_19'),
('yasmin@example.com', 'hashed_password_20');

INSERT INTO Customers (FirstName, LastName, LoginCredentialID)
VALUES 
('Ahmed', 'Hassan', 1),
('Fatma', 'Ali', 2),
('Mohamed', 'Ibrahim', 3),
('Nour', 'El-Din', 4),
('Omar', 'Mahmoud', 5),
('Laila', 'Farouk', 6),
('Karim', 'Zaki', 7),
('Amira', 'Sayed', 8),
('Hassan', 'Abdel-Rahman', 9),
('Dina', 'Naguib', 10),
('Youssef', 'Hamed', 11),
('Rana', 'Adel', 12),
('Ali', 'Mostafa', 13),
('Hoda', 'Fawzy', 14),
('Mahmoud', 'Sabry', 15),
('Sara', 'Tamer', 16),
('Tarek', 'Wahba', 17),
('Mona', 'Essam', 18),
('Hesham', 'Galal', 19),
('Yasmin', 'Khaled', 20);

INSERT INTO Orders (CustomerID, OrderDatetime, ShippingMethod, Status)
VALUES 
(1, '2024-10-01 10:00:00', 'Standard', 2),
(2, '2024-10-02 11:30:00', 'Express', 1),
(3, '2024-10-03 09:15:00', 'Standard', 3),
(4, '2024-10-04 14:45:00', 'Express', 2),
(5, '2024-10-05 16:20:00', 'Standard', 1),
(6, '2024-10-06 13:10:00', 'Express', 3),
(7, '2024-10-07 11:55:00', 'Standard', 2),
(8, '2024-10-08 10:30:00', 'Express', 1),
(9, '2024-10-09 15:40:00', 'Standard', 3),
(10, '2024-10-10 12:25:00', 'Express', 2),
(11, '2024-10-11 09:50:00', 'Standard', 1),
(12, '2024-10-12 14:05:00', 'Standard', 1),
(13, '2024-10-13 16:30:00', 'Express', 3),
(14, '2024-10-14 11:20:00', 'Standard', 2),
(15, '2024-10-15 13:45:00', 'Express', 1),
(16, '2024-10-16 10:15:00', 'Standard', 3),
(17, '2024-10-17 15:50:00', 'Express', 2),
(18, '2024-10-18 12:40:00', 'Standard', 1),
(19, '2024-10-19 09:30:00', 'Express', 3),
(20, '2024-10-20 14:55:00', 'Standard', 2);

INSERT INTO OrderProducts (OrderID, ProductID, Quantity, UnitPrice)
VALUES 
(1, 1, 1, 299.99),
(1, 5, 2, 9.99),
(2, 3, 1, 79.99),
(2, 7, 1, 29.99),
(3, 2, 2, 49.99),
(3, 8, 1, 19.99),
(4, 4, 1, 89.99),
(4, 12, 1, 39.99),
(5, 6, 1, 39.99),
(5, 10, 1, 69.99),
(6, 9, 1, 499.99),
(7, 11, 1, 59.99),
(7, 15, 1, 89.99),
(8, 13, 1, 199.99),
(9, 14, 1, 149.99),
(9, 17, 2, 14.99),
(10, 16, 1, 79.99),
(10, 19, 1, 34.99),
(11, 18, 1, 59.99),
(12, 20, 1, 49.99),
(13, 1, 1, 299.99),
(14, 3, 2, 79.99),
(15, 5, 3, 9.99),
(16, 7, 1, 29.99),
(17, 9, 1, 499.99),
(18, 11, 1, 59.99),
(19, 13, 1, 199.99),
(20, 15, 1, 89.99);

INSERT INTO PaymentMethods (MethodName)
VALUES 
('Credit Card'),
('Debit Card'),
('PayPal'),
('Bank Transfer'),
('Cash on Delivery'),
('Mobile Wallet'),
('Cryptocurrency'),
('Gift Card'),
('Installment Plan'),
('Western Union'),
('Stripe'),
('Apple Pay'),
('Google Pay'),
('Venmo'),
('Alipay'),
('WeChat Pay'),
('Square'),
('Klarna'),
('Afterpay'),
('Fawry');

INSERT INTO Transactions (CustomerID, OrderID, PaymentAmount, PaymentMethodID)
VALUES 
(1, 1, 319.97, 1),
(2, 2, 109.98, 2),
(3, 3, 119.97, 3),
(4, 4, 129.98, 4),
(5, 5, 109.98, 5),
(6, 6, 499.99, 6),
(7, 7, 149.98, 7),
(8, 8, 199.99, 8),
(9, 9, 179.97, 9),
(10, 10, 114.98, 10),
(11, 11, 59.99, 11),
(12, 12, 49.99, 12),
(13, 13, 299.99, 13),
(14, 14, 159.98, 14),
(15, 15, 29.97, 15),
(16, 16, 29.99, 16),
(17, 17, 499.99, 17),
(18, 18, 59.99, 18),
(19, 19, 199.99, 19),
(20, 20, 89.99, 20);

INSERT INTO ShippingCarriers (Name, ContactNumber)
VALUES 
('Egypt Post', '+20 2 23921222'),
('Aramex', '+20 2 26908746'),
('DHL', '+20 2 26908000'),
('FedEx', '+20 2 22908050'),
('UPS', '+20 2 25943000'),
('TNT Express', '+20 2 26908600'),
('EgyptAir Cargo', '+20 2 22576016'),
('Blue Nile Shipping', '+20 2 24093670'),
('Nile Logistics', '+20 2 24619190'),
('Alexandria Shipping', '+20 3 4879815'),
('Cairo Express', '+20 2 26908888'),
('Delta Fast', '+20 50 2245678'),
('Upper Egypt Delivery', '+20 88 2356789'),
('Red Sea Carriers', '+20 65 3456789'),
('Sinai Transport', '+20 69 3353535'),
('Luxor Express', '+20 95 2287654'),
('Aswan Shippers', '+20 97 2302020'),
('Giza Delivery', '+20 2 35855555'),
('Nile Delta Couriers', '+20 40 3333333'),
('Oasis Express', '+20 92 7654321');

INSERT INTO Shippings (OrderID, ShippingCarrierID, TrackingNumber, ShippingStatus, EstimatedDeliveryDate, ActualDeliveryDate, Notes)
VALUES 
(1, 1, 'EGP123456789', 2, '2024-10-05', '2024-10-04', 'Delivered ahead of schedule'),
(2, 2, 'ARX987654321', 1, '2024-10-06', NULL, 'In transit'),
(3, 3, 'DHL456789123', 3, '2024-10-07', '2024-10-08', 'Slight delay due to customs'),
(4, 4, 'FDX789123456', 2, '2024-10-08', '2024-10-08', 'Delivered on time'),
(5, 5, 'UPS321654987', 1, '2024-10-09', NULL, 'Package picked up'),
(6, 6, 'TNT147258369', 3, '2024-10-10', '2024-10-11', 'Delivered to neighbor'),
(7, 7, 'EAC258369147', 2, '2024-10-11', '2024-10-10', 'Early delivery'),
(8, 8, 'BNS369258147', 1, '2024-10-12', NULL, 'Out for delivery'),
(9, 9, 'NLG159753456', 3, '2024-10-13', '2024-10-14', 'Recipient not available, second attempt made'),
(10, 10, 'ALS753159852', 2, '2024-10-14', '2024-10-14', 'Delivered to reception'),
(11, 11, 'CXP951753852', 1, '2024-10-15', NULL, 'Processing at local facility'),
(12, 12, 'DFS357159852', 1, '2024-10-16', NULL, 'Delayed due to weather'),
(13, 13, 'UED753951852', 3, '2024-10-17', '2024-10-16', 'Delivered to secure location'),
(14, 14, 'RSC159753456', 2, '2024-10-18', '2024-10-18', 'Signed by recipient'),
(15, 15, 'SNT753159852', 1, '2024-10-19', NULL, 'In transit to destination'),
(16, 16, 'LXE951753852', 3, '2024-10-20', '2024-10-21', 'Delivery attempted, rescheduled'),
(17, 17, 'ASN357159852', 2, '2024-10-21', '2024-10-20', 'Left at front door'),
(18, 18, 'GZD753951852', 1, '2024-10-22', NULL, 'Package sorted, preparing for delivery'),
(19, 19, 'NDC159753456', 3, '2024-10-23', '2024-10-24', 'Delivery exception, address corrected'),
(20, 20, 'OXE753159852', 2, '2024-10-24', '2024-10-24', 'Delivered to mail room');