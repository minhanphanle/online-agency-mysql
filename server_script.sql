create database TheCrusaders;
use TheCrusaders;

-- Drop relationship --
-- Users is a parent of Customer:


-- DROP TABLE--
DROP TABLE  IF EXISTS User;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Admin;
DROP TABLE IF EXISTS Manager;
DROP TABLE IF EXISTS Staff;
DROP TABLE IF EXISTS Partner;
DROP TABLE IF EXISTS Voucher;
DROP TABLE IF EXISTS Tour;
DROP TABLE IF EXISTS Flight;
DROP TABLE IF EXISTS Accessory;
DROP TABLE IF EXISTS Booking_Bill;

-- ////////// TABLE CREATION: START ////////// --
--  Users --
CREATE TABLE User
(
    User_ID                INTEGER(10),
    User_Account           VARCHAR(30) UNIQUE NOT NULL ,
    User_Name              VARCHAR(30) NOT NULL ,
    User_Gender            VARCHAR(10) NOT NULL ,
    User_DOB               DATE,
    User_Country           VARCHAR(30),
    User_Type              VARCHAR(15),
    User_Email             VARCHAR(30),
    User_Phone             INTEGER(20),
    PRIMARY KEY (User_ID),
    CHECK (User_gender = 'Male'
        or User_Gender = 'Female'),
    CHECK (User_Type = 'Customer'
        or User_Type = 'Admin')
);

-- Customer --
CREATE TABLE Customer
(
    Customer_ID             INTEGER(10),
    Customer_Address        VARCHAR(50),
    Customer_Rank           VARCHAR(10) NOT NULL,
    Customer_Staff          INTEGER(10) ,
    PRIMARY KEY (Customer_ID),
    CHECK (Customer_Rank = 'Unranked'
        or Customer_Rank = 'Bronze'
        or Customer_Rank = 'Silver'
        or Customer_Rank = 'Gold')
);

-- Admin --
CREATE TABLE Admin
(
    Admin_ID                 INTEGER(10),
    Admin_Position           VARCHAR(30) NOT NULL ,
    PRIMARY KEY (Admin_ID),
    CHECK (Admin_Position = 'Sales & Support Staff'
        or Admin_Position = 'Manager')
);

-- Sale_and_Support_Staff --
CREATE TABLE Staff
(
    Staff_ID                  INTEGER(10),
    Staff_Manager             INTEGER(10),
    PRIMARY KEY (Staff_ID)
);

-- Manager --
CREATE TABLE Manager
(
    Manager_ID                 INTEGER(10),
    PRIMARY KEY (Manager_ID)
);

-- Partner --
CREATE TABLE Partner
(
    Partner_ID                  INTEGER(10),
    Partner_Name                VARCHAR(50) UNIQUE NOT NULL ,
    Partner_Country             VARCHAR(50),
    Partner_Phone               INTEGER(15) NOT NULL ,
    Partner_Commission               FLOAT NOT NULL ,
    Partner_Manager             INTEGER(10)  ,
    PRIMARY KEY (Partner_ID)
);

-- Voucher --
CREATE TABLE Voucher
(
    Voucher_ID                  INTEGER(10),
    Voucher_Amount              INTEGER,
    Voucher_Exp                 DATE NOT NULL ,
    Voucher_Detail              TEXT NOT NULL ,
    Voucher_Manager             INTEGER(10) NOT NULL,
    Voucher_Customer            INTEGER(10) ,
    PRIMARY KEY (Voucher_ID)
);


-- Tour --
CREATE TABLE Tour
(
    Tour_ID                     INTEGER(10),
    Tour_Partner                INTEGER(10) NOT NULL,
    Tour_Price                  FLOAT NOT NULL ,
    Tour_Detail                 TEXT NOT NULL ,
    Tour_Start_Date             DATE NOT NULL ,
    Tour_End_Date               DATE NOT NULL ,
    Tour_Name                   VARCHAR(30),
    PRIMARY KEY (Tour_ID)
);

-- Flight_Ticket --
CREATE TABLE Flight
(
    Flight_ID                  INTEGER(10),
    Flight_Partner             INTEGER(10) NOT NULL,
    Flight_From                VARCHAR(100) NOT NULL ,
    Flight_To                  VARCHAR(100) NOT NULL ,
    Flight_Return              VARCHAR(10) NOT NULL ,
    Flight_Date                DATE NOT NULL ,
    Flight_Return_Date         DATE,
    Flight_Price               FLOAT NOT NULL ,
    Flight_Type                VARCHAR(10) NOT NULL ,
    PRIMARY KEY (Flight_ID),
    check ( Flight_Return = 'Yes'
        or Flight_Return = 'No'),
    CHECK ( Flight_Type = 'Business'
        or Flight_Type = 'Economy')
);

-- Accessories --
CREATE TABLE Accessory
(
    Accessory_ID                 INTEGER(10),
    Accessory_Partner            INTEGER(10) NOT NULL ,
    Accessory_Type               VARCHAR(20) NOT NULL ,
    Accessory_Detail             TEXT NOT NULL ,
    Accessory_Price              FLOAT NOT NULL ,
    Accessory_Rent_Date          DATE NOT NULL ,
    Accessory_Return_Date        DATE NOT NULL ,
    PRIMARY KEY (Accessory_ID),
    CHECK (Accessory_Return_Date >= Accessory_Rent_Date)
);


-- Booking_Bill --
CREATE TABLE Booking_Bill
(
    Booking_ID                   INTEGER(10),
    Booking_Voucher              INTEGER(10),
    Booking_Customer             INTEGER(10) NOT NULL ,
    Booking_Accessory            INTEGER(10),
    Booking_Flight               INTEGER(10),
    Booking_Tour                 INTEGER(10),
    Booking_Total_Price          FLOAT NOT NULL ,
    Time                         DATETIME NOT NULL,
    PRIMARY KEY (Booking_ID)
);
-- ////////// TABLE CREATION: END ////////// --





-- ////////// RELATION CREATION: START ////////// --

-- Users is a parent of Customer:
ALTER TABLE Customer
ADD CONSTRAINT FK_User_Customer
FOREIGN KEY (Customer_ID) REFERENCES User(User_ID) ON UPDATE CASCADE ON DELETE CASCADE;


-- Users is a parent of Admin:
ALTER TABLE Admin
ADD CONSTRAINT FK_User_Admin
FOREIGN KEY (Admin_ID) REFERENCES User(User_ID) ON UPDATE CASCADE ON DELETE CASCADE;


-- Admin is a parent of Staff:
ALTER TABLE Staff
ADD CONSTRAINT FK_Admin_Staff
FOREIGN KEY (Staff_ID) REFERENCES Admin(Admin_ID) ON UPDATE CASCADE ON DELETE CASCADE;



-- Admin is a parent of Manager:
ALTER TABLE Manager
ADD CONSTRAINT FK_Admin_Manager
FOREIGN KEY (Manager_ID) REFERENCES Admin(Admin_ID) ON UPDATE CASCADE ON DELETE CASCADE;


-- Staff and Customer: one to many relationship:
ALTER TABLE Customer
ADD CONSTRAINT FK_Staff_Customer
FOREIGN KEY (Customer_Staff) REFERENCES Staff(Staff_ID) ON UPDATE CASCADE ON DELETE SET NULL ;


-- Manager and Staff: one to many relationship:
ALTER TABLE Staff
ADD CONSTRAINT FK_Manager_Staff
FOREIGN KEY (Staff_Manager) REFERENCES Manager(Manager_ID) ON UPDATE CASCADE ON DELETE SET NULL;



