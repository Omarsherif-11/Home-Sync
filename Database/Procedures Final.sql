Go

/* 3 - 24
Add a new device.
Signature:
Name: AddDevice.
Input:@device_id int, @status varchar(20), @battery int,@location int, @type varchar(20).
Output: Nothing.
*/
/* CHANGED
close the identity insert before inserting
*/
CREATE PROCEDURE AddDevice
@device_id INT,
@status VARCHAR(20),
@battery INT,
@location INT,
@type VARCHAR(20)
AS
BEGIN
if not exists (select * from Device where device_id= @device_id) 
begin
SET IDENTITY_INSERT Device ON
INSERT INTO Device (device_id, [status], battery_status, room, type)
VALUES (@device_id, @status, @battery, @location, @type);
SET IDENTITY_INSERT Device OFF
end
END;

go

 
/*3-18
Add  Guests  to  the  system  ,  generate  passwords  for  them and  reserve  rooms  under  their  name. Signature:
Name :  AddGuest
Input : @email varchar(30), @first_name varchar(10) ,@address varchar (30),@password varchar(30),@guest_of int,@room_id  int
Output :  @number_of_allowed  _guests  int */
 CREATE PROCEDURE AddGuest
    @email VARCHAR(30),
    @first_name VARCHAR(10),
    @address VARCHAR(30),
    @password VARCHAR(30),
    @guest_of INT,
    @room_id INT,
    @number_of_allowed_guests INT OUTPUT
AS
BEGIN

    IF ( (SELECT no_of_guests_allowed FROM [Admin] WHERE admin_id = @guest_of) > 0 AND  @email Not In (select email from Users) And @guest_of is Not null And @email is Not null And @room_id is Not null)
    BEGIN 

    INSERT INTO Users (f_Name, email, [password], [type], room)
    VALUES (@first_name, @email, @password, 'Guest', @room_id);
 
    DECLARE @guest_id INT;
    SET @guest_id = SCOPE_IDENTITY();
 
    INSERT INTO Guest (guest_id, guest_of, [address])
    VALUES (@guest_id, @guest_of, @address);
 
    
    UPDATE [Admin]
    SET @number_of_allowed_guests = no_of_guests_allowed - 1
    WHERE admin_id = @guest_of;

    END
ELSE BEGIN
print 'ERROR'
END

END

go

 
/*3-21
Add  outgoing  flight  itinerary  for  a  specific  flight. Signature:
Name :  AddItinerary
Input :  @@trip_no  int,@flight_num  varchar(30)  ,@flight_date  datetime  ,@destination  varchar(40) 
Output :  Nothing */
CREATE PROCEDURE AddItinerary
    @trip_no INT,
    @flight_num VARCHAR(30),
    @flight_date DATETIME,
    @destination VARCHAR(40)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Travel WHERE trip_no = @trip_no)
    BEGIN
        RAISERROR('Trip with trip_no %d does not exist.', 16, 1, @trip_no);
        RETURN;
    END
UPDATE Travel
SET outgoing_flight_num = @flight_num, outgoing_flight_date = @flight_date, destination=@destination
WHERE @trip_no=trip_no;

END;

go



/*
procedure 2 - 11) Add a reminder to a task.
Signature:
Name: AddReminder.
Input: @task_id int, @reminder datetime.
Output: Nothing.
*/

CREATE PROCEDURE AddReminder 
 @task_id INT,@reminder DATETIME
AS 
BEGIN
    IF(@task_id NOT IN(SELECT Task_id FROM Task)) RETURN;

	UPDATE Task SET reminder_date = @reminder WHERE Task.Task_id = @task_id;

END;

go

CREATE PROCEDURE AdminAddTask
    @user_id INT,
    @creator INT,
    @name VARCHAR(30),
    @category VARCHAR(20),
    @priority INT,
    @status VARCHAR(20),
    @reminder DATETIME,
    @deadline datetime
    
AS
BEGIN
    INSERT INTO Task 
    VALUES (@name, CURRENT_TIMESTAMP,@deadline, @category, @creator, @status, @reminder, @priority);
 
    DECLARE @task_id INT;
    SET @task_id = SCOPE_IDENTITY();
 
    INSERT INTO Assigned_to (admin_id, task_id, [user_id])
    VALUES (@creator, @task_id, @user_id);
 
END

go



