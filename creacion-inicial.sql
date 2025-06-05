USE [GD1C2025]
GO


DECLARE @DropConstraints NVARCHAR(max) = ''
SELECT @DropConstraints += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.'

                        +  QUOTENAME(OBJECT_NAME(parent_object_id)) + ' ' + 'DROP CONSTRAINT' + QUOTENAME(name)
FROM sys.foreign_keys
EXECUTE sp_executesql @DropConstraints;


PRINT '--- CONSTRAINTS DROPEADOS CORRECTAMENTE ---';
GO

DECLARE @DropProcedures NVARCHAR(max) = ''
SELECT @DropProcedures += 'DROP PROCEDURE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + ';'
FROM sys.procedures;
EXECUTE sp_executesql @DropProcedures;

PRINT '--- PROCEDURES DROPEADOS CORRECTAMENTE ---';
GO

DROP TABLE IF EXISTS Detalle_Compra;
DROP TABLE IF EXISTS Compra;
DROP TABLE IF EXISTS Detalle_Pedido;
DROP TABLE IF EXISTS Material_Sillon;
DROP TABLE IF EXISTS Sillon;
DROP TABLE IF EXISTS Envio;
DROP TABLE IF EXISTS Detalle_Factura;
DROP TABLE IF EXISTS Factura;
DROP TABLE IF EXISTS Pedido_Cancelacion;
DROP TABLE IF EXISTS Pedido;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Proveedor;
DROP TABLE IF EXISTS Sucursal;
DROP TABLE IF EXISTS Direccion;
DROP TABLE IF EXISTS Localidad;
DROP TABLE IF EXISTS Provincia;
DROP TABLE IF EXISTS Contacto;
DROP TABLE IF EXISTS Estado;
DROP TABLE IF EXISTS Tela;
DROP TABLE IF EXISTS Madera;
DROP TABLE IF EXISTS Relleno;
DROP TABLE IF EXISTS Material;
DROP TABLE IF EXISTS Sillon_Modelo;
DROP TABLE IF EXISTS Sillon_Medida;

PRINT '--- TABLAS DROPEADAS CORRECTAMENTE ---';

CREATE TABLE Cliente(
    cliente_numero BIGINT IDENTITY NOT NULL PRIMARY KEY,
    cliente_contacto_num BIGINT NOT NULL,
    cliente_dni BIGINT,
    cliente_nombre NVARCHAR(255),
    cliente_apellido NVARCHAR(255),
    cliente_fechaNacimiento DATETIME2(6),
    cliente_direccion NVARCHAR(255),
    cliente_localidad_id BIGINT NOT NULL
)

create table Pedido(
    pedido_numero BIGINT NOT NULL PRIMARY KEY,
    pedido_cliente_num BIGINT NOT NULL,
    pedido_sucursal_num BIGINT NOT NULL, 
    pedido_estado_num BIGINT NOT NULL
)

create table Estado(
    estado_numero BIGINT IDENTITY NOT NULL PRIMARY KEY,
    estado_descripcion NVARCHAR(255)
)

CREATE TABLE Envio(
    envio_numero BIGINT NOT NULL PRIMARY KEY,
    envio_fact_numero BIGINT NOT NULL,
    envio_fecha DATETIME2(6),
    envio_fecha_programada DATETIME2(6),
    envio_importeTraslado DECIMAL(18,2),
    Envio_importeSubida DECIMAL(18,2)
)

CREATE TABLE Sucursal(
    sucursal_numero BIGINT NOT NULL PRIMARY KEY,
    sucursal_contacto_num BIGINT NOT NULL,
    sucursal_direccion NVARCHAR(255) NOT NULL,
    sucursal_localidad_id BIGINT NOT NULL
)

CREATE TABLE Localidad(
    localidad_num BIGINT IDENTITY NOT NULL PRIMARY KEY,
    localidad_provincia BIGINT NOT NULL,
    localidad_nombre NVARCHAR(255)
)

CREATE TABLE Proveedor(
    proved_num BIGINT IDENTITY NOT NULL PRIMARY KEY,
    proved_contacto_num BIGINT NOT NULL,
    proved_cuit NVARCHAR(255) NOT NULL,
    proved_razonSocial NVARCHAR(255) NOT NULL,
    proved_direccion NVARCHAR(255) NOT NULL,
    proved_localidad_id BIGINT NOT NULL
)

CREATE TABLE Provincia(
    provincia_id BIGINT IDENTITY NOT NULL PRIMARY KEY,
    provincia_nombre NVARCHAR(255)
)

CREATE TABLE Contacto(
    contacto_num BIGINT IDENTITY NOT NULL PRIMARY KEY,
    contacto_mail NVARCHAR(255),
    contacto_telefono NVARCHAR(255)
)

create table Factura(
    fact_numero BIGINT NOT NULL PRIMARY KEY,
    fact_sucursal_num BIGINT NOT NULL,
    fact_cliente_num BIGINT NOT NULL,
    fact_fecha DATETIME2(6),
    fact_total DECIMAL(38,2)
)

