

--Sacamos temporales de venta

drop table if exists #venta_2020
select	*
into	#venta_2020
from	venta_universal_resumen
where	year(fecha) = '2020'

drop table if exists #venta_2019
select	*
into	#venta_2019
from	venta_universal_resumen
where	year(fecha) = '2019'



select	a. dia
		,nombre_local
		,nombre_producto
		,nombre_representante
		,id_representante
		,sum(PRECIO_TOTAL)venta
into	#venta_2020_detalle
from	temporal.[dbo].[periodo] a
left join #venta_2020 b
on		a.dia = b.fecha
group by a. dia
		,nombre_local
		,nombre_producto
		,nombre_representante
		,id_representante

alter table #venta_2020_detalle add cod_dia varchar(8)

update	#venta_2020_detalle
set		cod_dia = replace(cast(dia as varchar(10)),'-','')

delete from #venta_2020_detalle
where year(dia) = '2019'

select	a. dia
		,nombre_local
		,nombre_producto
		,nombre_representante
		,id_representante
		,sum(PRECIO_TOTAL)venta
into	#venta_2019_detalle
from	temporal.[dbo].[periodo] a
left join #venta_2019 b
on		a.dia = b.fecha
group by a. dia
		,nombre_local
		,nombre_producto
		,nombre_representante
		,id_representante

alter table #venta_2019_detalle add cod_dia varchar(8)

update	#venta_2019_detalle
set		cod_dia = replace(cast(dia as varchar(10)),'-','')

update	#venta_2019_detalle
set		cod_dia = replace(cod_dia,'2019','2020')

delete from #venta_2019_detalle
where year(dia) = '2020'

--join final

alter table temporal.[dbo].[periodo] add cod_dia varchar(8)

update	temporal.[dbo].[periodo]
set		cod_dia = replace(cast(dia as varchar(10)),'-','')

use comercial



truncate table universal_crecimiento
insert into	universal_crecimiento
select	a.dia
		,b.nombre_local
		,b.nombre_producto
		,b.nombre_representante
		,b.id_representante
		,b.venta as venta_2020
		,c.venta as venta_2019
from	temporal.[dbo].[periodo] a
left join 	#venta_2020_detalle b
on		(a.cod_dia = b.cod_dia)
left join 	#venta_2019_detalle c
on		(a.cod_dia = c.cod_dia
and		b.nombre_producto = c.nombre_producto)
and		b.nombre_representante = c.nombre_representante)
where	b.nombre_representante is not null





update	universal_crecimiento
set		venta_2020 = 0
where	venta_2020 is null

update	universal_crecimiento
set		venta_2019 = 0
where	venta_2019 is null


update	universal_crecimiento
set		nombre_representante = 'Yulisa Valverde Bellodas'
where	nombre_local = 'CENTRAL'












--1. Creamos la tabla matriz que tendrá todos los locales y productos

update	[dbo].[stock_universal]
set		nombre_local = 'LOS JARDINES'
where	nombre_local = 'JARDINES'

drop table if exists #tabla_matriz_universal
select 
distinct nombre_local
		,cod_producto
		,nombre_producto
into	#tabla_matriz_universal
from	venta_universal
union
select 
distinct nombre_local
		,cod_producto
		,nombre_producto
from	[dbo].[stock_universal]



--2. Tabla final cruces con ventas y stock
drop table if exists venta_universal_resumen
select	cast(b.fecha as date)fecha
		,b.COD_PRODUCTO
		,a.nombre_local
		,b.COD_LOCAL
		,a.nombre_producto
		,b.cantidad
		,b.PRECIO_TOTAL
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

--Actualizamos al día de hoy si la fecha es null
update	venta_universal_resumen
set		fecha = cast(GETDATE() as date)
where	fecha is null
go

--Eliminamos filas que no tengan venta ni stock
delete from venta_universal_resumen
where	cantidad = 0
and		stock = 0
go

--Actualizamos filas sin ventas con stock
update	venta_universal_resumen
set		cantidad = 0
where	cantidad is null
go

--4. Actualizamos columna de representantes

alter table venta_universal_resumen add nombre_representante varchar(50)
alter table venta_universal_resumen add id_representante varchar(50)
go

update a
set		a.nombre_representante = b.nombre_representante
		,a.id_representante = b.id_representante
