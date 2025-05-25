select clie_domicilio, clie_limite_credito from Cliente
join Factura on clie_codigo = fact_cliente
where fact_fecha between '2012-01-01' and '2012-12-31'



/*2. Mostrar el código, detalle de todos los artículos
vendidos en el año 2012 ordenados por cantidad vendida*/
select prod_codigo, prod_detalle from Producto
join Item_Factura on prod_codigo = item_producto
join Factura on item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
where year(fact_fecha) = 2012 
group by prod_codigo, prod_detalle
order by sum(item_cantidad);

/*Ejercicio 1 Mostrar el código, razón social de 
todos los clientes cuyo límite de crédito sea mayor o igual
a $ 1000 ordenado por código de cliente. */
select clie_codigo, clie_razon_social from Cliente 
where clie_limite_credito > 1000
order by clie_codigo;

/*3. Realizar una consulta que muestre código de producto, 
nombre de producto y el stock total, 
sin importar en que deposito se encuentre, 
los datos deben ser ordenados por nombre del artículo de menor a mayor. */
select prod_codigo, prod_detalle, sum(isnull(stoc_cantidad, 0)) as stock_total 
from Producto left join stock on prod_codigo = stoc_producto
group by prod_codigo, prod_detalle
order by 2 asc

/*4. Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de
artículos que lo componen. Mostrar solo aquellos artículos para los cuales el stock
promedio por depósito sea mayor a 100.*/
select prod_codigo, prod_detalle, count(comp_componente) 
from Producto left join Composicion on prod_codigo = comp_producto
group by prod_codigo, prod_detalle 
having prod_codigo in (select stoc_producto from stock group by stoc_producto having avg(stoc_cantidad) > 100)

/*5. Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de
stock que se realizaron para ese artículo en el año 2012 (egresan los productos que
fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011.*/

select prod_codigo, prod_detalle, sum(item_cantidad)
from Producto join Item_Factura on prod_codigo = item_producto
join factura on  item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
where year(fact_fecha) = 2012
group by prod_codigo, prod_detalle
having sum(item_cantidad) > (select sum(item_cantidad) 
                    from Item_Factura join Factura on item_tipo+item_sucursal+item_numero = fact_tipo+fact_sucursal+fact_numero
                    where year(fact_fecha) = 2011 and item_producto = prod_codigo)

