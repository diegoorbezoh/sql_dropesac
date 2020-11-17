select * from visita_concordancia where rank = 1

325.610937982869	1

drop table if exists #prueba_concordancia
select * into #prueba_concordancia from visita_concordancia

alter table #prueba_concordancia alter column distancia varchar(100)


select			1000*6371.01*ACOS(
				SIN(RADIANS(latitud_visita))*SIN(RADIANS(latitud_IPRESS))+
				COS(RADIANS(latitud_visita))*COS(RADIANS(latitud_IPRESS))*
				COS(RADIANS(longitud_visita)-RADIANS(longitud_IPRESS))
				)
				,rank
from			#prueba_concordancia


update #prueba_concordancia 
set longitud_visita = substring(longitud_visita,1,9)

update #prueba_concordancia 
set latitud_IPRESS = replace(latitud_IPRESS,',','')

update #prueba_concordancia 
set longitud_IPRESS = replace(longitud_IPRESS,',','')