USE [GD1C2025]
GO


DECLARE @DropConstraints NVARCHAR(max) = ''
SELECT @DropConstraints += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.'

                        +  QUOTENAME(OBJECT_NAME(parent_object_id)) + ' ' + 'DROP CONSTRAINT' + QUOTENAME(name)
FROM sys.foreign_keys
EXECUTE sp_executesql @DropConstraints;
GO


DECLARE @DropProcedures NVARCHAR(max) = ''
SELECT @DropProcedures += 'DROP PROCEDURE ' + QUOTENAME(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME(name) + ';'
FROM sys.procedures;
EXECUTE sp_executesql @DropProcedures;
GO

DECLARE @DropTables NVARCHAR(max) = ''
SELECT @DropTables += 'DROP TABLE BNFL. ' + QUOTENAME(TABLE_NAME)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'BNFL' and TABLE_TYPE = 'BASE TABLE'
EXECUTE sp_executesql @DropTables;
GO

IF EXISTS (SELECT name FROM sys.schemas WHERE name = 'BNFL')
    DROP SCHEMA BNFL
GO

CREATE SCHEMA BNFL;
GO

CREATE TABLE [BNFL].[Cliente] (
    cliente_numero BIGINT IDENTITY NOT NULL PRIMARY KEY,
    cliente_contacto_num BIGINT NOT NULL,
    cliente_dni BIGINT,
    cliente_nombre NVARCHAR(255),
    cliente_apellido NVARCHAR(255),
    cliente_fechaNacimiento DATETIME2(6),
    cliente_direccion NVARCHAR(255),
    cliente_localidad_id BIGINT NOT NULL
)
CREATE TABLE [BNFL].[Pedido] (
    pedido_id BIGINT IDENTITY NOT NULL PRIMARY KEY,
    pedido_numero BIGINT NOT NULL,
    pedido_cliente_num BIGINT NOT NULL,
    pedido_sucursal_id BIGINT NOT NULL, 
    pedido_estado_num BIGINT NOT NULL
)

CREATE TABLE [BNFL].[Estado] (
    estado_numero BIGINT IDENTITY NOT NULL PRIMARY KEY,
    estado_descripcion NVARCHAR(255)
)

CREATE TABLE [BNFL].[Envio] (
    envio_id BIGINT IDENTITY NOT NULL PRIMARY KEY,
    envio_numero BIGINT NOT NULL,
    envio_fact_id BIGINT NOT NULL,
    envio_fecha DATETIME2(6),
    envio_fecha_programada DATETIME2(6),
    envio_importeTraslado DECIMAL(18,2),
    Envio_importeSubida DECIMAL(18,2)
)

CREATE TABLE [BNFL].[Sucursal] (
    sucursal_id BIGINT IDENTITY NOT NULL PRIMARY KEY,
    sucursal_numero BIGINT NOT NULL,
    sucursal_contacto_num BIGINT NOT NULL,
    sucursal_direccion NVARCHAR(255) NOT NULL,
    sucursal_localidad_id BIGINT NOT NULL
)

CREATE TABLE [BNFL].[Localidad] (
    localidad_num BIGINT IDENTITY NOT NULL PRIMARY KEY,
    localidad_provincia BIGINT NOT NULL,
    localidad_nombre NVARCHAR(255)
)

CREATE TABLE [BNFL].[Proveedor] (
    proved_num BIGINT IDENTITY NOT NULL PRIMARY KEY,
    proved_contacto_num BIGINT NOT NULL,
    proved_cuit NVARCHAR(255) NOT NULL,
    proved_razonSocial NVARCHAR(255) NOT NULL,
    proved_direccion NVARCHAR(255) NOT NULL,
    proved_localidad_id BIGINT NOT NULL
)

CREATE TABLE [BNFL].[Provincia] (
    provincia_id BIGINT IDENTITY NOT NULL PRIMARY KEY,
    provincia_nombre NVARCHAR(255)
)

CREATE TABLE [BNFL].[Contacto] (
    contacto_num BIGINT IDENTITY NOT NULL PRIMARY KEY,
    contacto_mail NVARCHAR(255),
    contacto_telefono NVARCHAR(255)
)

CREATE TABLE [BNFL].[Factura] (
    fact_id BIGINT IDENTITY NOT NULL PRIMARY KEY,
    fact_numero BIGINT NOT NULL,
    fact_sucursal_id BIGINT NOT NULL,
    fact_cliente_num BIGINT NOT NULL,
    fact_fecha DATETIME2(6),
    fact_total DECIMAL(38,2)
)

CREATE TABLE [BNFL].[Detalle_Factura] (
    detalle_f_factura_id BIGINT not null,
    detalle_f_numero BIGINT not null,
    detalle_f_pedido_numero BIGINT NOT NULL,
    detalle_f_det_pedido BIGINT NOT NULL, 
    primary key(detalle_f_factura_id, detalle_f_numero),
    item_f_precioUnitario DECIMAL(18,2),
    item_f_cantidad DECIMAL(18,0)
)

CREATE TABLE [BNFL].[Detalle_Pedido] (
    detalle_p_pedido_id BIGINT NOT NULL, 
    detalle_p_numero BIGINT NOT NULL,
    primary key(detalle_p_pedido_id, detalle_p_numero),
    detalle_p_sillon_numero BIGINT NOT NULL,
    detalle_p_cantidad BIGINT,
    detalle_p_precio DECIMAL(18,2)
)

CREATE TABLE [BNFL].[Sillon] (
    sillon_codigo BIGINT primary key,
    sillon_sillon_m_num BIGINT NOT NULL,
    sillon_sillon_medida_num BIGINT NOT NULL
)

CREATE TABLE [BNFL].[Material] (
    material_numero BIGINT IDENTITY primary key,
    material_tipo NVARCHAR(255),
    material_nombre NVARCHAR(255),
    material_descripcion NVARCHAR(255),
    material_precio DECIMAL(38,2)
)

CREATE TABLE [BNFL].[Tela] (
    tela_numero BIGINT IDENTITY primary key,
    tela_color NVARCHAR(255),
    tela_textura NVARCHAR(255)
)

CREATE TABLE [BNFL].[Madera] (
    madera_numero BIGINT IDENTITY primary key,
    madera_color NVARCHAR(255),
    madera_dureza NVARCHAR(255)
)

CREATE TABLE [BNFL].[Relleno] (
    relleno_num BIGINT IDENTITY NOT NULL primary key,
    relleno_densidad DECIMAL(38,2)
)

CREATE TABLE [BNFL].[Detalle_Compra] (
    detalle_comp_numero BIGINT NOT NULL,
    detalle_comp_compra_num BIGINT NOT NULL,
    primary key(detalle_comp_numero, detalle_comp_compra_num),
    detalle_comp_material BIGINT NOT NULL,
    detalle_comp_precioUnitario DECIMAL(18,2),
    detalle_comp_cantidad DECIMAL(18,0)
)

CREATE TABLE [BNFL].[Compra] (
    compra_id BIGINT IDENTITY NOT NULL PRIMARY KEY,
    compra_numero BIGINT NOT NULL,
    compra_proved_num BIGINT NOT NULL,
    compra_sucursal_id BIGINT NOT NULL,
    compra_fecha DATETIME2(6),
    compra_total DECIMAL(18,2)
)

CREATE TABLE [BNFL].[Pedido_Cancelacion] (
    pedido_can_numero BIGINT IDENTITY NOT NULL primary key,
    pedido_can_pedido_id BIGINT NOT NULL,
    pedido_can_motivo varchar(255),
    pedido_can_fecha DATETIME2(6)
)

CREATE TABLE [BNFL].[Material_Sillon] (
    mat_sill_material BIGINT NOT NULL,
    mat_sill_sillon BIGINT NOT NULL,
    PRIMARY KEY (mat_sill_material, mat_sill_sillon)
)

CREATE TABLE [BNFL].[Sillon_Medida] (
    sillon_med_id BIGINT IDENTITY NOT NULL PRIMARY KEY,
    sillon_med_ancho DECIMAL(18,2) NOT NULL,
    sillon_med_alto DECIMAL(18,2) NOT NULL,
    sillon_med_profundidad DECIMAL(18,2) NOT NULL,
    sillon_med_precio DECIMAL(18,2) NOT NULL
)

CREATE TABLE [BNFL].[Sillon_Modelo] (
    sillon_mod_codigo BIGINT NOT NULL PRIMARY KEY,
    sillon_modelo NVARCHAR(255) NOT NULL,
    sillon_mod_descripcion NVARCHAR(255),
    silon_mod_precio DECIMAL(18,2)
)

------------------------------------------------------------------------------------------------
ALTER TABLE [BNFL].[Cliente]
ADD FOREIGN KEY ([cliente_contacto_num]) REFERENCES [BNFL].[Contacto]([contacto_num]),
    FOREIGN KEY ([cliente_localidad_id]) REFERENCES [BNFL].[Localidad]([localidad_num]);

ALTER TABLE [BNFL].[Localidad]
ADD FOREIGN KEY ([localidad_provincia]) REFERENCES [BNFL].[Provincia]([provincia_id]);

ALTER TABLE [BNFL].[Sucursal]
ADD FOREIGN KEY ([sucursal_contacto_num]) REFERENCES [BNFL].[Contacto]([contacto_num]),
    FOREIGN KEY ([sucursal_localidad_id]) REFERENCES [BNFL].[Localidad]([localidad_num]);

ALTER TABLE [BNFL].[Proveedor]
ADD FOREIGN KEY ([proved_contacto_num]) REFERENCES [BNFL].[Contacto]([contacto_num]),
    FOREIGN KEY ([proved_localidad_id]) REFERENCES [BNFL].[Localidad]([localidad_num]);

ALTER TABLE [BNFL].[Pedido]
ADD FOREIGN KEY ([pedido_cliente_num]) REFERENCES [BNFL].[Cliente]([cliente_numero]),
    FOREIGN KEY ([pedido_sucursal_id]) REFERENCES [BNFL].[Sucursal]([sucursal_id]),
    FOREIGN KEY ([pedido_estado_num]) REFERENCES [BNFL].[Estado]([estado_numero]);

ALTER TABLE [BNFL].[Pedido_Cancelacion]
ADD FOREIGN KEY ([pedido_can_pedido_id]) REFERENCES [BNFL].[Pedido]([pedido_id]);

ALTER TABLE [BNFL].[Factura]
ADD FOREIGN KEY ([fact_sucursal_id]) REFERENCES [BNFL].[Sucursal]([sucursal_id]),
    FOREIGN KEY ([fact_cliente_num]) REFERENCES [BNFL].[Cliente]([cliente_numero]);

ALTER TABLE [BNFL].[Envio]
ADD FOREIGN KEY ([envio_fact_id]) REFERENCES [BNFL].[Factura]([fact_id]);

ALTER TABLE [BNFL].[Sillon]
ADD FOREIGN KEY ([sillon_sillon_m_num]) REFERENCES [BNFL].[Sillon_Modelo]([sillon_mod_codigo]),
    FOREIGN KEY ([sillon_sillon_medida_num]) REFERENCES [BNFL].[Sillon_Medida]([sillon_med_id]);

ALTER TABLE [BNFL].[Material_Sillon]
ADD FOREIGN KEY ([mat_sill_material]) REFERENCES [BNFL].[Material]([material_numero]),
    FOREIGN KEY ([mat_sill_sillon]) REFERENCES [BNFL].[Sillon]([sillon_codigo]);

ALTER TABLE [BNFL].[Detalle_Pedido]
ADD FOREIGN KEY ([detalle_p_pedido_id]) REFERENCES [BNFL].[Pedido]([pedido_id]),
    FOREIGN KEY ([detalle_p_sillon_numero]) REFERENCES [BNFL].[Sillon]([sillon_codigo]);

ALTER TABLE [BNFL].[Compra]
ADD FOREIGN KEY ([compra_proved_num]) REFERENCES [BNFL].[Proveedor]([proved_num]),
    FOREIGN KEY ([compra_sucursal_id]) REFERENCES [BNFL].[Sucursal]([sucursal_id]);

ALTER TABLE [BNFL].[Detalle_Compra]
ADD FOREIGN KEY ([detalle_comp_compra_num]) REFERENCES [BNFL].[Compra]([compra_id]),
    FOREIGN KEY ([detalle_comp_material]) REFERENCES [BNFL].[Material]([material_numero]);

ALTER TABLE [BNFL].[Detalle_Factura]
ADD FOREIGN KEY ([detalle_f_factura_id]) REFERENCES [BNFL].[Factura]([fact_id]);

ALTER TABLE [BNFL].[Detalle_Factura]
ADD FOREIGN KEY ([detalle_f_pedido_numero], [detalle_f_det_pedido])
        REFERENCES [BNFL].[Detalle_Pedido]([detalle_p_pedido_id], [detalle_p_numero])
GO

/*Procedures*/
-- ESTADO
CREATE PROCEDURE [BNFL].Migracion_Estado
AS 
BEGIN
    INSERT INTO [BNFL].[Estado] (estado_descripcion) 
    SELECT DISTINCT 
        Maestra.Pedido_Estado
    FROM gd_esquema.Maestra AS Maestra
    WHERE Pedido_Estado IS NOT NULL
    UNION 
    SELECT 'PENDIENTE'
END 
GO

-- SILLON MEDIDA
CREATE PROCEDURE [BNFL].Migracion_Sillon_Medida
AS
BEGIN 
    INSERT INTO [BNFL].[Sillon_Medida] (sillon_med_alto, sillon_med_ancho, sillon_med_profundidad, sillon_med_precio)
    SELECT DISTINCT 
        Maestra.Sillon_Medida_Alto,
        Maestra.Sillon_Medida_Ancho,
        Maestra.Sillon_Medida_Profundidad,
        Maestra.Sillon_Medida_Precio
    FROM gd_esquema.Maestra AS Maestra
	WHERE Maestra.Sillon_Medida_Alto IS NOT NULL 
	AND Maestra.Sillon_Medida_Ancho IS NOT NULL 
	AND Maestra.Sillon_Medida_Profundidad IS NOT NULL 
	AND Maestra.Sillon_Medida_Precio IS NOT NULL 
END
GO

-- SILLON MODELO
CREATE PROCEDURE [BNFL].Migracion_Sillon_Modelo
AS 
BEGIN 
INSERT INTO [BNFL].[Sillon_Modelo] (sillon_mod_codigo,sillon_modelo,sillon_mod_descripcion,silon_mod_precio)
    SELECT DISTINCT 
        Maestra.Sillon_Modelo_Codigo,
        Maestra.Sillon_Modelo,
        Maestra.Sillon_Modelo_Descripcion,
        Maestra.Sillon_Modelo_Precio
    FROM gd_esquema.Maestra AS Maestra
	WHERE Maestra.Sillon_Modelo_Codigo IS NOT NULL
	AND Maestra.Sillon_Modelo IS NOT NULL
	AND Maestra.Sillon_Modelo_Descripcion IS NOT NULL
	AND Maestra.Sillon_Modelo_Precio IS NOT NULL
END
GO

-- MATERIAL
CREATE PROCEDURE [BNFL].Migracion_Material
AS
BEGIN
INSERT INTO [BNFL].[Material] (material_tipo, material_nombre, material_descripcion, material_precio)
    SELECT DISTINCT
        Maestra.Material_Tipo,
        Maestra.Material_Nombre,
        Maestra.Material_Descripcion,
        Maestra.Material_Precio
    FROM gd_esquema.Maestra AS Maestra
	WHERE Maestra.material_tipo IS NOT NULL
	AND Maestra.material_nombre IS NOT NULL
	AND Maestra.material_descripcion IS NOT NULL
	AND Maestra.material_precio IS NOT NULL
END
GO

-- TELA
CREATE PROCEDURE [BNFL].Migracion_Tela
AS
BEGIN
SET IDENTITY_INSERT [BNFL].Tela ON
INSERT INTO [BNFL].[Tela] (tela_numero, tela_color, tela_textura)
    SELECT DISTINCT
        Material.material_numero,
        Maestra.tela_color,
        Maestra.tela_textura
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN [BNFL].[Material] AS Material on Maestra.Material_Tipo = material.material_tipo 
        AND Maestra.Material_Nombre = Material.material_nombre
		AND Maestra.Material_Descripcion = Material.material_descripcion
		AND Maestra.Material_Precio = Material.material_precio
	WHERE Maestra.Material_Tipo = 'Tela' 
END
GO

-- MADERA
CREATE PROCEDURE [BNFL].Migracion_Madera
AS
BEGIN
SET IDENTITY_INSERT [BNFL].Madera ON
INSERT INTO [BNFL].[Madera] (madera_numero, madera_color, madera_dureza)
    SELECT DISTINCT
        Material.material_numero,
        Maestra.Madera_Color,
        Maestra.Madera_Dureza
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN [BNFL].[Material] AS Material on Maestra.Material_Tipo = material.material_tipo
        AND Maestra.Material_Nombre = Material.material_nombre
		AND Maestra.Material_Descripcion = Material.material_descripcion
		AND Maestra.Material_Precio = Material.material_precio
	WHERE Maestra.Material_Tipo = 'Madera'    
END
GO

-- RELLENO
CREATE PROCEDURE [BNFL].Migracion_Relleno
AS
BEGIN
SET IDENTITY_INSERT [BNFL].Relleno ON
INSERT INTO [BNFL].[Relleno] (relleno_num, relleno_densidad)
    SELECT DISTINCT
        Material.material_numero,
        Maestra.Relleno_Densidad
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN [BNFL].[Material] AS Material on Maestra.Material_Tipo = material.material_tipo
        AND Maestra.Material_Nombre = Material.material_nombre
		AND Maestra.Material_Descripcion = Material.material_descripcion
		AND Maestra.Material_Precio = Material.material_precio
	WHERE Maestra.Material_Tipo = 'Relleno'    
END
GO
-- PROVINCIA
CREATE PROCEDURE [BNFL].Migracion_Provincia 
AS 
BEGIN 
    -- Cliente
    INSERT INTO [BNFL].[Provincia] (provincia_nombre) 
    SELECT DISTINCT Cliente_Provincia
    FROM gd_esquema.Maestra
    WHERE Cliente_Provincia IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 
        FROM Provincia
        WHERE Provincia.provincia_nombre = Maestra.Cliente_Provincia
    );

    -- Sucursal
    INSERT INTO [BNFL].[Provincia] (provincia_nombre)  
    SELECT DISTINCT Sucursal_Provincia
    FROM gd_esquema.Maestra
    WHERE Sucursal_Provincia IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 
        FROM Provincia
        WHERE Provincia.provincia_nombre = Maestra.Sucursal_Provincia
    );

    -- Proveedor
    INSERT INTO [BNFL].[Provincia] (provincia_nombre) 
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
CREATE PROCEDURE [BNFL].Migracion_Localidad
AS 
BEGIN 
    INSERT INTO [BNFL].[Localidad] (localidad_nombre, localidad_provincia)
    SELECT DISTINCT 
        Maestra.Cliente_Localidad,
        Provincia.provincia_id
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN [BNFL].[Provincia] AS Provincia on Maestra.Cliente_Provincia = Provincia.provincia_nombre
    WHERE Maestra.Cliente_Localidad IS NOT NULL
	AND NOT EXISTS (
        SELECT 1
        FROM [BNFL].[Localidad] AS Localidad
        WHERE Localidad.localidad_nombre = Maestra.Cliente_Localidad
        and Localidad.localidad_provincia = Provincia.provincia_id
    );
    INSERT INTO [BNFL].[Localidad] (localidad_nombre, localidad_provincia)
    SELECT DISTINCT 
        Maestra.Sucursal_Localidad,
        Provincia.provincia_id
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN [BNFL].[Provincia] AS Provincia on Maestra.Sucursal_Provincia = Provincia.provincia_nombre
    WHERE Maestra.Sucursal_Localidad IS NOT NULL 
	AND NOT EXISTS (
        SELECT 1
        FROM [BNFL].[Localidad] AS Localidad
        WHERE Localidad.localidad_nombre = Maestra.Sucursal_Localidad
        and Localidad.localidad_provincia = Provincia.provincia_id
    );
    
    INSERT INTO [BNFL].[Localidad] (localidad_nombre, localidad_provincia)
    SELECT DISTINCT     
        Maestra.Proveedor_Localidad,
        Provincia.provincia_id
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN [BNFL].[Provincia] AS Provincia on Maestra.Proveedor_Provincia = Provincia.provincia_nombre
    WHERE Maestra.Proveedor_Localidad IS NOT NULL 
	AND NOT EXISTS (
        SELECT 1
        FROM [BNFL].[Localidad] AS Localidad
        WHERE Localidad.localidad_nombre = Maestra.Proveedor_Localidad
        AND Localidad.localidad_provincia = Provincia.provincia_id
    );
