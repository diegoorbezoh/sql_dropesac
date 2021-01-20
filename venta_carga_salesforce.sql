
-- Variables
set @dia_ant = '2021-01-13';
set @dia_post = '2021-01-18';
set @dia_ant_pre = '2021-01-12';


/* PREPEDIDOS */
/*
select
DATE_FORMAT(p.fechaEmision, "%d/%m/%Y %H:%i") as fechaEmision,
upper(s.nombre) as sede, 
p.codigo as PreOrdenDePedido,
upper(t.nombre) as tipodePrepedido,
upper(f.nombre) as formadePago,
p.diasPago as diasPago,
upper(fc.nombre) as formadeContacto,
coalesce(DATE_FORMAT(p.fechaEvaluacion, "%d/%m/%Y %H:%i"), '') as fechadeEvaluacion,
coalesce(DATE_FORMAT(p.fechaAnulacion, "%d/%m/%Y %H:%i"), '') as fechaAnulacion,
coalesce(upper(p.motivoAnulacion), '') as motivoAnulacion,
upper(e.nombre) as estadoPrepedido,
c.numeroDocIden as Cliente,
c.numeroDocIden as RUCoculto,
em.codigo as visitador,
p.cantidadFacturasBoletas as cantidadFacturas, 
UPPER(numeroOrdenCompra) as ordendeCompra,
replace(UPPER(p.puntoLlegada), '"',"'") as lugarEntrega,
RTRIM(UPPER(SUBSTRING_INDEX(LTRIM(p.ubigeoPuntoLlegada), '/', 1))) AS departamento,
LTRIM(UPPER(RTRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p.ubigeoPuntoLlegada, '/', 2),'/',-(1))))) AS provincia,
LTRIM(UPPER(SUBSTRING_INDEX(p.ubigeoPuntoLlegada, '/', -(1)))) AS distrito,
p.totalGravado as totalGravado, 
p.totalExonerado as totalExonerado, 
p.totalInafecto as totalInafecto,
p.totalIgv as totalIgv, 
p.totalIsc as totalIsc, 
p.totalDescuentos as totalDescuento,
p.importeTotal as importeTotal,
upper(m.descripcion) as moneda,
REPLACE(REPLACE(REPLACE(upper(p.observaciones), '\r', ''), '\n', ''), '"',"'") as observaciones
from ventas_pre_pedido p 
inner join cliente c on c.idCliente = p.cliente_idCliente
inner join sede s on s.idSede = p.sede_idSede
inner join ventas_estado_pre_pedido e on e.id = p.estadoPrePedido_id
inner join ventas_forma_contacto fc on fc.id = p.formaContacto_id
inner join moneda m on m.idMoneda = p.moneda_idMoneda
inner join empleado em on em.idEmpleado = p.vendedor_coIdVendedor
inner join ventas_tipo_orden_prepedido t on t.id = p.tipoOrdenPrePedido_id
inner join formapago f on f.idFormaPago = p.formaPago_idFormaPago
where p.flagEstado = true and p.flagActivo = true and DATE(p.fechaEmision) between @dia_ant and @dia_post
and p.codigo in (
'PRLIM-00008263',
'PRLIM-00008265',
'PRLIM-00008277'
)
order by p.fechaEmision;
*/

/* PREPEDIDO DETALLE */
/*
select d.id,
p.codigo as 'pre-ordenDePedido',
upper(m.descripcion) as moneda,
pr.codigoProducto,
d.cantidad,
d.valorUnitario,
d.precioUnitario,
d.porcentajeDescuento*100 as porcentajeDescuento,
d.montoDescuentoItem as descuento,
d.subTotalValorVenta as subtotalSinIGV,
d.subTotalPrecioVenta as subtotalConIGV,
IF(d.bonificacion = 0, 'NO', 'SI') as bonificacion
from ventas_pre_pedido_detalle d 
inner join ventas_pre_pedido p on p.id = d.prePedido_id
inner join producto pr on pr.idProducto = d.producto_idProducto
inner join moneda m on p.moneda_idMoneda = m.idMoneda
where d.flagActivo = true and d.flagEstado = true and p.flagActivo = true and p.flagEstado = true
and DATE(p.fechaEmision) between @dia_ant and @dia_post
/* and p.codigo in (
'PRCIX-00002166',
'PRCIX-00002208',
'PRCIX-00002213',
'PRCIX-00002214',
'PRCIX-00002310',
'PRCIX-00002346',
'PRCIX-00002349',
'PRCIX-00002354',
'PRCIX-00002357',
'PRCIX-00002359',
'PRCIX-00002414',
'PRCIX-00002444',
'PRCIX-00002445',
'PRCIX-00002448',
'PRLIM-00007091',
'PRLIM-00007099',
'PRLIM-00007137',
'PRLIM-00007140',
'PRLIM-00007179',
'PRLIM-00007218',
'PRCIX-00002429'
);
*/

