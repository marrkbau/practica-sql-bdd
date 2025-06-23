/*Hacer una función que dado un artículo y un deposito devuelva un string 
que indique el estado del depósito según el artículo. Si la cantidad almacenada 
es menor al límite retornar “OCUPACION DEL DEPOSITO XX %” siendo XX el % de ocupación. 
Si la cantidad almacenada es mayor o igual al límite retornar “DEPOSITO COMPLETO”. */

CREATE FUNCTION ejercicio1 (@artículo char(8), @deposito char(8)) 
RETURNS VARCHAR(70) 
AS 
BEGIN
    DECLARE @retorno VARCHAR(70), @stock numeric(12,2), @maximo numeric(12,2)
    SELECT @stock = stoc_cantidad, @maximo = stoc_stock_maximo
    FROM STOCK
    WHERE stoc_producto = @artículo and stoc_deposito = @deposito
    IF @stock >= @maximo
        SELECT @retorno = 'DEPOSITO COMPLETO'
    ELSE 
        SELECT @retorno = 'OCUPACIÓN DEL DEPOSITO '+@deposito+STR((@stock/@maximo)*100,2,2) +' %'
    RETURN @retorno
END
GO

SELECT stoc_producto, stoc_deposito, stoc_stock_maximo, DBO.ejercicio1(stoc_producto, stoc_deposito) ocupacion_deposito
FROM STOCK
GO

/*
3. Cree el/los objetos de base de datos necesarios para corregir la tabla empleado 
en caso que sea necesario. Se sabe que debería existir un único gerente general 
(debería ser el único empleado sin jefe). Si detecta que hay más de un empleado 
sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por 
mayor salario. Si hay más de uno se seleccionara el de mayor antigüedad en la 
empresa. Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla 
de un único empleado sin jefe (el gerente general) y deberá retornar la cantidad 
de empleados que había sin jefe antes de la ejecución.
*/

create procedure ej3 @cantidad int output
as
begin
    declare @gg numeric(6)
    select @cantidad = count(*) from Empleado where empl_jefe is null
    select top 1 @gg=empl_codigo from Empleado where empl_jefe is null
    order by empl_salario desc, empl_ingreso asc
    update Empleado set empl_jefe = @gg where empl_jefe is null and empl_codigo <> @gg
    return
end

begin
    declare @cant INT 
    execute ej3 @cant
    print @cant
end

select * from Empleado

update Empleado set empl_jefe = null where empl_codigo < 4


/*
*/



-- con cursores
go
alter procedure ej3 @cantidad int output
as
begin
    declare @gg numeric(6), @empleado numeric(6)
    select top 1 @gg=empl_codigo from Empleado where empl_jefe is null

    declare c1 cursor for (select empl_codigo from Empleado where empl_jefe is null and empl_codigo <> @gg)
    open c1 
    fetch c1 into @empleado
    while @@FETCH_STATUS = 0 
    begin
        update Empleado set empl_jefe = @gg where empl_codigo = @empleado
        fetch c1 into @empleado
    end
    close c1 
    deallocate c1

    return
end
GO

/*
6. Realizar un procedimiento que si en alguna factura se facturaron componentes 
que conforman un combo determinado (o sea que juntos componen otro 
producto de mayor nivel), en cuyo caso deberá reemplazar las filas 
correspondientes a dichos productos por una sola fila con el producto que 
componen con la cantidad de dicho producto que corresponda.
*/

/*
9. Crear el/los objetos de base de datos que ante alguna modificación de un ítem de 
factura de un artículo con composición realice el movimiento de sus 
correspondientes componentes.
*/

select * from Producto join Composicion on comp_producto = prod_codigo
go

create trigger ejercicio9 
on Item_Factura 
for insert 
as
begin

    if(select count(*)
    from inserted
    where inserted.item_producto in (select comp_producto from Composicion)) > 0
    begin
        declare @codigo char(8), @cantidad int, @deposito char(2) 
        declare cursor_insert cursor 
        for select stoc_producto, stoc_cantidad, stoc_deposito
        from stock
        join Composicion on stoc_producto = comp_componente
        where stoc_producto in (select comp_componente
                                from Composicion join inserted on item_producto = comp_producto	)
        and stoc_deposito = (
            select item_sucursal
            from inserted
            where comp_producto = item_producto
        )
        group by stoc_producto, stoc_deposito, stoc_cantidad
        open cursor_insert
        fetch from cursor_insert
        into @codigo, @cantidad, @deposito
        while @@FETCH_STATUS = 0
        begin
            update STOCK
            set stoc_cantidad  = stoc_cantidad - @cantidad
            where stoc_producto = @codigo and stoc_deposito = @deposito
            fetch from cursor_insert into @codigo, @cantidad, @deposito
        end
        close cursor_insert
        deallocate cursor_insert
    end

end





DROP TRIGGER Ejercicio9
go
alter TRIGGER Ejercicio9 ON item_factura FOR INSERT
AS
IF (SELECT COUNT(*)
	FROM inserted I
	WHERE I.item_producto IN (
								SELECT comp_producto
								FROM Composicion
							)
	) > 0
	BEGIN
		DECLARE @Codigo char(8), @Cantidad INT, @Deposito char(2)
		DECLARE cursor_insert CURSOR
			FOR SELECT S.stoc_producto
					,S.stoc_cantidad
					,S.stoc_deposito
				FROM STOCK S
					INNER JOIN Composicion C
						ON C.comp_componente = S.stoc_producto
				WHERE S.stoc_producto IN (SELECT Comp_componente
										FROM Composicion
										INNER JOIN inserted
											ON item_producto = comp_producto
											)
					AND S.stoc_deposito = (
											SELECT RIGHT(item_sucursal,2)
											FROM inserted
											WHERE C.comp_producto = item_producto
											)

				GROUP BY S.stoc_producto,S.stoc_cantidad,S.stoc_deposito

		OPEN cursor_insert
		FETCH NEXT FROM cursor_insert
		INTO @Codigo,@cantidad,@Deposito
		WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE STOCK 
				SET stoc_cantidad = stoc_cantidad - @cantidad
				WHERE stoc_producto = @Codigo AND stoc_deposito = @Deposito
				FETCH NEXT FROM cursor_insert
				INTO @Codigo,@cantidad,@Deposito
		END
		CLOSE cursor_insert
		DEALLOCATE cursor_insert

	END
GO




/*
select * from Item_Factura
where item_producto IN (SELECT comp_producto
						FROM Composicion)

SELECT * from stock
where stoc_producto IN (SELECT comp_producto
						FROM Composicion)
						*/