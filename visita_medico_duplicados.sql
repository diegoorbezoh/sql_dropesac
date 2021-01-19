-- Repetidos salesfoce_visita_medico

drop table if exists #salesforce_visita_medico
go
with cte_asignacion_medico
as
(
select distinct 
		ROW_NUMBER() OVER(PARTITION BY OwnerId,CMP__c,cast(Fecha_y_Hora__c as date)
		ORDER BY Fecha_y_Hora__c asc) AS "repetido"
		,Fecha_y_Hora__c as fecha_visita
		,substring(OwnerId,1,15)id_propietario
		,Elegir_Visita__c
		,CMP__c
		,Name as id_visita
from salesforce_visita_medico
)select * 
into #salesforce_visita_medico
from cte_asignacion_medico


select	a.*
		,b.nombre_representante
from	#salesforce_visita_medico a
left join temporal.[dbo].[input_usuarios] b
on		a.id_propietario = b.id_representante
where	repetido > 1
and		fecha_visita is not null
and		Elegir_Visita__c is not null
and		cast(fecha_visita as date) >= '2020-09-01'
order by fecha_visita,CMP__c


-- Repetidos visita_concordancia
drop table if exists #visita_concordancia
go
with cte_visita_concordancia
as
(
select distinct 
		ROW_NUMBER() OVER(PARTITION BY id_propietario,cmp,fecha_visita
		ORDER BY distancia asc) AS "repetido"
	  ,[rank]
      ,[latitud_IPRESS]
      ,[longitud_IPRESS]
      ,[nombre_medico]
      ,[nombre_centro]
      ,[nombre_propietario]
      ,[id_propietario]
      ,[cmp]
      ,[fecha_visita]
      ,[Geolocalizacion__c]
      ,[id_visita]
      ,[Elegir_Visita__c]
      ,[latitud_visita]
      ,[longitud_visita]
      ,[estado]
      ,[distancia]
      ,[descripcion_justificado]
from comercial.dbo.visita_concordancia
)select * 
into #visita_concordancia
from cte_visita_concordancia


delete from #visita_concordancia
where	repetido > 1
and		estado != 'revisar'

alter table #visita_concordancia drop column repetido
go

truncate table comercial.dbo.visita_concordancia
go

insert into comercial.dbo.visita_concordancia
select * from #visita_concordancia

/*
select distinct repetido,estado from #visita_concordancia
where	estado != 'revisar' and repetido > 1
order by estado 
*/






select	*
from	visita_concordancia
where	cmp = '9381'
and		fecha_visita = '2020-12-14'

select	*
from	#visita_concordancia
where	cmp = '9381'
and		fecha_visita = '2020-12-07'

