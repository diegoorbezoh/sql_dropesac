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

select * from [dbo].[salesforce_medico] w

38529

*/

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

update	salesforce_visita_medico
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
delete from #ubicacion_medico_total where nombre_propietario = 'Ivo Carlos Ramos'

-- ****************************************************************************************

--Preparamos la tabla salesforce_visita_medico
ALTER TABLE salesforce_visita_medico
ALTER COLUMN OwnerId nvarchar(18) COLLATE Latin1_General_CS_AS

ALTER TABLE salesforce_visita_medico
ALTER COLUMN id nvarchar(80) COLLATE Latin1_General_CS_AS

ALTER TABLE salesforce_visita_medico
ALTER COLUMN OwnerId nvarchar(18) COLLATE Latin1_General_CS_AS



update	salesforce_visita_medico
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
		,b.nombre_centro
		,a.Nombre_Propietario__c as nombre_propietario
		,a.OwnerId as id_propietario
		,a.cmp__c as cmp
		,cast(a.Fecha_y_Hora__c as date)fecha_visita
		,a.Geolocalizacion__c
		,a.id as id_visita
		,a.Elegir_Visita__c
into	#visita_concordancia
from	salesforce_visita_medico a
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
from salesforce_visita_medico


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
from salesforce_visita_medico


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

delete from visita_concordancia
where id_visita = 'a016g00000aMmdp'
go
/*




declare @cont0 int = 1
declare @total_representante int
declare @nid_representante varchar(200)

declare @cont int = 1
declare @total_cmp int
declare @n_cmp varchar(10)

declare @cont2 int = 1
declare @total_fecha int
declare @n_fecha date

declare @latitud_IPRESS varchar(200)
declare @longitud_IPRESS varchar(200)
declare @latitud_visita varchar(200)
declare @longitud_visita varchar(200)

declare @distancia varchar(200)

--***************************************************************************************************
-- Iniciamos recorridos

set @total_representante = (select count(*) from #id_propietario)

while (@cont0 <= @total_representante)
begin
	set	@nid_representante = (select id_propietario from #id_propietario where rank = @cont0)

	-- Creamos temporal de cmp según representante
	drop table if exists #cmp_aux
	select distinct cmp into #cmp_aux from visita_concordancia where id_propietario = @nid_representante

	drop table if exists #cmp
	select distinct rank() over(order by cmp asc)rank,cmp into #cmp from #cmp_aux

	print @cont0
	print @nid_representante

--Recorremos CMP

	set @total_cmp = (select count(*) from #cmp)

	while (@cont <= @total_cmp) 
	begin
		set @n_cmp = (select cmp from #cmp where rank = @cont)
		print @n_cmp

	--Creamos temporal de fecha según cmp y id_rep
	drop table if exists #fecha_visita_aux
	select distinct fecha_visita into #fecha_visita_aux from visita_concordancia where cmp = @n_cmp and id_propietario = @nid_representante
	drop table if exists #fecha_visita
	select distinct rank() over(order by fecha_visita asc)rank,fecha_visita into #fecha_visita from #fecha_visita_aux

	set @total_fecha = (select count(*) from #fecha_visita_aux)

		while (@cont2 <= @total_fecha)
		begin
			set @latitud_IPRESS = (
				select substring(latitud_IPRESS,1,8)  from visita_concordancia where id_propietario = @nid_representante and cmp = @n_cmp and fecha_visita = 
				(select fecha_visita from #fecha_visita where rank = @cont2)
			)
			set @longitud_IPRESS =  (
				select substring(longitud_IPRESS,1,8) from visita_concordancia where id_propietario = @nid_representante and cmp = @n_cmp and fecha_visita = 
				(select fecha_visita from #fecha_visita where rank = @cont2)
			) 
			set	@latitud_visita =  (
				select substring(latitud_visita,1,8) from visita_concordancia where id_propietario = @nid_representante and cmp = @n_cmp and fecha_visita = 
				(select fecha_visita from #fecha_visita where rank = @cont2)
			) 
			set @longitud_visita =  (
				select substring(longitud_visita,1,8) from visita_concordancia where id_propietario = @nid_representante and cmp = @n_cmp and fecha_visita = 
				(select fecha_visita from #fecha_visita where rank = @cont2)
			)

			set @distancia = (
			cast (
						(
						select 1000*6371.01*ACOS(SIN(RADIANS(@latitud_visita))*SIN(RADIANS(@latitud_IPRESS))+
						COS(RADIANS(@latitud_visita))*COS(RADIANS(@latitud_IPRESS))
						*COS(RADIANS(@longitud_visita)-RADIANS(@longitud_IPRESS)))
						)
						as varchar(8)
				)
				)
			update	visita_concordancia
			set		distancia = @distancia
			where	rank = (
						select rank from visita_concordancia where id_propietario = @nid_representante and cmp = @n_cmp and fecha_visita = 
						(select fecha_visita from #fecha_visita where rank = @cont2)
						)
			print 'latitud IPRESS ' + @latitud_IPRESS
			print 'longitud IPRESS ' + @longitud_IPRESS
			print 'latitud visita ' + @latitud_visita
			print 'longitud visita ' + @longitud_visita
			print 'distancia ' + @distancia
			set @cont2 = @cont2 + 1
		end
	set @cont2 = 1
	set @cont = @cont + 1
	end
	set @cont2 = 1
	set @cont = 1
set @cont0 = @cont0 + 1
end

*/
--Calculos de estado



