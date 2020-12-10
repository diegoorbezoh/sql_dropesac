/*
 Script de ventas
 Procesos:
 - Actualización de ventas, pedidos en proceso
 - Implementación Data Studio

 */

# Update ventas y Transferencias

drop table if exists test.venta;
create temporary table test.venta
SELECT a.idDetalle,
    a.idProducto,
    a.tipoDocumento,
    a.producto,
    a.idCliente,
    a.razonSocialCliente,
    a.numeroDocumentoCliente,
    a.codigoCliente,
    a.idTipoCliente,
    a.nombreTipoCliente,
    a.idVendedor,
    a.vendedor,
    a.numeroDocumentoVendedor,
    a.idSede,
    a.nombreSede,
    a.departamento,
    a.provincia,
    a.distrito,
    a.total,
    a.fechaEmision,
    a.mes,
    a.cantidad,
    a.serie,
    a.numero,
    a.formaPago,
    a.nombreComercial,
    a.semanaYear
from dropesac2015_temp.view_factura_boleta_reporteria a;

alter table test.venta add serieRef  varchar(100);
alter table test.venta add numeroRef varchar(100);

update  test.venta
set     serieRef = ''
        ,numeroRef = ''
where   venta.serieRef is null;

truncate table comercial.venta_reporteria;

insert into comercial.venta_reporteria
select  a.idDetalle,
    a.idProducto,
    a.tipoDocumento,
    a.producto,
    a.idCliente,
    a.razonSocialCliente,
    a.numeroDocumentoCliente,
    a.codigoCliente,
    a.idTipoCliente,
    a.nombreTipoCliente,
    a.idVendedor,
    a.vendedor,
    a.numeroDocumentoVendedor,
    a.idSede,
    a.nombreSede,
    a.departamento,
    a.provincia,
    a.distrito,
    a.total,
    a.fechaEmision,
    a.mes,
    a.cantidad,
    a.serie,
    a.numero,
    a.formaPago,
    a.nombreComercial,
    a.semanaYear,
    a.serieRef,
    a.numeroRef
from    test.venta a
union   distinct
select  	b.idDetalle,
    b.idProducto,
    b.tipoDocumento,
    b.producto,
    b.idCliente,
    b.razonSocialCliente,
    b.numeroDocumentoCliente,
    b.codigoCliente,
    b.idTipoCliente,
    b.nombreTipoCliente,
    b.idVendedor,
    b.vendedor,
    b.numeroDocumentoVendedor,
    b.idSede,
    b.nombreSede,
    b.departamento,
    b.provincia,
    b.distrito,
    b.total,
    b.fechaEmision,
    b.mes,
    b.cantidad,
    b.serie,
    b.numero,
    b.formaPago,
    b.nombreComercial,
    b.semanaYear,
    b.serieRef,
    b.numeroRef
from    dropesac2015_temp.view_nota_credito_devolucion_reporteria b;

# Update pedidos en proceso

truncate table comercial.transferencias_reporteria;

insert into comercial.transferencias_reporteria
select * from dropesac2015_temp.view_pre_pedidos_distribucion;


# Temporal venta directa

drop table if exists test.venta_reporteria_aux;
create temporary table test.venta_reporteria_aux
select  a.idVendedor
        ,a.vendedor
        ,cast(a.fechaEmision as date)fechaEmision
        ,sum(a.total)venta_directa
from    comercial.venta_reporteria a
group by a.idVendedor
         ,a.vendedor
        ,a.fechaEmision
;
/*
select * from test.venta_reporteria_aux


*/

# Temporal transferencias

drop table if exists test.transferencias_reporteria_aux;
create temporary table test.transferencias_reporteria_aux
select  a.idVendedor
        ,a.nombreVendedor
        ,cast(a.fechaEmisionPrePedido as date)fechaEmision
        ,sum(a.subTotalValorVenta)venta_transferencia
from    comercial.transferencias_reporteria a
group by a.idVendedor
        ,a.nombreVendedor
         ,a.fechaEmisionPrePedido
;

/*
 select * from comercial.transferencias_reporteria

 idVendedor,fechaEmision,venta_transferencia
10,2020-11-19,1694.9152542


 */

# Matriz de fecha


drop table if exists test.vendedor;
create temporary table test.vendedor
select distinct idVendedor
from    test.venta_reporteria_aux;

drop table if exists test.matriz;
create temporary table test.matriz
select  *
from    test.fecha
CROSS JOIN test.vendedor;

select * from test.matriz;


truncate table comercial.venta_resultado;

insert into comercial.venta_resultado

drop table if exists test.resultado_venta;
create temporary table test.resultado_venta
select  distinct
        c.dia as fechaEmision
        ,c.idVendedor
        ,a.vendedor
        ,a.venta_directa
from    test.matriz c
left join test.venta_reporteria_aux a
on      (a.fechaEmision = c.dia
and     a.idVendedor = c.idVendedor)
;

drop table if exists test.resultado_transferencia;
create temporary table test.resultado_transferencia
select  distinct
        c.dia as fechaEmision
        ,c.idVendedor
        ,a.nombreVendedor
        ,a.venta_transferencia
from    test.matriz c
left join test.transferencias_reporteria_aux a
on      (a.fechaEmision = c.dia
and     a.idVendedor = c.idVendedor)
;


drop table if exists test.resultado_final;
create temporary table test.resultado_final
select  distinct
        a.fechaEmision
        ,a.idVendedor
        ,a.vendedor as nombreVendedor
        ,a.venta_directa
        ,sum(b.venta_transferencia)venta_transferencia
from    test.resultado_venta a
left join test.resultado_transferencia b
on      (a.fechaEmision = b.fechaEmision
and     a.idVendedor = b.idVendedor)
group by a.fechaEmision
        ,a.idVendedor
        ,a.vendedor
        ,a.venta_directa
;

update  test.resultado_final a
join test.resultado_transferencia b
on      a.idVendedor = b.idVendedor
set     a.nombreVendedor = b.nombreVendedor
where   a.idVendedor is null
;



select * from test.resultado_final
where fechaEmision = '2020-04-03'
and vendedor is not null;

select * from test.resultado2
where dia >= '2019-01-01'
order by dia desc;

select count(*) from test.resultado2
where venta_transferencia is not null;