create table Detalle_Factura(
    detalle_f_factura_num BIGINT not null,
    detalle_f_numero BIGINT IDENTITY not null,
    detalle_f_pedido_numero BIGINT NOT NULL,
    detalle_f_det_pedido BIGINT NOT NULL, 
    primary key(detalle_f_factura_num, detalle_f_numero),
    item_f_precioUnitario DECIMAL(18,2),
    item_f_cantidad DECIMAL(18,0)
)

create table Detalle_Pedido(
    detalle_p_pedido_numero BIGINT NOT NULL, 
    detalle_p_numero BIGINT IDENTITY NOT NULL,
    primary key(detalle_p_pedido_numero, detalle_p_numero),
    detalle_p_sillon_numero BIGINT NOT NULL,
    detalle_p_cantidad BIGINT,
    detalle_p_precio DECIMAL(18,2)
)

create table Sillon(
    sillon_codigo BIGINT primary key,
    sillon_sillon_m_num BIGINT NOT NULL,
    sillon_sillon_medida_num BIGINT NOT NULL,
    sillon_tela_num BIGINT NOT NULL,
    sillon_madera_num BIGINT NOT NULL,
    sillon_relleno_num BIGINT NOT NULL
)

create table Material(
    material_numero BIGINT IDENTITY primary key,
    material_tipo NVARCHAR(255),
    material_nombre NVARCHAR(255),
    material_descripcion NVARCHAR(255),
    material_precio DECIMAL(38,2)
)

create table Tela(
    tela_numero BIGINT IDENTITY primary key,
    tela_color NVARCHAR(255),
    tela_textura NVARCHAR(255)
)

create table Madera(
    madera_numero BIGINT IDENTITY primary key,
    madera_color NVARCHAR(255),
    madera_dureza NVARCHAR(255)
)

create table Relleno(
    relleno_num BIGINT IDENTITY NOT NULL primary key,
    relleno_densidad DECIMAL(38,2)
)

create table Detalle_Compra(
    detalle_comp_numero BIGINT IDENTITY NOT NULL,
    detalle_comp_compra_num BIGINT NOT NULL,
    primary key(detalle_comp_numero, detalle_comp_compra_num),
    detalle_comp_material BIGINT NOT NULL,
    detalle_comp_precioUnitario DECIMAL(18,2),
    detalle_comp_cantidad DECIMAL(18,0)
)

create table Compra(
    compra_numero BIGINT NOT NULL primary key,
    compra_proved_num BIGINT NOT NULL,
    compra_sucursalNum BIGINT NOT NULL,
    compra_fecha DATETIME2(6),
    compra_total DECIMAL(18,2)
)


create table Pedido_Cancelacion(
    pedido_can_numero BIGINT IDENTITY NOT NULL primary key,
    pedido_can_pedido_num BIGINT NOT NULL,
    pedido_can_motivo varchar(255),
    pedido_can_fecha DATETIME2(6)
)

CREATE TABLE Material_Sillon (
    mat_sill_material BIGINT NOT NULL,
    mat_sill_sillon BIGINT NOT NULL,
    PRIMARY KEY (mat_sill_material, mat_sill_sillon)
)

CREATE TABLE Sillon_Medida (
    sillon_med_id BIGINT IDENTITY NOT NULL PRIMARY KEY,
    sillon_med_ancho DECIMAL(18,2) NOT NULL,
    sillon_med_alto DECIMAL(18,2) NOT NULL,
    sillon_med_profundidad DECIMAL(18,2) NOT NULL,
    sillon_med_precio DECIMAL(18,2) NOT NULL
)

CREATE TABLE Sillon_Modelo (
    sillon_mod_codigo BIGINT NOT NULL PRIMARY KEY,
    sillon_modelo NVARCHAR(255) NOT NULL,
    sillon_mod_descripcion NVARCHAR(255),
    silon_mod_precio DECIMAL(18,2)
)

------------------------------------------------------------------------------------------------
ALTER TABLE Cliente
ADD FOREIGN KEY (cliente_contacto_num) REFERENCES Contacto(contacto_num),
    FOREIGN KEY (cliente_localidad_id) REFERENCES Localidad(localidad_num);

ALTER TABLE Localidad
ADD FOREIGN KEY (localidad_provincia) REFERENCES Provincia(provincia_id);

ALTER TABLE Sucursal
ADD FOREIGN KEY (sucursal_contacto_num) REFERENCES Contacto(contacto_num),
    FOREIGN KEY (sucursal_localidad_id) REFERENCES Localidad(localidad_num);

ALTER TABLE Proveedor
ADD FOREIGN KEY (proved_contacto_num) REFERENCES Contacto(contacto_num),
    FOREIGN KEY (proved_localidad_id) REFERENCES Localidad(localidad_num);

ALTER TABLE Pedido
ADD FOREIGN KEY (pedido_cliente_num) REFERENCES Cliente(cliente_numero),
    FOREIGN KEY (pedido_sucursal_num) REFERENCES Sucursal(sucursal_numero),
    FOREIGN KEY (pedido_estado_num) REFERENCES Estado(estado_numero);

ALTER TABLE Pedido_Cancelacion
ADD FOREIGN KEY (pedido_can_pedido_num) REFERENCES Pedido(pedido_numero);