from	cadena_venta_stock b
inner join venta_universal_resumen a
on		a.NOMBRE_LOCAL = b.distrito

select distinct distrito,nombre_representante,id_representante from cadena_venta_stock

--Actualizamos distritos faltantes
update	venta_universal_resumen
set		nombre_representante = 'Por definir'
		,id_representante = '0'
where	NOMBRE_LOCAL = 'CENTRAL'
go

update	venta_universal_resumen
set		nombre_representante = 'Yulisa Valverde Bellodas'
		,id_representante = '0056g000004b20a'
where	NOMBRE_LOCAL = 'LA MARINA'
go

update	venta_universal_resumen
set		nombre_representante = 'Yulisa Valverde Bellodas'
		,id_representante = '0056g000004b20a'
where	NOMBRE_LOCAL = 'LA MARINA'
go



update	venta_universal_resumen
set		nombre_representante = 'Por definir'
		,id_representante = '0'
where	NOMBRE_LOCAL = 'V CORPORATIVAS'
go

update	venta_universal_resumen
set		nombre_representante = 'Por definir'
		,id_representante = '0'
where	NOMBRE_LOCAL = 'TIENDA VIRTUAL'
go

update	venta_universal_resumen
set		nombre_representante = 'Lisdey Cedrón Rengifo'
		,id_representante = '0056g000004b21n'
where	NOMBRE_LOCAL = 'LOS JARDINES'
go

update	venta_universal_resumen
set		nombre_representante = 'Lisdey Cedrón Rengifo'
		,id_representante = '0056g000004b21n'
where	NOMBRE_LOCAL = 'CTO. GRANDE'
go

update	venta_universal_resumen
set		nombre_representante = 'Lisdey Cedrón Rengifo'
		,id_representante = '0056g000004b21n'
where	NOMBRE_LOCAL = 'CANTO GRANDE'
go

update	venta_universal_resumen
set		nombre_representante = 'Allison Pasco Barbaran'
		,id_representante = '0056g000005mQuY'
where	NOMBRE_LOCAL = 'SAN BORJA2'
go

--surco
update	venta_universal_resumen
set		nombre_representante = 'Allison Pasco Barbaran'
		,id_representante = '0056g000005mQuY'
where	NOMBRE_LOCAL = 'SURCO'
go

update	venta_universal_resumen
set		nombre_representante = 'Allison Pasco Barbaran'
		,id_representante = '0056g000005mQuY'
where	NOMBRE_LOCAL = 'TRIGAL'
go

update	venta_universal_resumen
set		nombre_representante = 'Allison Pasco Barbaran'
		,id_representante = '0056g000005mQuY'
where	NOMBRE_LOCAL = 'CHACARILLA'
go
------

--- Insertamos columnas para acomodar el union
alter table venta_universal_resumen add descripcion_local varchar(100)
alter table venta_universal_resumen add formato varchar(100)
go

update	venta_universal_resumen
set		descripcion_local = NOMBRE_LOCAL
go

update	venta_universal_resumen
set		formato = 'Universal'
go

--Mantenemos solo productos solicitados
delete from venta_universal_resumen
where	NOMBRE_PRODUCTO not in ('CRETROL 10/10 30 TAB.','KENOPLAST 30 MG X 3 SOB 01/20','M VAT 500 UG/ML X 10 AMP','CLANZA CR  200 MG X 10 TAB','CLANZA 100 MG X 10 TAB*D*')
go



insert into [dbo].[cadena_venta_stock]
 SELECT [fecha]
      ,[COD_PRODUCTO]
		,[nombre_producto]
		,[COD_LOCAL]
      ,[descripcion_local]
      ,[formato]
      ,[nombre_local]
      ,[cantidad]
	  ,0
      ,[stock]
      ,[nombre_representante]
      ,[id_representante]
  FROM [dbo].[venta_universal_resumen]



SELECT distinct 
		[periodo]
      ,[cod_producto]
      ,[descripcion_producto]
      ,[cod_local]
      ,[descripcion_local]
      ,[formato]
      ,[distrito]
      ,[vta_periodo_unid]
	  ,vta_costo
      ,[stock_actual_unid]
      ,[nombre_representante]
      ,[id_representante]
into	#temporal
FROM [dbo].[cadena_venta_stock]

truncate table [dbo].[cadena_venta_stock]

insert into [dbo].[cadena_venta_stock]
select	*
from	#temporal