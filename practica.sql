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



/*
19. En virtud de una recategorizacion de productos referida a la familia de los mismos  se solicita que desarrolle una consulta sql que retorne para todos los productos: 
    Codigo de producto 
    Detalle del producto 
    Codigo de la familia del producto 
    Detalle de la familia actual del producto 
    Codigo de la familia sugerido para el producto 
    Detalle de la familia sugerido para el producto 
    
La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo detalle coinciden en los primeros 5 caracteres. 
En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar la de menor codigo.  

Solo se deben mostrar los productos para los cuales la familia actual sea diferente a la sugerida 
Los resultados deben ser ordenados por detalle de producto de manera ascendente 
*/

select
p.prod_codigo,
p.prod_detalle,
f1.fami_id,
f1.fami_detalle,
(select top 1 p1.prod_familia from Producto p1 
where left(p.prod_detalle, 5) = left(p1.prod_detalle, 5)
group by p1.prod_familia
order by count(*) desc, p1.prod_familia asc
) codigo_familia_sugerida,
(select top 1 f2.fami_detalle from Familia f2 join Producto p2 on p2.prod_familia = f2.fami_id
where left(p.prod_detalle, 5) = left(p2.prod_detalle, 5)
group by f2.fami_detalle, f2.fami_id
order by count(*) desc, f2.fami_id asc 
) detalle_familia_sugerida
from Producto p
join Familia f1 on fami_id = prod_familia
where p.prod_familia <> (select top 1 p1.prod_familia from Producto p1 
            where left(p.prod_detalle, 5) = left(p1.prod_detalle, 5)
            group by p1.prod_familia
            order by count(*) desc, p1.prod_familia asc
            )
order by prod_detalle asc

/*
20. Escriba una consulta sql que retorne un ranking de los mejores 3 empleados del 2012 Se debera retornar legajo, 
nombre y apellido, anio de ingreso, puntaje 2011, puntaje 2012.  
El puntaje de cada empleado se calculara de la siguiente manera: 
para los que hayan vendido al menos 50 facturas el puntaje se calculara como la cantidad 
de facturas que superen los 100 pesos que haya vendido en el año, para los que tengan menos de 50 facturas 
en el año el calculo del puntaje sera el 50% de cantidad de facturas realizadas 
por sus subordinados directos en dicho año. 
*/


/*
SELECT
    columna,
    CASE 
        WHEN condicion1 THEN resultado1
        WHEN condicion2 THEN resultado2
        ELSE resultado_por_defecto
    END AS nombre_columna_resultado
FROM tabla;

*/


select top 3 e.empl_codigo, e.empl_nombre, e.empl_apellido, e.empl_ingreso,
(case when (select count(*) from Factura where empl_codigo = fact_vendedor and year(fact_fecha) = 2011) >= 50
    then (select count(*) from Factura where fact_total > 100 and empl_codigo = fact_vendedor and year(fact_fecha) = 2011)
    else (select count(*) *  0.5 from Factura join Empleado e1 
        on e1.empl_codigo = fact_vendedor and e1.empl_jefe = empl_codigo and year(fact_fecha) = 2011) 
    end) puntaje_2011,
(case when (select count(*) from Factura where empl_codigo = fact_vendedor and year(fact_fecha) = 2012) >= 50
    then (select count(*) from Factura where fact_total > 100 and empl_codigo = fact_vendedor and year(fact_fecha) = 2012)
    else (select count(*) *  0.5 from Factura join Empleado e1 
        on e1.empl_codigo = fact_vendedor and e1.empl_jefe = e.empl_codigo and year(fact_fecha) = 2012) 
    end) puntaje_2012
from Empleado e
order by 6 desc

/*
21. Escriba una consulta sql que retorne para todos los años, en los cuales se haya hecho al menos una factura,
la cantidad de clientes a los que se les facturo de manera incorrecta al menos una factura y 
que cantidad de facturas se realizaron de manera incorrecta. 
Se considera que una factura es incorrecta cuando la diferencia entre el total de la factura menos el total 
de impuesto tiene una diferencia mayor a $ 1 respecto a la sumatoria de los costos de cada uno de los items de dicha factura. 
Las columnas que se deben mostrar son: 
Año 
Clientes a los que se les facturo mal en ese año 
Facturas mal realizadas en ese año 
*/




