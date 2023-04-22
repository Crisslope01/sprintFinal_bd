--creacion de schema--

CREATE SCHEMA telovendo;

--Creacion de  usuario con privilegios para crear, eliminar y modificar tablas, insertar registros.--

CREATE ROLE dba WITH SUPERUSER;
GRANT USAGE ON SCHEMA telovendo TO dba;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA telovendo TO dba WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA telovendo TO dba WITH GRANT OPTION;
CREATE USER administrador WITH 	PASSWORD '12345' IN ROLE dba;

--CREACION DE TABLAS--
--PRODUCTOS PROVEEDORES PRODUCTOS--

--CREACION DE DOMINIOS, (para no utilizar un id autoincrementable, le doy ,i propia notacion con esta herramienta)--

CREATE DOMAIN telovendo.ID_PRODUCTOS AS CHAR(7) NOT NULL
    CHECK (VALUE ~ '^[PR]{2}[-]{1}\d{4}$'); --PR-0001, esta es la notacion de como quedarian--
	
CREATE DOMAIN telovendo.ID_PROVEEDOR AS CHAR(7) NOT NULL 
    CHECK (VALUE ~ '^[PV]{2}[-]{1}\d{4}$'); --PV-0001

CREATE DOMAIN telovendo.ID_Cliente AS CHAR(7) NOT NULL
	CHECK (VALUE ~ '^[CL]{2}[-]{1}\d{4}$'); --CL-0001

CREATE DOMAIN telovendo.ID_PROVEEDOR_PRODUCTO AS CHAR(7) NOT NULL
	CHECK (VALUE ~ '^[PP]{2}[-]{1}\d{4}$'); --PP-0001


--CREACION DE TABLAS--
	
CREATE TABLE telovendo.CLIENTE(
	pk_idCliente telovendo.ID_CLIENTE,
	nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL UNIQUE,
	PRIMARY KEY (pk_idCliente)
);
	
CREATE TABLE telovendo.PRODUCTOS(
	pk_idProducto telovendo.ID_PRODUCTOS,
    precio DECIMAL(10,2) NOT NULL,
	nombre VARCHAR (50) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    color VARCHAR(50) NOT NULL,
	STOCK DECIMAL(10,1) NOT NULL,
	PRIMARY KEY (pk_idProducto)
	);
	
CREATE TABLE telovendo.PROVEEDOR_PRODUCTO(
	fk_idProveedor telovendo.ID_PROVEEDOR,
	fk_idProducto telovendo.ID_PRODUCTOS,
	PRIMARY KEY(fk_idProveedor, fk_idProducto),
	FOREIGN KEY (fk_idProveedor) REFERENCES telovendo.PROVEEDORES (pk_idProveedor) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (fk_idProducto) REFERENCES telovendo.PRODUCTOS (pk_idProducto) ON UPDATE CASCADE ON DELETE CASCADE
);

SELECT * FROM telovendo.PROVEEDOR_PRODUCTO;

CREATE TABLE telovendo.PROVEEDORES(
	pk_idProveedor telovendo.ID_PROVEEDOR,
	fk_idProducto telovendo.ID_PRODUCTOS,
	nombre_rep_legal VARCHAR(50) NOT NULL,
    nombre_corporativo VARCHAR(50) NOT NULL,
    telefono1 VARCHAR(20) NOT NULL,
    telefono2 VARCHAR(20),
    nombre_contacto VARCHAR(50),
    categoria_producto VARCHAR(50) NOT NULL,
    correo_electronico VARCHAR(50) NOT NULL UNIQUE,
	PRIMARY KEY (pk_idProveedor),
	FOREIGN KEY (fk_idProducto) REFERENCES telovendo.PRODUCTOS (pk_idProducto)
	ON UPDATE CASCADE ON DELETE CASCADE
	);
	
INSERT INTO telovendo.CLIENTE (pk_idCliente, nombre, apellido, direccion) VALUES
('CL-0001', 'Juan', 'Pérez', 'Calle 123'),
('CL-0002', 'María', 'García', 'Avenida 456'),
('CL-0003', 'Pedro', 'López', 'Calle 789'),
('CL-0004', 'Ana', 'Martínez', 'Avenida 012'),
('CL-0005', 'Luis', 'Sánchez', 'Calle 345');

