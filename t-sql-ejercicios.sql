



/*
3. Cree el/los objetos de base de datos necesarios para corregir la tabla empleado en caso que sea necesario.
Se sabe que debería existir un único gerente general (debería ser el único empleado sin jefe). 
Si detecta que hay más de un empleado sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por mayor salario. 
Si hay más de uno se seleccionara el de mayor antigüedad en la empresa.  
Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla de un único empleado sin jefe (el gerente general) y 
deberá retornar la cantidad de empleados que había sin jefe antes de la ejecución. 
*/


go
alter procedure ej3 @empleados_sin_jefe numeric(30) output
as
begin
    declare @jefe numeric(30)
    select @empleados_sin_jefe = count(*) from Empleado where empl_jefe is NULL
    set @jefe = (select top 1 empl_codigo from Empleado where empl_jefe is null order by empl_salario desc, empl_ingreso asc)
    update Empleado set empl_jefe = @jefe where empl_jefe is NULL and empl_codigo <> @jefe 
    return
end

begin
declare @emp numeric(30)
execute ej3 @emp
print @emp
end

update empleado set empl_jefe = null where empl_codigo < 5

select * from Empleado

/*
4. Cree el/los objetos de base de datos necesarios para actualizar la columna
de empleado empl_comision con la sumatoria del total de lo vendido por ese empleado a lo largo del último año.
Se deberá retornar el código del vendedor que más vendió (en monto) a lo largo del último año.
*/
go
create procedure ej4 @empl_mas_vendedor int output
as
begin 

set @empl_mas_vendedor = (select top 1 fact_vendedor from Factura
    where year(fact_fecha) = 2012
    group by fact_vendedor
    order by sum(fact_total) desc)

update e1 set empl_comision = isnull(tot.total_vendido, 0) 
    from Empleado e1 left join 
    (select fact_vendedor as vendedor, sum(fact_total) as total_vendido
     from Factura where year(fact_fecha) = 2012
    group by fact_vendedor) tot on e1.empl_codigo = tot.vendedor

return
end



DECLARE @vendedor INT;
EXECUTE ej4 @vendedor OUTPUT;
PRINT 'El código del vendedor que más vendió es: ' + CAST(@vendedor AS VARCHAR);

