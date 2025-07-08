use [project]
--1 פונקציה לזיהוי משתמש
go
create function identification (@userName varchar(20), @password nvarchar(10)) returns int
as
begin
if( @userName not in (select userName  from Users))
return 0;
--יש משתמש ובדיקה האם הסיסמה שהתקבלה שווה לסיסמה של שם זה  
if(@password = (select password  from Users where UserName=@userName))
return (select UserId 
        from Users
		where @password=[password])
return -1
end

--הפעלה של הפונקציה
select *
from Users
where UserId=(select dbo.identification('נחמי שורץ','2153'))
              
--2 פונקציה לשליפת עובדים כפופים
 go
 create function the_workers_below (@userId int) returns @tbl table(UserId int,UserName varchar(20))
 as
 begin
 with workers_below
 as
 (
 select UserId ,UserName
 from Users
 where managerId=@userId
 union all
 select Users.UserId ,Users.UserName
 from Users join workers_below on
 users.managerId=workers_below.UserId
 )
 insert into @tbl
 select *
 from workers_below
 return
 end 
 --הפעלה של הפונקציה
 select *
 from dbo.the_workers_below(101)
 --3 פונקציה לשליפת משימה וכל תתי המשימות שלה
 go
create function Retrieving_all_subtasks (@taskId int) returns @tbl table (taskId int,
                                                                           [TaskContent] varchar(200))
as
begin
with Retrieving_subtasks 
as
(
select taskId,TaskContent
from task
where TaskId=@taskId
union all
select task.taskId,task.TaskContent
from task join Retrieving_subtasks on
task.[fatherTaskID]=Retrieving_subtasks.TaskId
)
insert into @tbl
select *
from Retrieving_subtasks
return
end
 --הפעלה של הפונקציה
select *
from Retrieving_all_subtasks(1)
 --פונקציה לשליפת אבות משימה4 
 go
 create function fathersTask(@taskId int) returns @tbl table(taskId int,[TaskContent] varchar(200))
 as
 begin
 with fatherTask
 as
 (
select taskId,TaskContent,[fatherTaskID]
from task
where TaskId=@taskId
union all
select task.taskId,task.TaskContent,task.[fatherTaskID]
from task join fatherTask on
task.TaskId=fatherTask.[fatherTaskID]
 )
 insert into @tbl
select taskId,TaskContent
from fatherTask
return
 end
 --הפעלה של הפונקציה
select *
from fathersTask(3)
--5 פרוצדורת שינוי סטטוס למשימה
go
create proc ChangeStatus (@taskId int,@status int)
as
update task
set [status]=@status,DateOfStatusChange=GETDATE()
where TaskId=@taskId
 --הפעלה של הפרוצדורה
exec ChangeStatus 3,3
select *
from task
--6 טריגר עדכון סטטוס למשימה
go
alter trigger checkStatusim1
on task
after update
as
begin
declare @taskId int =(select taskId from inserted)
if ((select [status] from inserted)!=3)
return
if((select count([status])
from task
where fatherTaskID=@taskId)=0)
return

if(3=all(select [status]
from task
where fatherTaskID=@taskId))
exec ChangeStatus @taskId,3
else
exec ChangeStatus @taskId,2
end
--הפעל
exec ChangeStatus 2,3
select *
from task
go
CREATE trigger checkStatusim
on task
after update
as
begin
declare @fathertaskId int =(select fathertaskId from inserted)
if ((select [status] from inserted)!=3)
return
if(3=all(select [status]
from task
where fatherTaskID=@fathertaskId))
exec ChangeStatus @fathertaskId,3
end
--הפעלה של הטריגר
exec ChangeStatus 11,3
select *
from task
--7 פרוצדורת הוספה לטבלת משימות
go
CREATE proc addTask (@DateCreateTask date, @TaskContent nvarchar(100),@TaskCreatorId int
,@TaskperformId int, @fatherTaskID int)
as
if(@TaskperformId in (select userid from the_workers_below(@TaskCreatorId)))
begin
     insert into task 
     values(@DateCreateTask , @TaskContent ,@TaskCreatorId ,@TaskperformId 
     ,1,getDate(), @fatherTaskID )
end
else
throw 50001,'לא ניתן להוסיף משימה למשתמש שאינו כפוף ליוצר המשימה',1
 --הפעלה של הפרוצדורה
 declare @date date=getdate()
exec addTask  @date,'לשטוף צלחות',100,102,null
select *
from task
--8 פרוצדורת הוספת משימות כלליות
go
CREATE proc addGeneralTask (@fatherTaskID int,@TaskContent nvarchar(100))
as
begin tran
declare @userid int
begin try
declare group_of_worker cursor for
select UserId
from Users
where managerId=@fatherTaskID

open group_of_worker
fetch next from group_of_worker into @userid
while @@FETCH_STATUS=0
begin
exec addTask '2024-03-07',@TaskContent,@fatherTaskID,@userid,null
fetch next from group_of_worker into @userid
end
close group_of_worker
deallocate group_of_worker
commit
end try
begin catch
print error_message()
close group_of_worker
deallocate group_of_worker
rollback
end catch

--הפעלה של הפרוצדורה
exec addGeneralTask 100,'home work'
select *
from task
--9 טריגר למחיקת משימות ישנות--
go
CREATE trigger deletingOldTask
on task
after insert
as
begin
delete from task
where taskid in (select taskid from
                (select taskid, ROW_NUMBER() over (partition by [status] order by DateOfStatusChange desc) as number
                 from task where [status]=3 and TaskperformId=(select TaskperformId
                                    from inserted))as t
				where number>3)
end

insert into task
values('2024-03-21','לקנות חלב',100,101,2,'2024-03-21',2)

select *
from task
 --11 פונקצית שליפת משימות למשתמש 
 go
 CREATE function retrievingTasks (@UserName varchar(20),@passward nvarchar(15))
 returns @tbl table (taskid int,
 [DateCreateTask] date,
 [TaskContent] varchar(100),
 [TaskCreatorId] int,
 [TaskperformId] int,
 [status] int,
 [DateOfStatusChange] date,
 fatherTaskID int,
 sign1 nvarchar(3))
 as
 begin
 if((select dbo.identification(@UserName,@passward))<0)
 return
 else
 begin
 declare @userid int = ( dbo.identification(@UserName,@passward))
 insert into @tbl
 select *,(case when [status]=3 then 'v'
               when [status]=4 then 'x'
			   when [status]=2 and DATEDIFF(mm,DateOfStatusChange,getdate())<3 then '!'
			    when [status]=1 and DATEDIFF(mm,DateOfStatusChange,getdate())<3 then '!'
			   else '!!!'
			   end)
 from task
 where TaskperformId=@userid
end  
return	 
 end

 select *
 from Users
 select *
 from dbo.retrievingTasks('מיכל בושריאן','מיכל58')
 