-- Manager and Partner: one to many relationship:
ALTER TABLE Partner
ADD CONSTRAINT FK_Manager_Partner
FOREIGN KEY (Partner_Manager) REFERENCES Manager(Manager_ID) ON UPDATE CASCADE ON DELETE SET NULL;


-- Manager and Voucher: one to many relationship:
ALTER TABLE Voucher
ADD CONSTRAINT FK_Manager_Voucher
FOREIGN KEY (Voucher_Manager) REFERENCES Manager(Manager_ID) ON UPDATE CASCADE ON DELETE CASCADE;



-- Customer and Voucher: one to many relationship:
ALTER TABLE Voucher
ADD CONSTRAINT FK_Customer_Voucher
FOREIGN KEY (Voucher_Customer) REFERENCES Customer(Customer_ID) ON UPDATE CASCADE ON DELETE SET NULL;


-- Customer and Booking bill: One to One relationship.
ALTER TABLE Booking_Bill
ADD CONSTRAINT FK_Customer_Booking
FOREIGN KEY (Booking_Customer) REFERENCES Customer(Customer_ID) ON UPDATE CASCADE ON DELETE CASCADE;


-- Voucher and Booking bill: One to One relationship.
ALTER TABLE Booking_Bill
ADD CONSTRAINT FK_Voucher_Booking
FOREIGN KEY (Booking_voucher) REFERENCES Voucher(Voucher_ID) ON UPDATE CASCADE ON DELETE SET NULL;



-- Tour and Booking bill: One to One relationship.
ALTER TABLE Booking_Bill
ADD CONSTRAINT FK_Tour_Booking
FOREIGN KEY (Booking_Tour) REFERENCES Tour(Tour_ID) ON UPDATE CASCADE ON DELETE SET NULL;



-- Flight and Booking bill: One to Many relationship.
ALTER TABLE Booking_Bill
ADD CONSTRAINT FK_Flight_Booking
FOREIGN KEY (Booking_Flight) REFERENCES Flight(Flight_ID) ON UPDATE CASCADE ON DELETE SET NULL;


-- Accessory and Booking bill: One to many relationship.
ALTER TABLE Booking_Bill
ADD CONSTRAINT FK_Accessory_Booking
FOREIGN KEY (Booking_Accessory) REFERENCES Accessory(Accessory_ID) ON UPDATE CASCADE ON DELETE SET NULL;



-- Partner and Accessory: One to many relationship.
ALTER TABLE Accessory
ADD CONSTRAINT FK_Partner_Accessory
FOREIGN KEY (Accessory_Partner) REFERENCES Partner(Partner_ID) ON UPDATE CASCADE ON DELETE CASCADE;

-- Partner and Flight: One to many relationship.
ALTER TABLE Flight
ADD CONSTRAINT FK_Partner_Flight
FOREIGN KEY (Flight_Partner) REFERENCES Partner(Partner_ID) ON UPDATE CASCADE ON DELETE CASCADE;

-- Partner and Tour: One to many relationship.
ALTER TABLE Tour
ADD CONSTRAINT FK_Partner_Tour
FOREIGN KEY (Tour_Partner) REFERENCES Partner(Partner_ID) ON UPDATE CASCADE ON DELETE CASCADE;

-- ////////// RELATION CREATION: END ////////// --

-----------------------Drop constraint-------------------------- --
ALTER TABLE Customer
DROP FOREIGN KEY FK_User_Customer;
-- Users is a parent of Admin:
-- Drop constraint --
ALTER TABLE Admin
DROP FOREIGN KEY FK_User_Admin;
-- Admin is a parent of Staff:
-- Drop constraint --
ALTER TABLE Staff
DROP FOREIGN KEY FK_Admin_Staff;
-- Admin is a parent of Manager:
-- Drop constraint --
ALTER TABLE Manager
DROP FOREIGN KEY FK_Admin_Manager;
-- Staff and Customer: one to many relationship:
-- Drop constraint --
ALTER TABLE Customer
DROP FOREIGN KEY FK_Staff_Customer;
-- Manager and Staff: one to many relationship:
-- Drop constraint --
ALTER TABLE Staff
DROP FOREIGN KEY FK_Manager_Staff;
-- Manager and Partner: one to many relationship:
-- Drop constraint --
ALTER TABLE Partner
DROP FOREIGN KEY FK_Manager_Partner;
-- Manager and Voucher: one to many relationship:
-- Drop constraint --
ALTER TABLE Voucher
DROP FOREIGN KEY FK_Manager_Voucher;
-- Customer and Voucher: one to many relationship:
-- Drop constraint --
ALTER TABLE Voucher
DROP FOREIGN KEY FK_Customer_Voucher;
-- Customer and Booking bill: One to One relationship.
-- Drop constraint --
ALTER TABLE Booking_Bill
DROP FOREIGN KEY FK_Customer_Booking;
-- Voucher and Booking bill: One to One relationship.
-- Drop constraint --
ALTER TABLE Booking_Bill
DROP FOREIGN KEY FK_Voucher_Booking;
-- Tour and Booking bill: One to One relationship.
-- Drop constraint --
ALTER TABLE Booking_Bill
DROP FOREIGN KEY FK_Tour_Booking;
-- Flight and Booking bill: One to Many relationship.
-- Drop constraint --
ALTER TABLE Booking_Bill
DROP FOREIGN KEY FK_Flight_Booking;
-- Accessory and Booking bill: One to many relationship.
-- Drop constraint --
ALTER TABLE Booking_Bill
DROP FOREIGN KEY FK_Accessory_Booking;
-- Partner and Accessory: One to many relationship.
-- Drop constraint --
ALTER TABLE Accessory
DROP FOREIGN KEY FK_Partner_Accessory;
-- Partner and Flight: One to many relationship.
-- Drop constraint --
ALTER TABLE Flight
DROP FOREIGN KEY FK_Partner_Flight;
-- Partner and Tour: One to many relationship.
-- Drop constraint --
ALTER TABLE Tour
DROP FOREIGN KEY FK_Partner_Tour;
-- -----------------Drop Constraint: End-------------- --------------------

