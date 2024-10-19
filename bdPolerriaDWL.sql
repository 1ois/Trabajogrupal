use master
go
 if exists (select *from sys.databases where name='bdPolleriaDWL')
Begin
 alter database bdPolleriaDWL set single_user
 with rollback immediate
 END

 go
 if exists (select*from sys.databases where name='bdPolleriaDWL')
 Begin

 use master
 drop database bdPolleriaDWL
 end 
 go


 create database bdPolleriaDWL
 go

use bdPolleriaDWL 
go


-- Tabla Producto Cargo
Create table cargo(
codcargo int primary key identity(1,1),
nomcargo varchar(50) not  null,
descargo varchar(50) not null,
salacargo decimal(10,2) not null,
turncargo varchar(50) not null,
horencargo time not null,
horsalcargo time not null,
)

-- Tabla Producto
CREATE TABLE Producto (
    codPro INT PRIMARY KEY IDENTITY(1,1),
    nompro VARCHAR(99) NOT NULL,
    despro VARCHAR(99) NOT NULL,
    prepro DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    catepro VARCHAR(99) NOT NULL
);

-- Tabla Empleado
CREATE TABLE Empleado (
    codemple INT PRIMARY KEY IDENTITY(1,1),
    nomemple VARCHAR(50) NOT NULL,
    apeemple VARCHAR(50) NOT NULL,
    dniemple VARCHAR(8) NOT NULL,
	codcargo int not null,
    feccontrato DATE NOT NULL,
    telefono VARCHAR(9) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    estemple BIT NOT NULL
FOREIGN KEY (codcargo) REFERENCES cargo(codcargo),
);

-- Tabla Cliente
CREATE TABLE Cliente (
    codcli INT PRIMARY KEY IDENTITY(1,1),
    nomcli VARCHAR(50) NOT NULL,
    apecli VARCHAR(50) NOT NULL,
    dnicli VARCHAR(50) NOT NULL,
    telecli VARCHAR(50) NOT NULL,
    direcli VARCHAR(50) NOT NULL,
    correocli VARCHAR(50) NOT NULL,
    estcli BIT NOT NULL
);

create table sede(
codsede int primary key identity(1,1),
distrito varchar(50) not null,
referencia varchar(50) not null,
horatesede  time not null, ----horario de atencion de la sede

)

-- Tabla Venta (agregamos las llaves foráneas para Cliente y Empleado)
CREATE TABLE Venta (
    codven INT PRIMARY KEY IDENTITY(1,1),
    codcli INT NOT NULL,
    codemple INT NOT NULL,
    fecven DATE NOT NULL,
	codsede int not null,
    estven varchar(50) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    dsct DECIMAL(10,2) NOT NULL,
    igv DECIMAL(10,2) NOT NULL,
    costdelibery DECIMAL(10,2) NOT NULL,
    montotal DECIMAL(10,2) NOT NULL,
    tpentregave VARCHAR(50) NOT NULL,
    tppago VARCHAR(50) NOT NULL,
    tpventa VARCHAR(50) NOT NULL,
    -- Llaves foráneas
FOREIGN KEY (codcli) REFERENCES Cliente(codcli),
FOREIGN KEY (codemple) REFERENCES Empleado(codemple)
);

-- Tabla DetalleVenta (agregamos las llaves foráneas para Producto y Venta)
CREATE TABLE DetalleVenta (
    coddetaven INT PRIMARY KEY IDENTITY(1,1),
    codpro INT NOT NULL,
    codven INT NOT NULL,
    desdetven VARCHAR(50) NOT NULL,
    cantdetven INT NOT NULL,
    preunidetven DECIMAL(10,2) NOT NULL,
    subtotaldetven DECIMAL(10,2),
    -- Llaves foráneas
FOREIGN KEY (codpro) REFERENCES Producto(codPro),
FOREIGN KEY (codven) REFERENCES Venta(codven)
);

-- Tabla Costo (agregamos la llave foránea para Producto)
CREATE TABLE Costo (
    codcost INT PRIMARY KEY IDENTITY(1,1),
    impcost DECIMAL(10,2) NOT NULL,
    codpro INT NOT NULL,
    -- Llave foránea
    CONSTRAINT fk_costo_producto FOREIGN KEY (codpro) REFERENCES Producto(codPro)
);

-- Tabla Proveedor
CREATE TABLE Proveedor (
    codprovee INT PRIMARY KEY IDENTITY(1,1),
    nomprovee VARCHAR(50) NOT NULL,
    apeprovee VARCHAR(50) NOT NULL,
    rucprovee VARCHAR(10) NOT NULL,
    dirprovee VARCHAR(50) NOT NULL,
    corprovee VARCHAR(50) NOT NULL,
    telprovee VARCHAR(9) NOT NULL,
    estprovee BIT NOT NULL
);

