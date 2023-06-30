SELECT DATEPART(WEEKDAY, GETDATE())

SELECT DATENAME(WEEKDAY, GETDATE())

SELECT DATENAME(MONTH, GETDATE())

SELECT DATEPART(DAY, GETDATE())


CREATE TABLE [dbo].[staff](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];

CREATE TABLE [dbo].[clock](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[staffid] [int] NOT NULL,
	[startdate] [datetime] NOT NULL,
	[stopdate] [datetime] NOT NULL,

PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];

GO


INSERT INTO [dbo].[staff] ([name]) VALUES ('Admin');

INSERT INTO [dbo].[staff] ([name]) VALUES ('Peter');

INSERT INTO [dbo].[clock] ([staffid],[startdate],[stopdate]) VALUES (2,'08-08-18 7:00 AM','08-08-18 1:00 PM');

INSERT INTO [dbo].[clock] ([staffid],[startdate],[stopdate]) VALUES (2,'08-09-18 10:00 AM','08-09-18 6:00 PM');

INSERT INTO [dbo].[clock] ([staffid],[startdate],[stopdate]) VALUES (2,'08-10-18 8:00 AM','08-10-18 2:00 PM');

INSERT INTO [dbo].[clock] ([staffid],[startdate],[stopdate]) VALUES (1,'08-10-18 8:00 AM','08-10-18 2:00 PM');

INSERT INTO [dbo].[clock] ([staffid],[startdate],[stopdate]) VALUES (2,'08-07-18 8:00 AM','08-07-18 2:00 PM');

INSERT INTO [dbo].[clock] ([staffid],[startdate],[stopdate]) VALUES (2,'08-21-18 8:00 AM','08-21-18 2:00 PM');

DECLARE @table_result TABLE( staffname NVARCHAR(50), one NVARCHAR(50), two NVARCHAR(50), 
	three NVARCHAR(50), four NVARCHAR(50), five NVARCHAR(50), six NVARCHAR(50), seven NVARCHAR(50)
);
DECLARE @staffid int;
DECLARE @staffidt int;
DECLARE @weekname NVARCHAR(50);
DECLARE @employee NVARCHAR(50);
DECLARE @startdate DATETIME;
DECLARE @diffhour int;
DECLARE @weekid int;
DECLARE @weekidt int;
DECLARE @daynum int;
DECLARE @i int;
DECLARE @firstdate DATETIME;
DECLARE @lastdate DATETIME;
DECLARE @one NVARCHAR(50);
DECLARE @two NVARCHAR(50);
DECLARE @three NVARCHAR(50);
DECLARE @four NVARCHAR(50);
DECLARE @five NVARCHAR(50);
DECLARE @six NVARCHAR(50);
DECLARE @seven NVARCHAR(50);
DECLARE @name NVARCHAR(50);
DECLARE @tempdate DATETIME;
DECLARE @nameMonthS NVARCHAR(50);
DECLARE @nameMonthL NVARCHAR(50);
DECLARE @nameTo NVARCHAR(50);

