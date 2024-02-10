GO
USE HomeSync
GO
INSERT INTO [Room] VALUES ('Bedroom', 1, 'Available');
INSERT INTO [Room] VALUES ('Bedroom', 2, 'Booked');
INSERT INTO [Room] VALUES ('Bedroom', 2, 'Available');
INSERT INTO [Room] VALUES ('Bedroom', 3, 'Booked');
INSERT INTO [Room] VALUES ('Bedroom', 3, 'Available');
INSERT INTO [Room] VALUES ('Living Room', 1, 'Booked');
INSERT INTO [Room] VALUES ('Kitchen', 1, 'Available');
INSERT INTO [Room] VALUES ('Garden', 0, 'Booked');


INSERT INTO Users VALUES ('Mohammed', 'Ali', 'Pa$$w0rd123', 'mohammed.ali@email.com', 'preference3', 4, 'Admin', '1975/11/10');
INSERT INTO Users VALUES ('Rajesh', 'Patel', 'SecurePass456', 'rajesh.patel@email.com', 'preference5', 1, 'Admin', '1985/09/27');
INSERT INTO Users VALUES ('Kenji', 'Nakamura', 'Passw0rd789', 'kenji.nakamura@email.com', 'preference11', 2, 'Admin', '1989/02/17');
INSERT INTO Users VALUES ('Aisha', 'Khan', 'aisha_pass123', 'aisha.khan@email.com', 'preference8', 4, 'Admin', '1980/01/25');
INSERT INTO Users VALUES ('Priya', 'Choudhury', 'Ch0udhuryPass!', 'priya.choudhury@email.com', 'preference14', 5, 'Admin', '1991/09/12');

INSERT INTO Users VALUES ('Yuki', 'Tanaka', 'TanakaPass123', 'yuki.tanaka@email.com', 'preference6', 2, 'Guest', '1992/12/14');
INSERT INTO Users VALUES ('Isabella', 'Lopez', 'IsabellaPass456', 'isabella.lopez@email.com', 'preference10', 1, 'Guest', '1993/04/08');
INSERT INTO Users VALUES ('Juan', 'Gonzalez', 'G0nz@lezPass', 'juan.gonzalez@email.com', 'preference1', 2, 'Guest', '1988/05/15');
INSERT INTO Users VALUES ('Sofia', 'Moreno', 'Sofia123Secure', 'sofia.moreno@email.com', 'preference2', 3, 'Guest', '1983/08/22');
INSERT INTO Users VALUES ('Elena', 'Ivanova', 'IvanovaPass!', 'elena.ivanova@email.com', 'preference4', 5, 'Guest', '1990/03/18');
INSERT INTO Users VALUES ('Luis', 'Rodriguez', 'R0driguezPa$$', 'luis.rodriguez@email.com', 'preference7', 3, 'Guest', '1987/07/03');
INSERT INTO Users VALUES ('Mateo', 'Silva', 'SecureMateo789', 'mateo.silva@email.com', 'preference9', 5, 'Guest', '1998/06/30');
INSERT INTO Users VALUES ('Amina', 'Ahmed', 'AhmedPass123', 'amina.ahmed@email.com', 'preference12', 3, 'Guest', '2020/10/05');
INSERT INTO Users VALUES ('Lucas', 'Santos', 'Luca$Secure123', 'lucas.santos@email.com', 'preference13', 4, 'Guest', '1984/07/19');
INSERT INTO Users VALUES ('Carlos', 'Fernandez', 'Fern@ndezPass', 'carlos.fernandez@email.com', 'preference15', 1, 'Guest', '1986/12/28');



INSERT INTO [Admin] VALUES (1, 30, 1000);
INSERT INTO [Admin] VALUES (2, 10, 9999);
INSERT INTO [Admin] VALUES (3, 2, 10000);
INSERT INTO [Admin] VALUES (4, 4, 100);
INSERT INTO [Admin] VALUES (5, 9, 2000);


INSERT INTO Guest VALUES (6, 1, 'anotherstreet, USA', '2020-03-20', '2020-06-15', 'Apartment');
INSERT INTO Guest VALUES (7, 1, 'thirdstreet, Japan', '2021-08-05', '2021-09-30', 'Condo');
INSERT INTO Guest VALUES (8, 2, 'fourthstreet, India', '2022-01-10', '2022-04-02', 'Resort');
INSERT INTO Guest VALUES (9, 4, 'fifthstreet, Germany', '2023-05-12', '2023-08-18', 'Cabin');
INSERT INTO Guest VALUES (10, 4, 'anotherstreet, Bahrain', '2020-12-01', '2021-01-15', 'Beach House');
INSERT INTO Guest VALUES (11, 4, 'thirdstreet, USA', '2021-06-22', '2021-09-10', 'Villa');
INSERT INTO Guest VALUES (12, 5, 'fourthstreet, Japan', '2022-03-17', '2022-05-28', 'Apartment');
INSERT INTO Guest VALUES (13, 5, 'fifthstreet, India', '2023-01-05', '2023-03-19', 'Condo');
INSERT INTO Guest VALUES (14, 5, 'anotherstreet, Germany', '2023-08-01', '2023-10-10', 'Resort');
INSERT INTO Guest VALUES (15, 5, 'seventhstreet, Spain', '2023-12-15', '2024-01-31', 'Mountain Cabin');