SELECT YEAR(fact_fecha) AS [AÑO]
		,F.fact_cliente
		,COUNT(F.fact_cliente) AS [FACTURAS MAL REALIZADAS]
FROM FACTURA F
	/*INNER JOIN Item_Factura IFACT
		ON IFACT.item_numero = F.fact_numero AND IFACT.item_sucursal = F.fact_sucursal AND IFACT.item_tipo = F.fact_tipo*/
WHERE (F.fact_total-F.fact_total_impuestos) BETWEEN (
												SELECT SUM(item_precio)-1
												FROM Item_Factura
												WHERE item_numero+item_sucursal+item_tipo = F.fact_numero+F.fact_sucursal+F.fact_tipo
												)
												AND
												(
												SELECT SUM(item_precio)+1
												FROM Item_Factura
												WHERE item_numero+item_sucursal+item_tipo = F.fact_numero+F.fact_sucursal+F.fact_tipo
												)
GROUP BY YEAR(fact_fecha), F.fact_cliente



select year(fact_fecha) as anio, count(distinct clie_codigo) as clientes_mal_facturados, count(distinct fact_tipo+fact_sucursal+fact_numero) as facturas_mal_realizadas
from factura 
join Cliente on fact_cliente = clie_codigo
join Item_Factura i1 on fact_tipo+fact_sucursal+fact_numero=i1.item_tipo+i1.item_sucursal+i1.item_numero
where abs( (fact_total - fact_total_impuestos) - (select sum(i2.item_cantidad*i2.item_precio) from Item_Factura i2
														where i1.item_tipo+i1.item_sucursal+i1.item_numero = i2.item_tipo+i2.item_sucursal+i2.item_numero 
														))>1
group by year(fact_fecha)

/*
22. Escriba una consulta sql que retorne una estadistica de venta para todos los rubros por 
trimestre contabilizando todos los años. Se mostraran como maximo 4 filas por rubro (1 
por cada trimestre).
Se deben mostrar 4 columnas:
* Detalle del rubro
* Numero de trimestre del año (1 a 4)
* Cantidad de facturas emitidas en el trimestre en las que se haya vendido al 
menos un producto del rubro
* Cantidad de productos diferentes del rubro vendidos en el trimestre 
El resultado debe ser ordenado alfabeticamente por el detalle del rubro y dentro de cada 
rubro primero el trimestre en el que mas facturas se emitieron.
No se deberan mostrar aquellos rubros y trimestres para los cuales las facturas emitidas 
no superen las 100.
En ningun momento se tendran en cuenta los productos compuestos para esta 
estadistica
*/

select rubr_detalle, (select CASE
                        WHEN MONTH(f2.fact_fecha) BETWEEN 1 AND 3 THEN 1
                        WHEN MONTH(f2.fact_fecha) BETWEEN 4 AND 6 THEN 2
                        WHEN MONTH(f2.fact_fecha) BETWEEN 7 AND 9 THEN 3
                        WHEN MONTH(f2.fact_fecha) BETWEEN 10 AND 12 THEN 4
                        END from Factura f2 where f2.fact_tipo+f2.fact_sucursal+f2.fact_numero = i1.item_tipo+i1.item_sucursal+i1.item_numero)
from Rubro
join Producto on prod_rubro = rubr_id
join Item_Factura i1 on prod_codigo = item_producto
group by rubr_detalle, item_tipo
order by rubr_detalle, 2


SELECT
  r.rubr_detalle AS rubro,
  ((MONTH(f.fact_fecha) - 1) / 3) + 1 AS trimestre,
  COUNT(DISTINCT f.fact_tipo + f.fact_sucursal + f.fact_numero) AS cantidad_facturas,
  COUNT(DISTINCT p.prod_codigo) AS productos_diferentes
FROM Rubro r
JOIN Producto p ON p.prod_rubro = r.rubr_id
JOIN Item_Factura i ON i.item_producto = p.prod_codigo
JOIN Factura f ON f.fact_tipo = i.item_tipo AND f.fact_sucursal = i.item_sucursal AND f.fact_numero = i.item_numero
GROUP BY
  r.rubr_detalle,
  ((MONTH(f.fact_fecha) - 1) / 3) + 1
