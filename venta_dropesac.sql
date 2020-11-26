
insert into factura_boleta_reporteria
select * from dropesac2015_temp.view_factura_boleta_reporteria;

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

drop table if exists test.venta_2020;
create temporary table test.venta_2020
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

drop table if exists test.venta_2019;
create temporary table test.venta_2019
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
select		a.dia
			,b.id_visitador
			,b.nombre_visitador
			,b.total
from		test.fecha a
left join	comercial.venta_2020 b
on			a.dia = b.fecha_emision;

update  test.venta_resumen_2020 a
join    test.venta_2019 b
on      a.dia = b.fecha_emision
set     a.id_visitador = b.id_visitador
		,a.nombre_visitador = b.nombre_visitador
        ,a.total = b.total;

# 2. Insert final
insert into comercial.venta_reporteria_resumen
select * from test.venta_resumen_2020;