/* 3 - 34
Get the admin with more then 2 guests.
Signature:
Name: Admins.
Input: Nothing.
Output: Table containing Admins names.
*/
CREATE PROCEDURE Admins
AS
BEGIN
SELECT DISTINCT (u.f_Name + ' ' + u.l_Name) AS 'Name'
FROM Guest g1 INNER JOIN Guest g2 ON g1.guest_id < g2.guest_id AND g1.guest_of = g2.guest_of
INNER JOIN Users u ON g1.guest_of = u.id

END;

go


CREATE PROCEDURE AssignRoom
@user_id int,
@room_id int
AS
BEGIN
if @user_id is not null and @room_id is not null
begin
if exists (select * from Room where room_id = @room_id)
update Users 
set room = @room_id where id = @user_id;
UPDATE Room
set status = 'booked' where room_id =@room_id;
end
else 
begin
print 'mafeesh room';
end
END

go

 
/*3-19
Assign  task  to  a  specific  User. Signature:
Name :  AssignTask
Input :  @user_id  int  ,  @task_id  int  ,  @creator_id  int 
Output :  Nothing */
 CREATE PROCEDURE AssignTask
    @user_id INT,
    @task_id INT,
    @creator_id INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE id = @user_id) AND EXISTS (SELECT 1 FROM Task WHERE task_id = @task_id)
    BEGIN
        IF EXISTS (SELECT 1 FROM [Admin] WHERE admin_id = @creator_id) AND (@user_id Not In (select [user_id]  from Assigned_to) AND @task_id Not In (select task_id  from Assigned_to) AND @creator_id Not In (select admin_id  from Assigned_to))
        BEGIN
            INSERT INTO Assigned_to (admin_id, task_id, [user_id])
            VALUES (@creator_id, @task_id, @user_id);
        END
        ELSE
        BEGIN
            RAISERROR('Invalid creator ID or duplicate entry', 16, 1);
        END
    END
    ELSE
    BEGIN
        RAISERROR('Invalid user ID or task ID.', 16, 1);
    END
END;

go

/*
2-10) Assign user to attend event.
Signature:
Name: AssignUser.
Input: @user_id int, @event_id int.
Output: @user_id and all details of the event that the employee is assigned to.
*/
CREATE PROCEDURE AssignUser
@user_id int, 
@event_id int
AS
BEGIN
if @user_id is not null and @event_id is not null And Exists (select * from Calendar where event_id= @event_id) And not Exists (select * from Calendar where event_id = @event_id And user_assigned_to=@user_id) And Exists (select * from Users where id = @user_id)
insert into Calendar values
(@event_id, @user_id,(select TOP 1 [name] from Calendar where event_id= @event_id )
,(select TOP 1 [description] from Calendar where event_id= @event_id )
,(select TOP 1 [location] from Calendar where event_id= @event_id )
,(select TOP 1 reminder_date from Calendar where event_id= @event_id ));
END;


go


/* 3 - 31
Get the users whose average income per month is greater then a specific amount.
Signature:
Name: AveragaPayment.
Input: @amount decimal (10,2).
Output: Table Containing users names.
*/
CREATE PROCEDURE AveragePayment
@amount DECIMAL(10, 2)
AS
BEGIN
SELECT f_Name
FROM Users INNER JOIN [Admin] ON id = admin_id
WHERE (salary / 12) > @amount /* Assuming Salary is given per year */ 
END

go

/*
2-8) Book a room with other users.
Signature:
Name: BookRoom.
Input: @user_id int,@room_id int.
Output: Nothing.
*/

CREATE PROCEDURE BookRoom
@user_id int,
@room_id int
AS
BEGIN
if @user_id is not null and @room_id is not null
begin
if exists (select * from Room where room_id = @room_id)
update Users 
set room = @room_id where id = @user_id;
UPDATE Room
set status = 'booked' where room_id =@room_id;
end
else 
begin
print 'mafeesh room';
end
END

go

/*3-22
Change  flight  date  to  next  year  for  all  flights  in  current  year. Signature:
Name :  ChangeFlight 
Input :  Nothing 
Output :  Nothing*/
CREATE PROCEDURE ChangeFlight
AS
BEGIN
    DECLARE @CurrentYear INT = YEAR(CURRENT_TIMESTAMP);
    UPDATE Travel
    SET 
        outgoing_flight_date = DATEADD(YEAR, 1, outgoing_flight_date),
        ingoing_flight_date = DATEADD(YEAR, 1, ingoing_flight_date)
    WHERE 
        YEAR(outgoing_flight_date) = @CurrentYear
        AND YEAR(ingoing_flight_date) = @CurrentYear;