--!PROVISIONAL


insert into visita_concordancia
select * from #sin_IPRESS

begin tran
rollback


select * from visita_concordancia where distancia is null


update	visita_concordancia
set		estado = 'SIN IPRESS'
where estado is null
go

begin tran

update	visita_concordancia
set		estado = 'revisar'
where estado is null

delete from visita_concordancia 
where estado = 'revisar' and distancia is null
go

update	a
set		a.nombre_medico = b.[nombre_medico]
from	[dbo].[salesforce_medico] b
inner join visita_concordancia a
on		a.cmp= b.cmp
go



/*
select * from [dbo].[visita_concordancia] where nombre_centro is not null and latitud_IPRESS is null

select * from [dbo].[salesforce_medico] where cmp = '29180'


select * from [dbo].[salesforce_ubicacion_medico] where Medicos__c = 'a006g000003r8Os'
select * from [dbo].[salesforce_ubicacion_IPRESS] where ID like '%a0w6g0000037Vgt%'
[dbo].[salesforce_visita_medico]

ALTER TABLE salesforce_visita_medico
ALTER COLUMN Medicos__c nvarchar(18) COLLATE Latin1_General_CS_AS
go

ALTER TABLE salesforce_ubicacion_medico
ALTER COLUMN Medicos__c nvarchar(18) COLLATE Latin1_General_CS_AS
go

ALTER TABLE salesforce_ubicacion_medico
ALTER COLUMN Ubicacion_IPRESS__c nvarchar(18) COLLATE Latin1_General_CS_AS
go

ALTER TABLE salesforce_ubicacion_IPRESS
ALTER COLUMN id nvarchar(18) COLLATE Latin1_General_CS_AS
go

select	distinct a.cmp__c as cmp 
		,c.Latitud__c as latitud
		,c.Longitud__c as longitud
		,c.Name
from	salesforce_visita_medico a
left join salesforce_ubicacion_medico b
on substring(a.Medicos__c,1,15) = substring(b.Medicos__c,1,15)
inner join salesforce_ubicacion_IPRESS c
on substring(b.Ubicacion_IPRESS__c,1,15) = substring(c.id,1,15)



select * from visita_concordancia where cmp = '29890'

select * from visita_concordancia where nombre_propietario like '%erin%' and nombre_medico like '%TOMA%'

select * from [dbo].[salesforce_ubicacion_IPRESS] where Direccion__c like '%PIURA 185%'


select * from visita_concordancia where id_visita in
(select substring(id,1,15) from salesforce_visita_medico where Elegir_Visita__c != 'VISITA PRESENCIAL')

select * from visita_concordancia where cmp = 37286

select * from visita_concordancia where nombre_medico like '%LAU%'
select * from visita_concordancia where cmp = '37286'

select distinct nombre_representante from [dbo].[visita_dia_laborable] order by 1 desc

select * from visita_concordancia
union
select * from #sin_IPRESS

select * from visita_concordancia where cmp = '37286'

select distinct nombre_propietario,cmp from visita_concordancia where fecha_visita = '2020-11-10' and latitud_IPRESS is null
group by nombre_propietario

select * from visita_concordancia order by fecha_visita desc




select distinct estado from visita_concordancia where estado = 'revisar'
select * from visita_concordancia where distancia is NULL

select	ROW_NUMBER() OVER(PARTITION BY cmp,id_propietario,fecha_visita
			ORDER BY cmp DESC) AS "repetido"
			,*
	from	#visita_concordancia

------------------------------------------
	
	with cte_repetido
	as
	(
	select count(*)repetidos,cmp,fecha_visita,nombre_propietario from visita_concordancia
	group by cmp,fecha_visita,nombre_propietario
	)select * from cte_repetido where repetidos > 1


	select	ROW_NUMBER() OVER(PARTITION BY cmp
			ORDER BY cmp DESC) AS "Row Number"
			,cmp,fecha_visita,nombre_propietario 
	from	visita_concordancia
	group by cmp,fecha_visita,nombre_propietario



select max(len(latitud_IPRESS)) from visita_concordancia

update visita_concordancia
set		estado = null

#cmp
#fecha_visita
select * from visita_concordancia where estado is not null
select * from visita_concordancia where id_propietario = '0056g000004b20a' and cmp = '10611' and fecha_visita = '2020-03-13'

and fecha_visita = '2020-03-13'





##3. Test compara concordancia

##-------------------------------------------------------------------------------------

##Creamos tabla de representantes únicos

use test;
drop table if exists representante;
CREATE TABLE `representante` (
  num_fila int NOT NULL AUTO_INCREMENT,
  auxiliar_representante varchar(100) not null,
  PRIMARY KEY (`num_fila`)
);

insert into representante (auxiliar_representante)
select distinct nombre_representante from test.tabla_concordancia;


alter table test.representante add nombre_representante varchar(100) default '';

update test.representante set nombre_representante = auxiliar_representante;



##4. Store Procedure de comparación
##--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

USE `comercial`;
DROP procedure IF EXISTS `calculo_distancia`;

DELIMITER $$
USE `comercial`$$
CREATE DEFINER=`dorbezo`@`%` PROCEDURE `calculo_distancia`(in nrepresentante varchar(200))
begin

        declare nfecha_visita date;
        declare ini_rep int default 0;
        declare fin_rep int default 0;
        
        declare nfila int default 0;

        declare cont2 int default 1;
        declare total2 int default 1;
        declare ncmp varchar(10);
        
        declare cont3 int default 1;
        declare total3 int default 1;
        
        declare nlatitud1 varchar(50);
		declare nlongitud1 varchar(50);
        
        declare nlatitud2 varchar(50);
		declare nlongitud2 varchar(50);
        
        declare calculo_distancia int default 0;
        
		declare ndistancia1 int;
        declare ndistancia2 int;
        declare nfila2 int default 1;
		declare rdistancia1 int default 1;
		declare rdistancia2 int default 0;
        declare diferencia_distancia int default 0;
        
    #set nrepresentante = 'Erin Escobedo';
    set ini_rep = (select min(num_fila) from test.tabla_concordancia where nombre_representante = nrepresentante);
    set fin_rep = (select max(num_fila) from test.tabla_concordancia where nombre_representante = nrepresentante);
    ##Temporal CMP
      drop table if exists test.cmp_aux;
      create temporary table test.cmp_aux
      select distinct cmp from test.tabla_concordancia where nombre_representante = nrepresentante;
 
      drop table if exists test.cmp;
      create temporary table test.cmp
      select distinct cmp, @curRank := @curRank + 1 AS rank from test.cmp_aux, (SELECT @curRank := 0) r;
      ##Actualizamos de 1 al total de registros cmp que tiene un representante
      set total2 = (select count(*) from test.cmp);
      
      ##ciclo de CMP ------------------------------------------------------------------------------------------------------------------
      while cont2 <= total2 do
		  set ncmp = (select cmp from test.cmp where rank = cont2);
		##Temporal fechas
		#Todas las visitas con el CMP extraído
		  drop table if exists test.fecha;
		  create temporary table test.fecha
		  select distinct fecha_visita, @curRank := @curRank + 1 AS rank from test.tabla_concordancia,(SELECT @curRank := 0)r where cmp = ncmp;

		##Actualizamos de 1 al total de registros fecha que tiene un cmp para un representante
          set total3 = (select count(*) from test.fecha);

           ##ciclo de fecha ------------------------------------------------------------------------------------------------------------------
			  while cont3 <= total3 do
					#Traemos los valores de fecha
				  set nfecha_visita = (select fecha_visita from test.fecha where rank =cont3);
				  set nfila = (select rank from test.fecha where rank =cont3);
     
				  if (nfila = 1) then
					set nlatitud1 = (select latitud from test.tabla_concordancia where nombre_representante = nrepresentante and cmp = ncmp and fecha_visita = nfecha_visita);
					set nlongitud1 = (select longitud from test.tabla_concordancia where nombre_representante = nrepresentante and cmp = ncmp and fecha_visita = nfecha_visita);
   
				 elseif(nfila > 1)then
					set nfila2 = (select num_fila from test.tabla_concordancia where nombre_representante = nrepresentante and cmp = ncmp and fecha_visita = nfecha_visita);
					set nlatitud2 = (select latitud from test.tabla_concordancia where nombre_representante = nrepresentante and cmp = ncmp and fecha_visita = nfecha_visita);
					set nlongitud2 = (select longitud from test.tabla_concordancia where nombre_representante = nrepresentante and cmp = ncmp and fecha_visita = nfecha_visita);
                  	  
                  end if;
                  
				if (nlatitud1 != '' and nlongitud1 != '' and nlatitud2 != '' and nlongitud2 != '') then
					set calculo_distancia = ( select 1000*6371.01*ACOS(SIN(RADIANS(nlatitud1))*SIN(RADIANS(nlatitud2)) +COS(RADIANS(nlatitud1))*COS(RADIANS(nlatitud2)) *COS(RADIANS(nlongitud1)-RADIANS(nlongitud2))));
					update test.tabla_concordancia
					set		distancia = calculo_distancia
                    where num_fila = nfila2 and distancia = 0; #Se considera solo nfila2, porque la 1 es para solo 1 visita
                    
                    #Diferencia de distancias
                    #Traemos el num_fila de cada distancia encontrada
					set rdistancia1 = (select min(num_fila)+1 from test.tabla_concordancia where cmp = ncmp);
					set rdistancia2 = (rdistancia1+cont3-1);
                    
					#Traemos la distancia de cada num_fila
                    set ndistancia1 = (select distancia from test.tabla_concordancia where num_fila = rdistancia1);
                    set ndistancia2 = (select distancia from test.tabla_concordancia where num_fila = rdistancia2);
                    
                    if (ndistancia1 > 0 and ndistancia2 >0) then
						set diferencia_distancia = abs(ndistancia2 - ndistancia1);
						update test.tabla_concordancia
						set		distancia2 = diferencia_distancia
						where	num_fila = rdistancia2;
                    end if;
				end if;
#select   nlatitud1,nlatitud2,nlongitud1,nlongitud2,cont3,ncmp,calculo_distancia,rdistancia1,rdistancia2,ndistancia1,ndistancia2,diferencia_distancia;              
				set cont3 = cont3 + 1;
              end while;
		  #seteamos todas las variables para ingresar al nuevo while
          set cont3 = 1,nlatitud1 = 0, nlongitud1= 0, nlatitud2 = 0, nlongitud2 = 0,rdistancia1=0,rdistancia2=0,ndistancia1=0,ndistancia2=0,diferencia_distancia=0;
       
		  set cont2 = cont2 + 1;
		
      end while;
      
      update test.tabla_concordancia
      set	distancia = 0
      where distancia = 8603080;
      
      #Unificar fechas para latitudes y longitudes iguales
      select distinct latitud,sub_id,fecha_visita from test.tabla_concordancia
      where latitud = '-12.025283';
      
      
end$$
DELIMITER ;

call comercial.calculo_distancia('Yulisa Valverde Bellodas');
call comercial.calculo_distancia('Edgard Rojas Valqui');
call comercial.calculo_distancia('Lisdey Connie Cedrón Rengifo');
call comercial.calculo_distancia('Edgard Rojas Valqui');
call comercial.calculo_distancia('Danira Quispe Olivares');
call comercial.calculo_distancia('Allison Pasco Barbaran');
call comercial.calculo_distancia('Karin Mollyk Vela');
call comercial.calculo_distancia('Yessica Rosales Cardenas');

call comercial.calculo_distancia('Yulisa Valverde Bellodas');
call comercial.calculo_distancia('Edgard Rojas Valqui');
call comercial.calculo_distancia('Lisdey Connie Cedrón Rengifo');
call comercial.calculo_distancia('Edgard Rojas Valqui');
call comercial.calculo_distancia('Danira Quispe Olivares');
call comercial.calculo_distancia('Allison Pasco Barbaran');
call comercial.calculo_distancia('Karin Mollyk Vela');
call comercial.calculo_distancia('Yessica Rosales Cardenas');






--
select * from test.tabla_concordancia;
where latitud = '-12.025283';

drop table if exists test.tabla_concordancia_aux;
create temporary table test.tabla_concordancia_aux
select distinct latitud,longitud,sub_id,fecha_visita from test.tabla_concordancia;
#group by fecha_visita;


select longitud,fecha_visita from  test.tabla_concordancia
where latitud = '-12.025283'
group by longitud 


select nombre_representante,count(cmp) from  test.tabla_concordancia
group by nombre_representante 

select * from test.tabla_concordancia_aux
where latitud = '-12.025283';

select * from test.tabla_concordancia
where latitud = '-12.025283';



-12.025283	-77.0030063
 	4766017581214790009	Lisdey Connie Cedrón Rengifo	20376	2020-09-22
-12.025283	-77.0030063
 	4765119395022678156	Lisdey Connie Cedrón Rengifo	29180	2020-09-21
-12.025283	-77.0030063
 	4765121455023625810	Lisdey Connie Cedrón Rengifo	45342	2020-09-21

select * from test.tabla_concordancia
order by latitud;



drop table if exists test.representante;
drop table if exists test.cmp;
drop table if exists test.fecha;


select * from test.representante;
select * from test.cmp where cmp = '13158';
select * from test.fecha;


where nombre_representante = 'Erin Escobedo';


update test.tabla_concordancia
set distancia = 0, distancia2 = 0;

select * from test.tabla_concordancia
where cmp = '48179';

23004
30811
55504
13158
48179
30429
31754

select * from test.tabla_concordancia
where cmp = '976';






	drop table if exists test.tabla_concordancia_aux;
	create temporary table test.tabla_concordancia_aux
	select count(*)repetidos,cmp,fecha_visita,nombre_representante from test.tabla_concordancia
	group by cmp,fecha_visita,nombre_representante

	select * from test.tabla_concordancia_aux
	where repetidos > 1 and fecha_visita = '2020-10-28';

select * from test.tabla_concordancia_aux

select repetidos,count(*) from test.tabla_concordancia_aux
group by repetidos;

select * from test.visita_medico
where Nombre_Propietario__c = 'Erin Escobedo'
order by Fecha_visita__c desc





select count(*) from test.tabla_concordancia
where cmp = 13158 ;

select * from test.visita_medico
where cmp__c = 31754 ;






 where cmp = '28697';
where cmp = '28703';

update test.tabla_concordancia
set		distancia = 0

'90', '-12.0618799', '-77.1141508\n', '4768961461414793506', 'Erin Escobedo', '12561', '2020-09-25', 'VISITA PRESENCIAL'
'91', '-12.0644172', '-77.1227398\n', '4778099618682765488', 'Erin Escobedo', '12561', '2020-10-06', 'VISITA PRESENCIAL'
'92', '-12.0623144', '-77.123247\n', '4784986937417856666', 'Erin Escobedo', '12561', '2020-10-14', 'VISITA PRESENCIAL'
'93', '-12.0619417', '-77.1236827\n', '4791961809114299617', 'Erin Escobedo', '12561', '2020-10-22', 'VISITA PRESENCIAL'

*/


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
				end distancia
				,distancia as distancia2
				,rank