END
GO

-- CONTACTO
CREATE PROCEDURE [BNFL].Migracion_Contacto 
AS 
BEGIN
    INSERT INTO [BNFL].[Contacto] (contacto_mail, contacto_telefono)
    SELECT DISTINCT 
        Maestra.Cliente_Mail,
        Maestra.Cliente_Telefono
    FROM gd_esquema.Maestra AS Maestra
    WHERE NOT EXISTS (
        SELECT 1
        FROM [BNFL].[Contacto] AS Contacto
        WHERE contacto_telefono = Maestra.Cliente_Telefono
    );

    INSERT INTO [BNFL].[Contacto] (contacto_mail, contacto_telefono)
    SELECT DISTINCT 
        Maestra.Sucursal_mail,
        Maestra.Sucursal_telefono
    FROM gd_esquema.Maestra AS Maestra
    WHERE NOT EXISTS (
        SELECT 1
        FROM [BNFL].[Contacto] AS Contacto
        WHERE Contacto.contacto_telefono = Maestra.Sucursal_Telefono
    );

    INSERT INTO [BNFL].[Contacto] (contacto_mail, contacto_telefono)
    SELECT DISTINCT 
        Maestra.Proveedor_Mail,
        Maestra.Proveedor_Telefono
    FROM gd_esquema.Maestra AS Maestra
    WHERE NOT EXISTS (
        SELECT 1
        FROM [BNFL].[Contacto] AS Contacto
        WHERE Contacto.contacto_telefono = Maestra.Proveedor_Telefono
    );