ALTER TABLE Factura
ADD FOREIGN KEY (fact_sucursal_num) REFERENCES Sucursal(sucursal_numero),
    FOREIGN KEY (fact_cliente_num) REFERENCES Cliente(cliente_numero);

ALTER TABLE Detalle_Factura
ADD FOREIGN KEY (detalle_f_factura_num) REFERENCES Factura(fact_numero);

ALTER TABLE Envio
ADD FOREIGN KEY (envio_fact_numero) REFERENCES Factura(fact_numero);

ALTER TABLE Sillon
ADD FOREIGN KEY (sillon_sillon_m_num) REFERENCES Sillon_Modelo(sillon_mod_codigo),
    FOREIGN KEY (sillon_sillon_medida_num) REFERENCES Sillon_Medida(sillon_med_id),
    FOREIGN KEY (sillon_tela_num) REFERENCES Tela(tela_numero),
    FOREIGN KEY (sillon_madera_num) REFERENCES Madera(madera_numero),
    FOREIGN KEY (sillon_relleno_num) REFERENCES Relleno(relleno_num);

ALTER TABLE Material_Sillon
ADD FOREIGN KEY (mat_sill_material) REFERENCES Material(material_numero),
    FOREIGN KEY (mat_sill_sillon) REFERENCES Sillon(sillon_codigo);

ALTER TABLE Detalle_Pedido
ADD FOREIGN KEY (detalle_p_pedido_numero) REFERENCES Pedido(pedido_numero),
    FOREIGN KEY (detalle_p_sillon_numero) REFERENCES Sillon(sillon_codigo);

ALTER TABLE Compra
ADD FOREIGN KEY (compra_proved_num) REFERENCES Proveedor(proved_num),
    FOREIGN KEY (compra_sucursalNum) REFERENCES Sucursal(sucursal_numero);

ALTER TABLE Detalle_Compra
ADD FOREIGN KEY (detalle_comp_compra_num) REFERENCES Compra(compra_numero),
    FOREIGN KEY (detalle_comp_material) REFERENCES Material(material_numero);

ALTER TABLE Detalle_Factura
ADD FOREIGN KEY (detalle_f_pedido_numero, detalle_f_det_pedido)
        REFERENCES Detalle_Pedido(detalle_p_pedido_numero, detalle_p_numero)


PRINT '--- TABLAS CREADAS DE FORMA EXITOSA ---';
GO
/*Procedures*/

-- ESTADO
CREATE PROCEDURE Migracion_Estado
AS 
BEGIN
    INSERT INTO Estado (estado_descripcion)
VALUES 
    ('PENDIENTE'),
    ('CANCELADO'),
    ('ENTREGADO');
END 
GO

-- SILLON MEDIDA
CREATE PROCEDURE Migracion_Sillon_Medida
AS
BEGIN 
    INSERT INTO Sillon_Medida (sillon_med_alto, sillon_med_ancho, sillon_med_profundidad, sillon_med_precio)
    SELECT DISTINCT 
        Sillon_Medida_Alto,
        Sillon_Medida_Ancho,
        Sillon_Medida_Profundidad,
        Sillon_Medida_Precio
    FROM gd_esquema.Maestra
	WHERE Sillon_Medida_Alto IS NOT NULL 
	AND Sillon_Medida_Ancho IS NOT NULL 
	AND Sillon_Medida_Profundidad IS NOT NULL 
	AND Sillon_Medida_Precio IS NOT NULL 
END
GO

-- SILLON MODELO
CREATE PROCEDURE Migracion_Sillon_Modelo
AS 
BEGIN 
INSERT INTO Sillon_Modelo (sillon_mod_codigo,sillon_modelo,sillon_mod_descripcion,silon_mod_precio)
    SELECT DISTINCT 
        Sillon_Modelo_Codigo,
        Sillon_Modelo,
        Sillon_Modelo_Descripcion,
        Sillon_Modelo_Precio
    FROM gd_esquema.Maestra
	WHERE Sillon_Modelo_Codigo IS NOT NULL
	AND Sillon_Modelo IS NOT NULL
	AND Sillon_Modelo_Descripcion IS NOT NULL
	AND Sillon_Modelo_Precio IS NOT NULL
END
GO

-- MATERIAL
CREATE PROCEDURE Migracion_Material
AS
BEGIN
INSERT INTO Material (material_tipo, material_nombre, material_descripcion, material_precio)
    SELECT DISTINCT
        material_tipo,
        material_nombre,
        material_descripcion,
        material_precio
    FROM gd_esquema.Maestra
	WHERE material_tipo IS NOT NULL
	AND material_nombre IS NOT NULL
	AND material_descripcion IS NOT NULL
	AND material_precio IS NOT NULL
END
GO

-- TELA
CREATE PROCEDURE Migracion_Tela
AS
BEGIN
SET IDENTITY_INSERT Tela ON
INSERT INTO Tela (tela_numero, tela_color, tela_textura)
    SELECT DISTINCT
        Material.material_numero,
        Maestra.tela_color,
        Maestra.tela_textura
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Material on Maestra.Material_Tipo = material.material_tipo 
        AND Maestra.Material_Nombre = Material.material_nombre
		AND Maestra.Material_Descripcion = Material.material_descripcion
		AND Maestra.Material_Precio = Material.material_precio
	WHERE Maestra.Material_Tipo = 'Tela' 