-- -------------------- Insert Data -------------------
-- User --
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5685,'Edith Walker','jacobsrobert','Male','1998-2-15','Vietnam','CUSTOMER','dave35@gmail.com',678935663);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (2613,'Mary Smith','maria52','Female','1982-2-15','Tanzania','ADMIN','achang@gmail.com',407210005);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (2986,'Anna Williams','marcusmurray','Female','1988-2-16','Vietnam','ADMIN','tammy76@yahoo.com',388631962);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (2902,'Emma Brown','chenjoseph','Female','1997-2-17','Vietnam','ADMIN','nhoward@hotmail.com',394296634);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (2381,'Elizabeth Jones','cellison','Female','1998-2-18','Vietnam','ADMIN','juancampos@hotmail.com',160568037);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (2426,'Minnie Miller','vmercado','Male','1992-2-13','Vietnam','ADMIN','vanessa89@gmail.com',641824209);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (2365,'Margaret Johnson','janetsanchez','Female','1998-1-15','Vietnam','ADMIN','corey15@yahoo.com',263874704);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (2188,'Ida Davis','xbeck','Male','1997-2-17','Vietnam','ADMIN','gomezleslie@hotmail.com',245131612);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5791,'Alice Garcia','walter07','Female','1997-2-14','Vietnam','ADMIN','tammywoods@hotmail.com',315268949);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5902,'Bertha Rodriguez','pgonzales','Male','1982-1-15','Vietnam','CUSTOMER','bryan80@gmail.com',422410571);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5293,'Sarah Wilson','hcole','Female','1988-3-13','Vietnam','CUSTOMER','ypage@hotmail.com',869106619);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5697,'Annie Martinez','sayala','Female','1988-2-16','Vietnam','CUSTOMER','dsalazarmaria@yahoo.com',670912838);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5309,'Clara Anderson','smithpaul','Female','1997-1-17','Vietnam','CUSTOMER','jessicapadilla@gmail.com',405441009);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5795,'Ella Taylor','lwood','Female','1997-2-19','Vietnam','CUSTOMER','sallywalker@gmail.com',843138621);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5645,'Florence Thomas','jonesderek','Male','1997-1-20','Vietnam','CUSTOMER','udavis@hotmail.com',182653931);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5945,'Cora Hernandez','robert91','Male','1998-10-15','Vietnam','CUSTOMER','jrodriguez@yahoo.com',680642305);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5665,'Martha Moore','balltraci','Male','1992-2-21','Vietnam','CUSTOMER','kelleylisa@hotmail.com',719278757);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5777,'Laura Martin','hernandeznicole','Female','1993-5-1','Vietnam','CUSTOMER','tamaramorrison@hotmail.com',139288304);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5176,'Nellie Jackson','mackenzie49','Male','1994-9-22','Vietnam','CUSTOMER','sean96@yahoo.com',846252868);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5492,'Grace Thompson','monique84','Male','1995-4-23','Vietnam','CUSTOMER','kellylopez@gmail.com',653910625);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5637,'Carrie White','brownjoe','Male','1996-2-2','Vietnam','CUSTOMER','salazardiane@yahoo.com',737535861);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5679,'Maude Lopez','wilsonkyle','Male','1997-3-20','Vietnam','CUSTOMER','daviskatherine@gmail.com',817002860);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5654,'Mabel Lee','imorton','Male','1998-2-2','Vietnam','CUSTOMER','kirbyrachael@hotmail.com',454799579);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5596,'Bessie Gonzalez','kathleenmurphy','Male','1992-2-1','Vietnam','CUSTOMER','hmassey@yahoo.com',974706765);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5509,'Jennie Harris','jack88','Male','1992-12-12','Vietnam','CUSTOMER','melissajacobson@hotmail.com',314324010);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5825,'Gertrude Clark','michael52','Male','1993-11-11','Vietnam','CUSTOMER','criley@yahoo.com',969022388);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5738,'Julia Lewis','johnsonjohn','Male','1992-1-19','Vietnam','CUSTOMER','christopher91@yahoo.com',780822056);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5916,'Hattie Robinson','emcclure','Male','1992-3-17','Vietnam','CUSTOMER','megan30@hotmail.com',332582634);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5508,'Mattie Perez','tacorobert','Male','1992-6-17','Vietnam','CUSTOMER','ronald01@gmail.com',567100858);
INSERT INTO User (User_ID, User_Name, User_Account, User_Gender, User_DOB, User_Country, User_Type, User_Email, User_Phone)
VALUE (5258,'Rose Hall','dianawilson','Male','1992-2-15','Vietnam','CUSTOMER','brandonberry@hotmail.com',886993227);


-- Admin --
INSERT INTO admin (Admin_ID, Admin_Position)
VALUE (2613,'Manager');
INSERT INTO admin (Admin_ID, Admin_Position)
VALUE (2381,'Sales & Support Staff');
INSERT INTO admin (Admin_ID, Admin_Position)
VALUE (2986,'Manager');
INSERT INTO admin (Admin_ID, Admin_Position)
VALUE (2365,'Sales & Support Staff');
INSERT INTO admin (Admin_ID, Admin_Position)
VALUE (2902,'Sales & Support Staff');
INSERT INTO admin (Admin_ID, Admin_Position)
VALUE (2188,'Sales & Support Staff');
INSERT INTO admin (Admin_ID, Admin_Position)
VALUE (2426,'Sales & Support Staff');

-- Manager --
INSERT INTO Manager (Manager_ID)
VALUE (2613);
INSERT INTO Manager (Manager_ID)
VALUE (2986);

-- Staff --
INSERT INTO Staff (Staff_ID, Staff_Manager)
VALUE (2365, 2986);
INSERT INTO Staff (Staff_ID, Staff_Manager)
VALUE (2188, 2986);
INSERT INTO Staff (Staff_ID, Staff_Manager)
VALUE (2381, 2986);
INSERT INTO Staff (Staff_ID, Staff_Manager)
VALUE (2426, 2613);
INSERT INTO Staff (Staff_ID, Staff_Manager)
VALUE (2902, 2613);



-- Customer --
INSERT INTO Customer (Customer_ID, Customer_Address, Customer_Rank, Customer_Staff)
VALUE (5791,'48764 Howard Forge Apt. 421','Silver',2902);
INSERT INTO Customer (Customer_ID, Customer_Address, Customer_Rank, Customer_Staff)
VALUE (5902,'Vanessaside, PA 19763','Bronze',2381);
INSERT INTO Customer (Customer_ID, Customer_Address, Customer_Rank, Customer_Staff)
VALUE (5293,'578 Michael Island','Unranked',2426);
INSERT INTO Customer (Customer_ID, Customer_Address, Customer_Rank, Customer_Staff)
VALUE (5697,'New Thomas, NC 34644','Unranked',2365);
INSERT INTO Customer (Customer_ID, Customer_Address, Customer_Rank, Customer_Staff)
VALUE (5309,'60975 Jessica Squares','Unranked',2188);
INSERT INTO Customer (Customer_ID, Customer_Address, Customer_Rank, Customer_Staff)
VALUE (5795,'East Sallybury, FL 71671','Unranked',2902);
INSERT INTO Customer (Customer_ID, Customer_Address, Customer_Rank, Customer_Staff)
VALUE (5945,'8714 Mann Plaza','Unranked',2381);
INSERT INTO Customer (Customer_ID, Customer_Address, Customer_Rank, Customer_Staff)
VALUE (5665,'Lisaside, PA 72227','Unranked',2426);
INSERT INTO Customer (Customer_ID, Customer_Address, Customer_Rank, Customer_Staff)
VALUE (5777,'96593 White View Apt. 094','Unranked',2365);
INSERT INTO Customer (Customer_ID, Customer_Address, Customer_Rank, Customer_Staff)
VALUE (5176,'Jonesberg, FL 05565','Unranked',2188);
INSERT INTO Customer (Customer_ID, Customer_Address, Customer_Rank, Customer_Staff)
VALUE (5492,'848 Melissa Springs Suite 947','Unranked',2902);
INSERT INTO Customer (Customer_ID, Customer_Address, Customer_Rank, Customer_Staff)
VALUE (5637,'Kellerstad, MD 80819','Silver',2381);
INSERT INTO Customer (Customer_ID, Customer_Address, Customer_Rank, Customer_Staff)
VALUE (5679,'30413 Norton Isle Suite 012','Unranked',2426);
INSERT INTO Customer (Customer_ID, Customer_Address, Customer_Rank, Customer_Staff)
VALUE (5654	,'North Lisa, ND 79428','Gold',2365);
INSERT INTO Customer (Customer_ID, Customer_Address, Customer_Rank, Customer_Staff)
VALUE (5596,'39916 Mitchell Crescent','Gold',2188);


