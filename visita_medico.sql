/*
-- Script de coordenadas

select * from [dbo].[salesforce_ubicacion_IPRESS] where id like '%a0w6g000000nSmQ%'
select * from [dbo].[salesforce_ubicacion_medico] 
select * from [dbo].[salesforce_medico] where [id_medico] like '%a006g000003pwhS%'
select * from  #ubicacion_medico_new where [id_medico_new] like '%a006g000003pwhS%'
select * from #salesforce_medico_new where [id_medico_new] like '%a006g000003pwhS%'

select * from #salesforce_medico_new where [id_medico] COLLATE Latin1_General_CS_AS = 'a006g000003pwhS'
select * from salesforce_medico where [id_medico] = 'a006g000003pwhS'

select * from [dbo].[salesforce_ubicacion_medico] where Medicos__c like '%a006g00000DuzV1%'


select * from [dbo].[salesforce_ubicacion_IPRESS] where name like '%DAFI SALUD%'



select	a.*
		,a.Medicos__c
		,b.nombre_medico
from	salesforce_ubicacion_medico a
inner join [dbo].[salesforce_medico] b
on		a.Medicos__c = b.id_medico
where	b.cmp = '37286'

a0w6g0000037SUI -> IPRESS
a006g000003q4Pv -> Medicos

select * from #ubicacion_medico_total where id_medico = 'a006g000003q4Pv'
select * from salesforce_ubicacion_IPRESS where id = 'a0w6g0000037SUI'
select distinct nombre_representante,id_usuario_laborable from visita_dia_laborable

alter table salesforce_medico alter column id_propietario nvarchar(18)

update	a
set		a.nombre_propietario = b.Nombre_Propietario__c
from	salesforce_medico a
inner join salesforce_visita_medico b
on		substring(a.id_propietario,1,15) = substring(b.CreatedById,1,15)

update	a
set		a.nombre_propietario = b.[Nombre completo]
from	salesforce_medico a
inner join temporal.dbo.input_medicos b
on		substring(a.id_propietario,1,15) = b.[id# de usuario]


select distinct substring(id_propietario,1,15) from salesforce_medico where nombre_propietario is null
select * from salesforce_medico where cmp = '37286'

select * from salesforce_ubicacion_medico
select * from salesforce_medico where cmp = '66436'
select * from visita_concordancia where nombre_medico = 'VICTOR ISRAEL CABRERA SERNA'
select * from visita_concordancia where cmp = '66436'

select a.*
	,b.*
from salesforce_medico a
inner join salesforce_ubicacion_medico b
on	a.id_medico = b.Medicos__c
where a.cmp = '66436'

select * from salesforce_ubicacion_IPRESS
where id like '%a0w6g000000nSBw%' or id like 'a0w6g000000nQgJ'

select * from #ubicacion_medico where ubicacion_IPRESS__C like 'a0w6g000000nQgJ' or ubicacion_IPRESS__C like 'a0w6g000000nSBw'
select count(*) from #visita_concordancia
select * from visita_concordancia where cmp = '66436'
select * from visita_concordancia order by rank asc
select count(rank) from visita_concordancia
select count(distinct rank) from visita_concordancia
select * from visita_concordancia

truncate table [dbo].[salesforce_medico]

#sin_IPRESS
visita_concordancia

select * from salesforce_medico where cmp = '69276'
select * from #ubicacion_medico where cmp = '69276'
select * from #ubicacion_medico_total where cmp = '69276'
select * from salesforce_ubicacion_medico where Medicos__c like '%a006g000003r9wB%'

select * from #visita_concordancia where cmp = '20376'

*/

--Borramos duplicados
drop table if exists #salesforce_visita_medico
go
with cte_asignacion_medico
as
(
select distinct 
		ROW_NUMBER() OVER(PARTITION BY OwnerId,CMP__c,Fecha_y_Hora__c
		ORDER BY Fecha_y_Hora__c DESC) AS "repetido"
		,*
from salesforce_visita_medico
--where CMP__c = '37286'
)select * 
into #salesforce_visita_medico
from cte_asignacion_medico
where repetido = 1
--order by id_representante,CMP__c,Fecha_y_Hora__c desc

alter table #salesforce_visita_medico drop column repetido


----


ALTER TABLE [salesforce_ubicacion_medico]
ALTER COLUMN Medicos__c nvarchar(18) COLLATE Latin1_General_CS_AS
go

ALTER TABLE salesforce_ubicacion_medico
ALTER COLUMN Ubicacion_IPRESS__c nvarchar(18) COLLATE Latin1_General_CS_AS
go

ALTER TABLE salesforce_ubicacion_IPRESS
ALTER COLUMN id nvarchar(18) COLLATE Latin1_General_CS_AS
go

