use [project]
--����� ������ ������
--users
 insert into [Users] ([UserName],[password])
 values('���� ����','2153')
 insert into [Users] ([UserName],[password])
 values('���� �������','����58')
 insert into [Users]([UserName],[password])
 values('��� ���','sc123')
 insert into [Users]
 values('���� ���','rl456',101)
 insert into [Users]
 values('���� ��','ef789',103)
 insert into [Users]
 values('��� ����','tl1112',100)
 select *
 from users
 --statusim
 insert into statusim
 values('����� ������')
 insert into statusim
 values('������')
 insert into statusim
 values('����')
 insert into statusim
 values('����')
 select *
 from statusim

 --task
insert into task ([DateCreateTask],[TaskContent],[TaskCreatorId],[TaskperformId],[status],[DateOfStatusChange])
values('2024-03-21','����� ������ ����',100,101,1,'2024-03-21')
insert into task
values('2024-03-21','����� �������',101,103,2,'2024-03-21',1)
insert into task
values('2024-03-21','������ ��� �����',103,103,2,'2024-03-21',2)

 select *
 from task