-- Partner --
INSERT INTO Partner (Partner_ID, Partner_Name, Partner_Country, Partner_Phone, Partner_Manager,Partner_Commission)
VALUE (6730,'Chang-Fisher','Mongolia',1227093178,2613,2000000);
INSERT INTO Partner (Partner_ID, Partner_Name, Partner_Country, Partner_Phone, Partner_Manager,Partner_Commission)
VALUE (6230,'Sheppard-Tucker','Luxembourg',260676096,2986,2000000);
INSERT INTO Partner (Partner_ID, Partner_Name, Partner_Country, Partner_Phone, Partner_Manager,Partner_Commission)
VALUE (6243,'Oxalis Adventurer','Vietnam',307086589,2613,0);
INSERT INTO Partner (Partner_ID, Partner_Name, Partner_Country, Partner_Phone, Partner_Manager,Partner_Commission)
VALUE (6424,'Campos PLC','Macedonia',564302429,2986,2000000);
INSERT INTO Partner (Partner_ID, Partner_Name, Partner_Country, Partner_Phone, Partner_Manager,Partner_Commission)
VALUE (6735,'Archer-Patel','Guernsey',734595893,2613,2000000);
INSERT INTO Partner (Partner_ID, Partner_Name, Partner_Country, Partner_Phone, Partner_Manager,Partner_Commission)
VALUE (6117,'CResponsible Travel','Luxembourg',375441974,2986,2000000);
INSERT INTO Partner (Partner_ID, Partner_Name, Partner_Country, Partner_Phone, Partner_Manager,Partner_Commission)
VALUE (6996,'AndBeyond','Grenada',989117067,2613,2000000);
INSERT INTO Partner (Partner_ID, Partner_Name, Partner_Country, Partner_Phone, Partner_Manager,Partner_Commission)
VALUE (6311,'Kynder','Anguilla',713312779,2986,3000000);
INSERT INTO Partner (Partner_ID, Partner_Name, Partner_Country, Partner_Phone, Partner_Manager,Partner_Commission)
VALUE (6819	,'Levy Group','Micronesia',204670670,2613,0);
INSERT INTO Partner (Partner_ID, Partner_Name, Partner_Country, Partner_Phone, Partner_Manager,Partner_Commission)
VALUE (6862,'Eagle creek','Ethiopia',556282532,2986,3000000);
INSERT INTO Partner (Partner_ID, Partner_Name, Partner_Country, Partner_Phone, Partner_Manager,Partner_Commission)
VALUE (6733,'Salomon Group','Philippines',990129139,2613,3000000);
INSERT INTO Partner (Partner_ID, Partner_Name, Partner_Country, Partner_Phone, Partner_Manager,Partner_Commission)
VALUE (6715,'Trekkingnow Inc','Malaysia',631579040,2986,23000000);
INSERT INTO Partner (Partner_ID, Partner_Name, Partner_Country, Partner_Phone, Partner_Manager,Partner_Commission)
VALUE (6885,'ALKILU LLC	','Kiribati',217680762,2613,4000000);
INSERT INTO Partner (Partner_ID, Partner_Name, Partner_Country, Partner_Phone, Partner_Manager,Partner_Commission)
VALUE (6567,'AguaClan LLC','Suriname',585571357,2986,4000000);
INSERT INTO Partner (Partner_ID, Partner_Name, Partner_Country, Partner_Phone, Partner_Manager,Partner_Commission)
VALUE (6839,'Earthlove PLC','Malaysia',819323745,2613,4000000);

-- Voucher
INSERT INTO Voucher (Voucher_ID, Voucher_Amount, Voucher_Exp, Voucher_Detail, Voucher_Manager, Voucher_Customer)
VALUE (66048763, 1, '2020-6-20','Discount 10% total bill',2613,5309);
INSERT INTO Voucher (Voucher_ID, Voucher_Amount, Voucher_Exp, Voucher_Detail, Voucher_Manager, Voucher_Customer)
VALUE (47593824, 2, '2020-7-21','Free flight',2613,5795);
INSERT INTO Voucher (Voucher_ID, Voucher_Amount, Voucher_Exp, Voucher_Detail, Voucher_Manager, Voucher_Customer)
VALUE (42194897, 1, '2020-3-2','Discount 5% total bill',2613,5945);
INSERT INTO Voucher (Voucher_ID, Voucher_Amount, Voucher_Exp, Voucher_Detail, Voucher_Manager, Voucher_Customer)
VALUE (24115780, 1, '2020-6-20','Discount 10% total bill',2613,5665);
INSERT INTO Voucher (Voucher_ID, Voucher_Amount, Voucher_Exp, Voucher_Detail, Voucher_Manager, Voucher_Customer)
VALUE (15659385, 3, '2020-2-1','Free flight',2613,5777);
INSERT INTO Voucher (Voucher_ID, Voucher_Amount, Voucher_Exp, Voucher_Detail, Voucher_Manager, Voucher_Customer)
VALUE (77840806, 2, '2020-7-25','Discount 5% total bill',2613,5176);
INSERT INTO Voucher (Voucher_ID, Voucher_Amount, Voucher_Exp, Voucher_Detail, Voucher_Manager, Voucher_Customer)
VALUE (16097537, 1, '2020-6-22','Discount 10% total bill',2986,5492);
INSERT INTO Voucher (Voucher_ID, Voucher_Amount, Voucher_Exp, Voucher_Detail, Voucher_Manager, Voucher_Customer)
VALUE (51393328, 2, '2020-6-20','Free flight',2986,5637);
INSERT INTO Voucher (Voucher_ID, Voucher_Amount, Voucher_Exp, Voucher_Detail, Voucher_Manager, Voucher_Customer)
VALUE (87115871, 3, '2020-1-29','Discount 5% total bill',2986,5679);
INSERT INTO Voucher (Voucher_ID, Voucher_Amount, Voucher_Exp, Voucher_Detail, Voucher_Manager, Voucher_Customer)
VALUE (77730806, 2, '2020-2-21','Discount 10% total bill',2986,5654);

-- TOUR --
INSERT INTO Tour (Tour_ID, Tour_Partner, Tour_Price, Tour_Detail, Tour_Start_Date, Tour_End_Date, Tour_Name)
VALUE (382,6730,4500000, 'Jungle trek and over-night stay in the forest	','2020-11-11','2020-11-15','Cát Tiên National Park');
INSERT INTO Tour (Tour_ID, Tour_Partner, Tour_Price, Tour_Detail, Tour_Start_Date, Tour_End_Date, Tour_Name)
VALUE (383,6230,1050000, 'Boat ride to see Hoa Lu citadel and three famous caves in northern Ninh Binh province (Hang Ca, Hang Hai, Hang Ba) which recognized by UNESCO World Heritage Site','2020-10-9','2020-10-12','Tam Cốc-Bích Động');
INSERT INTO Tour (Tour_ID, Tour_Partner, Tour_Price, Tour_Detail, Tour_Start_Date, Tour_End_Date, Tour_Name)
VALUE (384,6243,69800000, 'Four days exploring with three nights camping in the largest cave in the world with activities like river-swimming, scaling the 90-meter "Great Wall of Vietnam", and discovering other adjacent cave like Hang En','2021-9-9','2021-9-12','Son Doong Expedition');
INSERT INTO Tour (Tour_ID, Tour_Partner, Tour_Price, Tour_Detail, Tour_Start_Date, Tour_End_Date, Tour_Name)
VALUE (385,6424,7200000, 'Trekking and caving adventure through the wildest canves in the region including Song Oxalis Cave, Tu Lan Cave, Rat Cave, etc.','2020-10-8','2020-10-13','Wild Tu Lan Explorer');
INSERT INTO Tour (Tour_ID, Tour_Partner, Tour_Price, Tour_Detail, Tour_Start_Date, Tour_End_Date, Tour_Name)
VALUE (386,6735,2000000, 'Trekking through the pristine park to see thousand-year-old trees, ancient caves, and lakes lying just 120 km southwest of Hanoi','2020-10-7','2020-10-10','Cúc Phương National Park');
INSERT INTO Tour (Tour_ID, Tour_Partner, Tour_Price, Tour_Detail, Tour_Start_Date, Tour_End_Date, Tour_Name)
VALUE (387,6117,10000000, 'Homestay in Mai Chau to experience the local culture with the mesmerizing natural landscape of rice fields and stilt houses','2020-10-6','2020-11-12','Mai Châus local tour');
INSERT INTO Tour (Tour_ID, Tour_Partner, Tour_Price, Tour_Detail, Tour_Start_Date, Tour_End_Date, Tour_Name)
VALUE (388,6996,15000000, 'Travelling to Ha Giang to see the breathtaking terraces of limestone karsts, rice fields, Ma Pi Leng Pass, and the local villages','2020-10-5','2020-11-15','Trekking Ha Giang');
INSERT INTO Tour (Tour_ID, Tour_Partner, Tour_Price, Tour_Detail, Tour_Start_Date, Tour_End_Date, Tour_Name)
VALUE (389,6311,18000000, 'A chance to experience the ethnic minorities'' cultures of Dao, O''Chau, H''Mong, etc. with beautify and cozy homestays','2020-10-4','2020-11-13','Trekking Sa Pa');
INSERT INTO Tour (Tour_ID, Tour_Partner, Tour_Price, Tour_Detail, Tour_Start_Date, Tour_End_Date, Tour_Name)
VALUE (390,6819,30000000, 'Hiking Fansipan - the roof of Indochina with 3,143 meters in height - to see the glorious flower field, abundant rainforests, and bamboo trees.','2020-11-3','2020-11-8','Fansipan Hiking');
INSERT INTO Tour (Tour_ID, Tour_Partner, Tour_Price, Tour_Detail, Tour_Start_Date, Tour_End_Date, Tour_Name)
VALUE (391,6996,25000000, 'Visiting Cao Bang to see Ba Be lake with more than 230 km in length, Ban Gioc waterfall, and Ngom Ngao cave.','2020-11-11','2020-11-15','Cao Bang Eco-Adventures');

