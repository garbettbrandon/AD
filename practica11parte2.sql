-- 6. Consultas
-- 6.1 Visualizar todas las líneas de venta para la venta id 2. 
-- Haz la consulta de otra forma sin sacar el nombre del objeto, usando TABLE.
	 select * from the(select tv.lineas from tabla_ventas tv where tv.idventa=2);

-- 6.1.2 Haz la consulta de otra forma sin sacar el nombre del objeto, usando TABLE.
	 select lin.* from tabla_ventas tv, table(tv.lineas) lin where tv.idventa=2;

-- 6.2 Visualizar todas las líneas de venta para la venta id 2, obteniendo los productos en vez de su oid.
	select deref(lin.idproducto) from tabla_ventas tv, table(tv.lineas) lin where tv.idventa=2;

-- 6.3 Visualizar todas las líneas de venta de todas las ventas.
	select deref(lin.idproducto) from tabla_ventas tv, table(tv.lineas) lin;

-- 6.4 Consulta el nombre del cliente idcliente 2
	select nombre from tabla_clientes where idcliente=2;

-- 6.5 Modifica el nombre del cliente 2 por Rosa Serrano
	update tabla_clientes set nombre='Rosa Serrano' where idcliente=2;

-- 6.6 Consulta la dirección del cliente 2 y modifica la calle por calle Estopa,34
	select tc.direc.calle from tabla_clientes tc where idcliente=2;
	update tabla_clientes tc set tc.direc.calle='calle Estopa,34' where idcliente =2;

-- 6.7 Consulta todos los datos del cliente 1 y añade un nuevo teléfono a su lista de teléfonos. Haz la consulta de otra forma usando value
	select * from tabla_clientes cli where idcliente=1;
	update tabla_clientes set telef=tip_telefonos('949876655','949876655','666888555')where idcliente=1;
	select value(cli) from tabla_clientes cli where idcliente=1;
	
-- 6.8 Visualiza el nombre del cliente que ha realizado la venta
	select tv.idcliente.nombre from tabla_ventas tv;
	
-- 6.8.2 Haz la misma consulta usando DEREF
	select deref(idcliente).nombre from tabla_ventas;
	

-- 6.9 Visualiza todos los datos del cliente anterior, que ha realizado la venta 2
	select deref(idcliente) from tabla_ventas where idventa=2;

-- 6.10 Visualizar el numero de venta y el total de ventas hechas por el cliente 1
	select idventa, tv.total_venta() from tabla_ventas tv where tv.idcliente.idcliente =1;
	
	select idventa, tv.total_venta() from tabla_ventas tv where deref(idcliente).idcliente =1;

-- 6.11 Visualiza las ventas de todos los clientes
	select idventa,deref(idcliente).idcliente cliente, lin.idproducto.descripcion producto, lin.cantidad from tabla_ventas tv, table(tv.lineas) lin;

-- 6.12 Crea un procedimiento que reciba como parámetro un id de venta y visualice los datos de la venta cuyo identificador recibe
select lin.numerolinea, lin.cantidad, deref(lin.idproducto) from tabla_ventas tv, table(tv.lineas) lin where tv.idventa=2;

create or replace procedure mostrar(vp_idventa tabla_ventas.idventa%type) as 
	lineas number;
	cantidad number;
	importe number;
	total_v number;
	product tip_producto:=tip_producto(NULL,NULL,NULL,NULL);
	cli tip_cliente;
	linea_venta tip_linea_venta;
	direccion tip_direccion;
	fecha date;
	cursor c1 is
		select deref(lin.idproducto),lin.cantidad,lin.numerolinea from tabla_ventas tv, table(tv.lineas) lin where tv.idventa=vp_idventa;
begin 
	
	select deref(idcliente),fechaventa,tv.total_venta() into cli,fecha,total_v from tabla_ventas tv where idventa=vp_idventa;
	select direc into direccion from tabla_clientes where cli.idcliente=idcliente; 
	DBMS_OUTPUT.PUT_LINE('Número de venta: '||vp_idventa||'Fecha de Venta: '||fecha);
	DBMS_OUTPUT.PUT_LINE('Cliente: '||cli.nombre);
	DBMS_OUTPUT.PUT_LINE('Dirección: '||direccion.calle);
	DBMS_OUTPUT.PUT_LINE('*************************************************');
	open c1;
	fetch c1 into product,cantidad,lineas;
	loop	
		
		DBMS_OUTPUT.PUT_LINE(lineas||' '||product.descripcion||' '||product.pvp||' '||cantidad||' '||cantidad*product.pvp);
		fetch c1 into product,cantidad,lineas;
		exit when c1%NOTFOUND;
	end loop;
	close c1;
	
	
	DBMS_OUTPUT.PUT_LINE('Total Venta:'||total_v);
end;
/