END

go

CREATE PROCEDURE Charging
AS
BEGIN
UPDATE Device SET [status] = 'Charging'
WHERE battery_status = 0
END

go


/*
2-9) Create events on the system.
Signature:
Name: CreateEvent.
Input:@event_id Int @user_id int, @name varchar(50), @description varchar(200), @location varchar(40),@reminder_date datetime ,@other_user_id int.
Output: Nothing.
*/
CREATE PROCEDURE CreateEvent
@event_id Int,
@user_id int, 
@name varchar(50), 
@description varchar(200), 
@location varchar(40),
@reminder_date datetime,
@other_user_id int
AS
BEGIN
if @event_id is not null and @user_id is not null and @name is not null and @description is not null and @location is not null and @reminder_date is not null and Exists (select * from Users where id = @user_id) And not Exists (select * from Calendar where event_id = @event_id And user_assigned_to=@user_id)
insert into Calendar values (@event_id, @user_id, @name, @description, @location, @reminder_date);
if @event_id is not null and @other_user_id is not null and @name is not null and @description is not null and @location is not null and @reminder_date is not null and Exists (select * from Users where id = @other_user_id) and  not Exists (select * from Calendar where event_id = @event_id And user_assigned_to=@other_user_id)
insert into Calendar values (@event_id, @other_user_id, @name, @description, @location, @reminder_date);
END;

go

/*
procedure 2 - 16) Create new note.
Signature:
Name: CreateNote.
Input: @User_id int, @note_id int, @title varchar(50), @Content varchar(500), @creation_date
datetime.
Output: Nothing.
*/
CREATE PROCEDURE CreateNote 
@User_id  INT,@note_id INT,@title varchar(50),@Content varchar(500),@creation_date DATETIME
AS 
BEGIN 
IF(@note_id IN (SELECT id FROM Notes))RETURN;
SET IDENTITY_INSERT Notes ON;
INSERT INTO Notes(id,[user_id],content,creation_date,title) VALUES(@note_id,@user_id,@Content,@creation_date,@title);
SET IDENTITY_INSERT Notes OFF;
END;

go


/*

3 - 3

Create schedule for the rooms.
Signature:
Name: CreateSchedule.
Input: @creator_id int, @room_id int, @start_time datetime, @end_time datetime, @action varchar(20).
Output: Nothing.

*/
CREATE PROC CreateSchedule
@creator_id int, @room_id int, @start_time datetime, @end_time datetime, @action varchar(20)
AS
BEGIN 

    if(exists (select *from Room where room_id=@room_id))
    begin
	IF ( EXISTS ( SELECT * FROM [Admin] WHERE admin_id = @creator_id  ) )
		
        IF(NOT EXISTS (SELECT * FROM RoomSchedule WHERE creator_id = @creator_id And start_time = @start_time) )
		
            INSERT INTO RoomSchedule VALUES (@creator_id ,@action, @room_id , @start_time , @end_time)
	   
        ELSE
      
            PRINT('Already created this schedule')
	
    ELSE
	
		PRINT('No creator with this ID exists')
    end
END;

go

CREATE PROCEDURE [dbo].[DeleteMsg]
AS
BEGIN

    DELETE FROM Communication
    WHERE message_id = (
        SELECT TOP 1 message_id
        FROM Communication
        ORDER BY message_id DESC
    );
END

go

/*
2-5)Finish their task.
Signature:
Name: FinishMyTask.
Input: @user_id int, @title varchar(50).
Output: Nothing.
*/
CREATE PROCEDURE FinishMyTask
@user_id int, @title varchar(50)
AS
BEGIN
if @user_id is not null and @title is not null
begin
update task set [status] = 'done' where task_id 
in (select t.task_id from task t 
inner join Assigned_to a 
on t.task_id = a.task_id and a.[user_id]=@user_id And [name]=@title ) ;
end
END;

go

CREATE PROCEDURE [dbo].[GuestNumber]
@admin_id INT
AS
BEGIN
SELECT COUNT(guest_of) AS 'Id'
FROM Guest
WHERE guest_of = @admin_id
END

go