-- Flight --
INSERT INTO Flight (Flight_ID, Flight_Partner, Flight_From, Flight_To, Flight_Return, Flight_Date, Flight_Return_Date, Flight_Price, Flight_Type)
VALUE (271,6839,'Ha Noi','Dong Hoi','Yes','2020-10-1','2020-1-5',2400000,'Economy');
INSERT INTO Flight (Flight_ID, Flight_Partner, Flight_From, Flight_To, Flight_Return, Flight_Date, Flight_Return_Date, Flight_Price, Flight_Type)
VALUE (284,6862,'Ha Noi','Ho Chi Minh','Yes','2021-1-2','2021-1-7',2300000,'Economy');
INSERT INTO Flight (Flight_ID, Flight_Partner, Flight_From, Flight_To, Flight_Return, Flight_Date, Flight_Return_Date, Flight_Price, Flight_Type)
VALUE (285,6733,'Da Nang','Cao Bang','Yes','2022-3-2','2020-3-9',1300000,'Economy');
INSERT INTO Flight (Flight_ID, Flight_Partner, Flight_From, Flight_To, Flight_Return, Flight_Date, Flight_Return_Date, Flight_Price, Flight_Type)
VALUE (299,6862,'Ho Chi Minh','Dong Hoi','Yes','2021-1-10','2021-1-9',1200000,'Economy');
INSERT INTO Flight (Flight_ID, Flight_Partner, Flight_From, Flight_To, Flight_Return, Flight_Date, Flight_Return_Date, Flight_Price, Flight_Type)
VALUE (225,6733,'Da Lat','Ha Noi','No','2020-11-1', null, 2800000,'Business');
INSERT INTO Flight (Flight_ID, Flight_Partner, Flight_From, Flight_To, Flight_Return, Flight_Date, Flight_Return_Date, Flight_Price, Flight_Type)
VALUE (227,6715,'Ho Chi Minh','Ninh Binh','No','2020-9-12',null,3400000,'Business');
INSERT INTO Flight (Flight_ID, Flight_Partner, Flight_From, Flight_To, Flight_Return, Flight_Date, Flight_Return_Date, Flight_Price, Flight_Type)
VALUE (292,6885,'Phu Quoc','Mai Chau','Yes','2020-1-1','2020-1-5',2900000,'Business');
INSERT INTO Flight (Flight_ID, Flight_Partner, Flight_From, Flight_To, Flight_Return, Flight_Date, Flight_Return_Date, Flight_Price, Flight_Type)
VALUE (257,6567,'Cam Ranh','Ha Noi','No','2020-3-12',null,3100000,'Business');
INSERT INTO Flight (Flight_ID, Flight_Partner, Flight_From, Flight_To, Flight_Return, Flight_Date, Flight_Return_Date, Flight_Price, Flight_Type)
VALUE (233,6715,'Da Nang','Dong Hoi','No','2020-3-3', null, 2400000,'Economy');
INSERT INTO Flight (Flight_ID, Flight_Partner, Flight_From, Flight_To, Flight_Return, Flight_Date, Flight_Return_Date, Flight_Price, Flight_Type)
VALUE (252,6885,'Ha Noi','Mai Chau','Yes','2020-9-2','2020-9-12',2400000,'Business');

-- Accessory --
INSERT INTO Accessory (Accessory_ID, Accessory_Partner, Accessory_Type, Accessory_Detail, Accessory_Price, Accessory_Rent_Date, Accessory_Return_Date)
VALUE (461,6839,'Trekking clothing','Best cloths with versatile layers and soft fabric with synethetic fibers to dry quicky during trail or hike',900000,'2020-10-10','2021-5-2');
INSERT INTO Accessory (Accessory_ID, Accessory_Partner, Accessory_Type, Accessory_Detail, Accessory_Price, Accessory_Rent_Date, Accessory_Return_Date)
VALUE (475,6862,'Gloves','Used for rock-climbing with nylon reinforcement and touch-screen compatibility, designed specially for functionality',300000,'2020-6-10','2020-7-12');
INSERT INTO Accessory (Accessory_ID, Accessory_Partner, Accessory_Type, Accessory_Detail, Accessory_Price, Accessory_Rent_Date, Accessory_Return_Date)
VALUE (473,6733,'LED filming light','Used to illuminate tent or camp site with solar charger, completely bug and insect free thanks to the absence of UV rays',350000,'2020-6-15','2020-9-12');
INSERT INTO Accessory (Accessory_ID, Accessory_Partner, Accessory_Type, Accessory_Detail, Accessory_Price, Accessory_Rent_Date, Accessory_Return_Date)
VALUE (489,6862,'Reusable bag','Used for rock-climbing with nylon reinforcement and touch-screen compatibility, designed specially for functionality',300000,'2019-6-10','2019-6-17');
INSERT INTO Accessory (Accessory_ID, Accessory_Partner, Accessory_Type, Accessory_Detail, Accessory_Price, Accessory_Rent_Date, Accessory_Return_Date)
VALUE (443,6733,'Sustainable tent','Made from 100% recycled material and no toxic dyes used, great for over-night jungle sleep',300000,'2020-4-10','2020-8-12');
INSERT INTO Accessory (Accessory_ID, Accessory_Partner, Accessory_Type, Accessory_Detail, Accessory_Price, Accessory_Rent_Date, Accessory_Return_Date)
VALUE (447,6715,'Sustainable luggage','Comfortable backpacks and bags with multiple handles for easy grab with minimal-waste material',2000000,'2020-6-11','2021-12-19');
INSERT INTO Accessory (Accessory_ID, Accessory_Partner, Accessory_Type, Accessory_Detail, Accessory_Price, Accessory_Rent_Date, Accessory_Return_Date)
VALUE (415,6885,'Sleeping mat','Used for outdoor sleeping',5000000,'2020-5-12','2020-9-12');
INSERT INTO Accessory (Accessory_ID, Accessory_Partner, Accessory_Type, Accessory_Detail, Accessory_Price, Accessory_Rent_Date, Accessory_Return_Date)
VALUE (424,6567,'Trekking shoes','Used for rock-climbing with nylon reinforcement and touch-screen compatibility, designed specially for functionality',1500000	,'2020-5-20','2020-12-12');
INSERT INTO Accessory (Accessory_ID, Accessory_Partner, Accessory_Type, Accessory_Detail, Accessory_Price, Accessory_Rent_Date, Accessory_Return_Date)
VALUE (483,6715,'Water purifier','Best shoes for trekking and ultra or marathon running',6000000,'2020-5-14','2020-10-1');
INSERT INTO Accessory (Accessory_ID, Accessory_Partner, Accessory_Type, Accessory_Detail, Accessory_Price, Accessory_Rent_Date, Accessory_Return_Date)
VALUE (441,6885,'Bamboo utensils','Used to eat during camp, could be thrown away at the site to decompose',100000,'2020-2-10','2020-6-1');

