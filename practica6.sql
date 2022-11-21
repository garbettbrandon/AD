create or replace type colec_hijos as varray(10) of varchar2(30);
/

drop table emp6;
create table emp6(
	idemp number,
	nombre varchar2(30),
	apellido varchar2(30),
	hijos colec_hijos
);

insert into emp6 values (1, 'Francisco', 'Perez', colec_hijos('Luis','Ursula'));
insert into emp6 values (2, 'Esperanza', 'Jimenez', colec_hijos('Carlos','Pedro','Ignacio'));

select * from emp6;

select e.hijos from emp6 e where idemp = 1;

set serveroutput on;

declare 
	v_hijos colec_hijos;
	cuenta number;
begin
	select e.hijos into v_hijos from emp6 e where e.idemp = 1;
	cuenta := v_hijos.count;
	dbms_output.put_line('Total de hijos: '||cuenta);
end;
/


declare
	cursor c_hijos is select * from emp6;
	v_id number;
	v_nombre varchar2(30);
	v_apellido varchar2(30);
	v_hijos colec_hijos;
begin
	open c_hijos;
	loop
		fetch c_hijos into v_id, v_nombre, v_apellido, v_hijos;
		exit when c_hijos%notfound;
		dbms_output.put_line('ID: '||v_id||' Nombre: '||v_nombre||' Apellido: '||v_apellido);
		for i in v_hijos.FIRST .. v_hijos.LAST loop
			dbms_output.put_line('El hijo '||i||' se llama: '||v_hijos(i));
		end loop;
	end loop;
end;
/

declare
	cursor c_hijos is select * from emp6;
	cuenta number;
	v_id number;
	v_nombre varchar2(30);
	v_apellido varchar2(30);
	v_hijos colec_hijos;
begin
	open c_hijos;
	loop
		fetch c_hijos into v_id, v_nombre, v_apellido, v_hijos;
		exit when c_hijos%notfound;
		dbms_output.put_line('ID: '||v_id||' Nombre: '||v_nombre||' Apellido: '||v_apellido);
		cuenta := v_hijos.count;
		dbms_output.put_line('Total de hijos: '||cuenta);
	end loop;
end;
/

declare
	hijo colec_hijos;
begin
	select hijos into hijo from emp6 where idemp = 1;
	for i in hijo.FIRST .. hijo.LAST loop
		dbms_output.put_line('EL hijo: '||i||' se llama: '||hijo(i));
	end loop;
	hijo.extend;
	hijo(hijo.last) := 'Tony';
	dbms_output.put_line('Hijos despues de añadir');
	for i in hijo.FIRST .. hijo.LAST loop
		dbms_output.put_line('EL hijo: '||i||' se llama: '||hijo(i));
	end loop;
end;
/


declare 
	v_hijos colec_hijos;
	i number;
	j number;
	cuenta number;
begin
	select hijos into v_hijos from emp6 e where e.idemp=1;
	for i in v_hijos.first .. v_hijos.last loop
		dbms_output.put_line('EL hijo: '||i||' se llama: '||v_hijos(i));
	end loop;
	v_hijos.extend(3,1);
	dbms_output.put_line('Hijos despues de añadir');
	for i in v_hijos.FIRST .. v_hijos.LAST loop
		dbms_output.put_line('EL hijo: '||i||' se llama: '||v_hijos(i));
	end loop;
end;
/

drop table emp6_hijos;
create table emp6_hijos(
	id number primary key,
	nombre varchar2(10),
	apellido varchar2(10),
	hijo colec_hijos
);

insert into emp6_hijos values (1,'Teresa', 'Lopez', colec_hijos('Ana','Rosa','Pepa'));
insert into emp6_hijos values (2, 'Natalia','Cabrera', colec_hijos('Carlos','Pedro','Ignacio'));


declare 
	i colec_hijos;
begin
	select hijo into i from emp6_hijos where id=1;
	i.extend;
	i(i.last) := 'Antonio';
	update emp6_hijos set hijo = i where id = 1;
end;
/
	
select * from emp6_hijos;
	
	
	
