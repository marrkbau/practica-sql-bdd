CREATE TABLE Cliente(
    cliente_numero BIGINT not null PRIMARY KEY,
    cliente_direccion_num BIGINT not null,
    cliente_contacto_num BIGINT not null,
    cliente_dni BIGINT,
    cliente_nombre NVARCHAR(255),
    cliente_apellido NVARCHAR(255),
    cliente_fechaNacimiento datetime2(6)
)

create table Pedido(
    pedido_numero bigint not null primary key,
    pedido_cliente_num bigint not null,
    pedido_sucursal_num bigint not null, 
    pedido_estado_num bigint not null
)

create table Estado(
    estado_numero BIGINT PRIMARY KEY,
    estado_descripcion NVARCHAR(255)
)

CREATE TABLE Envio(
    envio_numero BIGINT not null PRIMARY KEY,
    envio_pedido_num BIGINT not null,
    envio_fecha datetime2(6),
    envio_fecha_programada datetime2(6),
    envio_importeTraslado decimal(18,2),
    Envio_importeSubida decimal(18,2)
)

CREATE TABLE Sucursal(
    sucursal_numero BIGINT not null PRIMARY KEY,
    sucursal_direccion_num BIGINT not null,
    sucursal_contacto_num BIGINT not null
)

CREATE TABLE Direccion(
    dire_numero BIGINT not null PRIMARY KEY,
    direccion_localidad_num BIGINT,
    dire_direccion NVARCHAR(255),
)

CREATE TABLE Localidad(
    localidad_num BIGINT not null PRIMARY KEY,
    localidad_provincia BIGINT not null,
    localidad_nombre NVARCHAR(255)
)

CREATE TABLE Proveedor(
    proved_num BIGINT not null PRIMARY KEY,
    proved_dire_num BIGINT,
    proved_contact_num BIGINT,
    proved_cuit NVARCHAR(255),
    proved_razonSocial NVARCHAR(255)
)

CREATE TABLE Provincia(
    provincia_num BIGINT not null PRIMARY KEY,
    provincia_nombre NVARCHAR(255)
)

CREATE TABLE Contacto(
    contacto_num BIGINT not null PRIMARY KEY,
    contacto_mail NVARCHAR(255),
    contacto_telefono NVARCHAR(255)

)

create table Factura(
    fact_numero bigint primary key,
    fact_sucursal_num bigint not null,
    fact_cliente_num bigint not null,
    fact_fecha datetime2(6),
    fact_total decimal(38,2)
)

create table Detalle_Factura(
    detalle_f_factura_num bigint not null,
    detalle_f_numero bigint not null,
    primary key(detalle_f_factura_num, detalle_f_numero),
    item_f_precioUnitario decimal(18,2),
    item_f_cantidad decimal(18,0)
)

create table Detalle_Pedido(
    detalle_p_pedido_numero bigint not null, 
    detalle_p_numero bigint not null,
    primary key(detalle_p_pedido_numero, detalle_p_numero),
    detalle_p_sillon_numero bigint not null,
    detalle_p_cantidad bigint,
    detalle_p_precio decimal(18,2)
)

create table Sillon(
    sillon_codigo bigint primary key,
    sillon_sillon_m_num bigint not null,
    sillon_sillon_medida_num bigint not null,
    sillon_tela_num bigint not null,
    sillon_madera_num bigint not null,
    sillon_relleno_num bigint not null
)

create table Material(
    material_numero bigint primary key,
    material_tipo nvarchar(255),
    material_nombre nvarchar(255),
    material_descripcion nvarchar(255),
    material_precio decimal(38,2)
)

create table Tela(
    tela_numero bigint primary key,
    tela_color nvarchar(255),
    tela_textura nvarchar(255)
)

create table Madera(
    madera_numero bigint primary key,
    madera_color nvarchar(255),
    madera_dureza nvarchar(255)
)

create table Relleno(
    relleno_num bigint primary key,
    relleno_densidad decimal(38,2)
)

create table Detalle_Compra(
    detalle_comp_numero bigint not null,
    detalle_comp_compra_num bigint not null,
    primary key(detalle_comp_numero, detalle_comp_compra_num),
    detalle_comp_material bigint not null,
    detalle_comp_precioUnitario decimal(18,2),
    detalle_comp_cantidad decimal(18,0)
)

create table Compra(
    compra_numero bigint primary key,
    compra_proved_num bigint not null,
    compra_sucursalNum bigint not null,
    compra_fecha datetime2(6),
    compra_total decimal(18,2)
)


create table Pedido_Cancelacion(
    pedido_can_numero bigint primary key,
    pedido_can_pedido_num bigint not null,
    pedido_can_motivo varchar(255),
    pedido_can_fecha datetime2(6)
)

CREATE TABLE Material_Sillon (
    mat_sill_material BIGINT NOT NULL,
    mat_sill_sillon BIGINT NOT NULL,
    PRIMARY KEY (mat_sill_material, mat_sill_sillon)
)

CREATE TABLE Sillon_Medida (
    sillon_med_id bigint NOT NULL PRIMARY KEY,
    sillon_med_ancho decimal(18,2) NULL,
    sillon_med_alto decimal(18,2) NULL,
    sillon_med_profundidad decimal(18,2) NULL,
    sillon_med_precio decimal(18,2) NULL
)

CREATE TABLE Sillon_Modelo (
    sillon_mod_codigo bigint NOT NULL PRIMARY KEY,
    sillon_modelo NVARCHAR(255),
    sillon_mod_descripcion NVARCHAR(255),
    silon_mod_precio decimal(18,2)
)

------------------------------------------------------------------------------------------------

-- BLOQUE 1 – Relaciones de dirección, contacto, provincia y localidad