END 
GO

-- CLIENTE
CREATE PROCEDURE [BNFL].Migracion_Cliente
AS
BEGIN
    INSERT INTO [BNFL].[Cliente] (cliente_direccion, cliente_localidad_id, cliente_contacto_num, cliente_dni, cliente_nombre, cliente_apellido, cliente_fechaNacimiento)
    SELECT DISTINCT
        Maestra.Cliente_Direccion,
        Localidad.localidad_num,
        Contacto.contacto_num,
        Maestra.Cliente_Dni,
        Maestra.Cliente_Nombre,
        Maestra.Cliente_Apellido,
        Maestra.Cliente_FechaNacimiento
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN [BNFL].[Localidad] AS Localidad ON Maestra.Cliente_Localidad = Localidad.localidad_nombre
    LEFT JOIN [BNFL].[Provincia] AS Provincia ON Localidad.localidad_provincia = Provincia.provincia_id
        AND Maestra.Cliente_Provincia = Provincia.provincia_nombre
    LEFT JOIN [BNFL].[Contacto] AS Contacto ON Maestra.Cliente_Telefono = Contacto.contacto_telefono
        AND Maestra.Cliente_Mail = Contacto.contacto_mail
    WHERE Maestra.Cliente_Dni IS NOT NULL 
        AND Provincia.provincia_id IS NOT NULL
    	AND Localidad.localidad_num IS NOT NULL