create PROC GuestRemove
@guest_id int, @admin_id int
AS 
BEGIN

	IF ( EXISTS ( SELECT * FROM Guest WHERE guest_id = @guest_id ) ) 
	
	BEGIN
		DELETE FROM Guest
		WHERE guest_id = @guest_id;

        DELETE FROM Users
        WHERE id = @guest_id

		UPDATE [Admin]
		SET no_of_guests_allowed = no_of_guests_allowed + 1
		WHERE admin_id = @admin_id;  
	END
END;

go



/* 3 - 27
Set the number of allowed guests for an admin.
Signature:
Name: GuestsAllowed.
Input: @admin_id int,@number_of_guests int
Output: Nothing.
*/
CREATE PROCEDURE GuestsAllowed
@admin_id INT,
@number_of_guests INT
AS
BEGIN
UPDATE [Admin] SET no_of_guests_allowed = @number_of_guests
WHERE admin_id = @admin_id
END

go


 /*

 3 - 8

Create an inventory for a specific item.
Signature:
Name: Inventory.
Input: @item_id int„@name varchar(30), @quantity int, @expirydate datetime, @price decimal(10,2),
@manufacturer varchar(30),@category varchar(20)
Output: Nothing.

 */
--NO 2 Objects can have the same name so we added Proc
 CREATE PROC InventoryProc
@item_id int, 
@name varchar(30), 
@quantity int, 
@expirydate datetime, 
@price decimal(10,2),
@manufacturer varchar(30),
@category varchar(20)
AS 
BEGIN

    IF ( NOT EXISTS ( SELECT supply_id FROM Inventory WHERE supply_id = @item_id ) And @item_id is Not null And @name is Not null And @quantity is Not null And @expirydate is Not null And @price is Not null And @manufacturer is Not null And @category is Not null)

	    INSERT INTO Inventory VALUES (  @item_id, @name, @quantity, @expirydate, @price, @manufacturer, @category );
    
    ELSE
        
        PRINT('A Supply with this ID has already been inserted')

END;

go


 /*

 3 - 10

 If current user had an activity set its duration to 1 hour.
Signature:
Name: LogActivityDuration .
Input: @room_id int ,@device_id int, @user_id int,@date datetime, @duration varchar(50).
4
Output: Nothing.

*/

 CREATE PROC  LogActivityDuration
  @room_id int ,@device_id int, @user_id int,@date datetime, @duration varchar(50)
  AS
  BEGIN
	
	IF ( EXISTS ( SELECT * FROM [Log] WHERE room_id = @room_id AND device_id = @device_id AND [user_id] = @user_id AND [date] = @date ) And @duration is not null ) 
		
		UPDATE [Log]
		SET duration = @duration
		WHERE room_id = @room_id AND device_id = @device_id AND [user_id] = @user_id AND [date] = @date;

	ELSE

		PRINT('This record does not exist in the Log') 

  END;

  go

   
/*
3-12
Make  preferences  for  Room  temperature  to  be  30  if  a  user  is  older  then  40  .hint  :  ussenestedquery Signature:
Name :  MakePreferencesRoomTemp.
Input :  @user_id  int  ,@category  varchar(20),  @preferences_number  int   
Output :  Nothing.
*/
CREATE PROCEDURE MakePreferencesRoomTemp
@user_id  int  ,
@category  varchar(20),
@preferences_number  int
AS
BEGIN 
UPDATE Preferences
    SET content = '30'
    WHERE [user_id] = @user_id
        AND category = @category
        AND preference_no = @preferences_number
        AND @user_id IN (
            SELECT [user_id]
            FROM Users
            WHERE age > 40
        )
END

go



/* 3 - 33
Get the location where more then two devices have a dead battery.
Signature:
Name: NeedCharge.
Input: Nothing.
Output: Table Containing device_id and locations.
*/
CREATE PROCEDURE NeedCharge
AS
BEGIN
SELECT d1.*
FROM Device d1 INNER JOIN Device d2
ON d1.device_id < d2.device_id AND d1.room = d2.room
WHERE d1.battery_status = 0 AND d2.battery_status = 0 
END

go

/*
procedure 2 -20) Change note title for all notes user created.
Signature:
Name: NoteTitle.
Input: @user_id int,@note_title varchar(50).
Output: Nothing.
*/
CREATE PROCEDURE NoteTitle 
@user_id INT , @note_title varchar(50)
AS 
BEGIN 
UPDATE Notes SET Notes.title = @note_title WHERE Notes.[user_id] = @user_id;
END;

go

CREATE PROCEDURE OutOfBattery
AS
BEGIN
SELECT d.*
FROM Device d INNER JOIN Room r ON d.room = r.room_id
WHERE battery_status = 0
END;

