CREATE DATABASE IF NOT EXISTS kiosko_express_db
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE kiosko_express_db;

-- 1. Tabla Negocio
CREATE TABLE IF NOT EXISTS negocio (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    telefono_whatsapp VARCHAR(20) NOT NULL UNIQUE,
    direccion VARCHAR(255) NULL,
    configuracion_mensaje TEXT NULL,
    creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Tabla Producto (1:N con Negocio)
CREATE TABLE IF NOT EXISTS producto (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    negocio_id BIGINT UNSIGNED NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    precio_venta DECIMAL(12,2) NOT NULL CHECK (precio_venta >= 0),
    costo DECIMAL(12,2) NOT NULL CHECK (costo >= 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_producto_negocio
        FOREIGN KEY (negocio_id) REFERENCES negocio(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. Tabla Cliente (1:N con Negocio)
CREATE TABLE IF NOT EXISTS cliente (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    negocio_id BIGINT UNSIGNED NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(255) NULL,
    creado_en DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cliente_negocio
        FOREIGN KEY (negocio_id) REFERENCES negocio(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4. Tabla Pedido (1:N con Cliente)
CREATE TABLE IF NOT EXISTS pedido (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    negocio_id BIGINT UNSIGNED NOT NULL,
    cliente_id BIGINT UNSIGNED NOT NULL,
    fecha_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('PENDIENTE', 'CONFIRMADO', 'ENTREGADO', 'CANCELADO') NOT NULL DEFAULT 'PENDIENTE',
    total DECIMAL(12,2) NOT NULL DEFAULT 0.00 CHECK (total >= 0),
    CONSTRAINT fk_pedido_negocio
        FOREIGN KEY (negocio_id) REFERENCES negocio(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (cliente_id) REFERENCES cliente(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Tabla DetallePedido (N:M entre Pedido y Producto)
CREATE TABLE IF NOT EXISTS detalle_pedido (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    pedido_id BIGINT UNSIGNED NOT NULL,
    producto_id BIGINT UNSIGNED NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(12,2) NOT NULL CHECK (precio_unitario >= 0),
    subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal >= 0),
    CONSTRAINT fk_detalle_pedido
        FOREIGN KEY (pedido_id) REFERENCES pedido(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (producto_id) REFERENCES producto(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Índices de aceleración para JOINs en MySQL
CREATE INDEX idx_producto_negocio ON producto(negocio_id);
CREATE INDEX idx_cliente_negocio ON cliente(negocio_id);
CREATE INDEX idx_pedido_cliente ON pedido(cliente_id);
CREATE INDEX idx_pedido_negocio ON pedido(negocio_id);
CREATE INDEX idx_detalle_pedido ON detalle_pedido(pedido_id);
CREATE INDEX idx_detalle_producto ON detalle_pedido(producto_id);