END
GO

-- SUCURSAL
CREATE PROCEDURE [BNFL].Migracion_Sucursal
AS
BEGIN
    INSERT INTO [BNFL].[Sucursal] (sucursal_numero, sucursal_direccion, sucursal_contacto_num, sucursal_localidad_id)
    SELECT DISTINCT
        Maestra.Sucursal_NroSucursal, 
        Maestra.Sucursal_Direccion,
        Contacto.contacto_num,
        Localidad.localidad_num
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Contacto ON Maestra.Sucursal_mail = Contacto.contacto_mail
        AND Maestra.Sucursal_telefono = Contacto.contacto_telefono
    LEFT JOIN [BNFL].[Localidad] AS Localidad ON Maestra.Sucursal_Localidad = Localidad.localidad_nombre
	LEFT JOIN [BNFL].[Provincia] AS Provincia ON Localidad.localidad_provincia = Provincia.provincia_id
        AND Maestra.Sucursal_Provincia = Provincia.provincia_nombre
    WHERE Maestra.Sucursal_NroSucursal IS NOT NULL
    AND Localidad.localidad_num IS NOT NULL
	AND Provincia.provincia_id IS NOT NULL
END
GO

-- FACTURA
CREATE PROCEDURE [BNFL].Migracion_Factura
AS
BEGIN
    INSERT INTO [BNFL].[Factura] (fact_numero, fact_sucursal_id, fact_cliente_num, fact_fecha, fact_total)
    SELECT DISTINCT
        Maestra.factura_numero,
        Sucursal.sucursal_id,
        Cliente.cliente_numero,
        Maestra.factura_fecha,
        Maestra.factura_total
    FROM gd_esquema.Maestra
    LEFT JOIN [BNFL].[Cliente] AS Cliente ON Cliente.cliente_nombre = Maestra.Cliente_Nombre
        AND Cliente.cliente_apellido = Maestra.Cliente_Apellido
        AND Cliente.cliente_dni = Maestra.Cliente_Dni
        AND Cliente.cliente_fechaNacimiento = Maestra.Cliente_FechaNacimiento
    LEFT JOIN [BNFL].[Sucursal] AS Sucursal ON Sucursal.sucursal_numero = Maestra.Sucursal_NroSucursal
    WHERE Maestra.Factura_Numero IS NOT NULL
    AND Maestra.Sucursal_NroSucursal IS NOT NULL
    AND Maestra.Cliente_Nombre IS NOT NULL
    AND Maestra.Cliente_Apellido IS NOT NULL
    AND Maestra.Cliente_Dni IS NOT NULL
    AND Maestra.Factura_Fecha IS NOT NULL
    AND Maestra.Factura_Total IS NOT NULL
