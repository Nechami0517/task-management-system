--use master
--go
--CREATE DATABASE [project]
USE [project]
create table [Users]
(
[UserId] int identity(100,1) primary key,
[UserName] varchar(20) not null,
[password] nvarchar(10) not null unique,
[managerId] int foreign key references [Users](UserId)

)

create table [statusim]
(
[statusId] int identity(1,1) primary key ,
[statusName] varchar(15) not null
)
create table [task]
(
[TaskId] int identity(1,1) primary key,
[DateCreateTask] date not null,
[TaskContent] varchar(200),
[TaskCreatorId] int foreign key references [Users](UserId),
[TaskperformId] int foreign key references [Users](UserId),
[status] int not null foreign key references [statusim](statusId),
[DateOfStatusChange] date not null,
[fatherTaskID] int foreign key references [task](taskId)
)









