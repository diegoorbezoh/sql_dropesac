
[dbo].[venta_universal]
[dbo].[stock_universal]



select	a.nombre_local
		,a.nombre_producto
		,cast(b.fecha as date)fecha
		,b.cantidad
		,b.precio_unitario
		,b.precio_total
		,a.stock
into	venta_universal_resumen
from	stock_universal a
left join venta_universal b
on		(a.cod_producto = b.cod_producto
and		a.nombre_local = b.nombre_local)
order by cast(b.fecha as date) desc

select	* 
from	venta_universal_resumen
where	nombre_local = 'SURCO'
and		nombre_producto = 'B VAT SOL INY 2 ML X AMP UND'