END
GO

-- MADERA
CREATE PROCEDURE Migracion_Madera
AS
BEGIN
SET IDENTITY_INSERT Madera ON
INSERT INTO Madera (madera_numero, madera_color, madera_dureza)
    SELECT DISTINCT
        Material.material_numero,
        Maestra.Madera_Color,
        Maestra.Madera_Color
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Material on Maestra.Material_Tipo = material.material_tipo
        AND Maestra.Material_Nombre = Material.material_nombre
		AND Maestra.Material_Descripcion = Material.material_descripcion
		AND Maestra.Material_Precio = Material.material_precio
	WHERE Maestra.Material_Tipo = 'Madera'    
END
GO

-- RELLENO
CREATE PROCEDURE Migracion_Relleno
AS
BEGIN
SET IDENTITY_INSERT Relleno ON
INSERT INTO Relleno (relleno_num, relleno_densidad)
    SELECT DISTINCT
        Material.material_numero,
        Maestra.Relleno_Densidad
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Material on Maestra.Material_Tipo = material.material_tipo
        AND Maestra.Material_Nombre = Material.material_nombre
		AND Maestra.Material_Descripcion = Material.material_descripcion
		AND Maestra.Material_Precio = Material.material_precio
	WHERE Maestra.Material_Tipo = 'Relleno'    
END
GO

-- PROVINCIA
CREATE PROCEDURE Migracion_Provincia 
AS 
BEGIN 
    -- Cliente
    INSERT INTO Provincia (provincia_nombre) 
    SELECT DISTINCT Cliente_Provincia
    FROM gd_esquema.Maestra
    WHERE Cliente_Provincia IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 
        FROM Provincia
        WHERE Provincia.provincia_nombre = Maestra.Cliente_Provincia
    );

    -- Sucursal
    INSERT INTO Provincia (provincia_nombre)  
    SELECT DISTINCT Sucursal_Provincia
    FROM gd_esquema.Maestra
    WHERE Sucursal_Provincia IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 
        FROM Provincia
        WHERE Provincia.provincia_nombre = Maestra.Sucursal_Provincia
    );

    -- Proveedor
    INSERT INTO Provincia (provincia_nombre) 
    SELECT DISTINCT Proveedor_Provincia
    FROM gd_esquema.Maestra
    WHERE Proveedor_Provincia IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 
        FROM Provincia
        WHERE Provincia.provincia_nombre = Maestra.Proveedor_Provincia
    );
END
GO

-- LOCALIDAD
CREATE PROCEDURE Migracion_Localidad
AS 
BEGIN 
    INSERT INTO Localidad (localidad_nombre, localidad_provincia)
    SELECT DISTINCT 
        Maestra.Cliente_Localidad,
        Provincia.provincia_id
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Provincia on Maestra.Cliente_Provincia = Provincia.provincia_nombre
    WHERE Maestra.Cliente_Localidad IS NOT NULL
	AND NOT EXISTS (
        SELECT 1
        FROM Localidad
        WHERE Localidad.localidad_nombre = Maestra.Cliente_Localidad
        and Localidad.localidad_provincia = Provincia.provincia_id
    );
    INSERT INTO Localidad (localidad_nombre, localidad_provincia)
    SELECT DISTINCT 
        Maestra.Sucursal_Localidad,
        Provincia.provincia_id
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Provincia on Maestra.Sucursal_Provincia = Provincia.provincia_nombre
    WHERE Maestra.Sucursal_Localidad IS NOT NULL 
	AND NOT EXISTS (
        SELECT 1
        FROM Localidad
        WHERE Localidad.localidad_nombre = Maestra.Sucursal_Localidad
        and Localidad.localidad_provincia = Provincia.provincia_id
    );
    
    INSERT INTO Localidad (localidad_nombre, localidad_provincia)
    SELECT DISTINCT     
        Maestra.Proveedor_Localidad,
        Provincia.provincia_id
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Provincia on Maestra.Proveedor_Provincia = Provincia.provincia_nombre
    WHERE Maestra.Proveedor_Localidad IS NOT NULL 
	AND NOT EXISTS (
        SELECT 1
        FROM Localidad
        WHERE Localidad.localidad_nombre = Maestra.Proveedor_Localidad
        AND Localidad.localidad_provincia = Provincia.provincia_id
    );
END
GO