/* MODIFICACIONES ADICIONALES */
/*
select 
p.codigo as PreOrdenDePedido,
upper(fc.nombre) as formadeContacto,
upper(f.nombre) as formadePago,
p.diasPago as diasPago,
replace(UPPER(p.puntoLlegada), '"',"'") as lugarEntrega,
RTRIM(UPPER(SUBSTRING_INDEX(LTRIM(p.ubigeoPuntoLlegada), '/', 1))) AS departamento,
LTRIM(UPPER(RTRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(p.ubigeoPuntoLlegada, '/', 2),'/',-(1))))) AS provincia,
LTRIM(UPPER(SUBSTRING_INDEX(p.ubigeoPuntoLlegada, '/', -(1)))) AS distrito,
p.cantidadFacturasBoletas as cantidadFacturas, 
UPPER(numeroOrdenCompra) as ordendeCompra,
p.totalGravado as totalGravado, 
p.totalExonerado as totalExonerado, 
p.totalInafecto as totalInafecto,
p.totalIgv as totalIgv, 
p.totalIsc as totalIsc, 
p.totalDescuentos as totalDescuento,
p.importeTotal as importeTotal,
REPLACE(REPLACE(REPLACE(upper(p.observaciones), '\r', ''), '\n', ''), '"',"'") as observaciones
from ventas_pre_pedido p 
inner join formapago f on f.idFormaPago = p.formaPago_idFormaPago
inner join ventas_forma_contacto fc on fc.id = p.formaContacto_id
where p.flagEstado = true and p.flagActivo = true 
and (DATE(p.fechaModificacion) between @dia_ant and @dia_post
or DATE(p.fechaEvaluacion) between @dia_ant and @dia_post
or DATE(p.fechaAnulacion) between @dia_ant and @dia_post)
and DATE(p.fechaEmision) <= @dia_ant_pre;
*/


/* MODIFICACIONES DETALLE */
/*
select d.id as ItemDetallePrepedido,
d.cantidad,
d.valorUnitario,
d.precioUnitario,
d.porcentajeDescuento*100 as porcentajeDescuento,
d.montoDescuentoItem as descuento,
d.subTotalValorVenta as subtotal_sin_igv,
d.subTotalPrecioVenta as subtotal_con_igv
from ventas_pre_pedido_detalle d 
inner join ventas_pre_pedido p on p.id = d.prePedido_id
where d.flagActivo = true and d.flagEstado = true and p.flagActivo = true and p.flagEstado = true
and (DATE(p.fechaModificacion) between @dia_ant and @dia_post
or DATE(p.fechaEvaluacion) between @dia_ant and @dia_post
or DATE(p.fechaAnulacion) between @dia_ant and @dia_post)
and DATE(p.fechaEmision) <= @dia_ant_pre;
*/

