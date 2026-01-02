DROP DATABASE IF EXISTS company;
create database company;
use company;

create table employee(
e_name varchar(200) not null,
e_id int primary key ,
e_adress varchar(222),
e_phone varchar(222) not null
)
;

insert into employee (
e_name, e_id , e_adress, e_phone )

values( 'bob', 12, 'deeee', '33w'
)
;
select * 
from employee