END
GO

-- ENVIO
CREATE PROCEDURE [BNFL].Migracion_Envio
AS
BEGIN
    INSERT INTO [BNFL].[Envio] (envio_numero, envio_fact_id, envio_fecha, envio_fecha_programada, envio_importeTraslado, envio_importeSubida)
    SELECT DISTINCT
        Maestra.envio_numero,
        Factura.fact_id,
        Maestra.envio_fecha,
        Maestra.envio_fecha_programada,
        Maestra.envio_importeTraslado,
        Maestra.envio_importeSubida
    FROM gd_esquema.Maestra
    LEFT JOIN [BNFL].[Factura] AS Factura ON Factura.fact_numero = Maestra.Factura_Numero
    WHERE Maestra.envio_fecha IS NOT NULL
        AND Maestra.envio_fecha_programada IS NOT NULL
        AND Maestra.envio_importeTraslado IS NOT NULL
        AND Maestra.envio_importeSubida IS NOT NULL
        AND Maestra.envio_numero IS NOT NULL
        AND Maestra.Factura_Numero IS NOT NULL
END 
GO

-- SILLON
CREATE PROCEDURE [BNFL].Migracion_Sillon
AS
BEGIN 
    INSERT INTO [BNFL].[Sillon] (
    sillon_codigo, 
    sillon_sillon_m_num, 
    sillon_sillon_medida_num)
    SELECT DISTINCT 
        Sillon_Codigo,
        Maestra.Sillon_Modelo_Codigo,
        Sillon_Medida.sillon_med_id
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN [BNFL].[Sillon_Medida] AS Sillon_Medida ON Sillon_Medida.sillon_med_alto = Maestra.Sillon_Medida_Alto 
        AND Sillon_Medida.sillon_med_ancho = Maestra.Sillon_Medida_Ancho 
        AND Sillon_Medida.sillon_med_precio = Maestra.Sillon_Medida_Precio
        AND Sillon_Medida.sillon_med_profundidad = Maestra.Sillon_Medida_Profundidad
    WHERE Maestra.Sillon_Codigo IS NOT NULL 
        AND Maestra.Sillon_Modelo_Codigo IS NOT NULL 
        AND Maestra.Sillon_Medida_Alto IS NOT NULL 
        AND Maestra.Sillon_Medida_Ancho IS NOT NULL 
END
GO