-- CONTACTO
CREATE PROCEDURE Migracion_Contacto 
AS 
BEGIN
    INSERT INTO Contacto (contacto_mail, contacto_telefono)
    SELECT DISTINCT 
        Cliente_Mail,
        Cliente_Telefono
    FROM gd_esquema.Maestra
    WHERE NOT EXISTS (
        SELECT 1
        FROM Contacto
        WHERE contacto_telefono = Maestra.Cliente_Telefono
    );

    INSERT INTO Contacto (contacto_mail, contacto_telefono)
    SELECT DISTINCT 
        Sucursal_mail,
        Sucursal_telefono
    FROM gd_esquema.Maestra
    WHERE NOT EXISTS (
        SELECT 1
        FROM Contacto
        WHERE contacto_telefono = Maestra.Sucursal_Telefono
    );

    INSERT INTO Contacto (contacto_mail, contacto_telefono)
    SELECT DISTINCT 
        Proveedor_Mail,
        Proveedor_Telefono
    FROM gd_esquema.Maestra
    WHERE NOT EXISTS (
        SELECT 1
        FROM Contacto
        WHERE contacto_telefono = Maestra.Proveedor_Telefono
    );
END 
GO

-- CLIENTE
CREATE PROCEDURE Migracion_Cliente
AS
BEGIN
    INSERT INTO Cliente (cliente_direccion, cliente_localidad_id, cliente_contacto_num, cliente_dni, cliente_nombre, cliente_apellido, cliente_fechaNacimiento)
    SELECT DISTINCT
        Maestra.Cliente_Direccion,
        Localidad.localidad_num,
        Contacto.contacto_num,
        Maestra.Cliente_dni,
        Maestra.Cliente_nombre,
        Maestra.Cliente_apellido,
        Maestra.Cliente_fechaNacimiento
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Localidad ON Maestra.Cliente_Localidad = Localidad.localidad_nombre
    LEFT JOIN Contacto ON Maestra.Cliente_Telefono = Contacto.contacto_telefono
        AND Maestra.Cliente_Mail = Contacto.contacto_mail
    WHERE Maestra.Cliente_Dni IS NOT NULL 
        AND Maestra.Cliente_Nombre IS NOT NULL
        AND Maestra.Cliente_Apellido IS NOT NULL 
        AND Maestra.Cliente_FechaNacimiento IS NOT NULL
        AND Maestra.Cliente_Localidad IS NOT NULL
END
GO



-- SUCURSAL ???????????????????????????
CREATE PROCEDURE Migracion_Sucursal
AS
BEGIN
    INSERT INTO Sucursal (sucursal_numero, sucursal_direccion_num, sucursal_contacto_num)
    SELECT DISTINCT
        Maestra.Sucursal_NroSucursal, 
		Direccion.dire_numero
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Direccion ON Maestra.Sucursal_Direccion = Direccion.dire_direccion
    LEFT JOIN Localidad ON Maestra.Sucursal_Localidad = Localidad.localidad_nombre
	LEFT JOIN Provincia ON Localidad.localidad_provincia = Provincia.provincia_id
        AND Maestra.Sucursal_Provincia = Provincia.provincia_nombre
    WHERE Maestra.Sucursal_NroSucursal IS NOT NULL
    AND Direccion.dire_direccion IS NOT NULL
    AND Localidad.localidad_num IS NOT NULL
	AND Provincia.provincia_id IS NOT NULL
END
GO

	SELECT DISTINCT
		Maestra.Sucursal_NroSucursal, 
		Localidad.localidad_num, 
		Maestra.Sucursal_Direccion, 
		Maestra.Sucursal_telefono, 
		Maestra.Sucursal_mail
	FROM gd_esquema.Maestra AS Maestra
	LEFT JOIN Localidad ON Maestra.Sucursal_Localidad = Localidad.localidad_nombre
	LEFT JOIN Provincia ON Localidad.localidad_provincia = Provincia.provincia_id
		AND Maestra.Sucursal_Provincia = Provincia.provincia_nombre
	WHERE Sucursal_NroSucursal IS NOT NULL
	AND Localidad.localidad_num IS NOT NULL
	AND Provincia.provincia_id IS NOT NULL

select distinct Sucursal_NroSucursal, Sucursal_Provincia, Sucursal_Direccion, Sucursal_telefono, Sucursal_mail, Sucursal_Provincia from gd_esquema.Maestra
 SELECT DISTINCT
        Maestra.Sucursal_NroSucursal, 
        Direccion.dire_direccion,
        Direccion.direccion_localidad_num,
        Localidad.localidad_nombre,
        Localidad.localidad_provincia,
        Provincia.provincia_nombre
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Direccion ON Maestra.Sucursal_Direccion = Direccion.dire_direccion
    LEFT JOIN Contacto ON Maestra.Sucursal_telefono = Contacto.contacto_telefono 
    LEFT JOIN Provincia ON Maestra.Sucursal_Provincia = Provincia.provincia_nombre
    LEFT JOIN Localidad ON Maestra.Sucursal_Localidad = Localidad.localidad_nombre
        AND Maestra.Sucursal_mail = Contacto.contacto_mail
    WHERE Maestra.Sucursal_NroSucursal IS NOT NULL
    AND Direccion.dire_direccion IS NOT NULL
    AND Contacto.contacto_mail IS NOT NULL AND Contacto.contacto_telefono IS NOT NULL AND Maestra.Sucursal_NroSucursal = 202


