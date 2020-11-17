
select * from #prueba_concordancia where cmp = 21959 and distancia is null and estado != 'SIN IPRESS'

select * from visita_concordancia where distancia is null and latitud_IPRESS is not null


select max(len(longitud_visita)) from #prueba_concordancia

drop table if exists #prueba_concordancia
select * into #prueba_concordancia from visita_concordancia

alter table #prueba_concordancia alter column distancia varchar(100)

update #prueba_concordancia 
set longitud_visita = ltrim(rtrim(substring(longitud_visita,1,9)))
go

update #prueba_concordancia 
set latitud_visita = ltrim(rtrim(substring(latitud_visita,1,9)))
go

update #prueba_concordancia 
set latitud_IPRESS = ltrim(rtrim(replace(latitud_IPRESS,',','')))
go

update #prueba_concordancia 
set longitud_IPRESS = ltrim(rtrim(replace(longitud_IPRESS,',','')))
go

update #prueba_concordancia 
set longitud_visita = ltrim(rtrim(replace(longitud_visita,',','')))
go

update #prueba_concordancia 
set latitud_visita = ltrim(rtrim(replace(latitud_visita,',','')))
go


--valido
select			case when len(
				cast(
				1000*6371.01*ACOS(
				SIN(RADIANS(latitud_visita))*SIN(RADIANS(latitud_IPRESS))+
				COS(RADIANS(latitud_visita))*COS(RADIANS(latitud_IPRESS))*
				COS(RADIANS(longitud_visita)-RADIANS(longitud_IPRESS)))
				 as numeric(15,2)) 
				) > 8 then 10000 
				else 
				cast(
				1000*6371.01*ACOS(
				SIN(RADIANS(latitud_visita))*SIN(RADIANS(latitud_IPRESS))+
				COS(RADIANS(latitud_visita))*COS(RADIANS(latitud_IPRESS))*
				COS(RADIANS(longitud_visita)-RADIANS(longitud_IPRESS)))
				as numeric(15,2)) 
				end
				,distancia
from			#prueba_concordancia
where			latitud_IPRESS is not null

select			
				cast(
				1000*6371.01*ACOS(
				SIN(RADIANS(latitud_visita))*SIN(RADIANS(latitud_IPRESS))+
				COS(RADIANS(latitud_visita))*COS(RADIANS(latitud_IPRESS))*
				COS(RADIANS(longitud_visita)-RADIANS(longitud_IPRESS)))
				as numeric(15,2)) 
				,distancia
from			#prueba_concordancia
where			latitud_IPRESS is not null



				 cast(
				1000*6371.01*ACOS(
				SIN(RADIANS('-12.0626313'))*SIN(RADIANS('-12.0639353'))+
				COS(RADIANS('-12.0626313'))*COS(RADIANS('-12.0639353'))*
				COS(RADIANS('-77.1228245')-RADIANS('-77.1214128')))
				 as numeric(15,2)) 



select			cast(
				1000*6371.01*ACOS(
				SIN(RADIANS('-12.0619019'))*SIN(RADIANS('-12.056425'))+
				COS(RADIANS('-12.0619019'))*COS(RADIANS('-12.056425'))*
				COS(RADIANS('-77.1141656')-RADIANS('77.142401')))
				 as numeric(15,2))


16108116.76


select * from #distancias where cmp = 30429

select * from #prueba_concordancia where cmp = 30429

select * from #distancias where rank = 585
select * from #distancias order by distancia desc