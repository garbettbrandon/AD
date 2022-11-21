create or replace type tabla_hijos as table of varchar2(30);
/

drop table staff;
create table staff (
	id number,
	nombre varchar2(30),
	apellidos varchar2(30),
	hijos tabla_hijos
)
nested table hijos store as t_hijos
/


select object_name, object_type, status 
from all_objects 
where object_name like '%HIJO%';


insert into staff values (1, 'Fernando', 'Moreno', tabla_hijos('Elena', 'Pablo'));
insert into staff values (2, 'David', 'Sanchez', tabla_hijos('Carmen', 'Candela'));

select * from the(
		select s.hijos 
		from staff s 
		where s.id = 1
		);
	
select st.* 
from staff s, TABLE (s.hijos) st 
where s.id = 2;

update staff set hijos = tabla_hijos('Carmen', 'Candela', 'Cayetana')
where id = 1;

select st.* 
from staff s, TABLE (s.hijos) st 
where s.id = 1;

select st.* 
from staff s, TABLE (s.hijos) st;