-- MATERIAL SILLON
CREATE PROCEDURE [BNFL].Migracion_Material_Sillon
AS 
BEGIN
    INSERT INTO [BNFL].[Material_Sillon] (mat_sill_material, mat_sill_sillon)
    SELECT DISTINCT 
    	Material.material_numero,
		Sillon.sillon_codigo 
    FROM gd_esquema.Maestra AS Maestra 
    LEFT JOIN [BNFL].[Material] AS Material ON Maestra.Material_Tipo = Material.material_tipo
        AND Maestra.Material_Nombre = Material.material_nombre
        AND Maestra.Material_Precio = Material.material_precio
        AND Maestra.Material_Descripcion = Material.material_descripcion
    LEFT JOIN [BNFL].[Sillon] AS Sillon ON Maestra.Sillon_Codigo = Sillon.sillon_codigo
    WHERE Maestra.Material_Tipo IS NOT NULL
        AND Maestra.Material_Nombre IS NOT NULL
        AND Maestra.Material_Precio IS NOT NULL
        AND Maestra.Material_Descripcion IS NOT NULL
        AND Maestra.Sillon_Codigo IS NOT NULL
END 
GO

-- PROVEEDOR
CREATE PROCEDURE [BNFL].Migracion_Proveedor
AS 
BEGIN
    INSERT INTO [BNFL].[Proveedor] (proved_cuit, proved_razonSocial, proved_direccion, proved_localidad_id, proved_contacto_num)
    SELECT DISTINCT 
    Maestra.Proveedor_Cuit,
    Maestra.Proveedor_RazonSocial,
    Maestra.Proveedor_Direccion,
    Localidad.localidad_num,
    Contacto.contacto_num
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN [BNFL].[Localidad] AS Localidad ON Maestra.Proveedor_Localidad = Localidad.localidad_nombre
    LEFT JOIN [BNFL].[Provincia] AS Provincia ON Maestra.Proveedor_Provincia = Provincia.provincia_nombre
        AND Localidad.localidad_provincia = Provincia.provincia_id
    LEFT JOIN [BNFL].[Contacto] AS Contacto ON Maestra.Proveedor_Mail = Contacto.contacto_mail 
        AND Maestra.Proveedor_Telefono = Contacto.contacto_telefono
    WHERE Maestra.Proveedor_Cuit IS NOT NULL
        AND Maestra.Proveedor_RazonSocial IS NOT NULL
        AND Maestra.Proveedor_Direccion IS NOT NULL
        AND Localidad.localidad_num IS NOT NULL
        AND Provincia.provincia_id IS NOT NULL
        AND Contacto.contacto_num IS NOT NULL
END 
GO

-- COMPRA
CREATE PROCEDURE [BNFL].Migracion_Compra 
AS
BEGIN
    INSERT INTO [BNFL].[Compra] (compra_numero, compra_fecha, compra_proved_num, compra_sucursal_id, compra_total)
    SELECT DISTINCT 
    Maestra.Compra_Numero,
    Maestra.Compra_Fecha,
    Proveedor.proved_num,
    Sucursal.sucursal_id,
    Maestra.Compra_Total
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN [BNFL].[Sucursal] AS Sucursal ON Maestra.Sucursal_NroSucursal = Sucursal.sucursal_numero
    LEFT JOIN [BNFL].[Proveedor] AS Proveedor ON Maestra.Proveedor_Cuit = Proveedor.proved_cuit
        AND Maestra.Proveedor_RazonSocial = Proveedor.proved_razonSocial
    WHERE Maestra.Compra_Numero IS NOT NULL 
		AND Maestra.Compra_Fecha IS NOT NULL
        AND Sucursal.sucursal_id IS NOT NULL
        AND Proveedor.proved_num IS NOT NULL
END
GO

-- MIGRACION PEDIDO
CREATE PROCEDURE [BNFL].Migracion_Pedido
AS
BEGIN
    INSERT INTO [BNFL].[Pedido] (pedido_numero, pedido_cliente_num, pedido_estado_num, pedido_sucursal_id) 
    SELECT DISTINCT 
    Maestra.Pedido_Numero,
    Cliente.cliente_numero,
    Estado.estado_numero,
    Sucursal.sucursal_id
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN [BNFL].[Estado] AS Estado ON Maestra.Pedido_Estado = Estado.estado_descripcion
    LEFT JOIN [BNFL].[Cliente] AS Cliente ON Maestra.Cliente_Apellido = Cliente.cliente_apellido 
        AND Maestra.Cliente_Dni = Cliente.cliente_dni
        AND Maestra.Cliente_Nombre = Cliente.cliente_nombre
        AND Maestra.Cliente_FechaNacimiento = Cliente.cliente_fechaNacimiento
    LEFT JOIN [BNFL].[Sucursal] AS Sucursal ON Maestra.Sucursal_NroSucursal = Sucursal.sucursal_numero
    WHERE Maestra.Pedido_Numero IS NOT NULL
        AND Cliente.cliente_numero IS NOT NULL
        AND Estado.estado_numero IS NOT NULL
        AND Sucursal.sucursal_id IS NOT NULL
END
GO

-- PEDIDO CANCELACION
CREATE PROCEDURE [BNFL].Migracion_Pedido_Cancelacion
AS
BEGIN
    INSERT INTO [BNFL].[Pedido_Cancelacion] (pedido_can_pedido_id, pedido_can_motivo, pedido_can_fecha)
    SELECT DISTINCT
    Pedido.pedido_id,
    Maestra.Pedido_Cancelacion_Motivo,
    Maestra.Pedido_Cancelacion_Fecha
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN [BNFL].[Pedido] AS Pedido on Pedido.pedido_numero = Maestra.Pedido_numero
        WHERE Maestra.Pedido_Cancelacion_Fecha IS NOT NULL 
        AND Maestra.Pedido_Cancelacion_Motivo IS NOT NULL
END
GO