from			visita_concordancia
where			rank = '428'

alter table #prueba_concordancia alter column distancia varchar(200)

select			cast(
				1000*6371.01*ACOS(
				SIN(RADIANS(latitud_visita))*SIN(RADIANS(latitud_IPRESS))+
				COS(RADIANS(latitud_visita))*COS(RADIANS(latitud_IPRESS))*
				COS(RADIANS(longitud_visita)-RADIANS(longitud_IPRESS)))
				 as  numeric(15,2))
from			visita_concordancia
where			rank = '428'


select * from visita_concordancia where rank = '428'

select			1000*6371.01*ACOS(
				SIN(RADIANS(latitud_visita))*SIN(RADIANS(latitud_IPRESS))+
				COS(RADIANS(latitud_visita))*COS(RADIANS(latitud_IPRESS))*
				COS(RADIANS(substring(longitud_visita,1,7))-RADIANS(longitud_IPRESS)))
from			visita_concordancia
where			rank = '428'

select			1000*6371.01*ACOS(
				SIN(RADIANS(latitud_visita))*SIN(RADIANS(latitud_IPRESS))+
				COS(RADIANS(latitud_visita))*COS(RADIANS(latitud_IPRESS))*
				COS(RADIANS(substring('-77.055',1,7))-RADIANS(longitud_IPRESS)))
from			visita_concordancia
where			rank = '428'


select			1000*6371.01*ACOS(
				SIN(RADIANS(-12.02275))*SIN(RADIANS(-12.02202))+
				COS(RADIANS(-12.02275))*COS(RADIANS(-12.02202))*
				COS(RADIANS(-77.055 )-RADIANS(-77.05449)))




select RADIANS(substring('-77.055',1,4))


select * from visita_concordancia where distancia is null and rank not in (select * from pasaron)