-- Tabla Insumo (agregamos la llave foránea para Proveedor)
CREATE TABLE Insumo (
    codinsu INT PRIMARY KEY IDENTITY(1,1),
    codprovee INT NOT NULL,
    nominsu VARCHAR(50) NOT NULL,
    caninsu DECIMAL(10,2) NOT NULL,
    udinsu VARCHAR(50) NOT NULL, -- Unidad de medida
    preuninsu DECIMAL(10,2) NOT NULL, -- Precio unitario
    fecompra DATE NOT NULL,
    fecvenci DATE NOT NULL,
    -- Llave foránea
FOREIGN KEY (codprovee) REFERENCES Proveedor(codprovee)
);

-- Tabla DetalleInsumo (agregamos las llaves foráneas para Insumo y Producto)
CREATE TABLE DetalleInsumo (
    coddetains INT PRIMARY KEY IDENTITY(1,1),
    codinsu INT NOT NULL,
    codpro INT NOT NULL,
    cantinsu DECIMAL(10,2) NOT NULL,
    -- Llaves foráneas
    CONSTRAINT fk_detalleinsumo_insumo FOREIGN KEY (codinsu) REFERENCES Insumo(codinsu),
    CONSTRAINT fk_detalleinsumo_producto FOREIGN KEY (codpro) REFERENCES Producto(codPro)
)


INSERT INTO Cargo (nomcargo, descargo, salacargo, turncargo, horencargo, horsalcargo)
VALUES
('Cocinero', 'Responsable de la preparación de alimentos', 1025.00, 'Mañana', '08:00:00', '16:00:00'),
('Cajero', 'Atención al cliente y manejo de caja', 1025.00, 'Tarde', '12:00:00', '20:00:00'),
('Mesero', 'Servicio a las mesas y atención al cliente', 1025.00, 'Noche', '16:00:00', '00:00:00'),
('Supervisor', 'Supervisión del personal y operaciones', 1025.00, 'Mañana', '07:00:00', '15:00:00'),
('Limpiador', 'Encargado de la limpieza del local', 1025.00, 'Tarde', '13:00:00', '21:00:00');


INSERT INTO Producto (nompro, despro, prepro, stock, catepro)
VALUES
('Pollo a la Brasa Entero', 'Pollo marinado cocinado a las brasas', 50.00, 100, 'Comida'),
('Cuarto de Pollo', 'Cuarto de pollo a la brasa con papas', 15.00, 200, 'Comida'),
('Pollo con Ensalada', 'Medio pollo a la brasa con ensalada', 30.00, 150, 'Comida'),
('Inka Kola 500ml', 'Bebida gaseosa Inka Kola', 5.00, 300, 'Bebida'),
('Chicha Morada 1L', 'Bebida tradicional de maíz morado', 10.00, 250, 'Bebida');

-- Insertando 5 registros de ejemplo
INSERT INTO Proveedor (nomprovee, apeprovee, rucprovee, dirprovee, corprovee, telprovee, estprovee)
VALUES 
('Juan', 'Perez', '1234567890', 'Av. Los Robles 123', 'juan.perez@email.com', '987654321', 1),
('Maria', 'Lopez', '0987654321', 'Calle Las Flores 456', 'maria.lopez@email.com', '912345678', 1),
('Carlos', 'Gomez', '1122334455', 'Jr. San Martin 789', 'carlos.gomez@email.com', '923456789', 1),
('Luisa', 'Ramirez', '2233445566', 'Av. Los Olivos 321', 'luisa.ramirez@email.com', '934567890', 1),
('Ana', 'Diaz', '3344556677', 'Calle Las Amapolas 654', 'ana.diaz@email.com', '945678901', 0);

INSERT INTO Empleado (nomemple, apeemple, dniemple, codcargo, feccontrato, telefono, direccion, estemple)
VALUES
('Juan', 'Pérez', '12345678', 1, '2022-01-10', '987654321', 'Calle 1, Chaclacayo', 1),
('María', 'Lopez', '87654321', 2, '2023-02-15', '987654322', 'Calle 2, Santa Clara', 1),
('Pedro', 'González', '11223344', 3, '2021-03-12', '987654323', 'Calle 3, San Isidro', 1),
('Ana', 'Torres', '22334455', 4, '2022-04-20', '987654324', 'Calle 4, Chaclacayo', 1),
('Luis', 'Rodríguez', '33445566', 5, '2023-05-18', '987654325', 'Calle 5, San Isidro', 1);

