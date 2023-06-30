
CREATE TABLE [dbo].[products](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];


CREATE TABLE [dbo].[side](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] ;

CREATE TABLE [dbo].[ingredients](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];

CREATE TABLE [dbo].[wish](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];

CREATE TABLE [dbo].[wishline](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[wishid] [int]  NOT NULL,
	[productid] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];

CREATE TABLE [dbo].[sideline](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[wishlineid] [int] NOT NULL,
	[sideid] [int] NOT NULL,
	[ingredientid] [int] NOT NULL,

PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY];

GO

INSERT INTO [dbo].[products] ([name]) VALUES ('Pizza 16"');
INSERT INTO [dbo].[products] ([name]) VALUES ('Pizza 10"');

INSERT INTO [dbo].[side] ([name]) VALUES ('ALL');
INSERT INTO [dbo].[side] ([name]) VALUES ('Left Side');
INSERT INTO [dbo].[side] ([name]) VALUES ('Right Side');
INSERT INTO [dbo].[side] ([name]) VALUES ('Right Side');
INSERT INTO [dbo].[side] ([name]) VALUES ('Center');

INSERT INTO [dbo].[ingredients] ([name]) VALUES ('Cheese');
INSERT INTO [dbo].[ingredients] ([name]) VALUES ('Onion');
INSERT INTO [dbo].[ingredients] ([name]) VALUES ('Pepperoni');
INSERT INTO [dbo].[ingredients] ([name]) VALUES ('Green Pepper');
INSERT INTO [dbo].[ingredients] ([name]) VALUES ('Anchovies');
INSERT INTO [dbo].[ingredients] ([name]) VALUES ('Salami');

INSERT INTO [dbo].[wish] ([name]) VALUES ('Wish Test');

INSERT INTO [dbo].[wishline] ([wishid],[productid]) VALUES (1,1);

INSERT INTO [dbo].[sideline] ([wishlineid],[sideid],[ingredientid]) VALUES (1,2,1);
INSERT INTO [dbo].[sideline] ([wishlineid],[sideid],[ingredientid]) VALUES (1,2,2);
INSERT INTO [dbo].[sideline] ([wishlineid],[sideid],[ingredientid]) VALUES (1,3,3);
INSERT INTO [dbo].[sideline] ([wishlineid],[sideid],[ingredientid]) VALUES (1,3,4);
INSERT INTO [dbo].[sideline] ([wishlineid],[sideid],[ingredientid]) VALUES (1,2,5);
INSERT INTO [dbo].[sideline] ([wishlineid],[sideid],[ingredientid]) VALUES (1,3,6);


DECLARE @table_result TABLE( product NVARCHAR(50), side NVARCHAR(50), ingredient NVARCHAR(50));
DECLARE @product NVARCHAR(50);
DECLARE @side NVARCHAR(50);
DECLARE @ingredient NVARCHAR(50);
DECLARE @productb NVARCHAR(50);
DECLARE @sideb NVARCHAR(50);
DECLARE table_cursor CURSOR
FOR
Select p.name as product, s.name as side,  i.name as ingredient
from wish w inner join wishline wl on wl.wishid = w.id 
inner join sideline sl on sl.wishlineid = wl.id
inner join products p on wl.productid = p.id
inner join ingredients i on sl.ingredientid = i.id
inner join side s on sl.sideid = s.id
order by p.id, s.id;
set @productb = ' ';
set @sideb = ' ';

OPEN table_cursor
FETCH NEXT FROM table_cursor
INTO @product,@side ,@ingredient
WHILE @@FETCH_STATUS = 0
BEGIN
	if @productb != @product 
		begin	
			insert @table_result values(@product, ' ', ' ');
			insert @table_result values(' ', @side, ' ');
		end
	else
		if @sideb != @side 
			insert @table_result values(' ', @side, ' ');
	insert @table_result values(' ', ' ',@ingredient);
	set @productb = @product;
	set @sideb = @side;
	FETCH NEXT FROM table_cursor
	INTO @product,@side ,@ingredient
END;
CLOSE table_cursor;
DEALLOCATE table_cursor;
SELECT * FROM @table_result;
