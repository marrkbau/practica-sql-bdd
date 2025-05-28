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
    provincia_id BIGINT not null PRIMARY KEY,
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
ADD FOREIGN KEY (localidad_provincia) REFERENCES Provincia(provincia_id);

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



/*
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

*/
DELETE FROM Provincia;



-- Provincias
INSERT INTO Provincia (provincia_id, provincia_nombre)
SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Sucursal_Provincia) AS provincia_id, Sucursal_Provincia
FROM gd_esquema.Maestra;

-- Localidades
WITH loc AS (
    SELECT DISTINCT Sucursal_Localidad, Sucursal_Provincia
    FROM gd_esquema.Maestra
)
INSERT INTO Localidad (localidad_num, localidad_provincia, localidad_nombre)
SELECT ROW_NUMBER() OVER (ORDER BY Sucursal_Localidad), -- Asigna un ID artificial
       p.provincia_id,
       l.Sucursal_Localidad
FROM loc l
JOIN Provincia p ON p.provincia_nombre = l.Sucursal_Provincia;

-- Direcciones
INSERT INTO Direccion (dire_numero, direccion_localidad_num, dire_direccion)
SELECT ROW_NUMBER() OVER (ORDER BY Sucursal_Direccion), l.localidad_num, Sucursal_Direccion
FROM (SELECT DISTINCT Sucursal_Direccion, Sucursal_Localidad FROM gd_esquema.Maestra) m
JOIN Localidad l ON l.localidad_nombre = m.Sucursal_Localidad;

-- Contactos
INSERT INTO Contacto (contacto_num, contacto_mail, contacto_telefono)
SELECT ROW_NUMBER() OVER (ORDER BY Sucursal_mail), Sucursal_mail, Sucursal_telefono
FROM (SELECT DISTINCT Sucursal_mail, Sucursal_telefono FROM gd_esquema.Maestra) x;

-- Clientes
INSERT INTO Cliente (cliente_numero, cliente_direccion_num, cliente_contacto_num, cliente_dni, cliente_nombre, cliente_apellido, cliente_fechaNacimiento)
SELECT ROW_NUMBER() OVER (ORDER BY Cliente_Dni), d.dire_numero, c.contacto_num, Cliente_Dni, Cliente_Nombre, Cliente_Apellido, Cliente_FechaNacimiento
FROM gd_esquema.Maestra m
JOIN Direccion d ON d.dire_direccion = m.Cliente_Direccion
JOIN Contacto c ON c.contacto_mail = m.Cliente_Mail AND c.contacto_telefono = m.Cliente_Telefono
GROUP BY Cliente_Dni, Cliente_Nombre, Cliente_Apellido, Cliente_FechaNacimiento, Cliente_Direccion, Cliente_Mail, Cliente_Telefono;

-- Sucursales
INSERT INTO Sucursal (sucursal_numero, sucursal_direccion_num, sucursal_contacto_num)
SELECT ROW_NUMBER() OVER (ORDER BY Sucursal_NroSucursal), d.dire_numero, c.contacto_num
FROM gd_esquema.Maestra m
JOIN Direccion d ON d.dire_direccion = m.Sucursal_Direccion
JOIN Contacto c ON c.contacto_mail = m.Sucursal_mail AND c.contacto_telefono = m.Sucursal_telefono
GROUP BY Sucursal_NroSucursal, Sucursal_Direccion, Sucursal_mail, Sucursal_telefono;

-- Estado
INSERT INTO Estado (estado_numero, estado_descripcion)
SELECT DISTINCT ROW_NUMBER() OVER (ORDER BY Pedido_Estado), Pedido_Estado
FROM gd_esquema.Maestra;

-- Pedidos
INSERT INTO Pedido (pedido_numero, pedido_cliente_num, pedido_sucursal_num, pedido_estado_num)
SELECT Pedido_Numero, 
       c.cliente_numero, 
       s.sucursal_numero,
       e.estado_numero
