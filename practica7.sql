create type tipo_nombres_dep is varray(7) of varchar2(30);
/

drop table departamentos;
create table departamentos(
	region varchar(20),
	nombres_dep tipo_nombres_dep
);

insert into departamentos values ('Europa', tipo_nombres_dep('shipping', 'sales', 'finances'));
insert into departamentos values ('America', tipo_nombres_dep('sales', 'finances', 'shipping'));
insert into departamentos values ('Asia', tipo_nombres_dep('finances', 'payroll', 'shipping','sales'));

set serveroutput on;
declare
	v_nombres tipo_nombres_dep := tipo_nombres_dep('benefits','advertising', 'contracting', 'executive', 'marketing');
	v_nombres2 tipo_nombres_dep;
begin
	update departamentos set nombres_dep = v_nombres where region = 'Europa';
	commit;
	select nombres_dep into v_nombres2 from departamentos where region = 'Europa';
	for i in v_nombres2.first .. v_nombres2.last loop
		dbms_output.put_line('departamentos: '||v_nombres2(i));
	end loop;
end;
/

declare
	cursor c_depts is select * from departamentos;
	v_region varchar2(25);
	v_nombres tipo_nombres_dep;
begin
	open c_depts;
	loop
		fetch c_depts into v_region, v_nombres;
		exit when c_depts %NOTFOUND;
		dbms_output.put_line('Region: '||v_region);
		for i in v_nombres.first..v_nombres.last loop
			dbms_output.put_line('departamentos: '||'('||i||') '||v_nombres(i));
		end loop;
	end loop;
end;
/

declare
	cursor v_zonas is select * from departamentos;
begin
	for i in v_zonas loop
		dbms_output.put_line('Region: '||i.region);
		for j in i.nombres_dep.first..i.nombres_dep.last loop
			dbms_output.put_line('Departamento: '||'('||j||') '||i.nombres_dep(j));
		end loop;
	end loop;
end;
/