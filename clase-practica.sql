/* EJERCICIO 1
Mostrar el código, razón social de todos los clientes cuyo limite de crédito sea mayor
o igual a $1000 ordenado por código de cliente */

select clie_codigo, clie_razon_social
from cliente
where clie_limite_credito >= 1000;

/* EJERCICIO 2
Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por
cantidad vendida*/

select prod_codigo, prod_detalle
from producto join Item_Factura on prod_codigo = item_producto join factura 
		on fact_tipo+fact_sucursal+fact_numero= item_tipo+item_sucursal+item_numero
where year(fact_fecha) = 2012
group by prod_codigo, prod_detalle
order by sum(item_cantidad)

/* EJERCICIO 3
Realizar una consulta que muestra código de producto, nombre de producto y el stock
total, sin importar en que deposito se encuentre, los datos deben ser ordenados por 
nombre del artículo de menor a mayor*/

select prod_codigo, prod_detalle, sum(stoc_cantidad)
from Producto join stock on prod_codigo = stoc_producto 
group by prod_codigo, prod_detalle
order by 2

/* EJERCICIO 4 
Realizar una consulta que muestre todos los articulos código, detalle y cantidad de 
artículos que lo componen. Mostrar solo aquellos artíclos para los cuales el stock
promedio por depósito sea mayor a 100*/

select prod_codigo, prod_detalle 
from Producto left join Composicion on prod_codigo = comp_producto
group by prod_codigo, prod_detalle

order by comp_producto, comp_componente