-- Booking --
INSERT INTO Booking_Bill (Booking_ID, Booking_Voucher, Booking_Customer, Booking_Accessory, Booking_Flight, Booking_Tour, Booking_Total_Price, Time)
VALUE (10396,66048763,5309,489,271,382,3050000, '2020-11-11 13:23:44');
INSERT INTO Booking_Bill (Booking_ID, Booking_Voucher, Booking_Customer, Booking_Accessory, Booking_Flight, Booking_Tour, Booking_Total_Price, Time)
VALUE (90951,87115871,5679,443,284,383,73340000, '2020-11-09 15:45:21');
INSERT INTO Booking_Bill (Booking_ID, Booking_Voucher, Booking_Customer, Booking_Accessory, Booking_Flight, Booking_Tour, Booking_Total_Price, Time)
VALUE (68854,47593824,5795,447,285,384,9000000, '2020-11-11 11:12:01');
INSERT INTO Booking_Bill (Booking_ID, Booking_Voucher, Booking_Customer, Booking_Accessory, Booking_Flight, Booking_Tour, Booking_Total_Price, Time)
VALUE (39259,51393328,5637,415,299,385,8000000, '2020-10-29 14:56:59');
INSERT INTO Booking_Bill (Booking_ID, Booking_Voucher, Booking_Customer, Booking_Accessory, Booking_Flight, Booking_Tour, Booking_Total_Price, Time)
VALUE (67039,24115780,5665,424,225,386,11123550, '2020-10-29 14:56:59');
INSERT INTO Booking_Bill (Booking_ID, Booking_Voucher, Booking_Customer, Booking_Accessory, Booking_Flight, Booking_Tour, Booking_Total_Price, Time)
VALUE (52487,42194897,5945,461,227,387,14747400, '2019-11-12 10:11:01');
INSERT INTO Booking_Bill (Booking_ID, Booking_Voucher, Booking_Customer, Booking_Accessory, Booking_Flight, Booking_Tour, Booking_Total_Price, Time)
VALUE (78768,77840806,5176,475,292,388,18350000, '2019-10-19 13:51:49');
INSERT INTO Booking_Bill (Booking_ID, Booking_Voucher, Booking_Customer, Booking_Accessory, Booking_Flight, Booking_Tour, Booking_Total_Price, Time)
VALUE (12573,77730806,5654,473,257,389,29260000, '2020-05-19 08:21:33');
INSERT INTO Booking_Bill (Booking_ID, Booking_Voucher, Booking_Customer, Booking_Accessory, Booking_Flight, Booking_Tour, Booking_Total_Price, Time)
VALUE (99918,16097537,5492,483,233,390,23670000, '2019-01-05 02:10:03');

-- User --

--------- Search user by id, name, account, country, email, phone --------------

SELECT * FROM user
WHERE User_ID LIKE '%%'
AND User_Name LIKE '%E%'
AND User_Account LIKE '%%'
AND User_Country LIKE '%%'
AND User_Email LIKE '%%'
AND User_Phone LIKE '%%';

--------- Sort user list id, name, account, country ----------

SELECT * FROM User
ORDER BY User_ID DESC;

-- Note: Replace order by user_id with user_name, user_account, user_country for different result.
-- And replace DESC with ASC for opposite outcome

------- Calculate -------
--- 1. Total users ------
SELECT COUNT(*) as total_user
FROM User;
--------- Number of male/female users ------
SELECT User_Gender, COUNT(*)  as total_user
FROM User
GROUP BY User_Gender
ORDER BY total_user ASC;
-- Number of different countries by user ---------
SELECT User_Country, COUNT(*) as total_user
FROM User
GROUP BY User_Country
ORDER BY total_user ASC;
--------- Find country that have the most users --------
SELECT User_Country, total
FROM (SELECT User_Country, COUNT(*) as total
         FROM user
         GROUP BY User_Country) as country
WHERE country.total >= ALL (
     SELECT COUNT(*) as total
     FROM user
     GROUP BY User_Country
);

------- Customers --------

-- Search --
SELECT *
FROM Customer
WHERE Customer_id LIKE '%%'
AND Customer_Address LIKE '%%'
AND Customer_Rank LIKE '%Gold%'
AND Customer_Staff LIKE '%%';

-- Sort --
SELECT *
FROM Customer
ORDER BY Customer_ID DESC;

-- Note: Replace order by customer_id with user_rank, customer_staff for different result. And replace DESC with ASC for opposite outcome

-- Calculate total customer
SELECT COUNT(*) as total_cus
FROM Customer;
-- The number of customers that have the same rank
SELECT Customer_Rank, COUNT(*) as total_cus
FROM Customer
GROUP BY Customer_Rank;

-- Countries that have the most customers --
 SELECT User_Country, total
FROM (SELECT User_Country, COUNT(*) as total
         FROM user
         WHERE User_Type = 'Customer'
         GROUP BY User_Country) as country
WHERE country.total >= ALL (
     SELECT COUNT(*) as total
     FROM user
     WHERE User_Type = 'Customer'
     GROUP BY User_Country
);

-- Customers group by age
SELECT SUM(CASE WHEN (YEAR(CURDATE()) - YEAR(User_DOB)) < 18 THEN 1 ELSE 0 END) AS 'Younger than 18',
		SUM(CASE WHEN (YEAR(CURDATE()) - YEAR(User_DOB)) >= 18 AND (YEAR(CURDATE()) - YEAR(User_DOB)) < 35 THEN 1 ELSE 0 END) AS 'From 18 to 35',
		SUM(CASE WHEN (YEAR(CURDATE()) - YEAR(User_DOB)) >= 35 AND (YEAR(CURDATE()) - YEAR(User_DOB)) < 65 THEN 1 ELSE 0 END) AS 'From 35 to 65',
        SUM(CASE WHEN (YEAR(CURDATE()) - YEAR(User_DOB)) >= 65 THEN 1 ELSE 0 END) AS 'Older than 65'

FROM Customer, User WHERE User_ID = Customer_ID;


-- STAFF --

-- Search --
SELECT *
FROM Staff
WHERE Staff_ID LIKE '%2613%'
AND Staff_Manager LIKE '%2365%';

-- Sort --
SELECT * FROM Staff
ORDER BY Staff_id DESC;

-- Note: Replace order by staff_id with staff_manager for different result. And replace DESC with ASC for opposite outcome

-- Total staff --
SELECT COUNT(*) as total_staff
FROM Staff;

-- Number of staffs managed by a manager --
SELECT Staff_Manager, COUNT(*) as total_staff
FROM Staff
GROUP BY Staff_Manager
ORDER BY Staff_Manager ASC;

-- Country that have the most staffs --
 SELECT User_Country, total
FROM (SELECT User_Country, COUNT(*) as total
         FROM user, admin
         WHERE User_ID = Admin_ID
         AND Admin_Position = 'Sales & Support Staff'
         GROUP BY User_Country) as country
