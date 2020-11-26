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
select distinct substring(id_propietario,1,15) from salesforce_medico where nombre_propietario is null

select * from [dbo].[salesforce_medico] where cmp = '26135'
--a016g00000aGdSN

select * from visita_concordancia where cmp = '31844'
select * from salesforce_ubicacion_medico where Medicos__c = 'a006g000003q2T4'
select * from salesforce_ubicacion_IPRESS where id = 'a0w6g000000nR4D'

select * from #ubicacion_medico where cmp = '31844'
select * from #ubicacion_medico_total where cmp = '31844'
select * from #ubicacion_medico_total where cmp = '26135'
select * from #salesforce_visita_medico where Medicos__c like '%a006g000003pzjH%'
select * from #visita_concordancia where cmp = '26135'
select * from visita_concordancia where cmp = '26135'

select * from #ubicacion_medico where id_medico in ('a0x6g000003lMotAAE','a0x6g000003lPtIAAU')
select * from  #salesforce_visita_medico where cmp__c = '38588'
id_medico = a006g000003pwb1
ubicacion_IPRESS = a0w6g000000nSJ0


select * from visita_concordancia where fecha_visita = '2020-11-19'

select * from visita_concordancia where rank = '338'


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

-- Eliminamos registros pasados
delete from	#salesforce_visita_medico
where	cast(Fecha_y_Hora__c as date) < '2020-09-01'
go


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
ALTER COLUMN id_representante nvarchar(255) COLLATE Latin1_General_CS_AS
go

update	a
set		a.nombre_propietario = b.nombre_representante
from	temporal.[dbo].[input_usuarios] b
inner join salesforce_medico a
on		a.id_propietario= b.id_representante
go

drop table if exists #ubicacion_medico
select	b.nombre_propietario
		,a.medicos__c as id_medico
		,b.nombre_medico
		,b.cmp
		,a.ubicacion_IPRESS__C
into	#ubicacion_medico
from	salesforce_ubicacion_medico a
inner join salesforce_medico b
on		a.Medicos__c = b.id_medico
go


drop table if exists #ubicacion_medico_total
select	a.nombre_propietario
		,a.id_medico
		,a.nombre_medico
		,a.cmp
		,b.latitud__c as latitud
		,b.longitud__c as longitud
		,b.name as nombre_centro
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
--delete from #ubicacion_medico_total where nombre_propietario = 'Ivo Carlos Ramos'

-- ****************************************************************************************

--Preparamos la tabla salesforce_visita_medico
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
set		a.id_propietario = b.id_representante
from	temporal.dbo.input_usuarios b
inner join #ubicacion_medico_total a
on		a.nombre_propietario = b.nombre_representante
where	a.id_propietario is null



drop table if exists #visita_concordancia
select	b.latitud as latitud_IPRESS
		,b.longitud as longitud_IPRESS
		,b.nombre_medico
		,b.nombre_centro
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
on		(a.cmp__c = b.cmp)
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

ALTER TABLE temporal.[dbo].[input_usuarios]
ALTER COLUMN id_representante varchar(50) COLLATE Latin1_General_CS_AS
go

-- Completamos Nombres vacíos
update	a
set		a.nombre_propietario = b.nombre_representante
from	temporal.[dbo].[input_usuarios] b
inner join #visita_concordancia a
on		a.id_propietario = b.id_representante
where	a.nombre_propietario is null
go



--**************************************************************************
-- Tabla de concordancia

alter table #visita_concordancia add estado varchar(20)
go

alter table #visita_concordancia add distancia varchar(100)
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

-- Consideramos solo valores no repetidos
	drop table if exists visita_concordancia
	go
	with	cte_repetido
	as
	(
	select	ROW_NUMBER() OVER(PARTITION BY cmp,id_propietario,fecha_visita
			ORDER BY cmp DESC) AS "repetido"
			,*
	from	#visita_concordancia
	)select rank() over(order by id_visita asc)rank
	,* 
	into	visita_concordancia
	from	cte_repetido
	where	repetido = 1
	go

	alter table visita_concordancia drop column repetido
	go



---***************************************************************************************************
--SET NOCOUNT ON

--***************************************************************************************************
-- Extraemos registros sin IPRESS

drop table if exists #sin_IPRESS
select	*
into	#sin_IPRESS
from	visita_concordancia 
where	latitud_IPRESS is null
go

delete from visita_concordancia
where	latitud_IPRESS is null
go

update	visita_concordancia
set		longitud_visita = concat(substring(longitud_visita,1,7),'00')
where	len(longitud_visita) = 8

update visita_concordancia 
set longitud_visita = replace(ltrim(rtrim(substring(longitud_visita,1,9))),' ','')
go

update visita_concordancia 
set latitud_visita = replace(ltrim(rtrim(substring(latitud_visita,1,9))),' ','')
go

update visita_concordancia 
set longitud_IPRESS = replace(ltrim(rtrim(substring(longitud_IPRESS,1,9))),' ','')
go

update visita_concordancia 
set latitud_IPRESS = replace(ltrim(rtrim(substring(latitud_IPRESS,1,9))),' ','')
go

update visita_concordancia 
set latitud_IPRESS = ltrim(rtrim(replace(latitud_IPRESS,',','')))
go

update visita_concordancia 
set longitud_IPRESS = ltrim(rtrim(replace(longitud_IPRESS,',','')))
go

update visita_concordancia 
set longitud_visita = ltrim(rtrim(replace(longitud_visita,',','')))
go

update visita_concordancia 
set latitud_visita = ltrim(rtrim(replace(latitud_visita,',','')))
go

--

update	visita_concordancia
set		distancia = 
				1000*6371.01*ACOS(
				SIN(RADIANS(latitud_visita))*SIN(RADIANS(latitud_IPRESS))+
				COS(RADIANS(latitud_visita))*COS(RADIANS(latitud_IPRESS))*
				COS(RADIANS(longitud_visita)-RADIANS(longitud_IPRESS)))
go

--convertimos a decimal
alter table visita_concordancia alter column distancia float
go

update	visita_concordancia
set		distancia = cast(distancia as float)
go

--Unimos la tabla de IPRESS

insert into visita_concordancia
select * from #sin_IPRESS


update	visita_concordancia
set		estado = 'SIN IPRESS'
where	latitud_IPRESS is null
go


update	a
set		a.nombre_medico = b.[nombre_medico]
from	[dbo].[salesforce_medico] b
inner join visita_concordancia a
on		a.cmp= b.cmp
go

update	visita_concordancia
set		estado = 'revisar'
where	distancia > cast(200.00 as float)
and		latitud_IPRESS is not null
go

update	visita_concordancia
set		estado = 'correcto'
where	distancia <= cast(200.00 as float)
and		latitud_IPRESS is not null
go

update	visita_concordancia
set		distancia = 0
where	estado = 'SIN IPRESS'
go

SELECT [rank]
      ,[latitud_IPRESS]
      ,[longitud_IPRESS]
      ,[nombre_medico]
      ,[nombre_propietario]
      ,[id_propietario]
      ,[cmp]
      ,[fecha_visita]
      ,[Geolocalizacion__c]
      ,[id_visita]
      ,[latitud_visita]
      ,[longitud_visita]
      ,[estado]
      ,[distancia]
	  ,[nombre_centro]
  FROM [dbo].[visita_concordancia]

