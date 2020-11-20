


select	cast(b.periodo as date)periodo 
		,a.descripcion_producto as descripcion
		,a.cod_local
		,b.descripcion_local
		,b.estado_local
		,b.formato
		,b.distrito
		,b.vta_periodo_unid
		,a.stock_actual_unid
		,b.representante_venta_inkafarma
		,b.id_representante
into	#inkafarma
from	inkafarma_stock a
left join inkafarma_venta b
on		(a.cod_local = b.cod_local
and		a.descripcion_producto = b.descripcion)
where	a.cod_local is not null  and stock_actual_unid > 0


alter table #inkafarma alter column cod_local nvarchar(255)

update #inkafarma
set		cod_local = cast(cod_local as nvarchar(255))

update	a
set		a.descripcion_local = b.descripcion_local
		,a.estado_local = b.descripcion_local
		,a.formato = b.formato
		,a.distrito = b.distrito
from	inkafarma_ubicaciones b
inner join #inkafarma a
on		a.cod_local = b.cod_local
where	a.descripcion_local is null


update #inkafarma
set		periodo = '2020-11-18'

delete from #inkafarma where descripcion_local is null


update #inkafarma
set		vta_periodo_unid = 0