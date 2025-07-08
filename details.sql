use [project]
--הכנסת נתונים לטבלות
--users
 insert into [Users] ([UserName],[password])
 values('נחמי שורץ','2153')
 insert into [Users] ([UserName],[password])
 values('מיכל בושריאן','מיכל58')
 insert into [Users]([UserName],[password])
 values('שני כהן','sc123')
 insert into [Users]
 values('רינה לוי','rl456',101)
 insert into [Users]
 values('אסתר לב','ef789',103)
 insert into [Users]
 values('טלי לוין','tl1112',100)
 select *
 from users
 --statusim
 insert into statusim
 values('ממתין לטיפול')
 insert into statusim
 values('בטיפול')
 insert into statusim
 values('בוצע')
 insert into statusim
 values('בוטל')
 select *
 from statusim

 --task
insert into task ([DateCreateTask],[TaskContent],[TaskCreatorId],[TaskperformId],[status],[DateOfStatusChange])
values('2024-03-21','להכין משלוחי מנות',100,101,1,'2024-03-21')
insert into task
values('2024-03-21','לקנות צלופנים',101,103,2,'2024-03-21',1)
insert into task
values('2024-03-21','להוציא כסף מהבנק',103,103,2,'2024-03-21',2)

 select *
 from task