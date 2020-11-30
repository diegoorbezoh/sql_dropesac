
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

