drop table if exists test.vendedor_detalle;
create temporary table test.vendedor_detalle
select distinct
        a.coIdVendedor
        ,b.vendedor
from dropesac2015_temp.vendedor a
left join dropesac2015_temp.view_factura_boleta_reporteria b
on  a.coIdVendedor = b.idVendedor
where a.flagActivo = true
and   b.vendedor is not null
;

select distinct
        a.vendedor_coIdVendedor
        ,b.vendedor
        ,c.numeroDocIden
        ,c.idCliente
from    dropesac2015_temp.ventas_cliente_vendedor a
left join test.vendedor_detalle b
on      a.vendedor_coIdVendedor = b.coIdVendedor
left join dropesac2015_temp.cliente c
on      a.cliente_idCliente = c.idCliente
where   a.flagActivo = true
and     a.vendedor_coIdVendedor not in ('V141')
and     c.numeroDocIden in
(
'10400606230' #Colocar aquí los RUC's a consultar
)
;

