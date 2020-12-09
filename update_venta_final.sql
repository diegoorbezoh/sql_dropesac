
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


#---

select fechaEmision from comercial.venta_reporteria
order by fechaEmision desc;


select * from dropesac2015_temp.view_pre_pedidos_distribucion
where numeroDocumentoDistribuidor = '20482528695'
;


truncate table comercial.transferencias_reporteria;

insert into comercial.transferencias_reporteria
select * from dropesac2015_temp.view_pre_pedidos_distribucion;


select distinct idVendedor from comercial.venta_reporteria ;


select distinct idVendedor from comercial.venta_reporteria
where idVendedor in (select distinct idVendedor from comercial.transferencias_reporteria)
order by idVendedor;




select * from comercial.venta_reporteria
where idVendedor = '132' and cast(fechaEmision as date) = '2020-06-18';
select sum(subTotalValorVenta)venta_trans from comercial.transferencias_reporteria
where idVendedor = '132' and cast(fechaEmisionPrePedido as date) = '2020-06-18';

#resta NC

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

# Temporal transferencias

drop table if exists test.transferencias_reporteria_aux;
create temporary table test.transferencias_reporteria_aux
select  a.idVendedor
        ,cast(a.fechaEmisionPrePedido as date)fechaEmision
        ,sum(a.subTotalValorVenta)venta_transferencia
from    comercial.transferencias_reporteria a
group by a.idVendedor
         ,a.fechaEmisionPrePedido
;

# Tabla resumen

truncate table comercial.venta_resultado;

insert into comercial.venta_resultado
select  a.idVendedor
        ,a.vendedor
        ,a.fechaEmision
        ,a.venta_directa
        ,b.venta_transferencia
from    test.venta_reporteria_aux a
left join test.transferencias_reporteria_aux b
on      (a.idVendedor = b.idVendedor
and    a.fechaEmision = b.fechaEmision)
;

update  comercial.venta_resultado
set     venta_transferencia = 0
where   venta_transferencia is null;

select * from comercial.venta_resultado


select * from dropesac2015_temp.view_pedidos_con_cantidad_pendiente;


PERIODO AGOSTO - NOV
POR MES CUANTO EN UNID
MERICLE,CRETROL,ALZELIN, CLANZA ,MVAT , PREGRADROL Y KENOPLAST
UNIVERSAL E INKAFARMA



# --Cuentas

select * from comercial.salesforce_cuenta limit 5;

select  count(name)
from    comercial.salesforce_cuenta
where   Type = 'Cliente Oportunidad'
and     Tipos_de_Centro_de_Salud__c = 'DIGEMID'
and     Description = 'LAB'
;

drop table if exists test.oportunidad;
create temporary table test.oportunidad
select b.nombre_completo
        ,b.zona
        ,Distrito__c
        ,case when Description = 'DRG' then count(distinct name) else 0 end DRG
        ,case when Description = 'BOT' then count(distinct name) else 0 end BOT
        ,case when Description = 'FAR' then count(distinct name) else 0 end FAR
        ,case when Description not in ('FAR','DRG','BOT') then count(distinct name) else 0 end OTROS
from    comercial.salesforce_cuenta
left join comercial.empleado b
on      substring(OwnerId,1,15) = b.id_salesforce
where   Type = 'Cliente Facturado'
#and     Tipos_de_Centro_de_Salud__c = 'DIGEMID'
group by OwnerId
        ,Description
        ,Distrito__c
        ,b.nombre_completo
        ,b.zona
order by b.nombre_completo
        ,b.zona
;


select * from test.oportunidad;


select * from venta_reporteria where nombreComercial like '%BRALMA%';


HORIZONTALIDAD


select * from venta_visitador;

delete from venta_visitador
where id = '17';



select * from test.oportunidad;
select * from comercial.empleado;

select distinct
                b.DISTRITO
                ,a.Name as ruc
                ,substring(OwnerId,1,15) as id_salesforce
from  comercial.salesforce_cuenta a
inner join test.distrito b
on a.name = b.ruc
where Type = 'Cliente Facturado'
and a.Distrito__c is null;



# --------------

create table comercial.prepedidos_reporteria as
select * from dropesac2015_temp.view_pedidos_con_cantidad_pendiente;

# --------------

select distinct tipoDocumento
from comercial.venta_reporteria
where numeroDocumentoCliente != '20604754870'
and idProducto in ('2104','1388','2040','2100','2147','2143','2178','2179','1813','1817','2087')
and year(fechaEmision) = '2020'

order by producto;


select * from visita_concordancia
where id_propietario = '0056g000005efQj'
;


select * from dropesac2015_temp.view_pedidos_con_cantidad_pendiente
limit 10;

select * from dropesac2015_temp.ventas_ordenpedidodetalle
limit 10;



flagBonificacion