-- FACTURA
CREATE PROCEDURE Migracion_Factura
AS
BEGIN
--SET IDENTITY_INSERT Cliente ON
    INSERT INTO Factura (fact_numero, fact_sucursal_num, fact_cliente_num, fact_fecha, fact_total)
    SELECT DISTINCT
    Maestra.factura_numero,
    Sucursal.sucursal_numero,
    Cliente.cliente_numero,
    Maestra.factura_fecha,
    Maestra.factura_total
    FROM gd_esquema.Maestra
    LEFT JOIN Cliente on Cliente.cliente_nombre = Maestra.Cliente_Nombre
        AND Cliente.cliente_apellido = Maestra.Cliente_Apellido
        AND Cliente.cliente_dni = Maestra.Cliente_Dni
        AND Cliente.cliente_fechaNacimiento = Maestra.Cliente_FechaNacimiento
    LEFT JOIN Sucursal on Sucursal.sucursal_numero = Maestra.Sucursal_NroSucursal
END
GO

-- ENVIO
CREATE PROCEDURE Migracion_Envio
AS
BEGIN
    INSERT INTO Envio (envio_numero, envio_fact_numero, envio_fecha, envio_fecha_programada, envio_importeTraslado, envio_importeSubida)
    SELECT DISTINCT
        Maestra.envio_numero,
        Factura.fact_numero,
        Maestra.envio_fecha,
        Maestra.envio_fecha_programada,
        Maestra.envio_importeTraslado,
        Maestra.envio_importeSubida
        FROM gd_esquema.Maestra
        LEFT JOIN Factura on Factura.fact_numero = Maestra.Factura_Numero
END 
GO

-- SILLON
CREATE PROCEDURE Migracion_Sillon
AS
BEGIN 
    INSERT INTO Sillon (sillon_codigo, sillon_madera_num, sillon_relleno_num,
     sillon_tela_num, sillon_sillon_m_num, sillon_sillon_medida_num)
    SELECT DISTINCT 
    Sillon_Codigo,
    Madera.madera_numero,
    Relleno.relleno_num,
    Tela.tela_numero,
    Maestra.Sillon_Modelo_Codigo,
    Sillon_Medida.sillon_med_id
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Madera ON Madera.madera_color = Maestra.Madera_Color AND Madera.madera_dureza = Maestra.Madera_Dureza
    LEFT JOIN Relleno ON Relleno.relleno_densidad = Maestra.Relleno_Densidad
    LEFT JOIN Tela ON Tela.tela_color = Maestra.Tela_Color AND Tela.tela_textura = Maestra.Tela_Textura
    LEFT JOIN Sillon_Medida ON Sillon_Medida.sillon_med_alto = Maestra.Sillon_Medida_Alto 
        AND Sillon_Medida.sillon_med_ancho = Maestra.Sillon_Medida_Ancho 
        AND Sillon_Medida.sillon_med_precio = Maestra.Sillon_Medida_Precio
        AND Sillon_Medida.sillon_med_profundidad = Maestra.Sillon_Medida_Profundidad
END
GO

-- MATERIAL SILLON
CREATE PROCEDURE Migracion_Material_Sillon
AS 
BEGIN
    INSERT INTO Material_Sillon (mat_sill_material, mat_sill_sillon)
    SELECT DISTINCT 
    	Material.material_numero,
		Sillon.sillon_codigo 
    FROM gd_esquema.Maestra AS Maestra 
    LEFT JOIN Material ON Maestra.Material_Tipo = Material.material_tipo
        AND Maestra.Material_Nombre = Material.material_nombre
        AND Maestra.Material_Precio = Material.material_precio
        AND Maestra.Material_Descripcion = Material.material_descripcion
    LEFT JOIN Sillon ON Maestra.Sillon_Codigo = Sillon.sillon_codigo
END 
GO

-- PROVEEDOR
CREATE PROCEDURE Migracion_Proveedor
AS 
BEGIN
    INSERT INTO Proveedor (proved_cuit, proved_razonSocial, proved_dire_num, proved_contacto_num)
    SELECT DISTINCT 
    Maestra.Proveedor_Cuit,
    Maestra.Proveedor_RazonSocial,
    Direccion.dire_numero,
    Contacto.contacto_num
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Direccion ON Maestra.Proveedor_Direccion = Direccion.dire_direccion
    LEFT JOIN Contacto ON Maestra.Proveedor_Mail = Contacto.contacto_mail 
        AND Maestra.Proveedor_Telefono = Contacto.contacto_telefono
END 
GO

-- COMPRA
CREATE PROCEDURE Migracion_Compra 
AS
BEGIN
    INSERT INTO Compra (compra_numero, compra_fecha, compra_proved_num, compra_sucursalNum, compra_total)
    SELECT DISTINCT 
    Maestra.Compra_Numero,
    Maestra.Compra_Fecha,
    Proveedor.proved_num,
    Maestra.Sucursal_NroSucursal,
    Maestra.Compra_Total
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Proveedor ON Maestra.Proveedor_Cuit = Proveedor.proved_cuit
        AND Maestra.Proveedor_RazonSocial = Proveedor.proved_razonSocial
END
GO