HAVING COUNT(DISTINCT f.fact_tipo + f.fact_sucursal + f.fact_numero) > 100
ORDER BY
  r.rubr_detalle,
  COUNT(DISTINCT f.fact_tipo + f.fact_sucursal + f.fact_numero) DESC;


/*
23. Realizar una consulta SQL que para cada año muestre :
 Año
 El producto con composición más vendido para ese año.
 Cantidad de productos que componen directamente al producto más vendido
 La cantidad de facturas en las cuales aparece ese producto.
 El código de cliente que más compro ese producto.
 El porcentaje que representa la venta de ese producto respecto al total de venta 
del año.
El resultado deberá ser ordenado por el total vendido por año en forma descendente.
*/

select year(f1.fact_fecha), i1.item_producto,
(select count(*) from Producto p1 join Composicion c1 on p1.prod_codigo = c1.comp_producto
    join Producto componente on componente.prod_codigo = c1.comp_componente
    where p1.prod_codigo = i1.item_producto) as [Cant de composiciones],
(select count(distinct f2.fact_numero+f2.fact_sucursal+f2.fact_tipo) from Factura f2 
    join Item_Factura i2 on f2.fact_numero+f2.fact_sucursal+f2.fact_tipo = i2.item_numero+i2.item_sucursal+i2.item_tipo
    where i2.item_producto = i1.item_producto and year(f1.fact_fecha) = year(f2.fact_fecha)
) as [Cant facturas],
(select top 1 f3.fact_cliente from Factura f3 
    join Item_Factura i3 on i3.item_numero+i3.item_tipo+i3.item_sucursal = f3.fact_numero+f3.fact_tipo+f3.fact_sucursal
    where i1.item_producto = i3.item_producto and year(f1.fact_fecha) = year(fact_fecha)
    group by f3.fact_cliente
    order by sum(i3.item_cantidad)
) as [Cliente que mas compró],
(select sum(i4.item_cantidad * i4.item_precio) / (
                                                    select sum(i5.item_precio * i5.item_cantidad) from Item_Factura i5
                                                    join Factura f5 
                                                    on f5.fact_sucursal+f5.fact_numero+f5.fact_tipo = 
                                                        i5.item_sucursal+i5.item_numero+i5.item_tipo
                                                    where year(f1.fact_fecha) = year(f5.fact_fecha)
                                                ) * 100 from Item_Factura i4 
    join Factura f4 on f4.fact_sucursal+f4.fact_numero+f4.fact_tipo = i4.item_sucursal+i4.item_numero+i4.item_tipo
        where year(f4.fact_fecha) = year(f1.fact_fecha) and i4.item_producto = i1.item_producto
    ) as [Porcentaje respecto a la venta total del año]
from Factura f1 join Item_Factura i1 on 
f1.fact_numero+f1.fact_sucursal+f1.fact_tipo = i1.item_numero+i1.item_sucursal+i1.item_tipo
where i1.item_producto = (select top 1 prod_codigo from Producto p1 
                            join Composicion c1 on c1.comp_producto = p1.prod_codigo
                            join Item_Factura it1 on it1.item_producto = p1.prod_codigo
                            join Factura f on f.fact_numero+f.fact_sucursal+f.fact_tipo = it1.item_numero+it1.item_sucursal+it1.item_tipo
                            where year(f1.fact_fecha) = year(f.fact_fecha)
                            order by (it1.item_cantidad * it1.item_producto) desc)
group by year(f1.fact_fecha), i1.item_producto
order by sum(i1.item_cantidad * i1.item_precio) desc 




