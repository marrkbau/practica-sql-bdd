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