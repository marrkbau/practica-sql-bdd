select
    year(f1.fact_fecha) as [Año],
    c1.clie_razon_social as [Razón Social],
    fami1.fami_id as [Familia ID],
    (select sum(i2.item_cantidad) from Item_Factura i2
    join Producto p2 on p2.prod_codigo = i2.item_producto 
    where fami1.fami_id = p2.prod_familia
    group by p2.prod_familia) as [Cantidad de unidades compradas]
from Factura f1
join Cliente c1 on f1.fact_cliente = c1.clie_codigo
join Item_Factura i1 on f1.fact_numero+f1.fact_sucursal+f1.fact_tipo = i1.item_numero+i1.item_sucursal+i1.item_tipo
join Producto p1 on i1.item_producto = p1.prod_codigo
join Familia fami1 on fami1.fami_id = p1.prod_familia
where c1.clie_codigo in (select top 1 f2.fact_cliente from Factura f2
                            join Item_Factura i3  
                            on f2.fact_numero+f2.fact_sucursal+f2.fact_tipo = i3.item_numero+i3.item_sucursal+i3.item_tipo
                            join Producto p3 on i3.item_producto = p3.prod_codigo
                            where year(f2.fact_fecha) = year(f1.fact_fecha) and p3.prod_familia = fami1.fami_id
                            group by f2.fact_cliente, year(f2.fact_fecha) 
                            order by count(distinct i3.item_producto) asc, sum(i3.item_cantidad*i3.item_precio) desc)
group by year(f1.fact_fecha), c1.clie_razon_social, fami1.fami_id
order by year(f1.fact_fecha) asc, (select count(prod_familia) from Familia f4 join Producto p5 on f4.fami_id = p5.prod_familia
                                    where f4.fami_id = fami1.fami_id
                                    group by prod_familia)

