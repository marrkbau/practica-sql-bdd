



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
alter procedure ej4 @empl_mas_vendedor int output
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
        --RAISERROR('No se pueden borrar los producto con stock',)
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

--set @count = dbo.ej11(3) 
print(@count)
END


select * from Empleado

update Empleado set empl_jefe = 3 where empl_codigo = 7


/*
13. Cree el/los objetos de base de datos necesarios para implantar la siguiente regla 
“Ningún jefe puede tener un salario mayor al 20% de las suma de los salarios de sus empleados totales (directos + indirectos)”.
Se sabe que en la actualidad dicha regla se cumple y que la base de datos es accedida por n aplicaciones de diferentes tipos y tecnologías 
*/
go
create trigger ej13 on Empleado for delete, update 
as 
begin 
    if (select count(*) from inserted where (select empl_salario from Empleado where empl_codigo = inserted.empl_jefe) 
                                    < (dbo.ej13(inserted.empl_jefe) * 0.2)) > 0
    BEGIN
        ROLLBACK
    END

    if (select count(*) from deleted where (select empl_salario from Empleado where empl_codigo = deleted.empl_jefe) 
                                    < (dbo.ej13(deleted.empl_jefe) * 0.2)) > 0
    BEGIN
        ROLLBACK
    END

end
go

create function ej13 (@codigoDeJefe int )
returns numeric(8)
as 
begin 

    declare @salarioDeTodos NUMERIC(8)
    set @salarioDeTodos = (select sum(empl_salario) + sum(dbo.ej13(empl_codigo)) from Empleado where empl_jefe = @codigoDeJefe)
    return @salarioDeTodos
end

go

/*
14. Agregar el/los objetos necesarios para que si un cliente compra un producto compuesto a un precio menor que la suma
de los precios de sus componentes  que imprima la  fecha, que cliente, que productos y a qué precio se realizó la compra.
No se deberá permitir que dicho precio sea menor a la mitad de la suma de los componentes.
*/

create trigger ej14 on item_factura instead of insert 
as 
begin 
    declare @producto char(8), @precio numeric(12,2), @cantidad numeric(12,2), @tipo char, @numero char(8), @sucursal char
    declare c1 cursor for (select item_producto, item_precio from inserted)
    open c1
    fetch c1 next into @producto, @precio, @cantidad, @tipo, @sucursal, @numero 
    while @@FETCH_STATUS = 0
    begin 
        if @precio > (select isnull(sum(prod_precio), 0) from Producto join Composicion on prod_codigo = comp_componente where comp_producto = '00001104') * 0.5
            begin 
                insert Item_Factura values(@tipo, @sucursal, @numero, @producto, @cantidad, @precio)  
            end 
        else 
        if @precio < (select isnull(sum(prod_precio), 0) from Producto join Composicion on prod_codigo = comp_componente where comp_producto = @producto) * 0.5
            print('la suma del los componentes es menor que el precio del producto ' + @producto)
        else 
            begin 
                insert Item_Factura values(@tipo, @sucursal, @numero, @producto, @cantidad, @precio)
                declare @fecha date, @cliente char
                select @fecha = fact_fecha, @cliente = fact_cliente from Factura join Item_Factura on fact_numero+fact_sucursal+fact_tipo=@numero+@sucursal+@tipo
                print(@fecha + @cliente + @producto + @precio)
            end 
        fetch c1 next into @producto, @precio 

    end
    close c1 
    deallocate c1 

end 
go 

select prod_precio from Producto join Composicion on comp_producto = prod_codigo where prod_codigo = '00001104'


go
create trigger ejparcial2 on producto instead of insert 
as 
begin 
    declare @rubro char, @producto char, @cantidad_de_prods int, @nuevo_rubro char, @prod_envase char, @prod_familia char,
    @prod_detalle char, @prod_precio numeric(12,2)

    declare c1 cursor for (select prod_codigo, prod_rubro, prod_detalle, prod_familia, prod_envase, prod_precio from inserted)
    open c1
    fetch c1 next into @producto, @rubro, @prod_detalle, @prod_familia, @prod_envase, @prod_precio 
    while @@FETCH_STATUS = 0
        begin 
            set @cantidad_de_prods = (select count(*) from Producto join Rubro on prod_rubro = rubr_id and rubr_id = @rubro)
            if @cantidad_de_prods > 20
                begin
                    set @nuevo_rubro = (select rubr_id from Producto join Rubro on prod_rubro = rubr_id
                    group by rubr_id
                    order by count(*))
                    insert into Producto values (@producto, @nuevo_rubro, @prod_detalle, @prod_familia, @prod_envase, @prod_precio)
                    print('Nuevo rubro asignado: ' + @nuevo_rubro + ' Producto: ' + @producto)
                end
            else 
                begin 
                    insert into Producto values (@producto, @rubro, @prod_detalle, @prod_familia, @prod_envase, @prod_precio)
                end
            fetch c1 next into @producto, @rubro, @prod_detalle, @prod_familia, @prod_envase, @prod_precio 
        end 
        close c1
        deallocate c1
