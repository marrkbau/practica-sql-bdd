/*1. Mostrar el código, razón social de todos los clientes cuyo límite de crédito sea mayor o 
igual a $ 1000 ordenado por código de cliente.
 */
select
    clie_codigo,
    clie_razon_social
from
    Cliente
where
    clie_limite_credito >= 1000
order by
    clie_codigo
/*
    2. Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por 
    cantidad vendida.
     */
select
    prod_codigo,
    prod_detalle
from
    Producto
    join Item_Factura on prod_codigo = item_producto
    join Factura on item_tipo + item_sucursal + item_numero = fact_tipo + fact_sucursal + fact_numero
where
    year (fact_fecha) = 2012
group by
    prod_codigo,
    prod_detalle
order by
    sum(item_precio)
/*
    3. Realizar una consulta que muestre código de producto, nombre de producto y el stock 
    total, sin importar en que deposito se encuentre, los datos deben ser ordenados por 
    nombre del artículo de menor a mayor.
     */
select
    prod_codigo,
    prod_detalle,
    sum(stoc_cantidad)
from
    Producto
    join STOCK on prod_codigo = stoc_producto
group by
    prod_codigo,
    prod_detalle
order by
    2 asc
/*
    4. Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de 
    artículos que lo componen. Mostrar solo aquellos artículos para los cuales el stock 
    promedio por depósito sea mayor a 100.
     */
select
    prod_codigo,
    prod_detalle,
    COUNT(comp_componente)
from
    Producto
    left join Composicion on prod_codigo = comp_producto
group by
    prod_codigo,
    prod_detalle
having
    prod_codigo in (
        select
    stoc_producto
from
    STOCK
group by
            stoc_producto
having
            avg(stoc_cantidad) > 100
    )
/*
    5. Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de 
    stock que se realizaron para ese artículo en el año 2012 (egresan los productos que 
    fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011.
     */
select
    prod_codigo,
    prod_detalle,
    sum(item_cantidad)
from
    Producto
    join Item_Factura on prod_codigo = item_producto
    join Factura on item_tipo + item_sucursal + item_numero = fact_tipo + fact_sucursal + fact_numero
group by
    prod_codigo,
    prod_detalle
having
    sum(item_cantidad) > (
        select
    sum(item_cantidad)
from
    Item_Factura
    join Factura on item_tipo + item_sucursal + item_numero = fact_tipo + fact_sucursal + fact_numero
where
            year (fact_fecha) = 2011
    and item_producto = prod_codigo
    )
/*
    6. Mostrar para todos los rubros de artículos código, detalle, cantidad de artículos de ese 
    rubro y stock total de ese rubro de artículos. Solo tener en cuenta aquellos artículos que 
    tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’.
     */
/*
    7. Generar una consulta que muestre para cada artículo código, detalle, mayor precio 
    menor precio y % de la diferencia de precios (respecto del menor Ej.: menor precio = 
    10, mayor precio =12 => mostrar 20 %). Mostrar solo aquellos artículos que posean 
    stock.
     */
select
    prod_codigo,
    prod_detalle,
    max(item_precio),
    min(item_precio),
    (
        (max(item_precio) - min(item_precio)) / min(item_precio)
    ) * 100
from
    Item_Factura
    join Producto on item_producto = prod_codigo
    join STOCK on prod_codigo = stoc_producto
group by
    prod_codigo,
    prod_detalle
having
    sum(stoc_cantidad) > 0
/*
    8. Mostrar para el o los artículos que tengan stock en todos los depósitos, nombre del
    artículo, stock del depósito que más stock tiene.
     */
select
    prod_detalle,
    max(stoc_cantidad)
from
    Producto
    join STOCK on prod_codigo = stoc_producto
    join DEPOSITO on depo_codigo = stoc_deposito
where
    stoc_cantidad > 0
group by
    prod_detalle
having
    count(*) = (
        select
    count(*)
from
    DEPOSITO
    )
/*
    9. Mostrar el codigo del jefe, codigo del empleado que lo tiene como jefe, nombre del
    mismo y la cantidad de depositos que ambos tienen asignados.
     */
select
    empl_jefe,
    empl_codigo,
    empl_nombre,
    (
        select
        count(*)
    from
        DEPOSITO
    where
            empl_codigo = depo_encargado
        or empl_jefe = depo_encargado
    )
from
    Empleado
/*
    10. Mostrar los 10 productos mas vendidos en la historia y tambien los 10 productos menos
    vendidos en la historia. Ademas mostrar de esos productos, quien fue el cliente que
    mayor compra realizo.
     */
select
    prod_codigo,
    prod_detalle,
    clie_codigo
