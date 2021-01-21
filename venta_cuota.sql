/*
Script: Reporte Venta / Coutas

select * from comercial.dbo.venta_reporteria
select * from comercial.dbo.venta_cuota
select * from temporal.dbo.vendedor

*/

-- 1. Actualizamos los rucs invalidos de venta_reporteria

update	a
set		a.numeroDocumentoVendedor = b.dni
from	temporal.dbo.vendedor b
join	comercial.dbo.venta_reporteria a
on		a.vendedor = b.vendedor
where	year(a.fechaEmision) = '2021'


/*
update	a
set		a.dni = b.numeroDocumentoVendedor
from	comercial.dbo.venta_reporteria b
join	comercial.dbo.venta_cuota a
on		a.id_vendedor = b.idVendedor
where	year(a.fechaEmision) = '2021'
*/


drop table if exists #venta_cuota
select	macro_zona
		  ,grupo_zona
		  ,zona
		  ,sub_zona
		  ,a.dni
		  ,a.id_vendedor
		  ,a.nombre_representante
		  ,linea_estrategica
		  ,linea_representante
		  ,id_producto
		  ,descripcion_producto
		  ,a.mes
		  ,unidad
		  ,cast(b.fechaEmision as date)fechaEmision
		  ,cast(valor as decimal(10,2))valor_meta
		  ,linea
		 ,sum(b.cantidad)cantidad_vendida
into	#venta_cuota
from	comercial.dbo.venta_cuota a
left join comercial.dbo.venta_reporteria b
on		(a.dni = b.numeroDocumentoVendedor
and		a.id_producto = b.codigoProducto
and		a.mes = month(b.fechaEmision))
where	year(b.fechaEmision) = '2021'
and		cast(b.fechaEmision as date) = '2021-01-15'
and		nombre_representante not in ('Nuevo ingreso','Reemplazo 1','Visitador medico')
group by macro_zona
		  ,grupo_zona
		  ,zona
		  ,sub_zona
		  ,a.dni
		  ,a.id_vendedor
		  ,a.nombre_representante
		  ,linea_estrategica
		  ,linea_representante
		  ,id_producto
		  ,descripcion_producto
		  ,a.mes
		  ,unidad
		  ,valor
		  ,b.fechaEmision
		  ,linea

select * from #venta_cuota
where nombre_representante like '%itamar%'
order by descripcion_producto

select distinct dni,nombre_representante from comercial.dbo.venta_cuota
order by nombre_representante
select distinct numeroDocumentoVendedor,vendedor from comercial.dbo.venta_reporteria
order by vendedor

/*
--validar que nada quede fuera
select * from comercial.dbo.venta_reporteria
where idVendedor not in (
	select distinct id_Vendedor from #venta_cuota
	)
	and	codigoProducto in (
	select distinct id_producto
	from	comercial.dbo.venta_cuota
)
and vendedor like '%eva%'
and year(fechaEmision) = '2021'
*/

--validacion
select	*
from	comercial.dbo.venta_reporteria a
where	vendedor like '%itamar%'
and		codigoProducto in (
		select distinct id_producto from comercial.dbo.venta_cuota
		where nombre_representante like '%itamar%'
		and mes = 1
)
and		year(fechaEmision) = '2021'
and		cast(fechaEmision as date) = '2021-01-15'


select distinct descripcion_producto from comercial.dbo.venta_cuota
where nombre_representante like '%itamar%'
and mes = 1
order by descripcion_producto

--IMPORTANTE: TABLA MATRIZ DE PRODUCTOS Y MESES
--VALIDACION DIARIA/MENSUAL