/* PEDIDOS */
/*
select o.codigoOrdenPedido as codigoOrdendePedido, 
upper(t.noDescripcion) as tipo, 
upper(o.prioridad) as prioridad, 
DATE_FORMAT(o.fechaRegistro, "%d/%m/%Y %H:%i") as fechaderegistro, 
DATE_FORMAT(o.fechaEntregaMin, "%d/%m/%Y %H:%i") as fecha_minima_entrega, 
DATE_FORMAT(o.fechaEntregaMax, "%d/%m/%Y %H:%i") as fecha_maxima_entrega, 
upper(f.nombre) as formaPago, 
o.diasPago, 
IF(m.idMoneda = 1, 'SOLES', 'DOLARES AMERICANOS') as moneda,
coalesce(DATE_FORMAT(o.fechaEvaluacionCobranzas, "%d/%m/%Y %H:%i") , '')as fecha_de_evaluacion_cobranza, 
coalesce(DATE_FORMAT(o.fechaEvaluacionGerencia, "%d/%m/%Y %H:%i"), '') as fechaEvaluacionGerencia, 
upper(o.estadoOP) as estado, 
coalesce( REPLACE(REPLACE(REPLACE(upper(o.observaciones), '\r', ''), '\n', ''), '"',"'"), '') as observaciones,
coalesce( REPLACE(REPLACE(REPLACE(upper(o.observacionesInternas), '\r', ''), '\n', ''), '"',"'"), '') as observacionesInternas,
coalesce(upper(o.motivoAnulacion), '') as motivoAnulacion,
coalesce(DATE_FORMAT(o.fechaCancelacion, "%d/%m/%Y %H:%i"), '') as fechaAnulacion, 
e.codigo as visitador_vendedor, 
c.numeroDocIden as cuenta, 
RTRIM(UPPER(SUBSTRING_INDEX(LTRIM(o.ubigeoEntregaCliente), '/', 1))) AS departamento,
LTRIM(UPPER(RTRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.ubigeoEntregaCliente, '/', 2),'/',-(1))))) AS provincia,
LTRIM(UPPER(SUBSTRING_INDEX(o.ubigeoEntregaCliente, '/', -(1)))) AS distrito,
replace(UPPER(o.domicilioEntregaCliente), '"',"'") as calle_facturacion,
upper(s.nombre) as sede,
coalesce(vp.codigo, '') as pre_orden_de_pedido,
o.totalGravado,
o.totalExonerado,
o.totalInafecto,
o.totalIGV,
o.totalISC,
o.totalDescuento,
o.totalDescuentoGLB as totalDescuentoGlobal,
o.totalOperacionesGratuitas as Total_gratuito,
o.importeTotal
from ventas_ordenpedido o
inner join formapago f on f.idFormaPago = o.idFormaPago
inner join tipoordenpedido t on t.coIdTipoOrdenPedido = o.idTipoOrdenPedido
inner join moneda m on m.idMoneda = o.idMoneda
inner join empleado e on e.idEmpleado = o.idVendedor
inner join cliente c on c.idCliente = o.idCliente
inner join sede s on s.idSede = o.idSede
left join ventas_pre_pedido vp on vp.id = o.prePedido_id
where o.flagEstado = true and o.flagActivo = true and o.idTipoOrdenPedido in (1,2)
and o.subTipoOrdenPedido not in ('Retiro por entrega a trabajadores', 'Retiro por muestras medicas')
and DATE(o.fechaRegistro) between @dia_ant and @dia_post
and o.codigoOrdenPedido in  (
'LIM017484'
);
*/


 /* DETALLE PEDIDOS */
/*
select d.id,
p.codigoProducto, 
d.cantidad,
d.valorVentaUnitaria as valorUnitario, 
d.precioUnitario, 
d.porcentajeDescuento*100 as porcentajeDescuento,
d.montoDescuentoItem as descuento,
d.subTotalValorVenta as subtotalSinIGV, 
d.subTotalPrecioVenta as subtotalConIGV, 
d.tipoIgv,
o.codigoOrdenPedido as OrdenDePedido,
IF(m.idMoneda = 1, 'SOLES', 'DOLARES AMERICANOS') as moneda,
IF(d.flagBonificacion = 0, 'NO', 'SI') as bonificacion
from ventas_ordenpedidodetalle d 
inner join ventas_ordenpedido o on o.id = d.idOrdenPedido
inner join producto p on p.idProducto = d.idProducto
inner join moneda m on o.idMoneda = m.idMoneda
where d.flagEstado = true and d.flagActivo = true and o.flagActivo = true and o.flagEstado = true
and o.idTipoOrdenPedido in (1,2)
and o.subTipoOrdenPedido not in ('Retiro por entrega a trabajadores', 'Retiro por muestras medicas')
and DATE(o.fechaRegistro) between @dia_ant and @dia_post;
/*and o.codigoOrdenPedido in  (
'LIM014847',
'LIM014936',
'LIM014938',
'LIM014939',
'LIM014995',
'LIM014994',
'LIM015072',
'LIM015099',
'CIX006102',
'CIX006115',
'LIM015370',
'LIM015439',
'LIM015549',
'LIM015569'
);*/