-- MIGRACION PEDIDO
CREATE PROCEDURE Migracion_Pedido
AS
BEGIN
    INSERT INTO Pedido (pedido_numero, pedido_cliente_num, pedido_estado_num, pedido_sucursal_num) 
    SELECT DISTINCT 
    Maestra.Pedido_Numero,
    Cliente.cliente_numero,
    Estado.estado_numero,
    Sucursal.sucursal_numero
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Estado ON Maestra.Pedido_Estado = Estado.estado_descripcion
    LEFT JOIN Cliente ON Maestra.Cliente_Apellido = Cliente.cliente_apellido 
        AND Maestra.Cliente_Dni = Cliente.cliente_dni
        AND Maestra.Cliente_Nombre = Cliente.cliente_nombre
        AND Maestra.Cliente_FechaNacimiento = Cliente.cliente_fechaNacimiento
    LEFT JOIN Sucursal ON Maestra.Sucursal_NroSucursal = Sucursal.sucursal_numero
END
GO

-- Pedido cancelacion
CREATE PROCEDURE Migracion_Pedido_Cancelacion
AS
BEGIN
    INSERT INTO Pedido_Cancelacion (pedido_can_pedido_num, pedido_can_motivo, pedido_can_fecha)
    SELECT DISTINCT
    Pedido.pedido_numero,
    Maestra.Pedido_Cancelacion_Motivo,
    Maestra.Pedido_Cancelacion_Fecha
    FROM gd_esquema.Maestra
    LEFT JOIN Pedido on pedido.pedido_numero = Maestra.Pedido_numero
END
GO

-- DETALLE COMPRA
CREATE PROCEDURE Migracion_Detalle_Compra
AS
BEGIN
    INSERT INTO Detalle_Compra (detalle_comp_compra_num, detalle_comp_material, 
        detalle_comp_precioUnitario, detalle_comp_cantidad)
    SELECT DISTINCT
    Maestra.Compra_Numero,
    Material.material_numero,
	Maestra.Detalle_Compra_Precio,
	Maestra.Detalle_Compra_Cantidad
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Material ON Maestra.Material_tipo = Material.material_tipo
        AND Maestra.Material_Nombre = Material.material_nombre
        AND Maestra.Material_Descripcion = Material.material_descripcion
        AND Maestra.Material_Precio = Material.material_precio
END 
GO

-- DETALLE PEDIDO
CREATE PROCEDURE Migracion_Detalle_Pedido
AS
BEGIN
    INSERT INTO Detalle_Pedido (detalle_p_sillon_numero, detalle_p_pedido_numero, 
    detalle_p_cantidad, detalle_p_precio)
    SELECT DISTINCT 
    Sillon.sillon_codigo,
    Pedido.pedido_numero,
    Maestra.Detalle_Pedido_Cantidad,
    Maestra.Detalle_Pedido_Precio
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Sillon ON Maestra.Sillon_Codigo = Sillon.sillon_codigo
    LEFT JOIN Pedido ON Maestra.Pedido_Numero = Pedido.pedido_numero
END
GO


-- DETALLE FACTURA ---------------------------------------DUDASSSSSSSSSSSSSSSSSSS_____________________________
CREATE PROCEDURE Migracion_Detalle_Factura
AS
SET IDENTITY_INSERT Detalle_Factura ON
BEGIN
    INSERT INTO Detalle_Factura (detalle_f_numero,detalle_f_factura_num,item_f_precioUnitario, 
        item_f_cantidad, detalle_f_det_pedido)
    SELECT DISTINCT
    Factura.fact_numero,
    Maestra.detalle_factura_precio,
    Maestra.detalle_factura_cantidad,
    Detalle_Pedido.detalle_p_pedido_numero,
    Detalle_Pedido.detalle_p_numero
    FROM gd_esquema.Maestra
    LEFT JOIN Factura ON Maestra.Factura_Numero = Factura.fact_numero
    JOIN Pedido ON Maestra.Pedido_Numero = Pedido.pedido_numero
	JOIN Detalle_Pedido ON pedido.pedido_numero = detalle_pedido.detalle_p_numero
END 
GO
/*
-- Detalle_Factura
CREATE PROCEDURE Migracion_Detalle_Factura
AS
BEGIN
    INSERT INTO Detalle_Factura (detalle_f_factura_num, item_f_precioUnitario, item_f_cantidad, detalle_f_det_pedido)
    SELECT DISTINCT
        f.fact_numero,
        m.Detalle_Factura_Precio,
        m.Detalle_Factura_Cantidad,
        dp.detalle_p_numero
    FROM gd_esquema.Maestra m
    INNER JOIN Factura f ON m.Factura_Numero = f.fact_numero
    INNER JOIN Pedido p ON m.Pedido_Numero = p.pedido_numero
    INNER JOIN Detalle_Pedido dp ON p.pedido_numero = dp.detalle_p_pedido_numero
        AND m.Detalle_Pedido_Cantidad = dp.detalle_p_cantidad
        AND m.Detalle_Pedido_Precio = dp.detalle_p_precio
    WHERE m.Factura_Numero IS NOT NULL 
        AND m.Detalle_Factura_Precio IS NOT NULL
END
GO
*/
/*EXECUTES*/
execute Migracion_Estado; -- anda
execute Migracion_Sillon_Medida; -- anda
execute Migracion_Sillon_Modelo; -- anda
execute Migracion_Material;-- anda
execute Migracion_Tela; -- anda
execute Migracion_Madera; -- anda
execute Migracion_Relleno; -- anda
execute Migracion_Provincia; -- anda
execute Migracion_Localidad; -- anda
execute Migracion_Direccion; -- anda
execute Migracion_Contacto; -- ?
execute Migracion_Cliente;
execute Migracion_Sucursal;
execute Migracion_Factura; -- *
execute Migracion_Envio; -- *
execute Migracion_Sillon; -- ?
execute Migracion_Material_Sillon; -- ?
execute Migracion_Proveedor; -- ?
execute Migracion_Compra; -- ?
execute Migracion_Pedido; -- ?
execute Migracion_Pedido_Cancelacion; -- *
execute Migracion_Detalle_Compra; -- +
execute Migracion_Detalle_Pedido;
execute Migracion_Detalle_Factura; -- *