FROM gd_esquema.Maestra m
JOIN Cliente c ON c.cliente_dni = m.Cliente_Dni
JOIN Sucursal s ON s.sucursal_numero = m.Sucursal_NroSucursal
JOIN Estado e ON e.estado_descripcion = m.Pedido_Estado;

INSERT INTO Envio (envio_numero, envio_pedido_num, envio_fecha, envio_fecha_programada, envio_importeTraslado, envio_importeSubida)
SELECT Envio_Numero, Pedido_Numero, Envio_Fecha, Envio_Fecha_Programada, Envio_ImporteTraslado, Envio_ImporteSubida
FROM gd_esquema.Maestra;

INSERT INTO Factura (fact_numero, fact_sucursal_num, fact_cliente_num, fact_fecha, fact_total)
SELECT DISTINCT Factura_Numero, s.sucursal_numero, c.cliente_numero, Factura_Fecha, Factura_Total
FROM gd_esquema.Maestra m
JOIN Sucursal s ON s.sucursal_numero = m.Sucursal_NroSucursal
JOIN Cliente c ON c.cliente_dni = m.Cliente_Dni;

INSERT INTO Detalle_Pedido (detalle_p_pedido_numero, detalle_p_numero, detalle_p_sillon_numero, detalle_p_cantidad, detalle_p_precio)
SELECT Pedido_Numero, ROW_NUMBER() OVER (PARTITION BY Pedido_Numero ORDER BY Sillon_Codigo),
       Sillon_Codigo, Detalle_Pedido_Cantidad, Detalle_Pedido_Precio
FROM gd_esquema.Maestra;

-- Similar para Detalle_Factura

select distinct Pedido_Estado from gd_esquema.Maestra

select distinct Sucursal_Provincia from gd_esquema.Maestra 
-- prov localidad




-- ROW_NUMBER() es una función de ventana en T-SQL que asigna un número incremental único a cada fila dentro de un conjunto de resultados, empezando desde 1.

-- Estado
INSERT INTO Estado (estado_numero, estado_descripcion) Values
(1, 'PENDIENTE'),
(2, 'ENTREGADO'),
(3, 'CANCELADO')

--Provincia
INSERT INTO Provincia (provincia_id, provincia_nombre)
SELECT DISTINCT ROW_NUMBER() over (ORDER by provincia_nombre) as provincia_id,
    provincia_nombre 
    from (
        select distinct Cliente_Provincia from gd_esquema.Maestra
        union
        select distinct Sucursal_Provincia from gd_esquema.Maestra
        union 
        select distinct Proveedor_Provincia from gd_esquema.Maestra
    ) as provincias(provincia_nombre)

-- Localidad
insert into localidad (localidad_num, localidad_provincia, localidad_nombre)
select 
row_number() over (order by localidad_nombre) as localidad_num,
localidad_provincia,
localidad_nombre
from (
    select distinct cliente_localidad, cliente_provincia from gd_esquema.Maestra
    union
    select distinct sucursal_localidad, sucursal_provincia from gd_esquema.Maestra
    union
    select distinct proveedor_localidad, proveedor_provincia from gd_esquema.Maestra
) as localidades(localidad_nombre, localidad_provincia)
join provincia on localidad_provincia = provincia_id


INSERT INTO Localidad (
    localidad_num,
    localidad_provincia,
    localidad_nombre
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY subconsulta.localidad_nombre) AS localidad_num,
    Provincia.provincia_id,
    subconsulta.localidad_nombre
FROM (
    SELECT DISTINCT 
        cliente_localidad AS localidad_nombre, 
        cliente_provincia AS provincia_nombre
    FROM gd_esquema.Maestra
    UNION
    SELECT DISTINCT 
        sucursal_localidad AS localidad_nombre, 
        sucursal_provincia AS provincia_nombre
    FROM gd_esquema.Maestra
    UNION
    SELECT DISTINCT 
        proveedor_localidad AS localidad_nombre, 
        proveedor_provincia AS provincia_nombre
    FROM gd_esquema.Maestra
) AS subconsulta
JOIN Provincia 
    ON subconsulta.provincia_nombre = Provincia.provincia_nombre;

    
