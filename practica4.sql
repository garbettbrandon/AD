set serveroutput on;
alter type cubo replace as object(
	largo integer,
	ancho integer,
	alto integer,
	member function superficie return integer,
	member function volumen return integer,
	member PROCEDURE mostrar,
	static PROCEDURE nuevoCubo (v_largo integer, v_ancho integer, v_alto integer)
	);
/

create or replace type body cubo as
	member function superficie return integer is
	begin
		return 2*(largo*ancho + largo*alto + ancho*alto);
	end;
	
	member function volumen return integer is
	begin
		return largo*ancho*alto;
	end;
	
	member PROCEDURE mostrar is 
	begin
		dbms_output.put_line('Largo: '||largo||' '||'Ancho: '||ancho||' '||'Alto: '||alto);
		dbms_output.put_line('Superficie: '||superficie);
		dbms_output.put_line('Volumen: '||volumen);
	end;
	
	static PROCEDURE nuevoCubo (v_largo integer,v_ancho integer,v_alto integer) is
	begin
		insert into cubos values (v_largo,v_ancho,v_alto);
	end;
end;
/

drop table cubos;
create table cubos of cubo;

insert into cubos values (10,10,10);
insert into cubos values (3,4,5);

select * from cubos;

select c.volumen(), c.superficie() from cubos c where largo = 10;

declare
	mi_cubo cubo;
begin	
	select value(c) into mi_cubo from cubos c where c.largo = 10;
	mi_cubo.mostrar();
end;
/

begin
	cubo.nuevoCubo(1,8,1);
end;
/

select * from cubos;