/* MODIFICACION DE PEDIDOS  */
/* PEDIDOS */
/*
select 
o.codigoOrdenPedido as codigoOrdendePedido,
coalesce(DATE_FORMAT(o.fechaEvaluacionCobranzas, "%d/%m/%Y %H:%i") , '')as fecha_de_evaluacion_cobranza, 
coalesce(DATE_FORMAT(o.fechaEvaluacionGerencia, "%d/%m/%Y %H:%i"), '') as fechaEvaluacionGerencia,
upper(o.estadoOP) as estado, 
coalesce(upper(o.motivoAnulacion), '') as motivoAnulacion,
IF(o.estadoOP = 'OP_ANULADO', coalesce(DATE_FORMAT(o.fechaModificacion, "%d/%m/%Y %H:%i"), ''), '') as fechaAnulacion,
coalesce(upper(o.motivoCancelacion), '') as motivoCancelacion,
coalesce(DATE_FORMAT(o.fechaCancelacion, "%d/%m/%Y %H:%i"), '') as fechaCancelacion,
upper(o.prioridad) as prioridad, 
DATE_FORMAT(o.fechaEntregaMin, "%d/%m/%Y %H:%i") as fecha_minima_entrega, 
DATE_FORMAT(o.fechaEntregaMax, "%d/%m/%Y %H:%i") as fecha_maxima_entrega, 
upper(f.nombre) as formaPago, 
o.diasPago, 
coalesce( REPLACE(REPLACE(REPLACE(upper(o.observaciones), '\r', ''), '\n', ''), '"',"'"), '') as observaciones,
coalesce( REPLACE(REPLACE(REPLACE(upper(o.observacionesInternas), '\r', ''), '\n', ''), '"',"'"), '') as observacionesInternas,
RTRIM(UPPER(SUBSTRING_INDEX(LTRIM(o.ubigeoEntregaCliente), '/', 1))) AS departamento,
LTRIM(UPPER(RTRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(o.ubigeoEntregaCliente, '/', 2),'/',-(1))))) AS provincia,
LTRIM(UPPER(SUBSTRING_INDEX(o.ubigeoEntregaCliente, '/', -(1)))) AS distrito,
replace(UPPER(o.domicilioEntregaCliente), '"',"'") as calle_facturacion,
o.totalGravado,
o.totalExonerado,
o.totalInafecto,
o.totalIGV,
o.totalISC,
o.totalDescuento,
o.totalDescuentoGLB as totalDescuentoGlobal,
o.totalOperacionesGratuitas as Total_gratuito,
o.importeTotal
from ventas_ordenpedido o
inner join formapago f on f.idFormaPago = o.idFormaPago
inner join tipoordenpedido t on t.coIdTipoOrdenPedido = o.idTipoOrdenPedido
inner join moneda m on m.idMoneda = o.idMoneda
inner join empleado e on e.idEmpleado = o.idVendedor
inner join cliente c on c.idCliente = o.idCliente
inner join sede s on s.idSede = o.idSede
left join ventas_pre_pedido vp on vp.id = o.prePedido_id
where o.flagEstado = true and o.flagActivo = true and o.idTipoOrdenPedido in (1,2)
and o.subTipoOrdenPedido not in ('Retiro por entrega a trabajadores', 'Retiro por muestras medicas')
and (DATE(o.fechaModificacion) between @dia_ant and @dia_post or
 DATE(o.fechaCancelacion) between @dia_ant and @dia_post or
DATE(o.fechaEvaluacionCobranzas) between @dia_ant and @dia_post or
DATE(o.fechaEvaluacionGerencia) between @dia_ant and @dia_post
)
and DATE(o.fechaRegistro) <= @dia_ant_pre;
*/


 /* DETALLE PEDIDOS MODIFICADOS */