DECLARE table_cursor CURSOR
FOR
select * from (
select staff.id staffid, staff.name  employee, clock.startdate,
DATEDIFF ( hh , clock.startdate , clock.stopdate) diffhour,
DATEPART(WEEK, clock.startdate) weekid,
DATEPART(WEEKDAY, clock.startdate) daynum
from clock inner join staff on clock.staffid = staff.id) Temp
order by weekid,staffid,daynum;
set @weekidt = 0;
set @staffidt = 0;
set @i = 0;
OPEN table_cursor
FETCH NEXT FROM table_cursor
INTO @staffid, @employee, @startdate, @diffhour, @weekid, @daynum
WHILE @@FETCH_STATUS = 0
BEGIN
	if (@weekidt != @weekid)
	BEGIN
		set  @firstdate = DATEADD(DAY,-1*@daynum+1,@startdate);
		set @lastdate = DATEADD(DAY,6,@firstdate);
		if DATENAME(MONTH, @firstdate) = DATENAME(MONTH, @lastdate)
			set @nameTo = ' to '+ cast(DATEPART(DAY, @lastdate) AS nvarchar);
		else
			set @nameTo = ' to '+ DATENAME(MONTH, @lastdate) + ' ' + cast(DATEPART(DAY, @lastdate) AS nvarchar);
		set @weekname = DATENAME(MONTH, @firstdate) + ' ' + cast(DATEPART(DAY, @firstdate) AS nvarchar) + @nameTo;
			
		insert @table_result values(@weekname,' ', ' ', ' ', ' ', ' ', ' ', ' ');
		set @one = LEFT(DATENAME(WEEKDAY, @firstdate),3) + ' ' + 
				CAST(DATEPART(DAY, @firstdate) as nvarchar);
		set @tempdate = DATEADD(DAY,1,@firstdate);
		set @two = LEFT(DATENAME(WEEKDAY, @tempdate),3) + ' ' + 
				CAST(DATEPART(DAY, @tempdate) as nvarchar);
		set @tempdate = DATEADD(DAY,2,@firstdate);
		set @three = LEFT(DATENAME(WEEKDAY, @tempdate),3) + ' ' + 
				CAST(DATEPART(DAY, @tempdate) as nvarchar);
		set @tempdate = DATEADD(DAY,3,@firstdate);
		set @four = LEFT(DATENAME(WEEKDAY, @tempdate),3) + ' ' + 
				CAST(DATEPART(DAY, @tempdate) as nvarchar);
		set @tempdate = DATEADD(DAY,4,@firstdate);		
		set @five = LEFT(DATENAME(WEEKDAY, @tempdate),3) + ' ' + 
				CAST(DATEPART(DAY, @tempdate) as nvarchar);
		set @tempdate = DATEADD(DAY,5,@firstdate);
		set @six = LEFT(DATENAME(WEEKDAY, @firstdate),3) + ' ' + 
				CAST(DATEPART(DAY, @tempdate) as nvarchar);
		set @tempdate = DATEADD(DAY,6,@firstdate);
		set @seven = LEFT(DATENAME(WEEKDAY, @tempdate),3) + ' ' + 
				CAST(DATEPART(DAY, @tempdate) as nvarchar);
		insert @table_result values('Staff hours',@one, @two, @three, @four, @five, @six, @seven);
		set @weekidt = @weekid;
	END
	set @one = '-';
	set @two = '-';
	set @three = '-';
	set @four = '-';	
	set @five = '-';
	set @six = '-';
	set @seven = '-';
	set @name = @employee;
	if @daynum = 1 
		BEGIN
			set @one = cast(@diffhour as nvarchar);
			FETCH NEXT FROM table_cursor
			INTO @staffid, @employee, @startdate, @diffhour, @weekid, @daynum
		END
	if (@daynum = 2 and @@FETCH_STATUS = 0 and @weekid = @weekidt and @staffid = @staffid)
		BEGIN
			set @two = cast(@diffhour as nvarchar);
			FETCH NEXT FROM table_cursor
			INTO @staffid, @employee, @startdate, @diffhour, @weekid, @daynum
		END
	if (@daynum = 3 and @@FETCH_STATUS = 0 and @weekid = @weekidt and @staffid = @staffid)
		BEGIN
			set @three = cast(@diffhour as nvarchar);
			FETCH NEXT FROM table_cursor
			INTO @staffid, @employee, @startdate, @diffhour, @weekid, @daynum
		END
	if (@daynum = 4 and @@FETCH_STATUS = 0 and @weekid = @weekidt and @staffid = @staffid)
		BEGIN
			set @four = cast(@diffhour as nvarchar);
			FETCH NEXT FROM table_cursor
			INTO @staffid, @employee, @startdate, @diffhour, @weekid, @daynum
		END
	if (@daynum = 5 and @@FETCH_STATUS = 0 and @weekid = @weekidt and @staffid = @staffid)
		BEGIN
			set @five = cast(@diffhour as nvarchar);
			FETCH NEXT FROM table_cursor
			INTO @staffid, @employee, @startdate, @diffhour, @weekid, @daynum
		END
	if (@daynum = 6 and @@FETCH_STATUS = 0 and @weekid = @weekidt and @staffid = @staffid)
		BEGIN
			set @six = cast(@diffhour as nvarchar);
			FETCH NEXT FROM table_cursor
			INTO @staffid, @employee, @startdate, @diffhour, @weekid, @daynum
		END
	if (@daynum = 7 and @@FETCH_STATUS = 0 and @weekid = @weekidt and @staffid = @staffid)
		BEGIN
			set @six = cast(@diffhour as nvarchar);
			FETCH NEXT FROM table_cursor
			INTO @staffid, @employee, @startdate, @diffhour, @weekid, @daynum
		END
	insert @table_result values(@name,@one, @two, @three, @four, @five, @six, @seven);	
END;
CLOSE table_cursor;
DEALLOCATE table_cursor;
SELECT * FROM @table_result;