go



/* 3 - 28
Add a penalty for all unpaid transactions where the deadline has passed.
Signature:
Name: Penalize.
Input: @Penalty_amount int.
Output: Nothing.
*/
CREATE PROCEDURE Penalize
@Penatly_amount INT
AS
BEGIN
UPDATE Finance SET penalty = @Penatly_amount + penalty
WHERE [status] = 'unpaid' AND deadline < CURRENT_TIMESTAMP
END

go

/* 
procedure 2 - 18) Create a payment on a specific date.
Signature:
Name: PlanPayment.
Input: @sender_id int, @reciever_id int , @type varchar(30), @amount decimal(13,2), @status
varchar(10), @deadline datetime.
Output: Nothing.

*/
CREATE PROCEDURE PlanPayment
@sender_id INT , @reciever_id INT,@amount DECIMAL(13,2),@status varchar(10),@deadline DATETIME

AS 
BEGIN 
INSERT INTO Finance ([user_id],[type],amount,[status],deadline) 
VALUES 
(@sender_id, 'outgoing',@amount,@status,@deadline);

INSERT INTO Finance ([user_id],[type],amount,[status],deadline) 
VALUES 
(@reciever_id, 'incoming',@amount,@status,@deadline);

END;

go



/* 3 - 32
Get sum the sum of all purchases needed in the home inventory (assuming you need only 1 of each
missing item) .
Signature:
Name: Purchase.
Input: Nothing.
Output: The sum amount.
*/

CREATE PROCEDURE Purchase
AS
BEGIN
SELECT SUM(price) AS 'Sum of price'
FROM Inventory
WHERE quantity = 0
END

go

/*
procedure 2 - 17) Receive a transaction.
Signature:
Name: ReceiveMoney.
Input: @reciever_id int, @type varchar(30), @amount decimal(13,2), @status varchar(10), @date
datetime.
Output: Nothing.

*/
CREATE PROCEDURE ReceiveMoney
@reciever_id INT,@type varchar(30), @amount DECIMAL(13,2),
@status varchar(10),@date DATETIME
AS
BEGIN 
INSERT INTO Finance([user_id],[type],amount,[status],[date]) VALUES(@reciever_id,@type,@amount,@status,@date);
END;

go


/*

3 - 5

Recommend travel destinations for guests under certain age.
Signature:
Name: RecommendTD.
Input: @Guest_id int, @destination varchar(10), @age int , @preference_no int.
Output: Nothing.

*/

CREATE PROC RecommendTD
@Guest_id int, @destination varchar(10), @age int , @preference_no int
AS 
BEGIN 

	IF( EXISTS ( SELECT g.* FROM Guest g INNER JOIN Users u ON u.id = g.guest_id WHERE u.age < @age AND guest_id = @Guest_id) And exists(select * from Preferences where preference_no=@preference_no) )

		INSERT INTO Recommendation VALUES ( @Guest_id , 'Travel', @preference_no , @destination ) 

	ELSE

		PRINT('There does not exist a Guest with this ID less than that age')

END;

go


/*

3 - 2

Remove an event from the system.
Signature:
Name: RemoveEvent.
Input: @event_id int, @user_id int.
Output: Nothing.

*/

CREATE PROC RemoveEvent
@event_id int, @user_id int
AS 
BEGIN 
	
	IF ( EXISTS ( SELECT * FROM Calendar WHERE event_id = @event_id and user_assigned_to = @user_id )) 
        DELETE FROM Calendar 
		WHERE event_id = @event_id AND user_assigned_to = @user_id;

	ELSE

		PRINT('There does not exist an Event with this ID')

END;

go


/*

3 - 7

Change status of room.
Signature:
Name: RoomAvailability
Input: @location int, @status varchar(40)
Output: Nothing.

*/

CREATE PROC RoomAvailability
 @location int, @status varchar(40)
 AS 
 BEGIN

	IF( EXISTS ( SELECT * FROM Room WHERE room_id = @location ) And @status is not null )		
        
        UPDATE Room
		SET [status] = @status 
		WHERE room_id = @location;

	ELSE

		PRINT('There does not exist a room with this ID')

 END;

 go

 /*
procedure 2 - 19) Send message to user.
Signature:
Name: SendMessage.
Input: @sender_id int, @receiver_id int, @title varchar(30), @content Varchar(200), @timesent
time, @timereceived time.
Output: Nothing.
*/
CREATE PROCEDURE SendMessage
@sender_id INT,@reciever_id INT,@title varchar(30),
@content varchar(200),@timesent TIME,@timerecieved TIME