-- DETALLE COMPRA
CREATE PROCEDURE [BNFL].Migracion_Detalle_Compra
AS
BEGIN
    INSERT INTO [BNFL].Detalle_Compra (detalle_comp_numero, detalle_comp_compra_num, detalle_comp_material, 
        detalle_comp_precioUnitario, detalle_comp_cantidad)
    SELECT DISTINCT
	ROW_NUMBER() OVER (PARTITION BY Maestra.Compra_Numero ORDER BY Maestra.Material_Nombre) AS detalle_comp_item_id,
    Compra.compra_id,
    Material.material_numero,
	Maestra.Detalle_Compra_Precio,
	Maestra.Detalle_Compra_Cantidad
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN [BNFL].Material AS Material ON Maestra.Material_tipo = Material.material_tipo
        AND Maestra.Material_Nombre = Material.material_nombre
        AND Maestra.Material_Descripcion = Material.material_descripcion
        AND Maestra.Material_Precio = Material.material_precio
	LEFT JOIN [BNFL].Compra AS Compra ON Maestra.Compra_Numero = Compra.compra_numero
	WHERE Maestra.Compra_Numero IS NOT NULL
	AND Maestra.Detalle_Compra_Precio IS NOT NULL
	AND Maestra.Detalle_Compra_Cantidad IS NOT NULL
END 
GO

-- DETALLE PEDIDO
CREATE PROCEDURE [BNFL].Migracion_Detalle_Pedido
AS
BEGIN
    INSERT INTO [BNFL].Detalle_Pedido (detalle_p_numero, detalle_p_sillon_numero, detalle_p_pedido_id, 
    detalle_p_cantidad, detalle_p_precio)
    SELECT DISTINCT 
	ROW_NUMBER() OVER (PARTITION BY Pedido.pedido_numero ORDER BY Pedido.Pedido_Numero) AS detalle_ped_item_id,
    Sillon.sillon_codigo,
    Pedido.pedido_id,
    Maestra.Detalle_Pedido_Cantidad,
    Maestra.Detalle_Pedido_Precio
    FROM gd_esquema.Maestra AS Maestra
	JOIN [BNFL].Pedido ON Maestra.Pedido_Numero = Pedido.pedido_numero
    JOIN [BNFL].Sillon ON Maestra.Sillon_Codigo = Sillon.sillon_codigo
	WHERE Maestra.Detalle_Pedido_Cantidad IS NOT NULL
	AND Maestra.Detalle_Pedido_Precio IS NOT NULL
	AND Maestra.Pedido_Numero IS NOT NULL
END
GO

-- DETALLE FACTURA 
CREATE PROCEDURE [BNFL].Migracion_Detalle_Factura
AS 
BEGIN
    INSERT INTO [BNFL].[Detalle_Factura] (detalle_f_numero, detalle_f_factura_id, detalle_f_pedido_numero,
     detalle_f_det_pedido, item_f_cantidad, item_f_precioUnitario)
    SELECT DISTINCT 
        ROW_NUMBER() OVER (PARTITION BY Factura.fact_id ORDER BY Factura.fact_id) AS detalle_comp_item_id,
        Factura.fact_id,
        Detalle_Pedido.detalle_p_pedido_id,
        Detalle_Pedido.detalle_p_numero,
        Maestra.Detalle_Factura_Cantidad,
        Maestra.Detalle_Factura_Precio
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN [BNFL].[Factura] AS Factura ON Maestra.Factura_Numero = Factura.fact_numero
    LEFT JOIN [BNFL].[Pedido] AS Pedido ON Maestra.Pedido_Numero = Pedido.pedido_numero
    LEFT JOIN [BNFL].[Detalle_Pedido] AS Detalle_Pedido ON Pedido.pedido_id = Detalle_Pedido.detalle_p_pedido_id
        AND Maestra.Detalle_Pedido_Cantidad = Detalle_Pedido.detalle_p_cantidad 
        AND Maestra.Detalle_Pedido_Precio = Detalle_Pedido.detalle_p_precio
    WHERE Maestra.Factura_Numero IS NOT NULL
        AND Maestra.Detalle_Factura_Precio IS NOT NULL
        AND Pedido.pedido_id IS NOT NULL
        AND Detalle_Pedido.detalle_p_numero IS NOT NULL
        AND Detalle_Pedido.detalle_p_pedido_id IS NOT NULL
END
GO

execute [BNFL].Migracion_Estado; 
execute [BNFL].Migracion_Sillon_Medida; 
execute [BNFL].Migracion_Sillon_Modelo; 
execute [BNFL].Migracion_Material;
execute [BNFL].Migracion_Tela; 
execute [BNFL].Migracion_Madera; 
execute [BNFL].Migracion_Relleno; 
execute [BNFL].Migracion_Provincia; 
execute [BNFL].Migracion_Localidad; 
execute [BNFL].Migracion_Contacto;  
execute [BNFL].Migracion_Cliente; 
execute [BNFL].Migracion_Sucursal;   
execute [BNFL].Migracion_Factura; 
execute [BNFL].Migracion_Envio; 
execute [BNFL].Migracion_Sillon; 
execute [BNFL].Migracion_Material_Sillon; 
execute [BNFL].Migracion_Proveedor; 
execute [BNFL].Migracion_Compra; 
execute [BNFL].Migracion_Pedido; 
execute [BNFL].Migracion_Pedido_Cancelacion; 
execute [BNFL].Migracion_Detalle_Compra; 
execute [BNFL].Migracion_Detalle_Pedido; 
execute [BNFL].Migracion_Detalle_Factura; 

PRINT ' MIGRACION EXITOSA '

/* PROVINCIA */
CREATE INDEX IDX_PROVINCIA_ID ON [BNFL].[Provincia] (provincia_id);

/* LOCALIDAD */
CREATE INDEX IDX_LOCALIDAD_ID ON [BNFL].[Localidad] (localidad_num);
CREATE INDEX IDX_LOCALIDAD_PROVINCIA ON [BNFL].[Localidad] (localidad_provincia);

/* CLIENTE */
CREATE INDEX IDX_CLIENTE_NUMERO ON [BNFL].[Cliente] (cliente_numero);
CREATE INDEX IDX_CLIENTE_CONTACTO ON [BNFL].[Cliente] (cliente_contacto_num);
CREATE INDEX IDX_CLIENTE_LOCALIDAD ON [BNFL].[Cliente] (cliente_localidad_id);