end 

go
create trigger ejparcial1 on item_factura after insert
as 
begin 


    declare @producto char(8), @item_precio numeric(12,2), @fecha date, @precio_mes_pasado numeric(12,2), @precio_anio_pasado numeric(12,2)
    declare @tipo char, @sucursal char, @num numeric(12,2)
    declare c1 cursor for (select item_producto, item_precio, fact_fecha, fact_tipo, fact_sucursal, fact_numero from inserted join Factura on item_numero+item_sucursal+item_tipo=fact_numero+fact_sucursal+fact_tipo)
    open c1 
    fetch c1 next into @producto, @item_precio, @fecha, @tipo, @sucursal, @num
    while @@FETCH_STATUS = 0
        begin 
            select @precio_mes_pasado = isnull(avg(item_precio), 0) from Factura join Item_Factura 
                on item_numero+item_sucursal+item_tipo=fact_numero+fact_sucursal+fact_tipo where DATEDIFF(month, fact_fecha, GETDATE()) = 1 and item_producto = @producto

              select @precio_anio_pasado = isnull(avg(item_precio), 0) from Factura join Item_Factura 
                on item_numero+item_sucursal+item_tipo=fact_numero+fact_sucursal+fact_tipo where DATEDIFF(month, fact_fecha, GETDATE()) = 12 
                and item_producto = @producto 

            if @precio_mes_pasado = 0 and @precio_anio_pasado = 0
                begin
                fetch c1 next into @producto, @item_precio, @fecha, @tipo, @sucursal, @num
                continue -- Es 0, no hay valores anteriores anteriores
                end

            if @item_precio < @precio_mes_pasado or @item_precio > @precio_mes_pasado * 1.05
                begin 
                    ROLLBACK
                    delete from Item_Factura where item_numero+item_sucursal+item_tipo = @num+@sucursal+@tipo 
                    delete from Factura where fact_numero+fact_sucursal+fact_tipo=@num+@sucursal+@tipo 
                    print('No se puede vender un producto con un precio que no esté entre el 0% y el 5% del precio del mes pasado')
                    break
                end
 
            if @item_precio > @precio_anio_pasado * 1.50
                begin
                    delete from Item_Factura where item_numero+item_sucursal+item_tipo = @num+@sucursal+@tipo 
                    delete from Factura where fact_numero+fact_sucursal+fact_tipo=@num+@sucursal+@tipo 
                    print('No se puede vender un producto con un precio mayor al 50% del precio del año pasado')
                    break
                end 
            fetch c1 next into @producto, @item_precio, @fecha, @tipo, @sucursal, @num
        end
        close c1
        deallocate c1
end 


/*Realizar un store procedure que calcule e informe la comision de un vendedor para
un determinado mes. Los parametros de entrada es codigo de vendedor, mes y anio.
El criterio para calcular la comision es: 5% del total vendido tomando como importe
base el valor de la factura sin los impuestos del mes a comisionar, a esto se le debe
sumar un plus de 3% mas en el caso de que sea el vendedor que mas vendio los productos
nuevos en comparacion al resto de los vendedores, es decir este plus se le aplica
solo a un vendedor y en caso de igualdad se le otorga al que posea el codigo de vendedor
mas alto. Se considera que un producto es nuevo cuando su primera venta en la empresa 
se produjo durante el mes en curso o en alguno de los 4 meses anteriores. De no haber
ventas de productos nuevos en este periodo, ese plus nunca se aplica-*/
go


create procedure parcial3 @codigo_vendedor int, @mes int, @anio int
as 
begin 
    declare @comision numeric(12,2)
    declare @vendido numeric(12,2)

    set @vendido = (select sum(fact_total) from Factura 
                    where fact_vendedor = @codigo_vendedor 
                    and month(fact_fecha) = @mes 
                    and year(fact_fecha) = @anio)
    set @comision = @vendido * 0.05

    if (select top 1 fact_vendedor from Factura join Item_Factura 
        on item_numero+item_sucursal+item_tipo = fact_numero+fact_sucursal+fact_tipo
        group by fact_vendedor, fact_fecha
        having year(fact_fecha) = year(GETDATE()) and datediff(month, min(fact_fecha) ,GETDATE()) between 1 and 4
        order by count(item_producto) desc, fact_vendedor) = @codigo_vendedor
        begin 
            set @comision = @comision + @vendido * 0.03
        end
        print('La comisión del vendedor: ' + @codigo_vendedor + 'es: ' + @comision)

    return 
end  















































>>>>>>> c94217ef3a97b128bdf57560701f3121ddf23938
