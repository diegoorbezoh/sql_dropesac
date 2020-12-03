
--Limpiamos valores en rango de fecha ingresado
delete from temporal.dbo.inkafarma_venta
where	periodo in (select distinct periodo from temporal.dbo.inkafarma_venta_input)
go

--1. Creamos tabla de ubicaciones y productos únicos

--actualizamos el cod_producto de tabla_stock

update	a
set		a.cod_producto = b.cod_producto
from	temporal.dbo.inkafarma_venta_historico b
inner join  temporal.dbo.inkafarma_stock_input a
on		a.DESCRIPCION_PRODUCTO = b.DESCRIPCION
go

--2. Tabla de valores únicos
drop table if exists #inkafarma_local
select 
distinct cod_producto
		,descripcion
		,cod_local
into	#inkafarma_local
from	temporal.dbo.inkafarma_venta_input
union
select 
distinct cod_producto
		,DESCRIPCION_PRODUCTO
		,cod_local
from	temporal.dbo.inkafarma_stock_input
go



--3. Insertamos los nuevos registros de venta
insert into temporal.dbo.inkafarma_venta
select	
distinct cast(periodo as date)periodo
		,cod_producto
		,descripcion
		,cod_local
		,descripcion_local
		,distrito
		,vta_periodo_unid
		,COSTO_DE_VENTA_PERIODO_S
from	temporal.dbo.inkafarma_venta_input


--4. Tabla de ventas y stock
drop table if exists #inkafarma
select	b.periodo
		,a.cod_producto
		,a.descripcion as descripcion_producto
		,a.cod_local
		,b.descripcion_local
		,c.formato
		,b.distrito
		,b.vta_periodo_unid
		,b.vta_costo
		,c.stock_actual_unid
		,d.nombre_representante
		,d.id_representante
into	#inkafarma
from	#inkafarma_local a
left join temporal.dbo.inkafarma_venta b
on		(a.cod_local = b.cod_local
and		a.cod_producto = b.cod_producto)
left join temporal.dbo.inkafarma_stock_input c
on		(a.cod_local = c.cod_local
and		a.cod_producto = c.cod_producto)
left join comercial.dbo.cadena_representante d
on		a.cod_local = d.cod_local
where	a.descripcion in ('CLANZA 100MG TAB REC CJAx10UND'
		,'CLANZA CR 200MG TAB REC LP CJAx10UND'
		,'CRETROL 10-10MG TAB REC CJAx30UND')
and		d.nombre_representante is not null

--Nota: No hay venta de los productos filtrados en el 2019

/*
select distinct periodo from #inkafarma
order by 1 desc
*/


-- Filtramos los valores con stock
delete from #inkafarma
where	periodo is null
and		stock_actual_unid = 0
go

/*
select * from #inkafarma
where periodo = '2020-12-03'
*/

-- Actualizamos al día de hoy los productos con stock sin ventas
update	#inkafarma
set		periodo = (select max(periodo) from temporal.dbo.inkafarma_venta_input)
where	periodo is null
go

-- Actualizamos a 0 registros sin ventas
update	#inkafarma
set		vta_periodo_unid = 0
where	VTA_PERIODO_UNID is null
go

-- Actualizamos descripcion_local y distrito
update	a
set		a.descripcion_local = b.descripcion_local
		,a.distrito = b.distrito
from	temporal.dbo.inkafarma_locales b
inner join #inkafarma a
on		a.cod_local = b.cod_local
go

-- 5. Insert a tabla de producción

truncate table comercial.dbo.cadena_venta_stock
go

insert into comercial.dbo.cadena_venta_stock
SELECT [periodo]
      ,[cod_producto]
      ,[descripcion_producto]
      ,[cod_local]
      ,[descripcion_local]
      ,[formato]
      ,[distrito]
      ,[vta_periodo_unid]
	  ,[vta_costo]
      ,[stock_actual_unid]
      ,[nombre_representante]
      ,[id_representante]
 FROM #inkafarma

-------------------------------------------------------------
/*
drop table if exists #venta_2020
select  PERIODO
        ,nombre_representante
        ,id_representante
        ,sum(vta_costo)venta_costo
into	#venta_2020
from    comercial.dbo.cadena_venta_stock
where   year(PERIODO) = '2020'
group by PERIODO
        ,nombre_representante
        ,id_representante

--limpiamos casos nulos
update	comercial.dbo.cadena_venta_stock
set		vta_costo = 0
where	vta_costo is null

update	#venta_2020
set		venta_costo = 0
where	venta_costo is null

drop table if exists #periodo_2020
select	*
into	#periodo_2020
from	periodo
where	year(dia) = '2020'


select	a.dia as periodo
		,b.nombre_representante
		,b.id_representante
		,b.venta_costo
into	comercial.dbo.cadena_inkafarma_resumen
from	#periodo_2020 a
left join #venta_2020 b
on		(a.dia = b.periodo)
order by periodo desc

update	comercial.dbo.cadena_inkafarma_resumen
set		nombre_representante = ''
where	nombre_representante is null

update	comercial.dbo.cadena_inkafarma_resumen
set		id_representante = ''
where	id_representante is null

update	comercial.dbo.cadena_inkafarma_resumen
set		venta_costo = 0
where	venta_costo is null

delete from comercial.[dbo].[venta_visitador]
where id = 17
*/