-- Material
INSERT INTO Material (material_numero, material_nombre, material_tipo, material_descripcion, material_precio)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Material_nombre) AS material_numero,
    Material_nombre,
    Material_tipo,
    Material_descripcion,
    Material_precio
FROM (
    SELECT DISTINCT
        Material_nombre,
        Material_tipo,
        Material_descripcion,
        Material_precio
    FROM gd_esquema.Maestra
) AS materiales_unicos;

-- Madera
INSERT INTO Madera (madera_numero, madera_color, madera_dureza) 
SELECT DISTINCT material_numero,
    Madera_Color,
    Madera_Dureza
    FROM gd_esquema.Maestra
    JOIN Material 
    ON Material.material_nombre = gd_esquema.Maestra.Material_Nombre
    AND Material.material_tipo = gd_esquema.Maestra.Material_Tipo
    where Material.material_tipo = 'Madera';


-- Sillon modelo
INSERT INTO Sillon_Modelo (
    sillon_mod_codigo, 
    sillon_modelo, 
    sillon_mod_descripcion, 
    silon_mod_precio
)
SELECT 
    Sillon_Modelo_codigo as codigo,
    Sillon_Modelo AS modelo,
    Sillon_Modelo_Descripcion AS descripcion,
    Sillon_Modelo_Precio AS precio
FROM (
    SELECT DISTINCT 
        Sillon_Modelo_Codigo,
        Sillon_Modelo,
        Sillon_Modelo_Descripcion,
        Sillon_Modelo_Precio
    FROM gd_esquema.Maestra
    WHERE Sillon_Modelo IS NOT NULL
) AS modelos_distintos;

-- Sillon medidas
INSERT INTO Sillon_Medida (
    sillon_med_id, 
    sillon_med_ancho, 
    sillon_med_alto, 
    sillon_med_profundidad,
    sillon_med_precio
)
SELECT 
    ROW_NUMBER() over (order by sillon_med_precio) as sillon_med_id,
    sillon_medida_ancho,
    sillon_medida_alto,
    sillon_medida_profundidad,
    sillon_medida_precio
FROM (
    SELECT DISTINCT 
        Sillon_Medida_Ancho,
        sillon_medida_alto,
        Sillon_Medida_Profundidad,
        sillon_medida_precio
    FROM gd_esquema.Maestra
    WHERE Sillon_Modelo IS NOT NULL
) AS medidas_distintas;

INSERT INTO Sillon_Medida (
    sillon_med_id, 
    sillon_med_ancho, 
    sillon_med_alto, 
    sillon_med_profundidad,
    sillon_med_precio
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY sillon_medida_precio) AS sillon_med_id,
    sillon_medida_ancho,
    sillon_medida_alto,
    sillon_medida_profundidad,
    sillon_medida_precio
FROM (
    SELECT DISTINCT 
        Sillon_Medida_Ancho AS sillon_medida_ancho,
        Sillon_Medida_Alto AS sillon_medida_alto,
        Sillon_Medida_Profundidad AS sillon_medida_profundidad,
        Sillon_Medida_Precio AS sillon_medida_precio
    FROM gd_esquema.Maestra
    WHERE Sillon_Modelo IS NOT NULL
) AS medidas_distintas;


-- Contacto
INSERT INTO Contacto(
    contacto_num,
    contacto_mail,
    contacto_telefono
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY contacto_mail) as contacto_num,
    contacto_mail,
    contacto_telefono
FROM (
    SELECT DISTINCT Sucursal_mail AS contacto_mail, 
                    Sucursal_telefono AS contacto_telefono
    FROM gd_esquema.Maestra

    UNION

    SELECT DISTINCT Cliente_Mail AS contacto_mail, 
                    Cliente_Telefono AS contacto_telefono
    FROM gd_esquema.Maestra

    UNION

    SELECT DISTINCT Proveedor_mail AS contacto_mail, 
                    Proveedor_telefono AS contacto_telefono
    FROM gd_esquema.Maestra
    
) AS contactos;