WHERE country.total >= ALL (
     SELECT COUNT(*) as total
     FROM user, admin
     WHERE User_ID = Admin_ID
     AND Admin_Position = 'Sales & Support Staff'
     GROUP BY User_Country
);

-- Manager --

-- Sort --
 SELECT *
FROM Manager
ORDER BY Manager_ID DESC;

-- Total Manager --
 SELECT COUNT(*) as total_manager
FROM Manager;

-- Partner --

-- Search
 SELECT *
FROM Partner
WHERE Partner_ID LIKE '%%'
AND Partner_Name LIKE '%Q%'
AND Partner_Country LIKE '%%'
AND Partner_Manager LIKE '%%';

-- Sort
SELECT * FROM Partner
ORDER BY Partner_ID DESC;

-- Note: Replace order by partner_id with partner_country, partner_name, partner_commission for different result. And replace DESC with ASC for opposite outcome

-- Number of partners from a country
SELECT Partner_Country, COUNT(*) as total_partner
FROM Partner
GROUP BY Partner_Country
ORDER BY total_partner ASC;

-- Number of partners managed by a manager
SELECT Partner_Manager, COUNT(*) as total_partner
FROM Partner
GROUP BY Partner_Manager
ORDER BY total_partner ASC;

-- Tour --

-- search
SELECT *
FROM Tour
WHERE Tour_ID LIKE '%%'
AND Tour_Start_Date LIKE '%%'
AND Tour_End_Date LIKE '%%'
AND Tour_Partner LIKE '%S%';

-- Sort
 SELECT * FROM Tour
ORDER BY  Tour_ID DESC;

-- Note: Replace order by tour_id with tour_start_date, tour_end_date, tour_partner, tour_price for different result. And replace DESC with ASC for opposite outcome

-- The Most Expensive:

SELECT Tour_Name, Tour_Price
FROM Tour
WHERE Tour_Price >= ALL (
    SELECT Tour_Price
    FROM Tour
);


-- The Cheapest:

SELECT Tour_Name, Tour_Price
FROM Tour
WHERE Tour_Price <= ALL (
    SELECT Tour_Price
    FROM Tour
);

-- Partners provide the most tour --

SELECT Tour_Partner, Partner_Name, total
FROM Partner, (SELECT Tour_Partner, COUNT(*) as total
           FROM Tour
           GROUP BY Tour_Partner) as partner
WHERE Tour_Partner = Partner_ID
AND partner.total >= ALL (
     SELECT COUNT(*) as total
     FROM Tour
     GROUP BY Tour_Partner
);

-- FLIGHT --

 -- Search fight by id, location (from and to), date, price, and company
SELECT *
FROM Flight
WHERE Flight_ID LIKE '%%'
AND Flight_From LIKE'%H%'
AND Flight_To LIKE '%H%'
AND Flight_Date LIKE '%H%'
AND Flight_Return_Date LIKE '%%'
AND Flight_Partner LIKE '%%';

-- Sort flight by id, location (from and to), transit point, date, price, and company
SELECT * FROM Flight
ORDER BY  Flight_ID DESC;

-- Note: Replace order by flight_id with _country, flight_date, flight_return_date, flight_partner, flight_price for different result. And replace DESC with ASC for opposite outcome

 -- Find: 	The Most Expensive flight

SELECT Flight_Type, Flight_Partner, Flight_Price
FROM Flight
WHERE Flight_Price >= ALL (
    SELECT Flight_Price
    FROM Flight
);

-- The Cheapest:

SELECT Flight_Type, Flight_Partner, Flight_Price
FROM Flight
WHERE Flight_Price >= ALL (
    SELECT Flight_Price
    FROM Flight
);

 -- Companies that provided the most flight
SELECT Flight_Partner, Partner_Name, total
FROM Partner, (SELECT Flight_Partner, COUNT(*) as total
           FROM Flight
           GROUP BY Flight_Partner) as partner
WHERE Flight_Partner = Partner_ID
AND partner.total >= ALL (
     SELECT COUNT(*) as total
     FROM Flight
     GROUP BY Flight_Partner
);
 -- The flights that have below average price
 SELECT Flight_Type, Flight_Partner, Flight_Price
FROM Flight
WHERE Flight_Price <= (SELECT AVG(Flight_Price)
                        FROM Flight);

-- ACCESSORIES --

-- Search accessory by id, type, company, rent date, and return date
SELECT *
FROM Accessory
WHERE Accessory_ID LIKE '%%'
AND Accessory_Type LIKE '%C%'
AND Accessory_Rent_Date LIKE '%%'
AND Accessory_Return_Date LIKE '%%'
AND Accessory_Partner LIKE '%%';

-- Sort accessories by id, type, company, rent date, and return date
SELECT * FROM Accessory
ORDER BY  Accessory_ID DESC;

-- Note: Replace order by Accessory _id with Accessory _rent_date, Accessory _return_date, Accessory _partner, Accessory _price for different result. And replace DESC with ASC for opposite outcome

--	The Most Expensive:

SELECT Accessory_Type, Accessory_Price
FROM Accessory
WHERE Accessory_Price >= ALL (
    SELECT Accessory_Price
    FROM Accessory
);


-- The Cheapest:

SELECT Accessory_Type, Accessory_Price
FROM Accessory
WHERE Accessory_Price >= ALL (
    SELECT Accessory_Price
    FROM Accessory
);

-- Companies that provided the most accessory
SELECT Accessory_Partner, Partner_Name, total
FROM Partner, (SELECT Accessory_Partner, COUNT(*) as total
           FROM Accessory
           GROUP BY Accessory_Partner) as partner
WHERE Accessory_Partner = Partner_ID
AND partner.total >= ALL (
     SELECT COUNT(*) as total
     FROM Accessory
     GROUP BY Accessory_Partner
);

-- The accessories that have below average price
SELECT Accessory_Type, Accessory_Price
FROM Accessory
WHERE Accessory_Price <= (SELECT AVG(Accessory_Price)
                        FROM Accessory);
-- Voucher --

-- Search voucher by id, expiry date, details, manager and customer
SELECT *
FROM Voucher
WHERE Voucher_ID LIKE '%%'
AND Voucher_Exp LIKE  '%2021-09-20%'
AND Voucher_Amount LIKE '%%';
 -- Sort voucher by id, expiry date, manager and customer
 SELECT * FROM Voucher
ORDER BY  Voucher_ID DESC;

-- Note: Replace order by Voucher _id with Voucher_Exp, Voucher_Amount, Voucher _details, Voucher _manager, Voucher_customer for different result. And replace DESC with ASC for opposite outcome
-- Find:
-- Customers who have the most vouchers
SELECT User_Name, total
FROM User U, (SELECT Voucher_Customer, SUM(V1.Voucher_Amount) as total
    FROM Voucher V1
    GROUP BY Voucher_Customer) as voucher
WHERE Voucher_Customer = User_ID
AND voucher.total >= ALL (
    SELECT SUM(V2.Voucher_Amount) as total
    FROM Voucher V2
    GROUP BY Voucher_Customer
);

-- Managers who provide the most vouchers
SELECT User_Name, total
FROM User U, (SELECT Voucher_Manager, SUM(V1.Voucher_Amount) as total
    FROM Voucher V1
    GROUP BY Voucher_Manager) as voucher
WHERE Voucher_Manager = User_ID
AND voucher.total >= ALL (
    SELECT SUM(V2.Voucher_Amount) as total
    FROM Voucher V2
    GROUP BY Voucher_Manager
);

-- Booking bill