SELECT YEAR(F1.fact_fecha)
	,IFACT1.item_producto
	,(
		SELECT COUNT(*)
		FROM Producto Prod
			INNER JOIN Composicion C
				ON C.comp_producto = Prod.prod_codigo
			INNER JOIN Producto Componente
				ON Componente.prod_codigo = C.comp_componente
		WHERE Prod.prod_codigo = IFACT1.item_producto
	) AS [Productos que componen el mas vendido]
	,(
		SELECT COUNT(DISTINCT F.fact_numero+F.fact_sucursal+F.fact_tipo)
		FROM Factura F
			INNER JOIN Item_Factura IFACT
				ON F.fact_tipo = IFACT.item_tipo AND F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal
			INNER JOIN Producto Prod
				ON Prod.prod_codigo = IFACT.item_producto
			INNER JOIN Composicion C
				ON C.comp_producto = Prod.prod_codigo
		WHERE Prod.prod_codigo = IFACT1.item_producto AND YEAR(F.fact_fecha) = YEAR(F1.fact_fecha)
	) AS [Cantidad de facturas]
	,(
		SELECT TOP 1 F.fact_cliente
		FROM Factura F
			INNER JOIN Item_Factura IFACT
				ON F.fact_tipo = IFACT.item_tipo AND F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal
		WHERE IFACT.item_producto = IFACT1.item_producto AND YEAR(F.fact_fecha) = YEAR(F1.fact_fecha)
		GROUP BY F.fact_cliente
		ORDER BY SUM(IFACT.item_cantidad) DESC
	)
	,(
		SELECT ( SUM(IFACT.item_cantidad) /
					(
						SELECT TOP 1 SUM(item_cantidad)
						FROM Item_Factura
							INNER JOIN Factura
								ON fact_numero = item_numero AND fact_tipo = item_tipo AND fact_sucursal = item_sucursal
						WHERE YEAR(fact_fecha) = YEAR(F1.fact_fecha)
					) *100
					
				)
		FROM Factura F
			INNER JOIN Item_Factura IFACT
				ON F.fact_tipo = IFACT.item_tipo AND F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal
		WHERE IFACT.item_producto = IFACT1.item_producto AND YEAR(F.fact_fecha) = YEAR(F1.fact_fecha)
	)
FROM Factura F1
	INNER JOIN Item_Factura IFACT1
		ON F1.fact_tipo = IFACT1.item_tipo AND F1.fact_numero = IFACT1.item_numero AND F1.fact_sucursal = IFACT1.item_sucursal
WHERE IFACT1.item_producto = (
								SELECT top 1 P.prod_codigo
								FROM Producto P
									INNER JOIN Composicion C
										ON C.comp_producto = P.prod_codigo
									INNER JOIN Item_Factura IFACT
										ON IFACT.item_producto = P.prod_codigo
									INNER JOIN Factura F
										ON F.fact_tipo = IFACT.item_tipo AND F.fact_numero = IFACT.item_numero AND F.fact_sucursal = IFACT.item_sucursal
								WHERE YEAR(F1.fact_fecha) = YEAR(F.fact_fecha)
								ORDER BY (IFACT.item_producto * IFACT.item_cantidad) DESC
							)						
GROUP BY YEAR(F1.fact_fecha),IFACT1.item_producto
ORDER BY SUM(IFACT1.item_cantidad) DESC

/*
SELECT  YEAR(F.fact_fecha) 'Año',
		I.item_producto 'Producto mas vendido',
		(SELECT COUNT(*) FROM Composicion WHERE comp_producto = I.item_producto) 'Cant. Componentes',
		COUNT(DISTINCT F.fact_tipo + F.fact_sucursal + F.fact_numero) 'Facturas',
		(SELECT TOP 1 fact_cliente
		FROM Factura JOIN Item_Factura
			ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
		WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha) AND item_producto = I.item_producto
		GROUP BY fact_cliente
		ORDER BY SUM(item_cantidad) DESC) 'Cliente mas Compras',
		SUM(ISNULL(I.item_cantidad, 0)) /
			(SELECT SUM(item_cantidad)
			FROM Factura JOIN Item_Factura
				ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
			WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha))*100 'Porcentaje'
FROM Factura F JOIN Item_Factura I
    ON (F.fact_tipo + F.fact_sucursal + F.fact_numero = I.item_tipo + I.item_sucursal + I.item_numero)
WHERE  I.item_producto = (SELECT TOP 1 item_producto
							   FROM Item_Factura
							   JOIN Composicion
							     ON item_producto = comp_producto
							   JOIN Factura
							     ON fact_tipo + fact_sucursal + fact_numero = item_tipo + item_sucursal + item_numero
							 WHERE YEAR(fact_fecha) = YEAR(F.fact_fecha)
							 GROUP BY item_producto
							 ORDER BY SUM(item_cantidad) DESC)
GROUP BY YEAR(F.fact_fecha), I.item_producto
ORDER BY SUM(I.item_cantidad) DESC
*/


