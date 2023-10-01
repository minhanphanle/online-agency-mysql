# Online Travel Agency Management System MySQL script &amp; report

<img width="607" alt="image" src="https://github.com/minhanphanle/online-agency-mysql/assets/83915952/3d4ba241-5a9a-499b-868d-2453be951f55">

<img width="711" alt="image" src="https://github.com/minhanphanle/online-agency-mysql/assets/83915952/e429840c-2899-4a65-abda-58f86831ab53">



The project’s topic is a management system of an online travel agency named The Crusaders, embarked at Ho Chi Minh City. The Crusaders is a web-based service provider specializing in ecotourism, which offers cultural and natural experience tours, and accessories rental such as backpacks or tents. This project will facilitate the executive team including managers, marketing & sales team, and the customer support team of The Crusaders in overseeing their business operations effectively, while enhancing the interaction between their customers and their team significantly

## Project's scope

The Crusaders’ website includes three main user types: customer, sales & support staff, and manager. Manager is the user type which has not only the same feature with staff user type, but further advanced permissions.

### Oracle APEX functionality
1. Go to homepage and other pages of the website using navigation bar and sections attached on the homepage.
2. Login using their registered usernames with corresponding passwords.
3. Further functionalities detailed below

#### User
1. Create a User 
2. View User List
3. Edit a User
4. Delete  user
5. Search user by id, name, account, country, email, phone 
6. Sort user list by id, name, account, country

#### Customer
1. Create a Customer 
2. View Customer List
3. Edit a Customer
4. Delete customers

#### Sales & Support Staff
1. View staff list
2. Create a staff
3. Edit a staff
4. Delete a staff
5. Search staffs by id, and manager
6. 6. Sort staff list by manager
  
#### Manager
1. View manager list
2. Create a manager
3. Delete a manager

#### Partner
1. View partner list
2. Create partner
3. Edit partner
4. Delete partner

** Details about tour, flight, accessories, voucher, booking bill, etc. are included in the report

## ERD diagram 
<img width="1067" alt="image" src="https://github.com/minhanphanle/online-agency-mysql/assets/83915952/b4a46d34-b0be-42cd-8f4f-9b258e05113c">

## Relational schema

* User (User_id: integer, User_Account: varchar, User_Name: varchar, User_gender: varchar, User_DOB: date, User_Country: varchar, User_Type: varchar, User_Email: varchar, User_phone: integer): is a relation of degree nine, which stores information about the website’s users as a whole.
* Customers (Customer_id: integer, Customer_Address: varchar, Customer_Rank: varchar, Customer_Staff: integer) is a relation of degree four, which stores information about website’s customers. This table is a result of the hierachies, where it is the specialization of User and all attributes of User are included.
* Admin (admin_id: integer, admin_position: varchar) is a relation of degree two, which stores information about the company’s employees and their position (staff or manager), which is also the result of the User hierachies. It is seperated from staff table and manager table to maintain the 3rd normalized form.
* Staff (staff_id: integer, staff_manager: integer) is a relation of degree two, which stores the id of staff and shows the managers who manages which staffs. This is the result of Admin hierarchies.
* Manager (manager_id: integer) is a relation seperated from staff table to maintain the 3rd normalized form.
* Voucher (Voucher_id: integer, Voucher_exp: date, Voucher_detail: text, Voucher_amount: integer, Voucher_manager: integer, Voucher_customer: integer) is a relation of degree six, which stores the information about the vouchers available for customers, provided by managers.
* Accessory (Accessory_id: integer, Accessory_detail: text, Accessory_price: float, Accessory_type: varchar, Accessory_rent_date: date, Accessory_return_date: date, Accessory_Partner: integer) is a relation of degree six, which stores information about the accessory rental available.
* Partner (Partner_id: integer, Parter_name: varchar, Partner_country: varchar, Partner_phone: integer, Partner_commissions: float, Partner_Manager: integer) is a relation of degree six, which stores information of company’s partners.
* Tour (Tour_id: integer, Tour_partner: integer, Tour_name: varchar, Tour_price: float, Tour_details: text, Tour_start_date: time, Tour_end_date: time) is a relation of degree seven, which stores information of the tours provided.
* Flight (Flight_id: integer, Flight_type: varchar, Flight_price: float, Flight_from: varchar, Flight_to: varchar, Flight_return: varchar, Flight_partner: integer, Flight_date: date, Flight_return_date: date) is a relation of degree nine, which stores information of the flights.
* Booking bill (Booking_ID: integer, Booking_Voucher: integer, Booking_Customer: integer, Booking_Accessory: integer, Booking_Flight: integer, Booking_tour: integer, Booking_total_price: float, time: datetime) is a relation of degree seven, which stores information about the booking details.

<img width="666" alt="image" src="https://github.com/minhanphanle/online-agency-mysql/assets/83915952/07d883eb-3955-47ae-9a02-e7ba7a484292">