/*
select 
d.id as codigoDetalle, 
d.cantidad,
d.valorVentaUnitaria as valorUnitario, 
d.precioUnitario, 
d.porcentajeDescuento*100 as porcentajeDescuento,
d.montoDescuentoItem as descuento,
d.subTotalValorVenta as subtotalSinIGV, 
d.subTotalPrecioVenta as subtotalConIGV
from ventas_ordenpedidodetalle d 
inner join ventas_ordenpedido o on o.id = d.idOrdenPedido
inner join producto p on p.idProducto = d.idProducto
inner join moneda m on o.idMoneda = m.idMoneda
where d.flagEstado = true and d.flagActivo = true and 
o.flagActivo = true and o.flagEstado = true and o.idTipoOrdenPedido in (1,2)
and o.subTipoOrdenPedido not in ('Retiro por entrega a trabajadores', 'Retiro por muestras medicas')
and (DATE(o.fechaModificacion) between @dia_ant and @dia_post or
DATE(o.fechaCancelacion) between @dia_ant and @dia_post or
DATE(o.fechaEvaluacionCobranzas) between @dia_ant and @dia_post or
DATE(o.fechaEvaluacionGerencia) between @dia_ant and @dia_post
)
and DATE(o.fechaRegistro) <= @dia_ant_pre;
*/

/* FACTURA/BOLETA */
/*
select m.id, 
concat(m.serie, '-', m.numero) as NombreDeFactura,
upper(tv.descripcion) as tipoDeDocumentoDeVenta,
upper(m.motivoTraslado) as motivo,
coalesce(upper(m.motivotrasladoOtros), '') as motivoOtros,
DATE_FORMAT(m.fechaEmision, "%d/%m/%Y %H:%i") as fechaEmision,
DATE_FORMAT(m.fechaVencimiento, "%d/%m/%Y %H:%i") as FechaDeVencimiento,
m.diasPago,
upper(f.nombre) as FormaDePago,
c.numeroDocIden as Cuenta,
replace(UPPER(c.razonSocial), '"',"'") as RazonSocial,
replace(UPPER(c.nombreComercial), '"',"'") as NombreComercial,
e.codigo as Vendedor,
p.codigoOrdenPedido as 'N-pedido',
upper(em.nombreEstadoMovimiento) as estado,
IF(mo.idMoneda = 1, 'SOLES', 'DOLARES AMERICANOS') as moneda,
replace(UPPER(m.puntoPartida), '"',"'") as puntoPartida,
coalesce(TRIM(REPLACE(REPLACE(REPLACE(upper(m.puntoLlegada), '\r', ''), '\n', ''), '"',"'")), '') as puntoLlegada,
RTRIM(UPPER(SUBSTRING_INDEX(LTRIM(m.ubigeoPuntoLlegada), '/', 1))) AS 'Departamento.Pl',
LTRIM(UPPER(RTRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(m.ubigeoPuntoLlegada, '/', 2),'/',-(1))))) AS 'Provincia.Pl',
LTRIM(UPPER(SUBSTRING_INDEX(m.ubigeoPuntoLlegada, '/', -(1)))) AS 'Distrito.Pl',
coalesce(t.ruc,'') as rucTransportista,
coalesce(upper(t.razonSocial), '') as RazonSocialTransportista,
coalesce( REPLACE(REPLACE(REPLACE(upper(m.observaciones), '\r', ''), '\n', ''), '"',"'"), '') as observaciones,
m.totalGravado,
m.totalExonerado,
m.totalInafecto,
m.totalISC,
m.totalIGV,
m.totalDescuento,
m.totalDescuentoGLB as TotalDescuentoGlobal,
m.totalOperacionesGratuitas,
m.totalOtrosRecargos as TotalOtrosCargos,
m.totalOtrosTributos,
m.totalMontoAPagar as importeTotal,
upper(s.nombre) as sede
from ventas_movimiento m 
inner join cliente c on c.idCliente = m.idCliente
inner join empleado e on e.idEmpleado = m.idVendedor
inner join ventas_ordenpedido p on p.id = m.ordenPedido_id
inner join estadomovimiento em on em.idEstadoMovimiento = m.idEstadoMovimiento
inner join moneda mo on m.idMoneda = mo.idMoneda
inner join formapago f on f.idFormaPago = m.idFormaPago
inner join sede s on s.idSede = m.idSede
left join empresatransporte t on t.idEmpresaTransporte = m.idTransportista
inner join tipodocumentoventa tv on tv.idTipoDocVenta = m.idTipoDocumento
where 
m.flagActivo = true and m.flagEstado = true and m.codRespSunat = '0' 
and m.flagFacturaElect = true 
and (m.motivoTrasladoOtros is null || 
m.motivoTrasladoOtros not in ('TRANSFERENCIA GRATUITA-RETIRO POR MUESTRAS MEDICAS','Muestra Medica', 'TRANSFERENCIA GRATUITA-RETIRO POR ENTREGA A TRABAJADORES'))
and m.flagHistorico is null and m.idTipoDocumento in (1,2) 
and (DATE(m.fechaEmision) between @dia_ant and @dia_post or
 DATE(m.fechaAprobacionSunat) between @dia_ant and @dia_post)
# and m.idSede = 1
# and m.idVendedor <> 335
# and c.numeroDocIden in (
#'20512272470'
#)
having NombreDeFactura in (
'B002-00002660',
'F002-00014793',
'F002-00014794',
'F002-00014829',
'F002-00014854',
'F002-00014882'
);
*/