AS 
BEGIN 
INSERT INTO Communication VALUES(@sender_id,@reciever_id,@content,@timesent,@timerecieved,NULL,@title);
END;

go


/*

3 - 6

Access cameras in the house.
Signature:
Name: Servailance.
Input: @user_id int, @location int,@camera_id int .
Output: Nothing

*/
CREATE PROC Servailance
@user_id int, @location int,@camera_id int
AS 
BEGIN

	IF ( EXISTS ( SELECT * FROM Users WHERE id = @user_id ) )
	
		IF ( EXISTS ( SELECT * FROM Room WHERE room_id = @location ) )
		
        IF( NOT EXISTS ( SELECT * FROM Camera WHERE monitor_id = @user_id AND camera_id = @camera_id AND room_id = @location ) )
			
            INSERT INTO Camera VALUES ( @user_id, @camera_id, @location ) 
       
       ELSE

            PRINT('Already did this Action')

		ELSE

			PRINT('There does not exist a Room with this ID')

	ELSE

		PRINT('There does not exist a user with this ID')

END;

go


/*

3 - 9

Calculate price of purchasing a certain item.
Signature:
Name: Shopping.
Input: @id int , @quantity int , @total_price decimal(10,2).
Output: @total_price decimal(10,2).

*/

CREATE PROC Shopping
@id int , @quantity int ,
 @total_price decimal(10,2) OUTPUT
 AS 
 BEGIN

	IF ( EXISTS ( SELECT * FROM Inventory WHERE supply_id = @id ) and @quantity is not null ) 
		
        SELECT @total_price = price * @quantity
		FROM Inventory
		WHERE supply_id = @id;

	ELSE
		
		PRINT('There does not exist a supply with this ID')

 END;

 go

 /*
procedure 2 -21) Show all messages received from a spacific user.
Signature:
Name: ShowMessages.
Input: @user_id int, @sender_id int.
Output: Table Containing all details of these massages.
*/
CREATE PROCEDURE ShowMessages
@user_id INT , @sender_id INT
AS 
BEGIN 
IF(@user_id NOT IN(SELECT receiver_id FROM Communication) OR @sender_id NOT IN (SELECT sender_id FROM Communication))RETURN;
SELECT * FROM Communication 
WHERE sender_id = @sender_id AND 
receiver_id = @user_id;
END;

go


/*

3 - 11

Set device consumption for all tablets.
Signature:
Name: TabletConsumption.
Input: @consumption int.
Output: Nothing.

*/
CREATE PROC TabletConsumption
@consumption int
AS
BEGIN
	UPDATE Consumption 
	SET consumption = @consumption
	WHERE device_id
	IN (
		SELECT D.device_id
		FROM Consumption C INNER JOIN Device D ON C.device_id = D.device_id
		WHERE D.[type] = 'Tablet' )
		 
END;

go

CREATE PROCEDURE UnFinishMyTask
@user_id int, @title varchar(50)
AS
BEGIN
if @user_id is not null and @title is not null
begin
update task set [status] = 'Pending' where task_id 
in (select t.task_id from task t 
inner join Assigned_to a 
on t.task_id = a.task_id and a.[user_id]=@user_id And [name]=@title ) ;
end
END;

go

/*
procedure 2 - 12) Uninvite a specific user to an event.
Signature:
Name: Uninvited.
Input: @event_id int, @user_id int.
Output: Nothing.
*/
CREATE PROCEDURE Uninvited 
@event_id INT ,@user_id INT 
AS 
BEGIN
	IF(@user_id NOT IN(SELECT user_assigned_to FROM Calendar) OR @event_id NOT IN(SELECT event_id FROM Calendar))RETURN;
	DELETE FROM Calendar 
    WHERE Calendar.event_id = @event_id AND Calendar.user_assigned_to = @user_id;

END;

go


/*3-23 
Update  incoming  flights. Signature:
Name :  UpdateFlight
Input :  @date  datetime,  @time  time,  @destination  varchar(15) 
Output :  Nothing
*/
CREATE PROCEDURE UpdateFlight
    @date DATETIME,
     @trip_no Int ,
    @destination VARCHAR(15)