INSERT INTO Cliente (nomcli, apecli, dnicli, telecli, direcli, correocli, estcli)
VALUES
('Carlos', 'Ramos', '10111213', '999888777', 'Av. Primavera 123, Lima', 'carlos.ramos@example.com', 1),
('Lucía', 'Fernandez', '20212223', '998877665', 'Jr. Libertad 456, Chaclacayo', 'lucia.fernandez@example.com', 1),
('Andrés', 'Mendoza', '30313233', '997766554', 'Av. El Sol 789, Santa Clara', 'andres.mendoza@example.com', 1),
('Sofía', 'Martínez', '40414243', '996655443', 'Av. Benavides 456, San Isidro', 'sofia.martinez@example.com', 1),
('Ricardo', 'Gómez', '50515253', '995544332', 'Calle Los Olivos 123, San Isidro', 'ricardo.gomez@example.com', 1);

INSERT INTO Venta (codcli, codemple, codsede, fecven, estven, subtotal, dsct, igv, costdelibery, montotal, tpentregave, tppago, tpventa)
VALUES
(1, 1, 1, '2024-10-01', 'entregado', 100.00, 5.00, 18.00, 10.00, 123.00, 'Recoger en tienda', 'Tarjeta', 'Presencial'),
(2, 2, 2, '2024-10-05', 'pendiente', 50.00, 3.00, 9.00, 0.00, 56.00, 'Delivery', 'Efectivo', 'Online'),
(3, 3, 3, '2024-10-10', 'cancelado', 150.00, 10.00, 27.00, 15.00, 182.00, 'Recoger en tienda', 'Tarjeta', 'Presencial'),
(4, 4, 1, '2024-10-12', 'entregado', 75.00, 4.00, 13.50, 8.00, 92.50, 'Delivery', 'Efectivo', 'Online'),
(5, 5, 3, '2024-10-15', 'pendiente', 200.00, 15.00, 36.00, 12.00, 233.00, 'Recoger en tienda', 'Tarjeta', 'Presencial');

-- Insertando 5 registros en la tabla Insumo
INSERT INTO Insumo (codprovee, nominsu, caninsu, udinsu, preuninsu, fecompra, fecvenci)
VALUES
(1, 'Harina de Trigo', 100.00, 'kg', 3.50, '2024-10-01', '2025-10-01'),
(2, 'Azúcar', 50.00, 'kg', 2.80, '2024-09-15', '2025-09-15'),
(3, 'Aceite de Girasol', 200.00, 'litros', 5.00, '2024-10-05', '2025-04-05'),
(4, 'Pollo Entero', 75.00, 'unidades', 12.00, '2024-10-10', '2024-10-20'),
(5, 'Leche Evaporada', 120.00, 'latas', 1.50, '2024-10-01', '2025-02-01');

INSERT INTO DetalleVenta (codpro, codven, desdetven, cantdetven, preunidetven, subtotaldetven)
VALUES
(1, 1, 'Pollo a la Brasa Entero', 2, 50.00, 100.00),
(2, 2, 'Cuarto de Pollo', 3, 15.00, 45.00),
(3, 3, 'Pollo con Ensalada', 5, 30.00, 150.00),
(4, 4, 'Inka Kola 500ml', 10, 5.00, 50.00),
(5, 5, 'Chicha Morada 1L', 5, 10.00, 50.00);

INSERT INTO Sede (distrito, referencia, horatesede)
VALUES
('Chaclacayo', 'Av. Los Sauces 150', '09:00:00'),
('Santa Clara', 'Av. Las Flores 200', '10:00:00'),
('San Isidro', 'Av. Javier Prado 2500', '08:00:00');
-- Insertando 5 registros en la tabla DetalleInsumo
INSERT INTO DetalleInsumo (codinsu, codpro, cantinsu)
VALUES
(1, 1, 20.00), -- Harina de Trigo para Pan de Molde
(2, 2, 10.00), -- Azúcar para Galletas
(3, 3, 15.00), -- Aceite de Girasol para Torta de Chocolate
(4, 4, 5.00),  -- Pollo Entero para Pollo a la Brasa
(5, 5, 10.00); -- Leche Evaporada para Leche con Café


SELECT * FROM Sede;
SELECT * FROM Producto;
SELECT * FROM Empleado;
SELECT * FROM Cliente;
SELECT * FROM Proveedor;
SELECT * FROM Insumo;
SELECT * FROM DetalleInsumo;
SELECT * FROM DetalleVenta;
SELECT * FROM Venta;
