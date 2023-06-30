CREATE TABLE [dbo].[input](
	[orderID] [int] NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
	[Value] [float] NOT NULL);

GO

INSERT INTO [dbo].[input] ([orderID],[Type],[Value]) VALUES (1,'Cash',10.00);
INSERT INTO [dbo].[input] ([orderID],[Type],[Value]) VALUES (1,'Credit',25.00);
INSERT INTO [dbo].[input] ([orderID],[Type],[Value]) VALUES (1,'Debit',8.50);
INSERT INTO [dbo].[input] ([orderID],[Type],[Value]) VALUES (2,'Credit',6.75);
INSERT INTO [dbo].[input] ([orderID],[Type],[Value]) VALUES (2,'Debit',4.25);
INSERT INTO [dbo].[input] ([orderID],[Type],[Value]) VALUES (3,'Cash',7.80);
INSERT INTO [dbo].[input] ([orderID],[Type],[Value]) VALUES (4,'Credit',15.20);
INSERT INTO [dbo].[input] ([orderID],[Type],[Value]) VALUES (4,'Credit',10.80);
INSERT INTO [dbo].[input] ([orderID],[Type],[Value]) VALUES (5,'Cash',4.21);
INSERT INTO [dbo].[input] ([orderID],[Type],[Value]) VALUES (6,'Cash',5.00);
INSERT INTO [dbo].[input] ([orderID],[Type],[Value]) VALUES (6,'Cash',10.00);
INSERT INTO [dbo].[input] ([orderID],[Type],[Value]) VALUES (6,'Credit',15.00);

select [orderID], FORMAT(coalesce([Cash],0.00),'N') Cash, 
FORMAT(coalesce([Credit],0.00),'N') Credit, 
FORMAT(coalesce([Debit],0.00),'N') Debit 
from [dbo].[input] PIVOT(
SUM(Value) FOR [Type] IN ([Cash], [Credit],[Debit])
) as P