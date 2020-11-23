
[dbo].[venta_universal]
[dbo].[stock_universal]

--1. Creamos la tabla matriz que tendrá todos los locales y productos

drop table if exists #tabla_matriz_universal
select 
distinct nombre_local
		,cod_producto
		,nombre_producto
into	#tabla_matriz_universal
from	venta_universal

--2. Tabla final cruces con ventas y stock
drop table if exists venta_universal_resumen
select	a.nombre_local
		,a.nombre_producto
		,cast(b.fecha as date)fecha
		,b.cantidad
		,b.precio_unitario
		,b.precio_total
		,c.stock
into	venta_universal_resumen
from	#tabla_matriz_universal a
left join venta_universal b
on		(a.cod_producto = b.cod_producto
and		a.nombre_local = b.nombre_local)
left join stock_universal c
on		(a.cod_producto = c.cod_producto
and		a.nombre_local = c.nombre_local)

--3. Actualizamos stock 0

update	venta_universal_resumen
set		stock = 0
where	stock is null
go

--4. Actualizamos columna de representantes

alter table venta_universal_resumen add nombre_representante varchar(50)
alter table venta_inkafarma alter column periodo date

update venta_universal_resumen
set		nombre_representante = 'Julissa Valverde'
where	nombre_local in ('CENTRAL')

select distinct nombre_representante,nombre_local from venta_universal_resumen
select * from venta_inkafarma

select a.*
		,b.cantidad as venta_universal
		,b.stock as stock_universal
from	venta_inkafarma a

select *
from	venta_inkafarma
union
select *
from	venta_universal_resumen

alter table venta_universal_resumen drop column precio_unitario
go
alter table venta_universal_resumen drop column precio_total
go