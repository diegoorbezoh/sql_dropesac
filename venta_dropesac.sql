



insert into factura_boleta_reporteria
select * from dropesac2015_temp.view_factura_boleta_reporteria;


select distinct producto from comercial.venta_reporteria
where producto '%MEGEX%'





# 1. Update de campos null
update  comercial.venta_reporteria a
join    comercial.venta_visitador b
on      a.numeroDocumentoCliente = b.doc_cliente
set     a.id_visitador = b.id_visitador
where   a.id_visitador is null;

update  comercial.venta_reporteria a
join    comercial.venta_visitador b
on      a.id_visitador = b.id_visitador
set     a.nombre_visitador = b.nombre_visitador
where   a.nombre_visitador is null;

-- Tablas temporales según año

use test;

drop table if exists venta_2020;
create temporary table venta_2020
SELECT cast(fechaEmision as date)fecha_emision
			,id_visitador
            ,nombre_visitador
            ,sum(total)total
FROM	comercial.venta_reporteria
WHERE	YEAR(fechaEmision) = 2020
AND     idProducto IN ('1719','1813','1817','2035','2040','2087','2100','2104','2143','2147')
group by fechaEmision
		,id_visitador
		,nombre_visitador;

drop table if exists venta_2019;
create temporary table venta_2019
SELECT cast(fechaEmision as date)fecha_emision
			,id_visitador
            ,nombre_visitador
            ,sum(total)total
FROM	comercial.venta_reporteria
WHERE	YEAR(fechaEmision) = 2019
AND     idProducto IN ('1719','1813','1817','2035','2040','2087','2100','2104','2143','2147')
group by fechaEmision
		,id_visitador
		,nombre_visitador;

drop table if exists venta_resumen_2020;
create temporary table venta_resumen_2020
select		a.dia as fecha_emision
			,b.id_visitador
			,b.nombre_visitador
			,b.total as venta_2020
from		fecha a
left join	venta_2020 b
on			a.dia = b.fecha_emision;

drop table if exists venta_resumen_2019;
create temporary table venta_resumen_2019
select		a.dia as fecha_emision
			,b.id_visitador
			,b.nombre_visitador
			,b.total as venta_2019
from		fecha a
left join	venta_2019 b
on			a.dia = b.fecha_emision;

# Eliminamos fechas que no correspondan
delete from venta_resumen_2020
where	year(fecha_emision) = '2019';

delete from venta_resumen_2019
where	year(fecha_emision) = '2020';

# Limpiamos antes del Join con los días totales
update	venta_resumen_2020
set		venta_2020 = 0
where	venta_2020 is null
and		year(fecha_emision) = '2020';

update	venta_resumen_2019
set		venta_2019 = 0
where	venta_2019 is null
and		year(fecha_emision) = '2019';

alter table venta_resumen_2020 add cod_dia_act varchar(10);
alter table venta_resumen_2019 add cod_dia_act varchar(10);

update	venta_resumen_2020
set		cod_dia_act = replace(cast(fecha_emision as char(10)),'-','') 
;

update	venta_resumen_2019
set		cod_dia_act = replace(cast(fecha_emision as char(10)),'-','') 
;

update	venta_resumen_2019
set		cod_dia_act = replace(cod_dia_act,'2019','2020') 
;

select	dia
		,id_visitador
        ,nombre_visitador
        ,total as venta_2020
from	venta_resumen_2020
where	year(dia) = '2020';


# separar
update  venta_resumen_2020 a
join    venta_2019 b
on      a.dia = b.fecha_emision
set     a.id_visitador = b.id_visitador
		,a.nombre_visitador = b.nombre_visitador
        ,a.total = b.total;


drop co
alter table venta_resumen_2020 add crecimiento decimal(10,2) null;

# 2. Actualizamos el crecimiento
update	venta_resumen_2020
set		crecimiento ()

# 2. Insert final
insert into comercial.venta_reporteria_resumen
select * from venta_resumen_2020;