from
    Producto
    left join Item_Factura on prod_codigo = item_producto
    join Factura on item_tipo + item_sucursal + item_numero = fact_tipo + fact_sucursal + fact_numero
    join Cliente on clie_codigo = fact_cliente
where
    clie_codigo in (
        select
    top 1
    clie_codigo
from
    cliente
    join Factura on clie_codigo = fact_cliente
    join Item_Factura on item_tipo + item_sucursal + item_numero = fact_tipo + fact_sucursal + fact_numero
group by
            clie_codigo
order by
            sum(item_cantidad)
    )
group by
    prod_codigo,
    prod_detalle,
    clie_codigo
having
    prod_codigo in (
        select
        top 10
        item_producto
    from
        Item_Factura
    group by
            item_producto
    order by
            count(*) ASC
    )
    or prod_codigo in (
        select
        top 10
        item_producto
    from
        Item_Factura
    group by
            item_producto
    order by
            count(*) DESC
    )
select
    top 1
    clie_codigo
from
    cliente
    join Factura on clie_codigo = fact_cliente
    join Item_Factura on item_tipo + item_sucursal + item_numero = fact_tipo + fact_sucursal + fact_numero
group by
    clie_codigo
order by
    sum(item_cantidad)
select
    prod_codigo,
    (
        select
        top 1
        fact_cliente
    from
        Factura
        join Item_Factura on item_producto = prod_codigo
    group by
            fact_cliente,
            item_cantidad
    order by
            sum(item_cantidad) desc
    )
from
    producto
where
    prod_codigo in (
        select
        top 10
        Item_producto
    from
        Item_Factura
    group by
            item_producto
    order by
            count(*) desc
    )
    or prod_codigo in (
        select
        top 10
        Item_producto
    from
        Item_Factura
    group by
            item_producto
    order by
            count(*) asc
    )
/*11. Realizar una consulta que retorne el detalle de la familia, la cantidad diferentes de productos vendidos 
    y el monto de dichas ventas sin impuestos. Los datos se deberán
    ordenar de mayor a menor, por la familia que más productos diferentes vendidos tenga,
    solo se deberán mostrar las familias que tengan una venta superior a 20000 pesos para el año 2012. */
select
    fami_detalle,
    count(distinct item_producto) cant_productos,
    sum(item_precio * item_cantidad) total
from
    Producto
    join Familia on prod_familia = fami_id
    join Item_Factura on prod_codigo = item_producto
where
    fami_id in (
        select
    prod_familia
from
    Producto
    join Item_Factura on prod_codigo = item_producto
    join Factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
where
            year (fact_fecha) = 2012
group by
            prod_familia
having
            sum(item_precio * item_cantidad) > 20000
    )
group by
    fami_detalle
order by
    2 desc
/*12.  Mostrar nombre de producto, cantidad de clientes distintos que lo compraron importe 
    promedio pagado por el producto, cantidad de depósitos en los cuales hay stock del 
    producto y stock actual del producto en todos los depósitos. Se deberán mostrar 
    aquellos productos que hayan tenido operaciones en el año 2012 y los datos deberán 
    ordenarse de mayor a menor por monto vendido del producto.*/
-- Está mal por la atomicidad
-- el where condiciona la atomicidad y afecta el resultado del sum(item_precio*item_cantidad)
select
    prod_detalle,
    count(distinct fact_cliente) cantidad_clientes,
    AVG(item_precio) importe_promedio,
    count(distinct stoc_deposito) cant_depos,
    (
        select
        sum(stoc_cantidad)
    from
        STOCK
    where
            stoc_producto = prod_codigo
    ) stock_producto
from
    Item_Factura
    join Factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
    join Producto on item_producto = prod_codigo
    join stock on stoc_producto = prod_codigo
where
    year (fact_fecha) = 2012
group by
    prod_detalle,
    prod_codigo
order by
    sum(item_precio * item_cantidad) desc
-- Resolución del profe
select
    prod_detalle,
    count(distinct fact_cliente) cantidad_clientes,
    avg(item_precio) importe_promedio,
    (
        select
        count(*)
    from
        STOCK
    where
            stoc_producto = prod_codigo
    ),
    (
        select
        sum(stoc_cantidad)
    from
        STOCK
    where
            stoc_producto = prod_codigo
        and stoc_cantidad > 0
    )
from
    Producto
    join Item_Factura on prod_codigo = item_producto
    join Factura on item_tipo + item_sucursal + item_numero = fact_tipo + fact_sucursal + fact_numero
where
    prod_codigo in (
        select
    item_producto
from
    Item_Factura
    join Factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
where
            year (fact_fecha) = 2012
    )