INSERT INTO Task VALUES ('Complete Report', '2023-11-15 09:00:00', '2023-11-30 17:00:00', 'Work', 1, 'In Progress', '2023-11-28 15:00:00', 2);
INSERT INTO Task VALUES ('Review Presentation', '2023-11-20 12:00:00', '2023-11-25 14:30:00', 'Work', 3, 'Pending', '2023-11-23 10:00:00', 1);
INSERT INTO Task VALUES ('Grocery Shopping', '2023-11-12 18:30:00', '2023-11-15 20:00:00', 'Personal', 5, 'Completed', '2023-11-15 15:00:00', 3);
INSERT INTO Task VALUES ('Exercise', '2023-11-10 07:00:00', '2023-11-15 08:00:00', 'Health', 4, 'Not Started', '2023-11-15 07:30:00', 2);
INSERT INTO Task VALUES ('Read Book', '2023-11-13 20:00:00', '2023-11-20 22:00:00', 'Personal', 2, 'In Progress', '2023-11-18 19:00:00', 1);
INSERT INTO Task VALUES ('Project Meeting', '2023-11-14 10:00:00', '2023-11-16 11:30:00', 'Work', 1, 'Pending', '2023-11-16 09:30:00', 2);


INSERT INTO Assigned_to VALUES (1, 1, 2);
INSERT INTO Assigned_to VALUES (3, 2, 4);
INSERT INTO Assigned_to VALUES (5, 3, 3);
INSERT INTO Assigned_to VALUES (2, 4, 1);
INSERT INTO Assigned_to VALUES (4, 5, 5);
INSERT INTO Assigned_to VALUES (1, 6, 2);


INSERT INTO Calendar VALUES (1, 1, 'Team Meeting', 'Discuss project updates', 'Conference Room', '2023-12-10 14:00:00');
INSERT INTO Calendar VALUES (2, 3, 'Product Launch', 'Unveil new product line', 'Event Hall', '2023-11-20 18:30:00');
INSERT INTO Calendar VALUES (3, 5, 'Training Session', 'Employee training on new software', 'Training Room', '2024-01-05 09:00:00');
INSERT INTO Calendar VALUES (4, 2, 'Networking Event', 'Connect with industry professionals', 'Networking Lounge', '2023-12-02 17:00:00');


INSERT INTO Device VALUES (6, 'Tablet', 'Active', 20);
INSERT INTO Device VALUES (7, 'Tablet', 'Inactive', 0);
INSERT INTO Device VALUES (8, 'Smartphone', 'Active', 50);
INSERT INTO Device VALUES (1, 'Laptop', 'Inactive', 0);
INSERT INTO Device VALUES (1, 'Tablet', 'Inactive', 0);
INSERT INTO Device VALUES (2, 'Tablet', 'Active', 10);


INSERT INTO Notes VALUES (2, 'Meeting agenda', '2023-11-10 14:00:00', 'Project Discussion');
INSERT INTO Notes VALUES (4, 'Shopping list', '2023-11-12 10:30:00', 'Groceries');
INSERT INTO Notes VALUES (3, 'Workout plan', '2023-11-13 08:00:00', 'Fitness Routine');
INSERT INTO Notes VALUES (1, 'Book recommendations', '2023-11-14 18:00:00', 'Reading List');
INSERT INTO Notes VALUES (5, 'Project ideas', '2023-11-15 12:45:00', 'Brainstorming');



--New 

INSERT INTO Preferences VALUES(1,'Science',12,'science channels on youtube');
INSERT INTO Preferences VALUES(2,'Science',12,'science channels on youtube');
INSERT INTO Recommendation VALUES(1,'Science',12,'You should subscribe to vsauce');
INSERT INTO Recommendation VALUES(2,'Science',12,'You should subscribe to vsauce');

INSERT INTO Consumption VALUES (1, 10, '2023/11/11')

INSERT INTO [Log] VALUES (1, 1, 1, 'Lunch', '2023/11/25' , 0)

INSERT INTO Preferences VALUES ( 13 , 'Travel' , 1 , 'Stay Home')
INSERT INTO Preferences VALUES ( 1 , 'Temperature' , 9 , '100')
INSERT INTO Preferences VALUES ( 12 , 'Travel' , 2 , 'Stay Home')

Insert into Inventory VALUES (1, 'Tuna', 0, '2025/12/12', 70, 'Egypt Foods', 'Food')
Insert into Inventory VALUES (2, 'samak', 0, '2025/12/12', 30, 'Egypt Foods', 'Food')
Insert into Inventory VALUES (3, 'gambary', 0, '2025/12/12', 20, 'Egypt Foods', 'Food')
Insert into Inventory VALUES (4, 'mashwy', 10, '2025/12/12', 50, 'Egypt Foods', 'Food')

INSERT INTO RoomSchedule (creator_id, [action], room, start_time, end_time) VALUES (1, 'Meeting', 1, '2024-01-15 10:00:00', '2024-01-15 12:00:00');
	/*
	--newer
	INSERT INTO Travel (trip_no, hotel_name, destination, ingoing_flight_num, outgoing_flight_num, ingoing_flight_date, outgoing_flight_date, ingoing_flight_airport, outgoing_flight_airport, transport) VALUES
	(1, 'Hotel A', 'City X', 123, 456, '2023-01-25', '2023-01-30', 'Airport X', 'Airport Y', 'Airplane'),
	(2, 'Hotel B', 'City Y', 789, 101, '2023-02-28', '2023-03-05', 'Airport Y', 'Airport Z', 'Train'),
	(3, 'Hotel C', 'City Z', 111, 222, '2023-03-15', '2023-03-20', 'Airport Z', 'Airport X', 'Car');
	*/