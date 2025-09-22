-- =============================================
-- CREACIÓN DE TABLAS
-- =============================================

DROP TABLE IF EXISTS Detalle_Compras;
DROP TABLE IF EXISTS Compras;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Categorias;
DROP TABLE IF EXISTS Clientes;

-- =============================================
-- TABLA CLIENTES
-- =============================================
CREATE TABLE Clientes (
    Id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
    Nombre_cliente TEXT NOT NULL,
    Apellido_cliente TEXT NOT NULL,
    Email_cliente TEXT UNIQUE,
    Telefono_cliente TEXT,
    Direccion_cliente TEXT,
    Fecha_registro TEXT DEFAULT (date('now'))
);

-- =============================================
-- TABLA CATEGORÍAS
-- =============================================
CREATE TABLE Categorias (
    Id_categoria INTEGER PRIMARY KEY AUTOINCREMENT,
    Nombre_categoria TEXT NOT NULL,
    Descripcion_categoria TEXT,
    Fecha_creacion TEXT DEFAULT (date('now'))
);

-- =============================================
-- TABLA PRODUCTOS
-- =============================================
CREATE TABLE Productos (
    Id_producto INTEGER PRIMARY KEY AUTOINCREMENT,
    Nombre_producto TEXT NOT NULL,
    Descripcion_producto TEXT,
    Precio REAL NOT NULL,
    Stock_actual INTEGER NOT NULL DEFAULT 0,
    Stock_minimo INTEGER NOT NULL DEFAULT 0,
    Id_categoria INTEGER NOT NULL,
    FOREIGN KEY (Id_categoria) REFERENCES Categorias(Id_categoria)
);

-- =============================================
-- TABLA COMPRAS
-- =============================================
CREATE TABLE Compras (
    Id_compra INTEGER PRIMARY KEY AUTOINCREMENT,
    Id_cliente INTEGER NOT NULL,
    Fecha_compra TEXT DEFAULT (date('now')),
    Total REAL NOT NULL DEFAULT 0,
    Estado TEXT NOT NULL DEFAULT 'Pendiente',
    FOREIGN KEY (Id_cliente) REFERENCES Clientes(Id_cliente)
);

-- =============================================
-- TABLA DETALLE COMPRAS
-- =============================================
CREATE TABLE Detalle_Compras (
    Id_detalle INTEGER PRIMARY KEY AUTOINCREMENT,
    Id_compra INTEGER NOT NULL,
    Id_producto INTEGER NOT NULL,
    Cantidad INTEGER NOT NULL,
    Precio REAL NOT NULL,
    Subtotal REAL GENERATED ALWAYS AS (Cantidad * Precio) VIRTUAL,
    FOREIGN KEY (Id_compra) REFERENCES Compras(Id_compra),
    FOREIGN KEY (Id_producto) REFERENCES Productos(Id_producto)
);

-- =============================================
-- TRIGGERS
-- =============================================

-- Disminuir stock al registrar detalle de compra
CREATE TRIGGER trg_update_stock
AFTER INSERT ON Detalle_Compras
FOR EACH ROW
BEGIN
    UPDATE Productos
    SET Stock_actual = Stock_actual - NEW.Cantidad
    WHERE Id_producto = NEW.Id_producto;
END;

-- Evitar compra si no hay stock suficiente
CREATE TRIGGER trg_check_stock
BEFORE INSERT ON Detalle_Compras
FOR EACH ROW
BEGIN
    SELECT 
    CASE
        WHEN (SELECT Stock_actual FROM Productos WHERE Id_producto = NEW.Id_producto) < NEW.Cantidad
        THEN RAISE(ABORT, 'Stock insuficiente para este producto')
    END;
END;

-- =============================================
-- DATOS DE PRUEBA
-- =============================================

INSERT INTO Clientes (Nombre_cliente, Apellido_cliente, Email_cliente, Telefono_cliente, Direccion_cliente)
VALUES 
('Juan', 'Pérez', 'juan@example.com', '555-1234', 'Zona 1'),
('María', 'López', 'maria@example.com', '555-5678', 'Zona 10');

INSERT INTO Categorias (Nombre_categoria, Descripcion_categoria)
VALUES 
('Bebidas', 'Bebidas frías y calientes'),
('Snacks', 'Botanas y galletas');

INSERT INTO Productos (Nombre_producto, Descripcion_producto, Precio, Stock_actual, Stock_minimo, Id_categoria)
VALUES
('Coca Cola 600ml', 'Refresco embotellado', 8.50, 100, 10, 1),
('Galletas Oreo', 'Galletas de chocolate rellenas', 12.00, 50, 5, 2);

INSERT INTO Compras (Id_cliente, Estado)
VALUES (1, 'Pendiente');

INSERT INTO Detalle_Compras (Id_compra, Id_producto, Cantidad, Precio)
VALUES (1, 1, 2, 8.50),
       (1, 2, 1, 12.00);

UPDATE Compras
SET Total = (SELECT SUM(Subtotal) FROM Detalle_Compras WHERE Id_compra = Compras.Id_compra);