select distinct sillon_modelo_codigo, Sillon_Modelo, Sillon_Modelo_Descripcion, Sillon_Modelo_Descripcion , sillon_modelo_precio from gd_esquema.Maestra
select * from Sillon_modelo

select * from provincia

select * from estado

select localidad_num, localidad_nombre from localidad

select * from gd_esquema.Maestra
where Sucursal_Direccion = 'Avenida Mart�n Garc�a N� 5644'
or Cliente_direccion = 'Avenida Mart�n Garc�a N� 5644'
or proveedor_direccion = 'Avenida Mart�n Garc�a N� 5644'

select * from localidad
order by localidad_nombre

where direccion_localidad_num is null

select dire_direccion, direccion_localidad_num from direccion
group by dire_direccion, direccion_localidad_num

select distinct localidad_nombre from localidad
group by localidad_nombre

select cliente_localidad, cliente_provincia from gd_esquema.Maestra
where cliente_localidad is not null
and cliente_provincia is not null
union
select sucursal_localidad, sucursal_provincia from gd_esquema.Maestra
where sucursal_localidad is not null
and sucursal_provincia is not null
union
select proveedor_localidad, proveedor_provincia from gd_esquema.Maestra
where proveedor_localidad is not null
and proveedor_provincia is not null


select cliente_direccion, cliente_localidad from gd_esquema.Maestra
where cliente_direccion is not null

union all

select sucursal_direccion, Sucursal_Localidad from gd_esquema.Maestra
where sucursal_direccion is not null

union all

select proveedor_direccion, Proveedor_Localidad from gd_esquema.Maestra
where proveedor_direccion is not null


SELECT DISTINCT 
    dir.direccion AS dire_direccion, 
    l.localidad_num AS direccion_localidad_num
FROM (
    SELECT cliente_direccion AS direccion, cliente_localidad AS localidad
    FROM gd_esquema.Maestra
    WHERE cliente_direccion IS NOT NULL AND cliente_localidad IS NOT NULL

    UNION

    SELECT sucursal_direccion, sucursal_localidad
    FROM gd_esquema.Maestra
    WHERE sucursal_direccion IS NOT NULL AND sucursal_localidad IS NOT NULL

    UNION

    SELECT proveedor_direccion, proveedor_localidad
    FROM gd_esquema.Maestra
    WHERE proveedor_direccion IS NOT NULL AND proveedor_localidad IS NOT NULL
) AS dir
JOIN Localidad l ON dir.localidad = l.localidad_nombre;



select * from Contacto where contacto_telefono is not null and contacto_mail is not null

select distinct dir.direccion, dir.localidad from (
    SELECT Cliente_Mail AS direccion, Cliente_Telefono AS localidad
    FROM gd_esquema.Maestra
    WHERE Cliente_Mail IS NOT NULL AND Cliente_Telefono IS NOT NULL

    UNION

    SELECT Sucursal_mail, Sucursal_telefono
    FROM gd_esquema.Maestra
    WHERE sucursal_direccion IS NOT NULL AND sucursal_localidad IS NOT NULL

    UNION

    SELECT Proveedor_Mail, Proveedor_Telefono
    FROM gd_esquema.Maestra
    WHERE proveedor_direccion IS NOT NULL AND proveedor_localidad IS NOT NULL
) As dir

SELECT COUNT(*) 
FROM (
    SELECT DISTINCT 
        Maestra.Cliente_dni, 
        Maestra.Cliente_nombre, 
        Maestra.Cliente_apellido, 
        Maestra.Cliente_fechaNacimiento, 
        Maestra.Cliente_Direccion, 
        Maestra.Cliente_Telefono, 
        Maestra.Cliente_Mail
    FROM gd_esquema.Maestra AS Maestra
) AS distintos_clientes;

SELECT COUNT(*) FROM Cliente;

select Sucursal_NroSucursal, Sucursal_Direccion, Sucursal_Provincia, Sucursal_mail, Sucursal_telefono from gd_esquema.Maestra
group by Sucursal_NroSucursal, Sucursal_Direccion, Sucursal_Provincia, Sucursal_mail, Sucursal_telefono