SELECT * FROM telovendo.CLIENTE;

INSERT INTO telovendo.PRODUCTOS(pk_idProducto, precio, nombre, categoria, color, STOCK) 
VALUES ('PR-0001', 99.99, 'Producto 1', 'Categoria 1', 'Rojo', 50),
       ('PR-0002', 199.99, 'Producto 2', 'Categoria 2', 'Azul', 25),
       ('PR-0003', 49.99, 'Producto 3', 'Categoria 1', 'Verde', 100),
       ('PR-0004', 149.99, 'Producto 4', 'Categoria 3', 'Negro', 10),
       ('PR-0005', 79.99, 'Producto 5', 'Categoria 2', 'Blanco', 75),
       ('PR-0006', 399.99, 'Producto 6', 'Categoria 1', 'Plateado', 5),
       ('PR-0007', 29.99, 'Producto 7', 'Categoria 2', 'Morado', 200),
       ('PR-0008', 89.99, 'Producto 8', 'Categoria 3', 'Amarillo', 40),
       ('PR-0009', 149.99, 'Producto 9', 'Categoria 1', 'Dorado', 15),
       ('PR-0010', 59.99, 'Producto 10', 'Categoria 2', 'Gris', 50);
	
INSERT INTO telovendo.PRODUCTOS(pk_idProducto, precio, nombre, categoria, color, STOCK) 
VALUES ('PR-0011', 150.99, 'Producto 11', 'Categoria 1', 'Verde', 150);
	   
SELECT * FROM telovendo.PRODUCTOS;

INSERT INTO telovendo.PROVEEDORES (pk_idProveedor, fk_idProducto, nombre_rep_legal, nombre_corporativo, telefono1, telefono2, nombre_contacto, categoria_producto, correo_electronico)
VALUES
('PV-0001', 'PR-0001', 'Juan Perez', 'ABC Corporation', '555-1234', '555-5678', 'Maria Gomez', 'Electrónica', 'jperez@abccorp.com'),
('PV-0002', 'PR-0003', 'Ana Rodriguez', 'DEF Inc.', '555-4321', NULL, 'Pedro Hernandez', 'Hogar', 'arodriguez@definc.com'),
('PV-0003', 'PR-0005', 'Luis Sanchez', 'GHI S.A.', '555-1111', '555-2222', 'Sara Torres', 'Electrónica', 'lsanchez@ghisa.com'),
('PV-0004', 'PR-0010', 'Carlos Ramirez', 'JKL Corp.', '555-7777', NULL, 'Fernando Castro', 'Deportes', 'cramirez@jklcorp.com'),
('PV-0005', 'PR-0005', 'Martha Gomez', 'MNO Industries', '555-9999', NULL, 'David Hernandez', 'Hogar', 'mgomez@mnoind.com');

SELECT * FROM telovendo.PROVEEDORES;
--insertar datos en la tabla proveedor_producto---
	   
