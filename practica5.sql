create or replace type empleado as object(

	rut varchar2(10),
	nombre varchar2(9),
	cargo varchar2(9),
	fechaIng date,
	sueldo number(9),
	comision number(9),
	anticipo number(9),
	
	member function sueldo_liquido return number,
	member procedure aumento_sueldo(aumento number)	
);
/

create or replace type body empleado as
	member function sueldo_liquido return number is
	begin
		return(sueldo + comision) - anticipo;
	end;
	member procedure aumento_sueldo (aumento number) is
	begin
		sueldo := sueldo + aumento;
	end;
end;
/

alter type empleado replace as object (
	rut varchar2(10),
	nombre varchar2(9),
	cargo varchar2(9),
	fechaIng date,
	sueldo number(9),
	comision number(9),
	anticipo number(9),
	member function sueldo_liquido return number,
	member procedure aumento_sueldo(aumento number),
	member procedure setAnticipo (anticipo number)	
);
/

create or replace type body empleado as
	member function sueldo_liquido return number is
	begin
		return(sueldo + comision) - anticipo;
	end;
	member procedure aumento_sueldo (aumento number) is
	begin
		sueldo := sueldo + aumento;
	end;
	member procedure setAnticipo (anticipo number) is
	begin
		self.anticipo := anticipo;
	end;	
end;
/

drop table empleados;
create table empleados of empleado;
insert into empleados values ('1','Pepa','Directora',sysdate,2000,500,0);
insert into empleados values ('2','Juana','Comercial',sysdate,1000,800,0);
insert into empleados values ('3','Rosa','Comercial',sysdate,1000,800,0);

set serveroutput on;

declare
	empl empleado;
begin
	select value (e) into empl from empleados e where e.rut='1';
	dbms_output.put_line(empl.nombre||' '||empl.cargo||' Sueldo: '||empl.sueldo||' Sueldo liquido: '||empl.sueldo_liquido());
	empl.aumento_sueldo(400);
	dbms_output.put_line(empl.nombre||' '||empl.cargo||' Sueldo: '||empl.sueldo||' Sueldo liquido: '||empl.sueldo_liquido());
	update empleados set sueldo = empl.sueldo where e.rut = 1;
end;
/