ALTER TABLE Cliente
ADD FOREIGN KEY (cliente_direccion_num) REFERENCES Direccion(dire_numero),
    FOREIGN KEY (cliente_contacto_num) REFERENCES Contacto(contacto_num);

ALTER TABLE Direccion
ADD FOREIGN KEY (direccion_localidad_num) REFERENCES Localidad(localidad_num);

ALTER TABLE Localidad
ADD FOREIGN KEY (localidad_provincia) REFERENCES Provincia(provincia_num);

ALTER TABLE Sucursal
ADD FOREIGN KEY (sucursal_direccion_num) REFERENCES Direccion(dire_numero),
    FOREIGN KEY (sucursal_contacto_num) REFERENCES Contacto(contacto_num);

ALTER TABLE Proveedor
ADD FOREIGN KEY (proved_dire_num) REFERENCES Direccion(dire_numero),
    FOREIGN KEY (proved_contact_num) REFERENCES Contacto(contacto_num);


--  BLOQUE 2 – Relaciones de pedidos

ALTER TABLE Pedido
ADD FOREIGN KEY (pedido_cliente_num) REFERENCES Cliente(cliente_numero),
    FOREIGN KEY (pedido_sucursal_num) REFERENCES Sucursal(sucursal_numero),
    FOREIGN KEY (pedido_estado_num) REFERENCES Estado(estado_numero);

ALTER TABLE Pedido_Cancelacion
ADD FOREIGN KEY (pedido_can_pedido_num) REFERENCES Pedido(pedido_numero);


-- BLOQUE 3 – Facturación y detalle

ALTER TABLE Factura
ADD FOREIGN KEY (fact_sucursal_num) REFERENCES Sucursal(sucursal_numero),
    FOREIGN KEY (fact_cliente_num) REFERENCES Cliente(cliente_numero);

ALTER TABLE Detalle_Factura
ADD FOREIGN KEY (detalle_f_factura_num) REFERENCES Factura(fact_numero);


-- BLOQUE 4 – Envío

ALTER TABLE Envio
ADD FOREIGN KEY (envio_pedido_num) REFERENCES Pedido(pedido_numero);


-- BLOQUE 5 – Sillones y modelos

ALTER TABLE Sillon
ADD FOREIGN KEY (sillon_sillon_m_num) REFERENCES Sillon_Modelo(sillon_mod_codigo),
    FOREIGN KEY (sillon_sillon_medida_num) REFERENCES Sillon_Medida(sillon_med_id),
    FOREIGN KEY (sillon_tela_num) REFERENCES Tela(tela_numero),
    FOREIGN KEY (sillon_madera_num) REFERENCES Madera(madera_numero),
    FOREIGN KEY (sillon_relleno_num) REFERENCES Relleno(relleno_num);

ALTER TABLE Material_Sillon
ADD FOREIGN KEY (mat_sill_material) REFERENCES Material(material_numero),
    FOREIGN KEY (mat_sill_sillon) REFERENCES Sillon(sillon_codigo);

-- BLOQUE 6 – Detalle de pedido

ALTER TABLE Detalle_Pedido
ADD FOREIGN KEY (detalle_p_pedido_numero) REFERENCES Pedido(pedido_numero),
    FOREIGN KEY (detalle_p_sillon_numero) REFERENCES Sillon(sillon_codigo);


-- BLOQUE 7 – Compra y proveedores

ALTER TABLE Compra
ADD FOREIGN KEY (compra_proved_num) REFERENCES Proveedor(proved_num),
    FOREIGN KEY (compra_sucursalNum) REFERENCES Sucursal(sucursal_numero);

ALTER TABLE Detalle_Compra
ADD FOREIGN KEY (detalle_comp_compra_num) REFERENCES Compra(compra_numero),
    FOREIGN KEY (detalle_comp_material) REFERENCES Material(material_numero);

/*
Msg 1769, Level 16, State 1, Line 269
Foreign key 'detalle_comp_compra_num' references invalid column 'detalle_comp_compra_num' in referencing table 'Detalle_Compra'.
Msg 1750, Level 16, State 0, Line 269
Could not create constraint or index. See previous errors.
*/


-- BLOQUE 7 – Detalle y Compra
DROP TABLE IF EXISTS Detalle_Compra;
DROP TABLE IF EXISTS Compra;

-- BLOQUE 6 – Detalle de pedido
DROP TABLE IF EXISTS Detalle_Pedido;

-- BLOQUE 5 – Material-Sillon y Sillon
DROP TABLE IF EXISTS Material_Sillon;
DROP TABLE IF EXISTS Sillon;

-- BLOQUE 4 – Envío
DROP TABLE IF EXISTS Envio;

-- BLOQUE 3 – Detalle Factura y Factura
DROP TABLE IF EXISTS Detalle_Factura;
DROP TABLE IF EXISTS Factura;

-- BLOQUE 2 – Pedido Cancelación y Pedido
DROP TABLE IF EXISTS Pedido_Cancelacion;
DROP TABLE IF EXISTS Pedido;

-- BLOQUE 1 – Cliente, Proveedor, Sucursal, Direccion, Localidad, Provincia, Contacto
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Proveedor;
DROP TABLE IF EXISTS Sucursal;
DROP TABLE IF EXISTS Direccion;
DROP TABLE IF EXISTS Localidad;
DROP TABLE IF EXISTS Provincia;
DROP TABLE IF EXISTS Contacto;

-- Extras – Catálogos y auxiliares
DROP TABLE IF EXISTS Estado;
DROP TABLE IF EXISTS Tela;
DROP TABLE IF EXISTS Madera;
DROP TABLE IF EXISTS Relleno;
DROP TABLE IF EXISTS Material;
DROP TABLE IF EXISTS Sillon_Modelo;
DROP TABLE IF EXISTS Sillon_Medida;
