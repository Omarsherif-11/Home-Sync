GO
DROP DATABASE IF EXISTS HomeSync
GO
CREATE DATABASE HomeSync;
GO
USE HomeSync;
GO
CREATE TABLE [Room](
room_id INT PRIMARY KEY IDENTITY,
[type] VARCHAR(250),
[floor] INT,
[status] VARCHAR(250)
);

CREATE TABLE Users(
id INT PRIMARY KEY IDENTITY,
f_Name VARCHAR(250),
l_Name VARCHAR(250),
[password] VARCHAR(250),
[email] VARCHAR(250) UNIQUE,
[preference] VARCHAR(250),
room INT FOREIGN KEY REFERENCES Room,
[type] VARCHAR(250),
birthdate DATETIME,
age AS YEAR(CURRENT_TIMESTAMP) - YEAR(birthdate),
);
/* Admin with one M is key word*/
CREATE TABLE [Admin](
admin_id INT PRIMARY KEY FOREIGN KEY REFERENCES Users,
no_of_guests_allowed INT DEFAULT 30 ,
salary INT
);

CREATE TABLE Guest(
guest_id INT PRIMARY KEY FOREIGN KEY REFERENCES Users,
guest_of INT FOREIGN KEY REFERENCES [Admin],
[Address] VARCHAR(250),
arrival_date DATETIME,
departure_date DATETIME,
residential VARCHAR(250)
);

CREATE TABLE Task(
Task_id INT PRIMARY KEY IDENTITY,
[name] VARCHAR(250),
creation_date DATETIME,
due_date DATETIME,
category VARCHAR(250),
creator INT FOREIGN KEY REFERENCES [Admin],
[status] VARCHAR(250),
reminder_date DATETIME,
[priority] INT
);

CREATE TABLE Assigned_to(
admin_id INT FOREIGN KEY REFERENCES [Admin],
task_id INT FOREIGN KEY REFERENCES Task,
[user_id] INT FOREIGN KEY REFERENCES Users,
CONSTRAINT Assignement PRIMARY KEY (admin_id, task_id, [user_id])
);

CREATE TABLE Calendar(
event_id INT,
user_assigned_to INT FOREIGN KEY REFERENCES Users,
[name] VARCHAR(250),
[description] VARCHAR(250),
[location] VARCHAR(250),
reminder_date DATETIME
CONSTRAINT calendar_id PRIMARY KEY (event_id, user_assigned_to)
);

CREATE TABLE Notes(
id INT PRIMARY KEY IDENTITY,
[user_id] INT FOREIGN KEY REFERENCES Users,
content VARCHAR(250),
creation_date DATETIME,
title VARCHAR(250)
);

CREATE TABLE Travel(
trip_no INT PRIMARY KEY,
hotel_name VARCHAR(250),
destination VARCHAR(250),
ingoing_flight_num INT,
outgoing_flight_num INT,
ingoing_flight_date DATETIME,
outgoing_flight_date DATETIME,
ingoing_flight_airport VARCHAR(250),
outgoing_flight_airport VARCHAR(250),
transport VARCHAR(250)
);

CREATE TABLE User_trip(
trip_no INT FOREIGN KEY REFERENCES Travel,
[user_id] INT FOREIGN KEY REFERENCES Users,
hotel_room_no INT,
in_going_flight_seat_number INT,
out_going_flight_seat_number INT,
CONSTRAINT User_trip_id PRIMARY KEY (trip_no, [user_id])
);

CREATE TABLE Finance(
payment_id INT PRIMARY KEY IDENTITY,
[user_id] INT FOREIGN KEY REFERENCES Users,
[type] VARCHAR(250),
amount DECIMAL(13,2),
currency VARCHAR(250),
method VARCHAR(250),
[status] VARCHAR(250),
[date] DATETIME,
receipt_no INT,
deadline DATETIME,
/* Penatly could be amount of money*/
penalty INT DEFAULT 0
);

CREATE TABLE Health(
[date] DATETIME,
activity VARCHAR(250),
[user_id] INT FOREIGN KEY REFERENCES Users,
hours_slept INT,
food VARCHAR(250),
CONSTRAINT health_id PRIMARY KEY ([date], activity)
);

CREATE TABLE Communication(
message_id INT PRIMARY KEY IDENTITY,
sender_id INT FOREIGN KEY REFERENCES Users,
receiver_id INT FOREIGN KEY REFERENCES Users,
content VARCHAR(250),
time_sent DATETIME,
time_received DATETIME,
time_read DATETIME,
title VARCHAR(250),
);

CREATE TABLE Device(
device_id INT PRIMARY KEY IDENTITY,
room INT FOREIGN KEY REFERENCES Room,
[type] VARCHAR(250),
[status] VARCHAR(250),
battery_status INT
);


CREATE TABLE RoomSchedule(
creator_id INT FOREIGN KEY REFERENCES Users,
[action] VARCHAR(250),
room INT FOREIGN KEY REFERENCES Room,
start_time DATETIME,
end_time DATETIME,
CONSTRAINT roomSchedule_id PRIMARY KEY (creator_id, start_time)
);

CREATE TABLE [Log](
room_id INT FOREIGN KEY REFERENCES Room,
device_id INT FOREIGN KEY REFERENCES Device,
[user_id] INT FOREIGN KEY REFERENCES Users,
activity VARCHAR(250),
[date] DATETIME,
/* duration FLOAT(2, 2) bytl3 error*/
duration INT,
CONSTRAINT Log_id PRIMARY KEY (room_id, device_id, [user_id], [date])
);

CREATE TABLE Consumption(
device_id INT FOREIGN KEY REFERENCES Device,
/* consumption FLOAT(2, 2) bytl3 error*/
consumption INT,
[date] DATETIME,
CONSTRAINT consumption_id PRIMARY KEY (device_id, [Date])
);

CREATE TABLE Preferences(
[user_id] INT FOREIGN KEY REFERENCES Users,
category VARCHAR(250),
preference_no INT,
content VARCHAR(250),
CONSTRAINT preference_id PRIMARY KEY ([user_id], preference_no)
);

CREATE TABLE Recommendation(
Recommendation_id INT PRIMARY KEY IDENTITY,
[user_id] INT,
category VARCHAR(250),
preference_no INT,
content VARCHAR(250), 
FOREIGN KEY ([user_id], preference_no) REFERENCES Preferences ([user_id], preference_no)
);

CREATE TABLE Inventory(
supply_id INT PRIMARY KEY,
[name] VARCHAR(250),
quantity INT,
[expiry_date] DATETIME,
price INT,
manufacturer VARCHAR(250),
category VARCHAR(250)
);

CREATE TABLE Camera(
monitor_id INT PRIMARY KEY FOREIGN KEY REFERENCES Users,
camera_id INT,
room_id INT FOREIGN KEY REFERENCES Room
);

/*	DROP DATABASE HomeSync;
	DROP TABLE Room;
	DROP TABLE Users;
	DROP TABLE [Admin];
	DROP TABLE Guest;
	DROP TABLE Task;
	DROP TABLE Assigned_to;
	DROP TABLE Calender;
	DROP TABLE Notes;
	DROP TABLE Travel;
	DROP TABLE User_trip;
	DROP TABLE Finance;
	DROP TABLE Health;
	DROP TABLE Communication;
	DROP TABLE Communication;
	DROP TABLE Device;
	DROP TABLE RoomSchedule;
	DROP TABLE [Log];
	DROP TABLE Consumption;
	DROP TABLE Preferences;
	DROP TABLE Recommendation;
	DROP TABLE Inventory;
	DROP TABLE Camera;
*/