-- Search booking bill by id, customer, flight, accessory, tour and voucher
SELECT *
FROM booking_bill
WHERE Booking_ID LIKE '%%'
AND Booking_Flight LIKE '%%'
AND Booking_Tour LIKE '%%'
AND Booking_Accessory LIKE '%4%';

-- Sort booking bill by id, customer, flight, accessory, tour and voucher
SELECT * FROM Booking_Bill
ORDER BY  Booking_ID DESC;

-- Note: Replace order by Booking _id with Booking _customer, Booking _flight, Booking _tour, Booking _accessory for different result. And replace DESC with ASC for opposite outcome

-- Find:
-- Customers have most number of booking bills in a year
SELECT U.User_Name, total
FROM User U, (SELECT B1.Booking_Customer, COUNT(*) as total
    FROM Booking_Bill B1
    WHERE YEAR(B1.Time) = '2020'
    GROUP BY Booking_Customer) as booking
WHERE U.User_ID = Booking_Customer
AND booking.total >= ALL (SELECT COUNT(*) as total
    FROM Booking_Bill B2
    WHERE YEAR(B2.Time) = '2020'
    GROUP BY Booking_Customer);

-- MANAGEMENT DASHBOARD --

--- Booking management ---

-- Full booking details --

SELECT U.User_Name, V.Voucher_Detail, A.Accessory_Type, A.Accessory_Rent_Date,
       A.Accessory_Return_Date, F.Flight_From, F.Flight_To, F.Flight_Return, F.Flight_Date,
       F.Flight_Return_Date, F.Flight_Type, T.Tour_Name, T.Tour_Detail, T.Tour_Start_Date,
       T.Tour_End_Date, B.Booking_Total_Price
FROM Booking_Bill B
INNER JOIN User U ON B.Booking_Customer = U.User_ID
INNER JOIN Voucher V ON B.Booking_Voucher = V.Voucher_ID
INNER JOIN Accessory A ON B.Booking_Accessory = A.Accessory_ID
INNER JOIN Flight F ON B.Booking_Flight = F.Flight_ID
INNER JOIN Tour T ON B.Booking_Tour = T.Tour_ID;

-- Total number of booking bills in a year --
	 SELECT COUNT(*) as total_booking_bill
FROM Booking_Bill
WHERE Time BETWEEN '2020-01-01' AND '2020-12-31'
;

-- Customer Management --

-- Active customers: Customers who bought at least 1 item in the last 6 months

SELECT DISTINCT U.User_Name
FROM Booking_Bill B, User U
WHERE B.Time BETWEEN (SELECT DATE_ADD(CURRENT_DATE, INTERVAL -6 MONTH)) AND (SELECT CURRENT_DATE)
AND Booking_Customer = User_ID;

-- Customer’s name & numbers of items in each category that customer bought from
SELECT U.User_Name, COUNT(IF(B.Booking_Flight <> NULL, Booking_Flight, 0)) as total_flight,
       COUNT(IF(B.Booking_Tour <> NULL, Booking_Tour, 0)) as total_tour,
       COUNT(IF(B.Booking_Accessory <> NULL, Booking_Accessory, 0)) as total_accessory
FROM Booking_Bill B, User U
WHERE U.User_ID = B.Booking_Customer
GROUP BY U.User_Name;

-- STAFF MANAGEMENT --
-- The oldest/ youngest manager
-- Odest Manager:

SELECT User_Name, (YEAR(CURRENT_DATE) - YEAR(User_DOB)) as User_Age
FROM User, Manager
WHERE User_ID = Manager_ID
AND (YEAR(CURRENT_DATE) - YEAR(User_DOB)) >= ALL (
    SELECT (YEAR(CURRENT_DATE) - YEAR(User_DOB))
    FROM User, Manager
    WHERE User_ID = Manager_ID);


-- Youngest Manager:

SELECT User_Name, (YEAR(CURRENT_DATE) - YEAR(User_DOB)) as User_Age
FROM User, Manager
WHERE User_ID = Manager_ID
AND (YEAR(CURRENT_DATE) - YEAR(User_DOB)) <= ALL (
    SELECT (YEAR(CURRENT_DATE) - YEAR(User_DOB))
    FROM User, Manager
    WHERE User_ID = Manager_ID);

-- The oldest/ youngest staff
-- Odest Staff:

SELECT User_Name, (YEAR(CURRENT_DATE) - YEAR(User_DOB)) as User_Age
FROM User, Staff
WHERE User_ID = Staff_ID
AND (YEAR(CURRENT_DATE) - YEAR(User_DOB)) >= ALL (
    SELECT (YEAR(CURRENT_DATE) - YEAR(User_DOB))
    FROM User, Staff
    WHERE User_ID = Staff_ID);


-- Youngest Staff:

SELECT User_Name, (YEAR(CURRENT_DATE) - YEAR(User_DOB)) as User_Age
FROM User, Staff
WHERE User_ID = Staff_ID
AND (YEAR(CURRENT_DATE) - YEAR(User_DOB)) <= ALL (
    SELECT (YEAR(CURRENT_DATE) - YEAR(User_DOB))
    FROM User, Staff
    WHERE User_ID = Staff_ID);

-- Partner management --

-- Find: A manager who manages the most partner
SELECT DISTINCT U.User_Name
FROM User U, Partner P
WHERE U.User_ID = (SELECT DISTINCT Partner_Manager
            FROM (SELECT Partner_Manager, COUNT(*) as total
                       FROM Partner
                       GROUP BY Partner_Manager) as manager
            WHERE manager.total >= ALL (
                    SELECT COUNT(*) as total
                    FROM Partner
                    GROUP BY Partner_manager
            )
);

-- Countries that have the most partner
	 SELECT Partner_Country, total
FROM (SELECT Partner_Country, COUNT(*) as total
                    FROM Partner
                    GROUP BY Partner_Country) as country
WHERE country.total >= ALL (
          SELECT COUNT(*) as total
          FROM Partner
          GROUP BY Partner_Country
);

-- Service Management --

-- Best sellers regarding quantity, grouped by category
            -- Flight:

SELECT F.Flight_ID, F.Flight_From, F.Flight_To, total
FROM Flight F, (SELECT B1.Booking_Flight, COUNT(*) as total
    FROM Booking_Bill B1
    GROUP BY Booking_Flight) as booking
WHERE F.Flight_ID = Booking_Flight
AND booking.total >= ALL (SELECT COUNT(*) as total
    FROM Booking_Bill B2
    GROUP BY B2.Booking_Flight);


            -- Tour:

SELECT T.Tour_ID, T. Tour_Name, T. Tour_Detail, total
FROM Tour T, (SELECT B1.Booking_Tour, COUNT(*) as total
    FROM Booking_Bill B1
    GROUP BY Booking_Tour) as booking
WHERE T. Tour_ID = Booking_Tour
AND booking.total >= ALL (SELECT COUNT(*) as total
    FROM Booking_Bill B2
    GROUP BY B2.Booking_Tour);


            -- Accessory:

SELECT A. Accessory_ID, A. Accessory_Type, A. Accessory_Detail, total
FROM Accessory A, (SELECT B1.Booking_Accessory, COUNT(*) as total
    FROM Booking_Bill B1
    GROUP BY Booking_Accessory) as booking
WHERE A. Accessory_ID = Booking_Accessory
AND booking.total >= ALL (SELECT COUNT(*) as total
    FROM Booking_Bill B2
    GROUP BY B2.Booking_Accessory);


-- Sales Management --

-- Total Revenue in a year
SELECT SUM(Booking_Total_Price) + SUM(Partner_Commission) as total_revenue
FROM Booking_Bill, Partner
WHERE YEAR(Time) = '2020';

-- Income this year = total commission
SELECT SUM(Partner_Commission) as total_income
FROM Partner;


---- End ----