AS
BEGIN
    UPDATE Travel
    SET ingoing_flight_date = @date, /* Assuming incoming is ingoing */
        destination = @destination
    WHERE trip_no = @trip_no;
END;

go

 
/*3-14 
Update  log  entries  involving  the  user. Signature:
Name :  UpdateLogEntry
Input :  @user_id  int,  @room_id  int,  @device_id  int,@activity  varchar(30) 
Output :  Nothing */
CREATE PROCEDURE UpdateLogEntry
@user_id  int,  @room_id  int,  
@device_id  int,
@activity  varchar(30)
AS
BEGIN
UPDATE [Log]
    SET
        room_id = @room_id,
        device_id = @device_id,
      activity = @activity
    WHERE
        [user_id] = @user_id
END

go


/*
procedure 2 - 13) Update the deadline of a specific task.
Signature:
Name: UpdateTaskDeadline.
Input: @deadline datetime, @task_id int.
Output: Nothing.
*/

CREATE PROCEDURE UpdateTaskDeadline 
@deadline DATETIME , @task_id INT
AS
BEGIN
    IF(@task_id NOT IN(SELECT Task_id FROM Task))RETURN;
	UPDATE Task SET Task.due_date = @deadline WHERE Task.task_id = @task_id;

END;

go

CREATE PROCEDURE [dbo].[UserLogin]
 @email varchar(50),
 @password varchar(30)
 AS
BEGIN
Declare @user_id int
set @user_id=-1;
if exists (select * from Users where email=@email And [password]=@password) And @email is Not null And @password is Not null
    begin
        select @user_id=id from Users where email=@email And [password]=@password;
    end
select @user_id id;
END

go

CREATE PROCEDURE UserRegister
@usertype varchar(20), 
@email varchar(50), 
@first_name varchar(20),
@last_name varchar(20), 
@birth_date datetime, 
@password varchar(10)
AS
BEGIN
DECLARE @user_id INT;
if (@usertype = 'Admin' And @email Not In (select email from Users) And @usertype is Not null And @email is Not null And @first_name is Not null And @last_name is Not null And @birth_date is Not null And @password is Not null)
begin
insert into  Users (f_Name, l_Name, [password], email, birthdate, [type]) values (@first_name, @last_name, @password, @email, @birth_date, @usertype)
Select @user_id = (select top 1 id from Users where email = @email);
Insert into admin (admin_id) values (@user_id)
end
else 
begin;
THROW 52220,'REPEATED EMAIL',2;
end;
select id from Users where email = @email;
End;

select email from Users ;

go


/*
procedure 2 - 14) View their event given the @event_id and if the @event_id is empty then view all events that
belong to the user order by their date.
Signature:
Name: ViewEvent.
Input: @User_id int, @Event_id int.
Output: Table containing all the events details.
*/

CREATE PROCEDURE ViewEvent 
@User_id INT  , @Event_id INT = NULL 
AS 
BEGIN

	IF @Event_id IS NULL 
	SELECT * FROM Calendar WHERE user_assigned_to = @User_id ORDER BY reminder_date

	ELSE SELECT * FROM Calendar WHERE 
	Calendar.user_assigned_to = @User_id AND 
	Calendar.event_id = @Event_id;

	END;

    go
    
/*3-16
View  the  details  of  the  booked  rooms  given  @user_id  and  @room_id  .  
(If  @room_id  is  not  booked then  show  all  rooms  that  are  booked  by  this  user).
Signature:
Name :  ViewMeeting
Input :  @room_id  int,  @user_id  int
Output :  Table  containing  all  details  of  the  activity  and  table  containing  name  of  each  user */

CREATE PROCEDURE ViewMeeting
    @room_id INT = NULL,
    @user_id INT
AS
BEGIN
IF EXISTS (SELECT 1 FROM Users WHERE room = @room_id) 
BEGIN
        SELECT
            R.*,
            U.f_Name + ' ' + U.l_Name AS UserName
        FROM
            Users U 
            INNER JOIN Room R ON r.room_id = u.room
        WHERE
            U.room = @room_id
            AND R.status = 'booked'
    END
    ELSE
    BEGIN
        SELECT
            R.*,
            U.f_Name + ' ' + U.l_Name AS UserName
        FROM
            Users U 
            INNER JOIN Room R ON r.room_id = u.room
        WHERE
            R.status = 'booked'

    END
END;

go

