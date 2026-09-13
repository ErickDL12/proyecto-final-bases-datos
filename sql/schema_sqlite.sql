-- Habilitar integridad referencial en SQLite
PRAGMA foreign_keys = ON;

-- 1. Tabla Negocio
CREATE TABLE IF NOT EXISTS negocio (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    telefono_whatsapp TEXT NOT NULL UNIQUE,
    direccion TEXT,
    configuracion_mensaje TEXT,
    creado_en TEXT NOT NULL DEFAULT (datetime('now', 'localtime'))
);

-- 2. Tabla Producto (Relación 1:N con Negocio)
CREATE TABLE IF NOT EXISTS producto (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    negocio_id INTEGER NOT NULL,
    nombre TEXT NOT NULL,
    precio_venta REAL NOT NULL CHECK (precio_venta >= 0),
    costo REAL NOT NULL CHECK (costo >= 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    activo INTEGER NOT NULL DEFAULT 1 CHECK (activo IN (0, 1)),
    creado_en TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (negocio_id) REFERENCES negocio(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 3. Tabla Cliente (Relación 1:N con Negocio)
CREATE TABLE IF NOT EXISTS cliente (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    negocio_id INTEGER NOT NULL,
    nombre TEXT NOT NULL,
    telefono TEXT NOT NULL,
    direccion TEXT,
    creado_en TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (negocio_id) REFERENCES negocio(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 4. Tabla Pedido (Relación 1:N con Cliente y Negocio)
CREATE TABLE IF NOT EXISTS pedido (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    negocio_id INTEGER NOT NULL,
    cliente_id INTEGER NOT NULL,
    fecha_pedido TEXT NOT NULL DEFAULT (datetime('now', 'localtime')),
    estado TEXT NOT NULL DEFAULT 'PENDIENTE' CHECK (estado IN ('PENDIENTE', 'CONFIRMADO', 'ENTREGADO', 'CANCELADO')),
    total REAL NOT NULL DEFAULT 0.0 CHECK (total >= 0),
    FOREIGN KEY (negocio_id) REFERENCES negocio(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 5. Tabla DetallePedido (Relación N:M entre Pedido y Producto)
CREATE TABLE IF NOT EXISTS detalle_pedido (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pedido_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario REAL NOT NULL CHECK (precio_unitario >= 0),
    subtotal REAL NOT NULL CHECK (subtotal >= 0),
    FOREIGN KEY (pedido_id) REFERENCES pedido(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES producto(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Índices recomendados para SQLite (Consultas frecuentes / JOINs)
CREATE INDEX IF NOT EXISTS idx_producto_negocio ON producto(negocio_id);
CREATE INDEX IF NOT EXISTS idx_cliente_negocio ON cliente(negocio_id);
CREATE INDEX IF NOT EXISTS idx_pedido_cliente ON pedido(cliente_id);
CREATE INDEX IF NOT EXISTS idx_pedido_negocio ON pedido(negocio_id);
CREATE INDEX IF NOT EXISTS idx_detalle_pedido ON detalle_pedido(pedido_id);
CREATE INDEX IF NOT EXISTS idx_detalle_producto ON detalle_pedido(producto_id);