ALTER TABLE [salesforce_medico]
ALTER COLUMN id_medico nvarchar(255) COLLATE Latin1_General_CS_AS
go

-- Limpiamos tabla de ubicacion_medico
update	salesforce_ubicacion_medico
set		Medicos__c = substring(Medicos__c,1,15)
go

update	#salesforce_visita_medico
set		id = substring(id,1,15)

-- Limpiamos tabla de ubicacion_medico
update	salesforce_ubicacion_medico
set		ubicacion_IPRESS__C = substring(ubicacion_IPRESS__C,1,15)
go

-- Limpiamos tabla de ubicacion_IPRESS
update	salesforce_ubicacion_IPRESS
set		id = substring(id,1,15)
go

-- Limpiamos tabla de médicos
update	salesforce_medico
set		id_medico = substring(id_medico,1,15)
go

update	salesforce_medico
set		id_propietario = substring(id_propietario,1,15)
go

ALTER TABLE salesforce_medico
ALTER COLUMN id_propietario nvarchar(18) COLLATE Latin1_General_CS_AS
go

ALTER TABLE temporal.[dbo].[input_usuarios]
ALTER COLUMN [Id# de usuario] nvarchar(255) COLLATE Latin1_General_CS_AS
go

update	a
set		a.nombre_propietario = b.[Nombre completo]
from	temporal.[dbo].[input_usuarios] b
inner join salesforce_medico a
on		a.id_propietario= b.[Id# de usuario]
go

drop table if exists #ubicacion_medico
select	b.nombre_propietario
		,a.medicos__c as id_medico
		,b.nombre_medico
		,b.cmp
		,a.ubicacion_IPRESS__C
		,a.estado_ubicacion__c
into	#ubicacion_medico
from	salesforce_ubicacion_medico a
right join salesforce_medico b
on		a.Medicos__c = b.id_medico
go


drop table if exists #ubicacion_medico_total
select	a.nombre_propietario
		,a.id_medico
		,a.nombre_medico
		,a.cmp
		,a.estado_ubicacion__c
		,b.latitud__c as latitud
		,b.longitud__c as longitud
into	#ubicacion_medico_total
from	#ubicacion_medico a
inner join salesforce_ubicacion_IPRESS b
on		a.ubicacion_IPRESS__C = b.id
go

--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

--Agregamos id_propietario
alter table #ubicacion_medico_total add id_propietario varchar(20)
go

update	a
set		a.id_propietario = b.id_usuario_laborable
from	visita_dia_laborable b
inner join #ubicacion_medico_total a
on		a.nombre_propietario = b.nombre_representante
go


--Limpiamos algún valor que no corresponda
delete from #ubicacion_medico_total where nombre_propietario = 'Ivo Carlos Ramos'

-- ****************************************************************************************

--Preparamos la tabla #salesforce_visita_medico
ALTER TABLE #salesforce_visita_medico
ALTER COLUMN OwnerId nvarchar(18) COLLATE Latin1_General_CS_AS

ALTER TABLE #salesforce_visita_medico
ALTER COLUMN id nvarchar(80) COLLATE Latin1_General_CS_AS

ALTER TABLE #salesforce_visita_medico
ALTER COLUMN OwnerId nvarchar(18) COLLATE Latin1_General_CS_AS



update	#salesforce_visita_medico
set		OwnerId = substring(OwnerId,1,15)

ALTER TABLE #ubicacion_medico_total
ALTER COLUMN id_propietario varchar(20) COLLATE Latin1_General_CS_AS
go

--Actualizamos id_propietario de existir NULL
update	a
set		a.id_propietario = b.[Id# de usuario]
from	temporal.dbo.input_usuarios b
inner join #ubicacion_medico_total a
on		a.nombre_propietario = b.[Nombre completo]
where	a.id_propietario is null



drop table if exists #visita_concordancia
select	b.latitud as latitud_IPRESS
		,b.longitud as longitud_IPRESS
		,b.nombre_medico
		,b.estado_ubicacion__c as estado_ubicacion
		,a.Nombre_Propietario__c as nombre_propietario
		,a.OwnerId as id_propietario
		,a.cmp__c as cmp
		,cast(a.Fecha_y_Hora__c as date)fecha_visita
		,a.Geolocalizacion__c
		,a.id as id_visita
		,a.Elegir_Visita__c
into	#visita_concordancia
from	#salesforce_visita_medico a
left join #ubicacion_medico_total b
on		(a.cmp__c = b.cmp
and		a.OwnerId = b.id_propietario)
where	a.Elegir_Visita__c = 'VISITA PRESENCIAL'
order by cast(a.Fecha_y_Hora__c as date) asc




--Extramos la latitud y longitud de las visitas
alter table #visita_concordancia add latitud_visita varchar(100)
go
alter table #visita_concordancia add longitud_visita varchar(100)
go

drop table if exists #longitud
select
substring(
	substring(geolocalizacion__c
	,1
	,charindex('Latitude',geolocalizacion__c)-1)
,12
,100)longitud
,id
,geolocalizacion__c
into #longitud
from #salesforce_visita_medico


drop table if exists #latitud;
select substring(
	substring(geolocalizacion__c
	,charindex('Latitude',geolocalizacion__c)
	,100)
,11
,100)latitud
,id
,geolocalizacion__c
into #latitud
from #salesforce_visita_medico


update	a
set		a.longitud_visita = b.longitud
from	#longitud b
inner join #visita_concordancia a
on		a.id_visita = b.id


update	a
set		a.latitud_visita = b.latitud
from	#latitud b
inner join #visita_concordancia a
on		a.id_visita = b.id

ALTER TABLE [dbo].[venta_visitador_inkafarma]
ALTER COLUMN id_visitador varchar(50) COLLATE Latin1_General_CS_AS
go

-- Completamos Nombres vacíos
update	a
set		a.nombre_propietario = b.visitador
from	venta_visitador_inkafarma b
inner join #visita_concordancia a
on		a.id_propietario = b.id_visitador
where	a.nombre_propietario is null
go

-- Eliminamos registros pasados
delete from	#visita_concordancia
where	fecha_visita < '2020-09-01'
go

--**************************************************************************
-- Tabla de concordancia

alter table #visita_concordancia add estado varchar(20)
go

alter table #visita_concordancia add distancia float
go

update	#visita_concordancia
set		nombre_propietario = 'Luz Castañeda Jumpa'
where	id_propietario = '0056g000004b20L'
go

update	#visita_concordancia
set		nombre_propietario = 'Rocio Luyo Torres'
where	id_propietario = '0056g000004b21O'
go

delete from #visita_concordancia where id_visita in ('a016g00000KWu0g','a016g00000KWtof')
go

-- Temporal de representante
drop table if exists #id_propietario
go
with cte_propietario
as
(
select	distinct id_propietario
from	#visita_concordancia 
)select rank() over(order by id_propietario asc)rank
		,id_propietario
into #id_propietario
from cte_propietario


-- Temporal de cmp
drop table if exists #cmp
go
with cte_cmp
as
(
select	distinct cmp
from	#visita_concordancia 
)select rank() over(order by cmp asc)rank
		,cmp
into #cmp
from cte_cmp

alter table #visita_concordancia add cod_dia varchar(8)
go

update	#visita_concordancia
set		cod_dia = convert(varchar(8),fecha_visita,112)
go


-- Extraemos registros sin IPRESS

drop table if exists #sin_IPRESS
select	*
into	#sin_IPRESS
from	#visita_concordancia 
where	latitud_IPRESS is null
go

delete from #visita_concordancia
where	latitud_IPRESS is null
go

delete from #visita_concordancia
where id_visita = 'a016g00000aMmdp'
go

--
--concatenado

ALTER TABLE #visita_concordancia
ALTER COLUMN id_propietario nvarchar(18) COLLATE Latin1_General_CS_AS
go

ALTER TABLE #visita_concordancia
ALTER COLUMN cmp nvarchar(10) COLLATE Latin1_General_CS_AS
go

ALTER TABLE #visita_concordancia
ALTER COLUMN cod_dia varchar(8) COLLATE Latin1_General_CS_AS
go

ALTER TABLE #visita_concordancia
ALTER COLUMN latitud_IPRESS nvarchar(255) COLLATE Latin1_General_CS_AS
go

ALTER TABLE #visita_concordancia
ALTER COLUMN id_visita nvarchar(255) COLLATE Latin1_General_CS_AS
go

drop table if exists visita_concordancia_aux
go
with cte_rep
as
(
select concat(id_propietario,cmp,cod_dia,latitud_IPRESS,id_visita)cod_unico, * from #visita_concordancia
)select ROW_NUMBER() OVER(PARTITION BY cod_unico
			ORDER BY cod_unico DESC) AS "repetido"
		,*
into visita_concordancia_aux
from cte_rep

alter table visita_concordancia_aux drop column repetido
go

drop table if exists visita_concordancia
go
with cte_rep
as
(
select * from visita_concordancia_aux
)select ROW_NUMBER() OVER(ORDER BY cod_unico DESC) AS rank
		,*
into visita_concordancia
from cte_rep

alter table visita_concordancia drop column cod_unico
go


ALTER TABLE visita_concordancia
ALTER COLUMN latitud_IPRESS nvarchar(255) COLLATE Latin1_General_CS_AS
go

--***************************************************************************************************************************************

-- prueba