/*
2-7) View device charge.
Signature:
Name: ViewMyDeviceCharge.
Input: @device_id int.
Output: @charge int, @location int.
*/
CREATE PROCEDURE ViewMyDeviceCharge
@device_id int,
@charge int output
AS
BEGIN
if @device_id is not null
begin
set @charge = (select battery_status from Device where device_id = @device_id);
end
select @charge Charge
END;

go

 
/*3-13
View  Log  entries  involving  the  user. Signature:
Name :  ViewMyLogEntry
Input :  @user_id  int
Output :  Table  containing  all  the  details  of  the  log
*/
CREATE PROCEDURE ViewMyLogEntry
    @user_id INT
AS
BEGIN
    SELECT * 
    FROM [Log]
    WHERE [user_id] = @user_id;
END

go

/*
2-4)View their task. (You should check if the deadline has passed or not if it passed set the status to
done).
Signature:
Name: ViewMyTask.
Input: @user_id int.
Output: Table containing all the details of the tasks.
*/
CREATE PROCEDURE ViewMyTask
@user_id int
AS
BEGIN
if @user_id is not null
begin
update task set [status] = 'done' where task_id
in (select t.task_id from task t 
inner join Assigned_to a
on t.task_id = a.task_id and a.[user_id]=@user_id And due_date< current_timestamp) ;
select * from task where task_id in (select t.task_id from task t inner join Assigned_to a on t.task_id = a.task_id and a.[user_id]=@user_id) ;
end
END

go

/*
2-2) View all the details of my profile.
Signature:
Name: ViewProfile.
Input: @user_id int.
Output: Table containing the user details.
*/
CREATE PROCEDURE ViewProfile
@user_id int
AS
BEGIN
if @user_id is not null And Exists (select * from Users where id = @user_id)
select * from users where id = @user_id ;
END

go

/*
procedure 2 - 15) View users that have no recommendations.
Signature:
Name: ViewRecommendation.
Input: Nothing.
Output: Table containing names of users.

*/ 
CREATE PROCEDURE ViewRecommendation 
AS 
BEGIN 

SELECT f_Name AS First_name, l_Name AS Last_name FROM Users WHERE 
NOT EXISTS(SELECT 1 FROM Recommendation 
WHERE Recommendation.[user_id] = Users.id
);

END;

go

 
/*3-15
View  Log  entries  involving  the  user. Signature:
Name :  ViewMyLogEntry 
Input :  @user_id  int
Output :  Table  containing  all  the  details  of  the  log */
 
CREATE PROCEDURE ViewRoom
AS
BEGIN
    SELECT *
    FROM Room r

    EXCEPT

    SELECT r.*
    FROM Room r INNER JOIN Users u ON r.room_id = u.room
     

END

go

/*
2-3)View the assigned room of each user according to their @user_id ordered according to @age (if
there is no value given for @age then show details of the room that is assigned to @user_id, if
@user_id is also empty then show all the details of the room).
Signature:
Name: ViewRooms.
Input: @age int, @user_id int.
Output: Table containing Room details.
*/
-- age parameter doesn't make any sense
CREATE PROCEDURE ViewRooms
@age int = null,
@user_id int = null
AS
BEGIN
if @user_id is not null
select r.* from Users u inner join Room r on u.room=r.room_id where u.id=@user_id order by u.age
else
begin
if @age is not null
select * from Room r inner join Users u on r.room_id=u.room where u.age=@age --order by age nonsensible
else
select * from Room r
end
END

go

/*
2-6) View task status given the @user_id and the @creator of the task. (The recently created reports
should be shown first).
Signature:
Name: ViewTask.
Input: @user_id int, @creator int.
Output: Table containing all details of the task(s).
*/
CREATE PROCEDURE ViewTask
@user_id int, @creator int
AS
BEGIN
if @user_id is not null and @creator is not null
begin
select t.* from task t 
inner join Assigned_to a 
on t.task_id = a.task_id where a.[user_id]=@user_id And t.creator =@creator 
Order by t.creation_date Desc  ;
end
END;

go


CREATE PROC ViewUsers
@user_type varchar(20)
AS 
BEGIN
	IF @user_type is not null
		SELECT * 
		FROM Users
		WHERE [type] = @user_type
END;

go



/* 3 - 30
Get the youngest user in the system (hint : use limit).
Signature:
Name: Youngest.
Input: Nothing.
Output: The youngest user in the system.
*/
CREATE PROCEDURE Youngest
AS
BEGIN
SELECT TOP 1 *
FROM Users
ORDER BY age 
END;

go






