select coordenada 
from visita_cliente_total

alter table visita_cliente_total add longitud_visita nvarchar(20)
go
alter table visita_cliente_total add latitud_visita nvarchar(20)
go
alter table visita_cliente_total add latitud_cliente nvarchar(20)
go

alter table visita_cliente_total add longitud_cliente nvarchar(20)
go

drop table if exists #longitud
select
substring(
	substring(coordenada
	,1
	,charindex('Latitude',coordenada)-1)
,12
,100)longitud
,coordenada
,ruc
into #longitud
from visita_cliente_total


drop table if exists #latitud;
select substring(
	substring(coordenada
	,charindex('Latitude',coordenada)
	,100)
,11
,100)latitud
,coordenada
,ruc
into #latitud
from visita_cliente_total

--update latitud y longitud
update	a
set		a.latitud_visita = b.latitud
from	#latitud b
inner join visita_cliente_total a
on		a.ruc = b.ruc

update	a
set		a.longitud_visita = b.longitud
from	#longitud b
inner join visita_cliente_total a
on		a.ruc = b.ruc




drop table if exists #temporal
select	a.*
		,b.latitud as latitud_cliente
		,b.longitud as longitud_cliente
into	#temporal
from	visita_cliente_total a
inner join cliente b
on		a.ruc = b.ruc
go

--Extramos las coordenadas de los links
--Ubicamos la latitud
drop table if exists #1
select ruc
		,substring(link
		,charindex('@-',link)+1
		,1000)link
into	#1
from	coordenada


--Extraemos latitud, se detiene en la primera coma
drop table if exists #2
select ruc
		,substring(link
		,1
		,charindex(',',link)-1)link
into	#2
from	#1


--Extraemos longitud
drop table if exists #3
select ruc
		,substring(link
		,charindex('-7',link)
		,1000)link
into	#3
from	coordenada


update	#3
set		link = '-80.6316416,'
where	ruc = '20102487363'
go

update	#3
set		link = '-80.6548882,'
where	ruc = '20526522860'
go

update	#3
set		link = '-80.6638125,'
where	ruc = '20601049130'
go

update	#3
set		link = '-80.248262,'
where	ruc = '20601713765'
go

update	#3
set		link = '-80.697807,'
where	ruc = '20604243972'
go


drop table if exists #4
select ruc
		,substring(link
		,1
		,charindex(',',link))link
into	#4
from	#3


update	#4
set		link = replace(link,',','')
go


update	#4
set		link = '-77.0714169'
where	ruc = '10418866867'
go

update	#4
set		link = '-78.1108279'
where	ruc = '20602002480'
go


--consolidado
drop table if exists #consolidado_cliente
select a.ruc
	,a.link as latitud
	,b.link as longitud
into	#consolidado_cliente	
from	#2 a
inner join #4 b
on	a.ruc = b.ruc
go

--update de coordenadas cliente
update	a
set		a.latitud_cliente = b.latitud
		,a.longitud_cliente = b.longitud
from	#consolidado_cliente b
right join visita_cliente_total a
on		a.ruc = b.ruc
where	a.tipo_visita = 'VISITA PRESENCIAL'
go

alter table visita_cliente_total add distancia varchar(100)
go

alter table visita_cliente_total add estado varchar(100)
go


update	visita_cliente_total
set		estado = 'Sin ubicacion'
where	latitud_cliente is null
go


update	visita_cliente_total
set		distancia = 
				1000*6371.01*ACOS(
				SIN(RADIANS(latitud_visita))*SIN(RADIANS(latitud_cliente))+
				COS(RADIANS(latitud_visita))*COS(RADIANS(latitud_cliente))*
				COS(RADIANS(longitud_visita)-RADIANS(longitud_cliente)))
where	estado is null
go

update	visita_cliente_total
set		estado = 'Revisar'
where	cast(distancia as decimal(10,2)) > 200.00
and		estado is null
go

update	visita_cliente_total
set		estado = 'Correcto'
where	cast(distancia as decimal(10,2)) <= 200.00
and		estado is null
go


update	visita_cliente_total
set		distancia = cast(distancia as decimal(10,2))
go

select * from visita_cliente_total
order by cast(distancia as decimal(10,2)) asc


[dbo].[input_usuarios]




alter table #temporal add 

select * from #temporal
where propietario not in ('David Alberto Bonilla','Ivo Carlos Ramos')
order by distancia asc




truncate table coordenada
go

-- Limpieza de link

select	substring(
		link
		,charindex('-1',link)
		,300)
		,link
from coordenada

select substring('-',link)link
		,link
from coordenada



update	[dbo].[visitador_tarea]
set		status = 'Abierto'
where	status = 'Open'

