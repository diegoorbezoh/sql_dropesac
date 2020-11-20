
truncate table temporal.dbo.visitador_tarea_resumen
go

insert into temporal.dbo.visitador_tarea_resumen
select  b.nombre_representante as responsable
		,cast(a.CreatedDate as date) as fecha
		,a.Status as estado_tarea
		,a.subject as asunto
from temporal.dbo.visitador_tarea a
inner join temporal.dbo.input_usuarios b
on		substring(a.OwnerId,1,15) = b.id_representante
where	a.CreatedById like '%0056g000004b21n%' 