/*
31. Escriba una consulta sql que retorne una estadística por Año y Vendedor que retorne las siguientes columnas: 
 * Año.
 * Codigo de Vendedor 
 * Detalle del Vendedor 
 * Cantidad de facturas que realizó en ese año 
 * Cantidad de clientes a los cuales les vendió en ese año. 
 * Cantidad de productos facturados con composición en ese año 
 * Cantidad de productos facturados sin composicion en ese año. 
 * Monto total vendido por ese vendedor en ese año 
Los datos deberan ser ordenados por año y dentro del año por el vendedor que haya vendido mas productos diferentes de mayor a menor.
*/

select 
    year(f1.fact_fecha) as Anio,
    f1.fact_vendedor,
    e1.empl_nombre,
    count(distinct f1.fact_cliente) as cantidad_de_clientes,
    (select count(*) from item_factura
	join composicion on item_producto = comp_producto
	join factura f2 on item_tipo+item_sucursal+item_numero = f2.fact_tipo + f2.fact_sucursal + f2.fact_numero
	where year(fact_fecha) = year(f1.fact_fecha)
	and f2.fact_vendedor = f1.fact_vendedor
    ) as cant_productos_facturados_con_composicion,
    (select count(*) from Item_Factura i1 
    join Factura f2 on f2.fact_numero+f2.fact_sucursal+f2.fact_tipo = i1.item_numero+i1.item_sucursal+i1.item_tipo
    where f1.fact_vendedor = f2.fact_vendedor and year(f2.fact_fecha) = year(f1.fact_fecha) 
    and item_producto not in (select comp_producto from Composicion)
    ) as cant_productos_sin_comp,
    sum(item_cantidad*item_precio) as total_vendido
from Factura f1 join Empleado e1 on e1.empl_codigo = f1.fact_vendedor
join Item_Factura on item_numero+item_sucursal+item_tipo = fact_numero+fact_sucursal+fact_tipo
group by year(f1.fact_fecha), f1.fact_vendedor, e1.empl_nombre
order by 1, (select count(*) from Item_Factura i1 
    join Producto on item_producto = prod_codigo
    join Factura f2 on f2.fact_numero+f2.fact_sucursal+f2.fact_tipo = i1.item_numero+i1.item_sucursal+i1.item_tipo
    where f1.fact_vendedor = f2.fact_vendedor and year(f2.fact_fecha) = year(f1.fact_fecha)) desc


/* Realizar una consulta SQL que permita saber si un cliente compró un producto en todos los meses del 2012.

Además, mostrar para el 2012:
El cliente
La razón social del cliente
El producto comprado
El nombre del producto
Cantidad de productos distintos comprados por el cliente
Cantidad de productos con composición comprados por el cliente

📌 Condición de ordenamiento:

El resultado deberá ser ordenado poniendo primero aquellos clientes que compraron más de 10 productos distintos en el 2012.
⚠️ Nota:
No se permite SELECT en el FROM, es decir:
SELECT ... FROM (SELECT ...) AS T ... no está permitido.el resultado Debera ser ordenado poniendo primero aquellos clientes que compraron mas de 10 productos distintos en el 2012
*/

select 
    fact_cliente, 
    clie_razon_social, 
    item_producto, 
    prod_detalle,
    (select count(distinct item_producto) from Item_Factura i1 
    join Factura f1 on i1.item_numero+i1.item_sucursal+i1.item_tipo = f1.fact_numero+f1.fact_sucursal+f1.fact_tipo
    join Cliente c1 on f1.fact_cliente = c1.clie_codigo where fac.fact_cliente = c1.clie_codigo and year(f1.fact_fecha) = 2012),
    (select count(distinct item_producto) from Item_Factura i1
    join Factura f1 on i1.item_numero+i1.item_sucursal+i1.item_tipo = f1.fact_numero+f1.fact_sucursal+f1.fact_tipo
    join Cliente c2 on f1.fact_cliente = c2.clie_codigo where fac.fact_cliente = c2.clie_codigo and year(f1.fact_fecha) = 2012
    and item_producto in (select comp_producto from Composicion))
    from Cliente
