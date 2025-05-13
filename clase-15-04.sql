
select top 1 fact_cliente
-- , count(*) as cantidad, sum(fact_total), min(fact_total), max(fact_total), avg(fact_total)
from factura
group by fact_cliente
-- having count(*) > 10
order by sum(fact_total) desc


/*
Las dos son lo mismo, la segunda es mas recomendada usarla por un tema de legilibidad.
*/
select * from Cliente, Factura
where clie_codigo = fact_cliente;

select * from Cliente join Factura on 
clie_codigo = fact_cliente;

/*
CASE Condition
*/

select fact_fecha, case year(fact_fecha) when 2010 then 'vieja' when 2011 then 'normal' when 2012 then 'nueva' else 'nada' end from Factura

select clie_codigo, clie_razon_social, case when clie_codigo > '00100' then 'codigo bajo' when clie_razon_social like '%A%' 
then 'tiene A' when clie_vendedor = 2 then 'vendedor 2' else 'ninguno' END
from Cliente;