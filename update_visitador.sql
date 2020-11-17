
drop table if exists #salesforce_visita_medico
select	*
into	#salesforce_visita_medico
from	salesforce_visita_medico

ALTER TABLE #salesforce_visita_medico
ALTER COLUMN OwnerId nvarchar(255) COLLATE Latin1_General_CS_AS
go

update	#salesforce_visita_medico
set		OwnerId = substring(OwnerId,1,18)

drop table if exists #lista_visita
select	distinct
		substring(OwnerId,1,15)id_propietario
		,substring(Medicos__c,1,15)id_medico
		,cast(Fecha_y_Hora__c as date)fecha
into	#lista_visita
from	#salesforce_visita_medico
where	OwnerId not in ('a006g000003pwwj','0056g0000039GlB','0056g000004bILJ','0056g000004b79t','0056g000004b1u8','0056g0000037qsr','0056g000004bNgg','0056g000005CArK')
order by id_medico,cast(Fecha_y_Hora__c as date) desc

drop table if exists #visita_medico_visitador
go
with	cte_lista_visita
as
(
select	ROW_NUMBER() OVER(PARTITION BY id_medico,fecha
		ORDER BY fecha DESC) AS "repetido"
		,*
from	#lista_visita
)select * 
into	#visita_medico_visitador
from	cte_lista_visita
where	repetido = 1
ORDER BY cast(fecha as date) desc

alter table #visita_medico_visitador drop column repetido
--
drop table if exists visita_medico_visitador
go
with	cte_lista_visita2
as
(
select	ROW_NUMBER() OVER(PARTITION BY id_medico
		ORDER BY fecha DESC) AS "repetido"
		,*
from	#visita_medico_visitador
)select *
into	visita_medico_visitador
from	cte_lista_visita2
where	repetido = 1
and		fecha is not null

alter table visita_medico_visitador drop column repetido
go