group by
    prod_detalle,
    prod_codigo
order by
    sum(item_precio * item_cantidad) desc
/*13. Realizar una consulta que retorne para cada producto que posea composición nombre 
    del producto, precio del producto, precio de la sumatoria de los precios por la cantidad 
    de los productos que lo componen. Solo se deberán mostrar los productos que estén 
    compuestos por más de 2 productos y deben ser ordenados de mayor a menor por 
    cantidad de productos que lo componen*/
-- Hecho por el profe
select
    pp.prod_detalle,
    pp.prod_precio,
    sum(comp_cantidad * pc.prod_precio)
from
    Producto pp
    join Composicion on comp_producto = pp.prod_codigo
    join Producto pc on pc.prod_codigo = comp_componente
group by
    pp.prod_detalle,
    pp.prod_precio
having
    count(*) >= 2
/*14. Escriba una consulta que retorne una estadística de ventas por cliente. Los campos que 
    debe retornar son:
    Código del cliente
    Cantidad de veces que compro en el último año
    Promedio por compra en el último año
    Cantidad de productos diferentes que compro en el último año
    Monto de la mayor compra que realizo en el último año
    Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en 
    el último año.
    No se deberán visualizar NULLs en ninguna columna
     */
-- Le pongo count(fact_numero) porque si hago count(*) cuenta el renglón a pesar de no haber facturas
-- entonces da true, y da todo 0
select
    clie_codigo,
    count(distinct fact_numero) cantidad_compras,
    avg(isnull (fact_total, 0)) promedio_compra,
    (
        select
        count(distinct item_producto)
    from
        Item_Factura
        join Factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
    where
            fact_cliente = clie_codigo
        and year (fact_fecha) = (
                select
            max(year (fact_fecha))
        from
            Factura
            )
    ) cantidad_productos_distintos,
    max(isnull (fact_total, 0)) mayor_compra
from
    Cliente
    left join Factura on fact_cliente = clie_codigo
where
    year (fact_fecha) = (
        select
    max(year (fact_fecha))
from
    Factura
    )
group by
    clie_codigo
order by
    count(fact_numero) desc
/*
    15. Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos 
    (en la misma factura) más de 500 veces. El resultado debe mostrar el código y 
    descripción de cada uno de los productos y la cantidad de veces que fueron vendidos 
    juntos. El resultado debe estar ordenado por la cantidad de veces que se vendieron 
    juntos dichos productos. Los distintos pares no deben retornarse más de una vez.
    Ejemplo de lo que retornaría la consulta:
    PROD1 DETALLE1 PROD2 DETALLE2 VECES
    1731 MARLBORO KS 1 7 1 8 P H ILIPS MORRIS KS 5 0 7
    1718 PHILIPS MORRIS KS 1 7 0 5 P H I L I P S MORRIS BOX 10 5 6 2
     */
select
    p1.prod_codigo,
    p1.prod_detalle,
    p2.prod_codigo,
    p2.prod_detalle
from
    Factura
    join Item_Factura i1 on i1.item_tipo + i1.item_numero + i1.item_sucursal = fact_tipo + fact_numero + fact_sucursal
    join Item_Factura i2 on i2.item_tipo + i1.item_numero + i1.item_sucursal = fact_tipo + fact_numero + fact_sucursal
        and i1.item_producto < i2.item_producto
    JOIN Producto p1 ON p1.prod_codigo = i1.item_producto
    JOIN Producto p2 ON p2.prod_codigo = i2.item_producto
order by
    fact_numero
-- ????????????
/*
16. Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran 
en la empresa, se pide una consulta SQL que retorne aquellos clientes cuyas ventas son 
inferiores a 1/3 del promedio de ventas del producto que más se vendió en el 2012.
Además mostrar
1. Nombre del Cliente
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1, 
mostrar solamente el de menor código) para ese cliente.
Aclaraciones:
La composición es de 2 niveles, es decir, un producto compuesto solo se compone de 
productos no compuestos.
Los clientes deben ser ordenados por código de provincia ascendente.
*/

select 
cli.clie_razon_social, 
(select sum(i2.item_cantidad) from Factura f1
    join Item_Factura i2 on f1.fact_tipo+f1.fact_sucursal+f1.fact_numero = i2.item_tipo+i2.item_sucursal+i2.item_numero
    where cli.clie_codigo = f1.fact_cliente and year(fact_fecha) = 2012
    ) cantidad_unidades,
(select top 1 i3.item_producto from Factura f4 join Item_Factura i3 
    on f4.fact_sucursal+f4.fact_numero+f4.fact_tipo = i3.item_sucursal+i3.item_numero+i3.item_tipo
    where year(f4.fact_fecha) = 2012 and f4.fact_cliente = clie_codigo
    group by item_producto
    order by sum(item_cantidad*item_precio) desc) codigo_producto 
