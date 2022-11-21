create or replace type veterinario as object(
id integer,
nombre varchar2(10),
direccion varchar2(30)
);
/

create or replace type mascota as object(
id integer,
raza varchar2(10),
nombre varchar2(10),
vet REF veterinario
);
/

drop table veterinarios;
drop table mascotas;

create table veterinarios of veterinario;
insert into veterinarios values (1,'Jesus Perez','C/El mareo, 29');

create table mascotas of mascota;
insert into mascotas values (1,'Perro','Sproket',(select REF(v) from veterinarios v where v.id=1));

select * from mascotas;
select id, nombre, deref(vet) from mascotas;

select nombre, raza, deref(m.vet).nombre from mascotas m;
select nombre, raza, deref(m.vet).nombre from mascotas m;
select nombre, raza, deref(m.vet).nombre from mascotas m;

drop table veterinarios;
drop table mascotas;

drop type mascota;
drop type veterinario;