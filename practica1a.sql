create or replace type direccion as object (
calle varchar2(25),
ciudad varchar2(20),
codigo_post number(5)
);

create or replace type persona as object (
codigo number,
nombre varchar2(35),
direc direccion,
fecha_nac date
);
/

create table alumnos of persona(codigo primary key);

declare
dir direccion := direccion(null,null,null);
p persona := persona(null,null,null);
begin

	dir.calle := 'La mina, 3';
	dir.ciudad := 'GUADALAJARA';
	dir.codigo := 19001;
	p.codigo := 1;
	p.nombre := 'Juan';
	p.direc := dir;
	p.fecha_nac := '1/11/1988';
	insert into alunnos values(p);
	commit;
end;
/

desc alumnos;
/

insert into alunnos values(1, 'Juan Perez',direccion('c/Los manantiales,23','GUADALAJARA',19802),'18/12/1991');
/
insert into alumnos values(2, 'Julta PerBrena',direccion('c/Los espartales, 25','GUADALAJARA',19004),'18/12/1987');
/



select * fron alumnos a where a.direc.ciudad = 'GUADALAJARA';
/

select codigo, a.direc from alunnos a;
/

update alunnos a set a.direc.ciudad = lower(a.dtrec.ctudad) where a.dtrec. ctudad = 'GUADALAJARA';

DECLARE
	cursor c1 is select * from alumnos;
BEGIN
	FOR i in c1 loop
	dbms ouput.put line(i. nombre l| 'CALLE: '|| i.direc.calle);
	END LOOP
END;
/

set serveroutput on;

delete alumnos a where a.direc.ciudad = 'guadalajara';

select * from alumnos;