/* SUCURSAL */
CREATE INDEX IDX_SUCURSAL_ID ON [BNFL].[Sucursal] (sucursal_id);
CREATE INDEX IDX_SUCURSAL_CONTACTO ON [BNFL].[Sucursal] (sucursal_contacto_num);
CREATE INDEX IDX_SUCURSAL_LOCALIDAD ON [BNFL].[Sucursal] (sucursal_localidad_id);

/* FACTURA */
CREATE INDEX IDX_FACTURA_ID ON [BNFL].[Factura] (fact_id);
CREATE INDEX IDX_FACTURA_NUMERO ON [BNFL].[Factura] (fact_numero);
CREATE INDEX IDX_FACTURA_CLIENTE ON [BNFL].[Factura] (fact_cliente_num);
CREATE INDEX IDX_FACTURA_SUCURSAL ON [BNFL].[Factura] (fact_sucursal_id);

/* DETALLE_FACTURA */
CREATE INDEX IDX_DETALLE_FACTURA_FACTURA_ID ON [BNFL].[Detalle_Factura] (detalle_f_factura_id);
CREATE INDEX IDX_DETALLE_FACTURA_PEDIDO ON [BNFL].[Detalle_Factura] (detalle_f_pedido_numero, detalle_f_det_pedido);

/* ENVIO */
CREATE INDEX IDX_ENVIO_ID ON [BNFL].[Envio] (envio_id);
CREATE INDEX IDX_ENVIO_FACTURA_ID ON [BNFL].[Envio] (envio_fact_id);

/* PEDIDO */
CREATE INDEX IDX_PEDIDO_ID ON [BNFL].[Pedido] (pedido_id);
CREATE INDEX IDX_PEDIDO_NUMERO ON [BNFL].[Pedido] (pedido_numero);
CREATE INDEX IDX_PEDIDO_CLIENTE ON [BNFL].[Pedido] (pedido_cliente_num);
CREATE INDEX IDX_PEDIDO_SUCURSAL ON [BNFL].[Pedido] (pedido_sucursal_id);
CREATE INDEX IDX_PEDIDO_ESTADO ON [BNFL].[Pedido] (pedido_estado_num);

/* PEDIDO_CANCELACION */
CREATE INDEX IDX_PEDIDO_CANCELACION_ID ON [BNFL].[Pedido_Cancelacion] (pedido_can_numero);
CREATE INDEX IDX_PEDIDO_CANCELACION_PEDIDO_ID ON [BNFL].[Pedido_Cancelacion] (pedido_can_pedido_id);

/* DETALLE_PEDIDO */
CREATE INDEX IDX_DETALLE_PEDIDO_ID ON [BNFL].[Detalle_Pedido] (detalle_p_pedido_id);
CREATE INDEX IDX_DETALLE_PEDIDO_SILLON ON [BNFL].[Detalle_Pedido] (detalle_p_sillon_numero);

/* COMPRA */
CREATE INDEX IDX_COMPRA_ID ON [BNFL].[Compra] (compra_id);
CREATE INDEX IDX_COMPRA_NUMERO ON [BNFL].[Compra] (compra_numero);
CREATE INDEX IDX_COMPRA_PROVEEDOR ON [BNFL].[Compra] (compra_proved_num);
CREATE INDEX IDX_COMPRA_SUCURSAL ON [BNFL].[Compra] (compra_sucursal_id);

/* DETALLE_COMPRA */
CREATE INDEX IDX_DETALLE_COMPRA_COMPRA_ID ON [BNFL].[Detalle_Compra] (detalle_comp_compra_num);
CREATE INDEX IDX_DETALLE_COMPRA_MATERIAL ON [BNFL].[Detalle_Compra] (detalle_comp_material);

/* PROVEEDOR */
CREATE INDEX IDX_PROVEEDOR_ID ON [BNFL].[Proveedor] (proved_num);
CREATE INDEX IDX_PROVEEDOR_CONTACTO ON [BNFL].[Proveedor] (proved_contacto_num);
CREATE INDEX IDX_PROVEEDOR_LOCALIDAD ON [BNFL].[Proveedor] (proved_localidad_id);

/* CONTACTO */
CREATE INDEX IDX_CONTACTO_NUM ON [BNFL].[Contacto] (contacto_num);

/* SILLON_MODELO */
CREATE INDEX IDX_SILLON_MODELO_ID ON [BNFL].[Sillon_Modelo] (sillon_mod_codigo);

/* SILLON_MEDIDA */
CREATE INDEX IDX_SILLON_MEDIDA_ID ON [BNFL].[Sillon_Medida] (sillon_med_id);

/* SILLON */
CREATE INDEX IDX_SILLON_CODIGO ON [BNFL].[Sillon] (sillon_codigo);
CREATE INDEX IDX_SILLON_MODELO ON [BNFL].[Sillon] (sillon_sillon_m_num);
CREATE INDEX IDX_SILLON_MEDIDA ON [BNFL].[Sillon] (sillon_sillon_medida_num);

/* MATERIAL_SILLON */
CREATE INDEX IDX_MATERIAL_SILLON_MATERIAL ON [BNFL].[Material_Sillon] (mat_sill_material);
CREATE INDEX IDX_MATERIAL_SILLON_SILLON ON [BNFL].[Material_Sillon] (mat_sill_sillon);

/* MATERIAL */
CREATE INDEX IDX_MATERIAL_NUMERO ON [BNFL].[Material] (material_numero);

/* TELA */
CREATE INDEX IDX_TELA_NUMERO ON [BNFL].[Tela] (tela_numero);

/* MADERA */
CREATE INDEX IDX_MADERA_NUMERO ON [BNFL].[Madera] (madera_numero);

/* RELLENO */
CREATE INDEX IDX_RELLENO_NUM ON [BNFL].[Relleno] (relleno_num);

PRINT ' EJECUCION FINALIZADA '
