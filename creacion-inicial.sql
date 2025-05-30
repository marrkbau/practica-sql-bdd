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
    cliente_direccion_num BIGINT NOT NULL,
    cliente_contacto_num BIGINT NOT NULL,
    cliente_dni BIGINT,
    cliente_nombre NVARCHAR(255),
    cliente_apellido NVARCHAR(255),
    cliente_fechaNacimiento DATETIME2(6)
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
    sucursal_direccion_num BIGINT NOT NULL,
    sucursal_contacto_num BIGINT NOT NULL
)

CREATE TABLE Direccion(
    dire_numero BIGINT IDENTITY NOT NULL PRIMARY KEY,
    direccion_localidad_num BIGINT,
    dire_direccion NVARCHAR(255),
)

CREATE TABLE Localidad(
    localidad_num BIGINT IDENTITY NOT NULL PRIMARY KEY,
    localidad_provincia BIGINT NOT NULL,
    localidad_nombre NVARCHAR(255)
)

CREATE TABLE Proveedor(
    proved_num BIGINT IDENTITY NOT NULL PRIMARY KEY,
    proved_dire_num BIGINT,
    proved_contacto_num BIGINT,
    proved_cuit NVARCHAR(255),
    proved_razonSocial NVARCHAR(255)
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
ADD FOREIGN KEY (cliente_direccion_num) REFERENCES Direccion(dire_numero),
    FOREIGN KEY (cliente_contacto_num) REFERENCES Contacto(contacto_num);

ALTER TABLE Direccion
ADD FOREIGN KEY (direccion_localidad_num) REFERENCES Localidad(localidad_num);

ALTER TABLE Localidad
ADD FOREIGN KEY (localidad_provincia) REFERENCES Provincia(provincia_id);

ALTER TABLE Sucursal
ADD FOREIGN KEY (sucursal_direccion_num) REFERENCES Direccion(dire_numero),
    FOREIGN KEY (sucursal_contacto_num) REFERENCES Contacto(contacto_num);

ALTER TABLE Proveedor
ADD FOREIGN KEY (proved_dire_num) REFERENCES Direccion(dire_numero),
    FOREIGN KEY (proved_contacto_num) REFERENCES Contacto(contacto_num);

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
/*Procedures*/
GO

-- ESTADO
CREATE PROCEDURE Migracion_Estado
AS 
BEGIN
    INSERT INTO Estado (estado_descripcion)
    SELECT DISTINCT 
        Maestra.Pedido_Estado
    FROM gd_esquema.Maestra
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
    INSERT INTO Provincia (provincia_nombre) 
    SELECT DISTINCT Cliente_Provincia AS prov_nombre1
    FROM gd_esquema.Maestra;

    INSERT INTO Provincia (provincia_nombre)  
    SELECT DISTINCT Sucursal_Provincia AS prov_nombre2
    FROM gd_esquema.Maestra;
    
    INSERT INTO Provincia (provincia_nombre) 
    SELECT DISTINCT Proveedor_Provincia AS prov_nombre3
    FROM gd_esquema.Maestra;
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
    LEFT JOIN Provincia on Maestra.Cliente_Localidad = Provincia.provincia_nombre
    WHERE NOT EXISTS (
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
    LEFT JOIN Provincia on Maestra.Sucursal_Localidad = Provincia.provincia_nombre
    WHERE NOT EXISTS (
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
    LEFT JOIN Provincia on Maestra.Proveedor_Localidad = Provincia.provincia_nombre
    WHERE NOT EXISTS (
        SELECT 1
        FROM Localidad
        WHERE Localidad.localidad_nombre = Maestra.Proveedor_Localidad
        AND Localidad.localidad_provincia = Provincia.provincia_id
    );
END
GO

-- DIRECCION
CREATE PROCEDURE Migracion_Direccion
AS
BEGIN
    INSERT INTO Direccion (dire_direccion, direccion_localidad_num)
    SELECT DISTINCT 
        Cliente_Direccion,
        localidad_num
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Localidad ON Maestra.Cliente_Localidad = localidad_nombre
    WHERE NOT EXISTS (
        SELECT 1
        FROM Direccion
        WHERE dire_direccion = Maestra.Cliente_Direccion
        AND direccion_localidad_num = localidad_num
    );

    INSERT INTO Direccion (dire_direccion, direccion_localidad_num)
    SELECT DISTINCT 
        Sucursal_Direccion,
        localidad_num
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Localidad ON Maestra.Cliente_Localidad = localidad_nombre
    WHERE NOT EXISTS (
        SELECT 1
        FROM Direccion
        WHERE dire_direccion = Maestra.Cliente_Direccion
        AND direccion_localidad_num = localidad_num
    );
    
    INSERT INTO Direccion (dire_direccion, direccion_localidad_num)
    SELECT DISTINCT 
        Proveedor_Direccion,
        localidad_num
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Localidad ON Maestra.Cliente_Localidad = localidad_nombre
    WHERE NOT EXISTS (
        SELECT 1
        FROM Direccion
        WHERE dire_direccion = Maestra.Cliente_Direccion
        AND direccion_localidad_num = localidad_num
    );
END 
GO

-- CONTACTO
CREATE PROCEDURE Migracion_Contacto 
AS 
BEGIN
    INSERT INTO Contacto (contacto_mail, contacto_num)
    SELECT DISTINCT 
        Cliente_Mail,
        Cliente_Telefono
    FROM gd_esquema.Maestra
    WHERE NOT EXISTS (
        SELECT 1
        FROM Contacto
        WHERE contacto_telefono = Maestra.Cliente_Telefono
    );

    INSERT INTO Contacto (contacto_mail, contacto_num)
    SELECT DISTINCT 
        Sucursal_mail,
        Sucursal_telefono
    FROM gd_esquema.Maestra
    WHERE NOT EXISTS (
        SELECT 1
        FROM Contacto
        WHERE contacto_telefono = Maestra.Cliente_Telefono
    );

    INSERT INTO Contacto (contacto_mail, contacto_num)
    SELECT DISTINCT 
        Proveedor_Mail,
        Proveedor_Telefono
    FROM gd_esquema.Maestra
    WHERE NOT EXISTS (
        SELECT 1
        FROM Contacto
        WHERE contacto_telefono = Maestra.Cliente_Telefono
    );
END 
GO

-- CLIENTE
CREATE PROCEDURE Migracion_Cliente
AS
BEGIN
    INSERT INTO Cliente (cliente_direccion_num, cliente_contacto_num, cliente_dni, cliente_nombre, cliente_apellido, cliente_fechaNacimiento)
    SELECT DISTINCT
        Direccion.dire_numero,
        Contacto.contacto_num,
        Maestra.Cliente_dni,
        Maestra.Cliente_nombre,
        Maestra.Cliente_apellido,
        Maestra.Cliente_fechaNacimiento
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Direccion ON Maestra.Cliente_Direccion = Direccion.dire_direccion
    LEFT JOIN Contacto ON Maestra.Cliente_Telefono = Contacto.contacto_telefono
        AND Maestra.Cliente_Mail = Contacto.contacto_mail
END
GO

-- SUCURSAL ???????????????????????????
CREATE PROCEDURE Migracion_Sucursal
AS
BEGIN
    INSERT INTO Sucursal (sucursal_numero, sucursal_direccion_num, sucursal_contacto_num)
    SELECT DISTINCT
        Maestra.Sucursal_NroSucursal, 
		Direccion.dire_numero, 
		Contacto.contacto_num
    FROM gd_esquema.Maestra AS Maestra
    LEFT JOIN Direccion ON Maestra.Cliente_Direccion = Direccion.dire_direccion
    LEFT JOIN Contacto ON Maestra.Cliente_Telefono = Contacto.contacto_telefono 
        AND Maestra.Cliente_Mail = Contacto.contacto_mail
END
GO

-- FACTURA
CREATE PROCEDURE Migracion_Factura
AS
BEGIN
SET IDENTITY_INSERT Cliente ON
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
SET IDENTITY_INSERT Detalle_Pedido ON
BEGIN
    INSERT INTO Detalle_Factura (detalle_f_factura_num,item_f_precioUnitario, 
        item_f_cantidad, detalle_f_pedido_numero, detalle_f_det_pedido)
    SELECT DISTINCT
    Factura.fact_numero,
    Maestra.detalle_factura_precio,
    Maestra.detalle_factura_cantidad,
    Detalle_Pedido.detalle_p_pedido_numero,
    Detalle_Pedido.detalle_p_numero
    FROM gd_esquema.Maestra
    LEFT JOIN Factura ON Maestra.Factura_Numero = Factura.fact_numero
    LEFT JOIN Detalle_Pedido ON Maestra.Detalle_Pedido_Cantidad = Detalle_Pedido.detalle_p_cantidad
        AND Maestra.Detalle_Pedido_Precio = Detalle_Pedido.detalle_p_precio
    LEFT JOIN Pedido ON Detalle_Pedido.detalle_p_pedido_numero = Pedido.pedido_numero 
        AND Maestra.Pedido_Numero = Pedido.pedido_numero
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

execute Migracion_Estado; -- ?
execute Migracion_Sillon_Medida;
execute Migracion_Sillon_Modelo;
execute Migracion_Material;-- anda
execute Migracion_Tela; -- anda
execute Migracion_Madera; -- anda
execute Migracion_Relleno; -- anda
execute Migracion_Provincia; -- ? creo que anda
execute Migracion_Localidad; -- ?
execute Migracion_Direccion; -- ?
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