from Cliente cli
left join Factura f2 on cli.clie_codigo = f2.fact_cliente
left join Item_Factura i5 on i5.item_numero+i5.item_tipo+i5.item_sucursal = f2.fact_numero+f2.fact_tipo+f2.fact_sucursal
where year(f2.fact_fecha) = 2012
group by clie_codigo, clie_razon_social
having isnull(sum(i5.item_cantidad*i5.item_precio), 0) < (select top 1 avg(item_cantidad*item_precio) 
                        from Factura f3
                        join Item_Factura i1 on f3.fact_tipo + f3.fact_sucursal + f3.fact_numero = i1.item_tipo + i1.item_sucursal + i1.item_numero 
                        where year (fact_fecha) = 2012
                        group by i1.item_producto 
                        order by sum(item_cantidad*item_precio) desc) / 3
order by 2

--having count(fact_numero) < 
/*count(fact_numero) < (select top 1 avg(item_cantidad) 
                        from Factura 
                        join Item_Factura on fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero 
                        join Producto on prod_codigo = item_producto
                        where
                        year (fact_fecha) = 2012
                        group by prod_detalle 
                        order by sum(item_cantidad) desc) / 3*/
/*
17. Escriba una consulta que retorne una estadística de ventas por año y mes para cada
producto.
La consulta debe retornar:
PERIODO: Año y mes de la estadística con el formato YYYYMM
PROD: Código de producto
DETALLE: Detalle del producto
CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo 
pero del año anterior
CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el 
periodo
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada 
por periodo y código de producto*/

select FORMAT(fact_fecha, 'yyyy-MM'), prod_detalle, isnull(sum(i2.item_cantidad*i2.item_precio), 0) cantidad_vendida,
    isnull((select sum(i1.item_cantidad*i1.item_precio) from Item_Factura i1
    left join Factura f2 on f2.fact_tipo+f2.fact_sucursal+f2.fact_numero = i1.item_tipo+i1.item_sucursal+i1.item_numero
    where item_producto = prod_codigo and year(f1.fact_fecha)-1  = year(f2.fact_fecha) 
    and month(f2.fact_fecha) = month(f1.fact_fecha)), 0) cantidad_vendida_anio_pasado, count(distinct fact_numero+fact_sucursal+fact_numero) from Producto
left join Item_Factura i2 on prod_codigo = item_producto
left join Factura f1 on fact_tipo+fact_sucursal+fact_numero = item_tipo+item_sucursal+item_numero
group by prod_codigo, prod_detalle, fact_fecha
order by 4 desc

/*
18. Escriba una consulta que retorne una estadística de ventas para todos los rubros.
La consulta debe retornar:
DETALLE_RUBRO: Detalle del rubro
VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
PROD1: Código del producto más vendido de dicho rubro
PROD2: Código del segundo producto más vendido de dicho rubro
CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30 
días
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada 
por cantidad de productos diferentes vendidos del rubro
*/

select rubr_detalle, sum(item_cantidad*item_precio), 
(select top 1 item_producto from Item_Factura i2 join Producto on prod_codigo = i2.item_producto
where prod_rubro = rubr_id
group by i2.item_producto
order by sum(item_cantidad*item_numero) desc) producto_mas_vendido,
                                    (select top 1 item_producto from Item_Factura i3 join Producto on prod_codigo = i3.item_producto
                                    where prod_rubro = rubr_id and item_producto not in
                                                    (select top 1 item_producto from Item_Factura i2 
                                                    join Producto on prod_codigo = i2.item_producto
                                                    where prod_rubro = rubr_id 
                                                    group by i2.item_producto
                                                    order by sum(item_cantidad*item_numero) desc) 
                                    group by i3.item_producto
order by sum(item_cantidad*item_numero) desc ) segundo_mas_vendido,
(select top 1 clie_codigo from Cliente join Factura on fact_cliente = clie_codigo
join Item_Factura i4 on i4.item_sucursal+i4.item_tipo+i4.item_numero = fact_sucursal+fact_tipo+fact_numero
join Producto p2 on i4.item_producto = prod_codigo and prod_rubro = rubr_id
where fact_fecha >= DATEADD(DAY, -30, GETDATE()) AND fact_fecha <= GETDATE()
group by clie_codigo
order by sum(item_cantidad*item_precio))
from Rubro 
join Producto on prod_rubro = rubr_id
join Item_Factura on item_producto = prod_codigo
group by rubr_id, rubr_detalle