/* DETALLE FACTURA BOLETA */
/*
select d.id as nombreDeDetalleFactura,
concat(m.serie, '-', m.numero) as factura,
p.codigoProducto,
IF(d.flagBonificacion = 0, 'NO', 'SI') as bonificacion,
d.cantidad,
IF(mo.idMoneda = 1, 'SOLES', 'DOLARES AMERICANOS') as moneda,
d.lote as numeroLote,
d.valorVentaUnitaria as valorUnitario,
d.precioUnitario,
d.porcentajeDescuento,
d.montoDescuentoItem as descuento,
d.subTotalValorVenta as subtotalSinIGV,
d.subTotalPrecioVenta as subtotalConIGV
from ventas_movimientodetalle d 
inner join ventas_movimiento m on m.id = d.movimientoVenta_id
inner join producto p on p.idProducto = d.idProducto
inner join moneda mo on m.idMoneda = mo.idMoneda
where m.flagActivo = true and m.flagEstado = true and m.codRespSunat = '0' 
and m.flagFacturaElect = true and (m.motivoTrasladoOtros is null or
m.motivoTrasladoOtros not in ('TRANSFERENCIA GRATUITA-RETIRO POR MUESTRAS MEDICAS','Muestra Medica', 'TRANSFERENCIA GRATUITA-RETIRO POR ENTREGA A TRABAJADORES') )
and m.flagHistorico is null and m.idTipoDocumento in (1,2) and 
(DATE(m.fechaEmision) between @dia_ant and @dia_post or
 DATE(m.fechaAprobacionSunat) between @dia_ant and @dia_post)
 and m.idVendedor <> 335;
/*and m.idSede = 1
having factura in (
'B002-00002344',
'F002-00012690',
'F002-00012694',
'F002-00012732',
'B002-00002346',
'B002-00002347',
'F002-00012848',
'B002-00002353',
'F001-00004704',
'F001-00004717',
'F002-00013120',
'F002-00013180',
'B002-00002396',
'F002-00013263'
);
*/

/* ANULADAS */
/*
select m.id,
concat(m.serie, '-', m.numero) as NombreDeFactura,
upper(em.nombreEstadoMovimiento) as estado,
DATE_FORMAT(m.fechaAnulacion, "%d/%m/%Y %H:%i") as fechaAnulacion,
m.totalGravado,
m.totalExonerado,
m.totalInafecto,
m.totalISC,
m.totalIGV,
m.totalDescuento,
m.totalDescuentoGLB as TotalDescuentoGlobal,
m.totalOperacionesGratuitas,
m.totalOtrosRecargos as TotalOtrosCargos,
m.totalOtrosTributos,
m.totalMontoAPagar as importeTotal
from ventas_movimiento m 
inner join cliente c on c.idCliente = m.idCliente
inner join empleado e on e.idEmpleado = m.idVendedor
inner join ventas_ordenpedido p on p.id = m.ordenPedido_id
inner join estadomovimiento em on em.idEstadoMovimiento = m.idEstadoMovimiento
inner join moneda mo on m.idMoneda = mo.idMoneda
inner join formapago f on f.idFormaPago = m.idFormaPago
inner join sede s on s.idSede = m.idSede
inner join empresatransporte t on t.idEmpresaTransporte = m.idTransportista
inner join tipodocumentoventa tv on tv.idTipoDocVenta = m.idTipoDocumento
where m.flagActivo = true and m.flagEstado = true and m.codRespSunat = '0' 
and m.flagFacturaElect = true and (m.motivoTrasladoOtros is null || m.motivoTrasladoOtros not in ('TRANSFERENCIA GRATUITA-RETIRO POR MUESTRAS MEDICAS','Muestra Medica'))
and m.flagHistorico is null and m.idTipoDocumento in (1,2) and DATE(m.fechaEmision) <= @dia_ant_pre
and DATE(m.fechaAnulacion) between @dia_ant and @dia_post
and m.idVendedor <> 335;
*/

