



/*
3. Cree el/los objetos de base de datos necesarios para corregir la tabla empleado en caso que sea necesario.
Se sabe que debería existir un único gerente general (debería ser el único empleado sin jefe). 
Si detecta que hay más de un empleado sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por mayor salario. 
Si hay más de uno se seleccionara el de mayor antigüedad en la empresa.  
Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla de un único empleado sin jefe (el gerente general) y 
deberá retornar la cantidad de empleados que había sin jefe antes de la ejecución. 
*/


go
create procedure ej3 @empleados_sin_jefe numeric(30) output
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
go


/*
10. Crear el/los objetos de base de datos que ante el intento de borrar un artículo 
verifique que no exista stock y si es así lo borre en caso contrario que emita un 
mensaje de error
*/


create trigger ej10 on Producto after delete 
AS 
begin

    if(select count(*) from deleted join STOCK on stoc_producto = prod_codigo where stoc_cantidad > 0) > 0
    BEGIN
        rollback 
        RAISERROR('No se pueden borrar los producto con stock',)
    END

end



GO

-- Borrar los que se puedan e informar uno por uno los que no se puedan --
alter trigger ej10 on Producto INSTEAD OF delete 
AS 
begin

    declare @producto char(8)
    delete from Producto where prod_codigo in (select prod_codigo from deleted where prod_codigo
    not in (select distinct stoc_producto from STOCK where stoc_cantidad > 0))

    declare c1 cursor for select distinct stoc_producto from deleted join STOCK on prod_codigo = stoc_producto where stoc_cantidad > 0
    open c1 
    fetch next c1 into @producto
    while @@FETCH_STATUS = 0
    begin 
        print('El producto' + @producto + 'no se pudo borrar porque tiene stock')
        fetch next c1 into @producto 
    END
    close c1
    DEALLOCATE c1

end



/*
11. Cree el/los objetos de base de datos necesarios para que dado un código de
empleado se retorne la cantidad de empleados que este tiene a su cargo (directa o
indirectamente). Solo contar aquellos empleados (directos o indirectos) que 
tengan un código mayor que su jefe directo
*/
go
create function ej11 (@empleado int)
returns int 
as 
begin 

    declare @conteo numeric(8)

    set @conteo = (select isnull(count(*) + sum(dbo.ej11(empl_codigo)), 0) from Empleado e where e.empl_jefe = @empleado)
    return @conteo 
end
go


drop FUNCTION ej11

BEGIN
declare @count NUMERIC(8)

set @count = ej11(3) 
print(@count)
END


select * from Empleado

update Empleado set empl_jefe = 3 where empl_codigo = 7