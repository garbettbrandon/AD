create or replace type direccion as object(
	calle varchar2(25),
	ciudad varchar2(20),
	cod_post number(5)
);
/

create or replace type tabla_anidada as table of direccion;
/

drop table ejemplo_tabla_anidada;
create table ejemplo_tabla_anidada(
	id number(2),
	apellido varchar2(30),
	direc tabla_anidada 
)nested table direc store as Direc_anidada;

insert into ejemplo_tabla_anidada values (1, 'Ramos', tabla_anidada(
direccion('Calle Manantiales, 2','GUADALAJARA',19984),
direccion('Calle Manantiales, 14','GUADALAJARA',19984),
direccion('Calle Paris, 78','CACERES',10005),
direccion('Calle Segovia, 89','TOLEDO',45555)
));

insert into ejemplo_tabla_anidada values (2, 'Martin', tabla_anidada(
direccion('Calle Huesca, 2','ALCALA DE HENARES',28008),
direccion('Calle Madrid, 14','ALCORCON',28999)
));

desc tabla_anidada;
desc ejemplo_tabla_anidada;
select * from ejemplo_tabla_anidada;

select e.direc from ejemplo_tabla_anidada e where e.id = 1;

select dir.calle from ejemplo_tabla_anidada e, table(e.direc) dir where e.id = 1;


update table (select direc from ejemplo_tabla_anidada where id=1) primera set value (primera) = direccion ('C/ Pinzon, 13', 'TOLEDO', 45555) where value (primera) = direccion('Calle Manantiales, 2', 'GUADALAJARA', 19984);

select e.direc from ejemplo_tabla_anidada e where e.id = 1;

insert into table (select e.direc from ejemplo_tabla_anidada e where id = 1) values (direccion('Calle de los naranjos, 99', 'MURCIA', 78788));

select direc from ejemplo_tabla_anidada where id = 1;



select dir.calle from ejemplo_tabla_anidada e, table(e.direc) dir where e.id = 1;

update ejemplo_tabla_anidada set direc = tabla_anidada(direccion('Calle Sol, 2', 'MADRID', 19984),direccion('Calle Luna, 2', 'MURCIA', 19984), direccion('Calle Cielos, 2', 'BURGOS', 19984)) where id = 1;

select dir.* from ejemplo_tabla_anidada e, table(e.direc) dir where e.id = 1;


delete from table(select e.direc from ejemplo_tabla_anidada e where id = 1) primera where value (primera) = direccion('Calle Cielos, 2', 'BURGOS', 19984);

select direc from ejemplo_tabla_anidada where id = 1;

select dir.* from ejemplo_tabla_anidada e, table(e.direc) dir where e.id = 1;

--Seleccionar filas de una tabla anidada con clausula THE

select calle from the (
	select e.direc 
	from ejemplo_tabla_anidada e
	where id = 1
	)
where ciudad = 'MURCIA';


--Seleccionar filas de una tabla anidada con clausula TABLE

select dir.calle 
from ejemplo_tabla_anidada e, table (e.direc) dir
where e.id = 1 and dir.ciudad = 'MURCIA';

--Procedimiento que reciba id y muestre las calles

create or replace procedure ver_direc(ident number) as

cursor c1 is select calle from the (
				select e.direc 
				from ejemplo_tabla_anidada e 					where id = ident
				);
begin
	for i in c1 loop
		dbms_output.put_line(i.calle);
	end loop;
end;
/

set serveroutput on;
begin
	ver_direc(1);
end;
/

execute ver_direc(1);


--Con TABLE

create or replace procedure ver_direc2(ident number) as

cursor c1 is 	select dir.calle 
		from ejemplo_tabla_anidada e, 
		TABLE(e.direc) dir 
		where e.id = ident;
begin
	for i in c1 loop
		dbms_output.put_line(i.calle);
	end loop;
end;
/

set serveroutput on;
begin
	ver_direc2(2);
end;
/