INSERT INTO telovendo.PROVEEDOR_PRODUCTO (fk_idProveedor, fk_idProducto) VALUES ('PV-0001', 'PR-0001');
INSERT INTO telovendo.PROVEEDOR_PRODUCTO (fk_idProveedor, fk_idProducto) VALUES ('PV-0002', 'PR-0002');
INSERT INTO telovendo.PROVEEDOR_PRODUCTO (fk_idProveedor, fk_idProducto) VALUES ('PV-0003', 'PR-0003');   
INSERT INTO telovendo.PROVEEDOR_PRODUCTO (fk_idProveedor, fk_idProducto) VALUES ('PV-0004', 'PR-0004');
INSERT INTO telovendo.PROVEEDOR_PRODUCTO (fk_idProveedor, fk_idProducto) VALUES ('PV-0005', 'PR-0005');
INSERT INTO telovendo.PROVEEDOR_PRODUCTO (fk_idProveedor, fk_idProducto) VALUES ('PV-0001', 'PR-0006');
INSERT INTO telovendo.PROVEEDOR_PRODUCTO (fk_idProveedor, fk_idProducto) VALUES ('PV-0002', 'PR-0007');   
INSERT INTO telovendo.PROVEEDOR_PRODUCTO (fk_idProveedor, fk_idProducto) VALUES ('PV-0003', 'PR-0008');
INSERT INTO telovendo.PROVEEDOR_PRODUCTO (fk_idProveedor, fk_idProducto) VALUES ('PV-0004', 'PR-0009');
INSERT INTO telovendo.PROVEEDOR_PRODUCTO (fk_idProveedor, fk_idProducto) VALUES ('PV-0005', 'PR-0010');
INSERT INTO telovendo.PROVEEDOR_PRODUCTO (fk_idProveedor, fk_idProducto) VALUES ('PV-0001', 'PR-0011');
INSERT INTO telovendo.PROVEEDOR_PRODUCTO (fk_idProveedor, fk_idProducto) VALUES ('PV-0001', 'PR-0002');
INSERT INTO telovendo.PROVEEDOR_PRODUCTO (fk_idProveedor, fk_idProducto) VALUES ('PV-0001', 'PR-0003');

--PARA OBTENER LA CATEGORIA DE PRODUCTO QUE MAS SE REPITE EN UNA TABLA POSTGRESQL--

SELECT categoria, COUNT(*) as cantidad --cantidad es el nombre que colocamos a la tabla de la consulta
FROM telovendo.PRODUCTOS --desde la tabla productos
GROUP BY categoria --agrupa por categoria
ORDER BY cantidad DESC  --ordena descendentemente
LIMIT 1;
--la respuesta es la "categoria 2" que se repite 4 veces--

--Cuales son los productos con mayor stock---
SELECT nombre, categoria, STOCK --llamamos con select a las carpetas nombre y categoria desde la tabla PRODUCTOS--
FROM telovendo.PRODUCTOS
ORDER BY STOCK DESC --Ordenamos de forma desdente y limitamos por un rango, por ejemplo 5--
LIMIT 5;

--que color de producto es mas comun en nuestra tienda--
SELECT color, COUNT(*) AS CANTIDAD
FROM telovendo.PRODUCTOS
GROUP BY color
ORDER BY CANTIDAD DESC 
LIMIT 1;
--en este caso el color mas comun es el color verde con 2 repeticiones--

--Cual o cuales son los proveedores con menos stock de productos--

SELECT p.nombre_corporativo AS proveedor, SUM(pr.STOCK) AS stock_total
FROM telovendo.PROVEEDORES p
JOIN telovendo.PRODUCTOS pr
ON p.fk_idProducto = pr.pk_idProducto
GROUP BY p.nombre_corporativo
ORDER BY stock_total ASC
LIMIT 5;

--cambiar la categoria de productos mas popular por électronica y computacion--

SELECT categoria, COUNT(*) AS cantidad_productos
FROM telovendo.PRODUCTOS
GROUP BY categoria
ORDER BY cantidad_productos DESC
LIMIT 1;
--con esto sabemos que la categoria mas popular es la 1 con 5 repeticiones--

--ahora buscamos los productos de esta categoria
SELECT * FROM telovendo.PRODUCTOS WHERE categoria = 'Categoria 1';

--finalmente actualizamos estos registros de categoria 1 por "Electronica y computacion"
UPDATE telovendo.PRODUCTOS SET categoria = 'Electronica y computacion' WHERE pk_idProducto = 'PR-0001';
UPDATE telovendo.PRODUCTOS SET categoria = 'Electronica y computacion' WHERE pk_idProducto = 'PR-0003';
UPDATE telovendo.PRODUCTOS SET categoria = 'Electronica y computacion' WHERE pk_idProducto = 'PR-0006';
UPDATE telovendo.PRODUCTOS SET categoria = 'Electronica y computacion' WHERE pk_idProducto = 'PR-0009';
UPDATE telovendo.PRODUCTOS SET categoria = 'Electronica y computacion' WHERE pk_idProducto = 'PR-0011';

--realizamos la ultima consulta para comprobar que se guardaron los registros--
SELECT * FROM telovendo.PRODUCTOS 



