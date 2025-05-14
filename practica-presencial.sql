/*
9. Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del
mismo y la cantidad de depósitos que ambos tienen asignados.
*/

select empl_jefe, empl_codigo, empl_nombre, (select count(*) from DEPOSITO where empl_codigo = depo_encargado or empl_jefe = depo_encargado)
from Empleado 


/*
10. Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos
vendidos en la historia. Además mostrar de esos productos, quien fue el cliente que
mayor compra realizo.
*/

select prod_codigo, prod_detalle, clie_codigo from Producto
left join Item_Factura on prod_codigo=item_producto
join Factura on item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
join Cliente on clie_codigo = fact_cliente
where clie_codigo in (select top 1 clie_codigo from cliente 
join Factura on clie_codigo = fact_cliente 
join Item_Factura on item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero group by clie_codigo order by sum(item_cantidad))
group by prod_codigo, prod_detalle, clie_codigo
having prod_codigo in (select top 10 item_producto from Item_Factura group by item_producto order by count(*) ASC)
or prod_codigo in (select top 10 item_producto from Item_Factura group by item_producto order by count(*) DESC)

select top 1 clie_codigo from cliente 
join Factura on clie_codigo = fact_cliente 
join Item_Factura on item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
group by clie_codigo order by sum(item_cantidad)

select prod_codigo, 
(select top 1 fact_cliente from Factura 
join Item_Factura on item_producto=prod_codigo group by fact_cliente, item_cantidad order by sum(item_cantidad) desc)
from producto where prod_codigo in (select top 10 Item_producto from Item_Factura group by item_producto order by count(*) desc
) or prod_codigo in (select top 10 Item_producto from Item_Factura group by item_producto order by count(*) asc
)