join Factura fac on clie_codigo = fact_cliente
join Item_Factura on item_numero+item_sucursal+item_tipo = fact_numero+fact_sucursal+fact_tipo
join Producto on item_producto = prod_codigo
where year(fact_fecha) = 2012
group by fact_cliente, clie_razon_social, item_producto, prod_detalle 
having count(distinct month(fact_fecha)) = 5
order by (select count(distinct item_producto) from Item_Factura i1 
    join Factura f1 on i1.item_numero+i1.item_sucursal+i1.item_tipo = f1.fact_numero+f1.fact_sucursal+f1.fact_tipo
    join Cliente c1 on f1.fact_cliente = c1.clie_codigo where fac.fact_cliente = c1.clie_codigo and year(f1.fact_fecha) = 2012) desc



/*
Realizar una consulta sql que retorne para los 10 clientes que más
compraron en 2012 y que fueron atendidos por más de 3 vendedores distintos
* Apellido y nombre de cliente
* Cantidad de productos distintos comprados en 2012
* Cantidad de unidades compradas dentro del primer semestre del 2012 

El resultado deberá mostrar ordenado la cantidad de ventas descendente del 2012
de cada cliente, en caso de igualdad de ventas, ordenar por código de cliente
*/

select 
    clie_razon_social,
    count(distinct item_producto),
    (select count(i1.item_producto) from Item_Factura i1
    join Factura f1 on i1.item_numero+i1.item_sucursal+i1.item_tipo = f1.fact_numero+f1.fact_sucursal+f1.fact_tipo
    where year(fact_fecha) = 2012 and f1.fact_cliente = f2.fact_cliente and month(fact_fecha) <= 6)
from Cliente 
join Factura f2 on clie_codigo = fact_cliente
join Item_Factura on fact_numero+fact_sucursal+fact_tipo = item_numero+item_sucursal+item_tipo
where year(fact_fecha) = 2012
group by clie_razon_social, fact_cliente
order by count(distinct fact_numero), fact_cliente






select 
    item_producto,
    (case when count(item_producto) > 100 then 'Popular' else 'Sin interés' end),
    count(distinct item_numero+item_sucursal+item_tipo),
    (select top 1 f1.fact_cliente from Factura f1
    join Item_Factura i1 on i1.item_tipo+i1.item_numero+i1.item_sucursal = f1.fact_tipo+f1.fact_numero+f1.fact_sucursal
    where i1.item_producto = i0.item_producto
    and year(f1.fact_fecha) = 2012
    group by f1.fact_cliente
    order by sum(i1.item_cantidad*i1.item_precio) desc)
from Item_Factura i0
join Factura f2 on item_numero+item_tipo+item_sucursal = fact_numero+fact_tipo+fact_sucursal
where year(fact_fecha) = 2012
group by item_producto
having sum(i0.item_cantidad*i0.item_precio) > (select avg(i2.item_cantidad*i2.item_precio) from Item_Factura i2
                            join Factura f3 on i2.item_tipo+i2.item_numero+i2.item_sucursal = f3.fact_tipo+f3.fact_numero+f3.fact_sucursal
                            where year(fact_fecha) = 2011 or year(fact_fecha) = 2010) * 0.15 
order by 2, 3 desc


/*
Mostrar 

* Depósito
* Domicilio del Depósito 
* Cantidad de productos compuestos con stock
* Cantidad de productos no compuestos con stock 
* Indicar un string "Mayoria Compuestos", en caso de que el depósito tenga mayor cantidad 
    de productos compuestos o "Mayoría no compuestos", caso contrario
* Empleado más joven en todos los depósitos
*/

select 
    depo_codigo, 
    depo_domicilio,
    (select count(distinct stoc_producto) from STOCK
    where stoc_deposito = depo_codigo and stoc_producto in (select comp_producto from Composicion)),
    (select count(distinct stoc_producto) from STOCK
    where stoc_deposito = depo_codigo and stoc_producto not in (select comp_producto from Composicion)),
    (case when (select count(distinct stoc_producto) from STOCK 
            where stoc_deposito = depo_codigo and stoc_producto 
            in (select comp_producto from Composicion)) > (select count(distinct stoc_producto) from STOCK
            where stoc_deposito = depo_codigo and stoc_producto not in (select comp_producto from Composicion)) then 'Mayoria Compuestos' else 'Mayoría no compuestos' 
            end),
    (select top 1 d1.depo_encargado from DEPOSITO d1
    join Empleado on depo_encargado = empl_codigo
    order by empl_nacimiento)
from DEPOSITO 
group by depo_codigo, depo_domicilio