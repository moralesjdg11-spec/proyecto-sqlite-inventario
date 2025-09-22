# 📊 Base de Datos - Sistema de Inventario SQLite

## 🗂️ Tablas Principales

### **CLIENTES**
- **Campos importantes**: `Id_cliente` (PK), `Email_cliente` (UNIQUE), `Nombre_cliente`, `Apellido_cliente`
- **Propósito**: Gestión de clientes del sistema

### **CATEGORIAS** 
- **Campos importantes**: `Id_categoria` (PK), `Nombre_categoria`
- **Propósito**: Clasificación de productos

### **PRODUCTOS**
- **Campos importantes**: `Id_producto` (PK), `Nombre_producto`, `Precio`, `Stock_actual`, `Stock_minimo`, `Id_categoria` (FK)
- **Propósito**: Inventario de productos con control de stock

### **COMPRAS**
- **Campos importantes**: `Id_compra` (PK), `Id_cliente` (FK), `Total`, `Estado`, `Fecha_compra`
- **Propósito**: Registro de compras realizadas

### **DETALLE_COMPRAS**
- **Campos importantes**: `Id_compra` (FK), `Id_producto` (FK), `Cantidad`, `Precio`, `Subtotal` (VIRTUAL)
- **Propósito**: Detalles específicos de cada compra

## 🔒 Restricciones Principales

- **PKs**: Todas con `AUTOINCREMENT`
- **Email único**: `Clientes.Email_cliente` UNIQUE
- **FKs**: Integridad referencial entre todas las tablas
- **Control de Stock**: Triggers automáticos que validan y actualizan stock
- **Campos obligatorios**: Nombres, precios, cantidades (NOT NULL)

## ⚙️ Triggers Automáticos

- **Stock Control**: Reduce stock automáticamente al registrar compras
- **Stock Validation**: Previene compras sin stock suficiente

## 🔌 Connection String para C#

### **appsettings.json**
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Data Source=Database/inventario.sqlite"
  }
}
```

### **Program.cs - Entity Framework**
```csharp
builder.Services.AddDbContext<InventarioContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("DefaultConnection")));
```

### **Conexión directa ADO.NET**
```csharp
string connectionString = "Data Source=Database\\inventario.sqlite;Version=3;";
```

## 📁 Archivos de Base de Datos

- `schema.sql` - Script de creación completo
- `inventario.sqlite` - Base de datos funcional con datos de prueba
- Ubicación: `/Database/` en el repositorio
