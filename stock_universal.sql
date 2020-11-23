select * from [dbo].[salesforce_ubicacion_IPRESS]
where name like '%DAFI%'

select distinct cmp,id_medico from [dbo].[salesforce_medico]
where cmp in ('27501','46333','31844','67106','64128','68730','64469','50898','31495','56561','63125','45832','31784','38003')

select	count(*)
from	[dbo].[salesforce_visita_medico]



drop table if exists #visitador
select	distinct substring(a.OwnerId,1,15)id_visitador
		,b.nombre_representante
		,cast(a.Fecha_y_Hora__c as date)fecha_visita
into	#visitador
from	[dbo].[salesforce_visita_medico] a
left join temporal.dbo.input_usuarios b
on		substring(a.OwnerId,1,15) = b.id_representante
where	b.nombre_representante in ('Rocio Luyo Torres','Luz Castañeda Jumpa','Cesar Pezo','David Tello Trauco')
and		Fecha_y_Hora__c is not null

select distinct a.nombre_representante
		,a.fecha_visita
		--,b.DIA_LABORABLE
from	#visitador a
left join visita_dia_laborable b
on	a.id_visitador = b.Id_usuario_laborable
where	a.nombre_representante in ('Rocio Luyo Torres','Luz Castañeda Jumpa','Cesar Pezo','David Tello Trauco')

declare @nombre_representante varchar(200) = ''
declare @fecha_visita date = ''

Cesar Pezo	2020-11-17
Luz Castañeda Jumpa	2020-11-09
Rocio Luyo Torres	2020-11-09
Rocio Luyo Torres	2020-11-11
Rocio Luyo Torres	2020-11-12

delete from visita_dia_laborable
where NOMBRE_REPRESENTANTE = @nombre_representante
and		DIA_LABORABLE not in (@fecha_visita)


select count(*) from [dbo].[salesforce_visita_medico] where cast([Fecha_y_Hora__c] as date) = '2020-11-19' and [Nombre_Propietario__c] = 'Allison Pasco'

select count(*) from visita_concordancia where fecha_visita = '2020-11-19' and nombre_propietario = 'Allison Pasco'

--

select * from [dbo].[salesforce_visita_medico] where cast([Fecha_y_Hora__c] as date) = '2020-11-17' and [Nombre_Propietario__c] = 'Allison Pasco'

select * from visita_concordancia where fecha_visita = '2020-11-19' and nombre_propietario = 'Allison Pasco'

