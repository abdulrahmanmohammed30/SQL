-- Create the database
CREATE DATABASE MobilePhoneCompany;
GO

USE MobilePhoneCompany;
GO

-- Create tables
CREATE TABLE CUSTOMER (
    SSN CHAR(9) PRIMARY KEY,
    Name VARCHAR(50),
    Surname VARCHAR(50),
    PhoneNum VARCHAR(15),
    Plan_ VARCHAR(20)
);
GO

CREATE TABLE PRICINGPLAN (
    Code VARCHAR(10) PRIMARY KEY,
    ConnectionFee DECIMAL(10, 2),
    PricePerSecond DECIMAL(10, 4)
);
GO

CREATE TABLE PHONECALL (
    SSN CHAR(9),
    Date DATE,
    Time TIME,
    CalledNum VARCHAR(15),
    Seconds INT,
    PRIMARY KEY (SSN, Date, Time),
    FOREIGN KEY (SSN) REFERENCES CUSTOMER(SSN)
);
GO

CREATE TABLE BILL (
    SSN CHAR(9),
    Month INT,
    Year INT,
    Amount DECIMAL(10, 2),
    PRIMARY KEY (SSN, Month, Year),
    FOREIGN KEY (SSN) REFERENCES CUSTOMER(SSN)
);
GO

-- Insert sample data
INSERT INTO CUSTOMER (SSN, Name, Surname, PhoneNum, Plan_)
VALUES 
('123456789', 'John', 'Doe', '555-1234', 'Basic'),
('234567890', 'Jane', 'Smith', '555-2345', 'Premium'),
('345678901', 'Bob', 'Johnson', '555-3456', 'Family'),
('456789012', 'Alice', 'Williams', '555-4567', 'Business'),
('567890123', 'Charlie', 'Brown', '555-5678', 'Basic'),
('678901234', 'Diana', 'Davis', '555-6789', 'Premium'),
('789012345', 'Eve', 'Taylor', '555-7890', 'Family'),
('890123456', 'Frank', 'Miller', '555-8901', 'Business');
INSERT INTO PRICINGPLAN (Code, ConnectionFee, PricePerSecond)
VALUES 
('BASIC', 0.50, 0.01),
('PREMIUM', 0.25, 0.008),
('FAMILY', 0.75, 0.012),
('BUSINESS', 1.00, 0.015),
('STUDENT', 0.30, 0.009),
('SENIOR', 0.40, 0.007),
('INTL', 1.50, 0.02),
('WEEKEND', 0.60, 0.011);
GO

INSERT INTO PHONECALL (SSN, Date, Time, CalledNum, Seconds)
VALUES 
('123456789', '2024-10-01', '09:00:00', '555-9876', 300),
('234567890', '2024-10-01', '10:30:00', '555-8765', 180),
('345678901', '2024-10-02', '14:15:00', '555-7654', 420),
('456789012', '2024-10-02', '16:45:00', '555-6543', 600),
('567890123', '2024-10-03', '11:00:00', '555-5432', 240),
('678901234', '2024-10-03', '13:30:00', '555-4321', 360),
('789012345', '2024-10-04', '08:45:00', '555-3210', 480),
('890123456', '2024-10-04', '17:00:00', '555-2109', 540);
GO

INSERT INTO BILL (SSN, Month, Year, Amount)
VALUES 
('123456789', 10, 2024, 50.00),
('234567890', 10, 2024, 75.50),
('345678901', 10, 2024, 100.25),
('456789012', 10, 2024, 150.75),
('567890123', 10, 2024, 45.00),
('678901234', 10, 2024, 80.25),
('789012345', 10, 2024, 110.50),
('890123456', 10, 2024, 200.00);

GO

CREATE TRIGGER trigger_update_bill 
on PhoneCall 
as 
 update Bill 
 set amount = amount + 
 (
   select * from PRICINGPLAN
   join PHONECALL on PRICINGPLAN.SSN = PRICINGPLAN.SSN
    PricePerSecond
 )x