select d.id as nombreDeDetalleFactura,
concat(m.serie, '-', m.numero) as factura,
p.codigoProducto,
IF(d.flagBonificacion = 0, 'NO', 'SI') as bonificacion,
d.cantidad,
IF(mo.idMoneda = 1, 'SOLES', 'DOLARES AMERICANOS') as moneda,
d.lote as numeroLote,
d.valorVentaUnitaria as valorUnitario,
d.precioUnitario,
d.porcentajeDescuento,
d.montoDescuentoItem as descuento,
d.subTotalValorVenta as subtotalSinIGV,
d.subTotalPrecioVenta as subtotalConIGV
from ventas_movimientodetalle d 
inner join ventas_movimiento m on m.id = d.movimientoVenta_id
inner join producto p on p.idProducto = d.idProducto
inner join moneda mo on m.idMoneda = mo.idMoneda
where m.flagActivo = true and m.flagEstado = true and m.codRespSunat = '0' 
and m.flagFacturaElect = true and (m.motivoTrasladoOtros is null or
m.motivoTrasladoOtros not in ('TRANSFERENCIA GRATUITA-RETIRO POR MUESTRAS MEDICAS','Muestra Medica', 'TRANSFERENCIA GRATUITA-RETIRO POR ENTREGA A TRABAJADORES') )
and m.flagHistorico is null and m.idTipoDocumento in (1,2) 
-- and p.codigoproducto = '5220003';
and DATE(m.fechaEmision) <= @dia_ant_pre
and DATE(m.fechaAnulacion) between @dia_ant and @dia_post
and m.idVendedor <> 335;



/** CLIENTES **/
select
c.numeroDocIden, 
upper(c.razonSocial) as razonSocial, 
upper(c.nombreComercial) as nombreComercial, 
t.abrev as tipoDocumento,
lower(coalesce(c.email, '')) as email, 
lower(coalesce(c.email2, '')) as email2,
lower(coalesce(c.email3,'')) as email3, 
coalesce(c.telefono1, '') as telefono1, 
coalesce(c.telefono2, '') as telefono2, 
coalesce(c.telefono3, '') as telefono3,
rtrim(upper(substring_index(ltrim(`c`.`descUbigeoDomicFiscal`),'/',1))) AS `departamento`,
upper(ltrim(rtrim(substring_index(substring_index(`c`.`descUbigeoDomicFiscal`,'/',2),'/',-(1))))) AS `provincia`,
rtrim(ltrim(upper(substring_index(`c`.`descUbigeoDomicFiscal`,'/',-(1))))) AS distrito, 
upper(c.domicilioFiscal) as direccion,
upper(c.personaCobranzas) as personaCobranzas,
lower(c.correoCobranzas) as correoCobranzas,
c.telefonoCobranzas,
upper(c.personaCompras) as personaCompras,
lower(c.correoCompras) as correoCompras,
c.telefonoCompras
from cliente c inner join sede s on s.idSede = c.idSede
inner join tipodocidentidad t on t.idTipoDocIden = c.idTipoDocIden
where 
c.flagEstado = true and c.flagActivo = true
and c.numeroDocIden in
(
'20604344574',
'20605614648',
'21574071'
);

/* PRODUCTOS */
select p.idProducto, 
p.codigoProducto,
replace(CONCAT(IFNULL(`p`.`nombreComun`, ''),
                ' ',
                IFNULL(`p`.`concentracion`, ''),
                ' ',
                IFNULL(`p`.`presentacionEnvase1`, ''),
                ' ',
                CONVERT( IFNULL(`p`.`unidadMinVenta`, '') USING UTF8),
                ' X ',
                CONVERT( IFNULL(`p`.`cantidadUniMinVenta`, '') USING UTF8)), '"', "'") AS `producto`
 from producto p 
 where p.codigoProducto in (
'3000019',
'3000020',
'3000023'
) and p.flagEstado = 1 and p.flagActivo = 1;