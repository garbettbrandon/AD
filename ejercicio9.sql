/*
Crear una función "Anual" para devolver el salario anual cuando se pasa el salario mensual y la comisión de un empleado. Hay que asegurarse de que controla nulos. Utilizar una variable de acoplamiento para ver lo que devuelve y/o devolverlo por pantalla.
*/

create o replace function anual(f_sal in emp.sal%type, f_comm in emp.comm%type) return emp.sal%type as
  	f_salanual emp.sal%type;
  begin
  	f_salanual := (f_sal + NVL(f_comm,0))*12;
  	return f_salanual;
 end anual;
 /
 
 VARIABLE v_salanual number;
 
 DECLARE 
 	v_empno emp.empno % type;
 	v_sal emp.sal % type;
 	v_comm emp.comm % type;
 BEGIN
 	select sal, comm into v_sal, v_comm from emp where empno = &v_empno;
 	v_salanual := anual(v_val, v_comm);
 END;
 /
 