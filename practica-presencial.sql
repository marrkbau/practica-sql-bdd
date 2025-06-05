/*
9. Mostrar el c�digo del jefe, c�digo del empleado que lo tiene como jefe, nombre del
mismo y la cantidad de dep�sitos que ambos tienen asignados.
*/

select empl_jefe, empl_codigo, empl_nombre, (select count(*)
    from DEPOSITO
    where empl_codigo = depo_encargado or empl_jefe = depo_encargado)
from Empleado


/*
10. Mostrar los 10 productos m�s vendidos en la historia y tambi�n los 10 productos menos
vendidos en la historia. Adem�s mostrar de esos productos, quien fue el cliente que
mayor compra realizo.
*/

select prod_codigo, prod_detalle, clie_codigo
from Producto
    left join Item_Factura on prod_codigo=item_producto
    join Factura on item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
    join Cliente on clie_codigo = fact_cliente
where clie_codigo in (select top 1
    clie_codigo
from cliente
    join Factura on clie_codigo = fact_cliente
    join Item_Factura on item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
group by clie_codigo
order by sum(item_cantidad))
group by prod_codigo, prod_detalle, clie_codigo
having prod_codigo in (select top 10
        item_producto
    from Item_Factura
    group by item_producto
    order by count(*) ASC)
    or prod_codigo in (select top 10
        item_producto
    from Item_Factura
    group by item_producto
    order by count(*) DESC)

select top 1
    clie_codigo
from cliente
    join Factura on clie_codigo = fact_cliente
    join Item_Factura on item_tipo+item_sucursal+item_numero=fact_tipo+fact_sucursal+fact_numero
group by clie_codigo
order by sum(item_cantidad)

select prod_codigo,
    (select top 1
        fact_cliente
    from Factura
        join Item_Factura on item_producto=prod_codigo
    group by fact_cliente, item_cantidad
    order by sum(item_cantidad) desc)
from producto
where prod_codigo in (select top 10
        Item_producto
    from Item_Factura
    group by item_producto
    order by count(*) desc
) or prod_codigo in (select top 10
        Item_producto
    from Item_Factura
    group by item_producto
    order by count(*) asc
)


/*11. Realizar una consulta que retorne el detalle de la familia, la cantidad diferentes de productos vendidos 
y el monto de dichas ventas sin impuestos. Los datos se deberán
ordenar de mayor a menor, por la familia que más productos diferentes vendidos tenga,
solo se deberán mostrar las familias que tengan una venta superior a 20000 pesos para el año 2012. */

select fami_detalle, count(distinct item_producto) cant_productos, sum(item_precio*item_cantidad) total
from Producto
    join Familia on prod_familia = fami_id
    join Item_Factura on prod_codigo = item_producto
where fami_id in (select prod_familia
from Producto
    join Item_Factura on prod_codigo = item_producto
    join Factura on fact_tipo+fact_sucursal+fact_numero=item_tipo+item_sucursal+item_numero
    where year(fact_fecha) = 2012
    group by prod_familia
having sum(item_precio*item_cantidad) > 20000)
group by fami_detalle
order by 2 desc
 







