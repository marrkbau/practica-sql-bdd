/* EJERCICIO 1
Mostrar el c�digo, raz�n social de todos los clientes cuyo limite de cr�dito sea mayor
o igual a $1000 ordenado por c�digo de cliente */

select clie_codigo, clie_razon_social
from cliente
where clie_limite_credito >= 1000;

/* EJERCICIO 2
Mostrar el c�digo, detalle de todos los art�culos vendidos en el a�o 2012 ordenados por
cantidad vendida*/

select prod_codigo, prod_detalle
from producto join Item_Factura on prod_codigo = item_producto join factura 
		on fact_tipo+fact_sucursal+fact_numero= item_tipo+item_sucursal+item_numero
where year(fact_fecha) = 2012
group by prod_codigo, prod_detalle
order by sum(item_cantidad)

/* EJERCICIO 3
Realizar una consulta que muestra c�digo de producto, nombre de producto y el stock
total, sin importar en que deposito se encuentre, los datos deben ser ordenados por 
nombre del art�culo de menor a mayor*/

select prod_codigo, prod_detalle, sum(stoc_cantidad)
from Producto join stock on prod_codigo = stoc_producto 
group by prod_codigo, prod_detalle
order by 2

/* EJERCICIO 4 
Realizar una consulta que muestre todos los articulos c�digo, detalle y cantidad de 
art�culos que lo componen. Mostrar solo aquellos art�clos para los cuales el stock
promedio por dep�sito sea mayor a 100*/

select prod_codigo, prod_detalle 
from Producto left join Composicion on prod_codigo = comp_producto
group by prod_codigo, prod_detalle

order by comp_producto, comp_componente