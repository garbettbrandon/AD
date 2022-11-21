
drop table triangulos;
drop type tipo_triangulo;

create or replace type tipo_triangulo as object(
	base number,
	altura number,
	member function area return number
);
/

create or replace type body tipo_triangulo as 
	member function area return number is
		a number;
		begin
		a:= (base * altura)/2;
		return a;
	end;
end;
/


create table triangulos (id number, triangulo tipo_triangulo);

insert into triangulos values (1, tipo_triangulo(5,6));
insert into triangulos values (2, tipo_triangulo(10,10));

select * from triangulos;

set serveroutput on;

declare
	t tipo_triangulo;
begin
	for i in (select * from triangulos) loop
		t := i.triangulo;
		dbms_output.put_line('El triangulo con id: '|| i.id);
		dbms_output.put_line('Con base: '|| t.base);
		dbms_output.put_line('Altura: '|| t.altura);
		dbms_output.put_line('Area: '|| t.area);
	end loop;
end;
/


/* Recorrer la tabla con un cursor para sacarlo por registro y un while */
declare
	cursor c_cur is select id, t.triangulo.base B, t.triangulo.altura A, t.triangulo.area() superficie from triangulos t;
	v_cur c_cur%rowtype;
begin
	open c_cur;
	fetch c_cur into v_cur;
	while c_cur%found loop
		dbms_output.put_line('El triangulo con id: '|| v_cur.id);
		dbms_output.put_line('Con base: '|| v_cur.B);
		dbms_output.put_line('Altura: '|| v_cur.A);
		dbms_output.put_line('Area: '|| v_cur.superficie);
		fetch c_cur into v_cur;
	end loop;
	close c_cur;
end;
/



/* Recorrer con cursor y for */
declare
	cursor c_triangulos is select * from triangulos;
begin
	for v_triangulo in c_triangulos loop
		dbms_output.put_line('El triangulo con id: '|| v_triangulo.id);
		dbms_output.put_line('Con base: '|| v_triangulo.triangulo.base);
		dbms_output.put_line('Altura: '|| v_triangulo.triangulo.altura);
		dbms_output.put_line('Area: '|| v_triangulo.triangulo.area());
	end loop;
end;
/