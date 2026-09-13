-- Crear tipo ENUM nativo para el estado del pedido
CREATE TYPE estado_pedido_enum AS ENUM ('PENDIENTE', 'CONFIRMADO', 'ENTREGADO', 'CANCELADO');

-- 1. Tabla Negocio
CREATE TABLE negocio (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    telefono_whatsapp VARCHAR(20) NOT NULL UNIQUE,
    direccion VARCHAR(255),
    configuracion_mensaje TEXT,
    creado_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabla Producto (1:N con Negocio)
CREATE TABLE producto (
    id BIGSERIAL PRIMARY KEY,
    negocio_id BIGINT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    precio_venta NUMERIC(12,2) NOT NULL CHECK (precio_venta >= 0),
    costo NUMERIC(12,2) NOT NULL CHECK (costo >= 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_producto_negocio
        FOREIGN KEY (negocio_id) REFERENCES negocio(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 3. Tabla Cliente (1:N con Negocio)
CREATE TABLE cliente (
    id BIGSERIAL PRIMARY KEY,
    negocio_id BIGINT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    direccion VARCHAR(255),
    creado_en TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cliente_negocio
        FOREIGN KEY (negocio_id) REFERENCES negocio(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 4. Tabla Pedido (1:N con Cliente)
CREATE TABLE pedido (
    id BIGSERIAL PRIMARY KEY,
    negocio_id BIGINT NOT NULL,
    cliente_id BIGINT NOT NULL,
    fecha_pedido TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado estado_pedido_enum NOT NULL DEFAULT 'PENDIENTE',
    total NUMERIC(12,2) NOT NULL DEFAULT 0.00 CHECK (total >= 0),
    CONSTRAINT fk_pedido_negocio
        FOREIGN KEY (negocio_id) REFERENCES negocio(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (cliente_id) REFERENCES cliente(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- 5. Tabla DetallePedido (N:M entre Pedido y Producto)
CREATE TABLE detalle_pedido (
    id BIGSERIAL PRIMARY KEY,
    pedido_id BIGINT NOT NULL,
    producto_id BIGINT NOT NULL,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(12,2) NOT NULL CHECK (precio_unitario >= 0),
    subtotal NUMERIC(12,2) NOT NULL CHECK (subtotal >= 0),
    CONSTRAINT fk_detalle_pedido
        FOREIGN KEY (pedido_id) REFERENCES pedido(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (producto_id) REFERENCES producto(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Índices B-Tree en PostgreSQL
CREATE INDEX idx_producto_negocio ON producto(negocio_id);
CREATE INDEX idx_cliente_negocio ON cliente(negocio_id);
CREATE INDEX idx_pedido_cliente ON pedido(cliente_id);
CREATE INDEX idx_pedido_negocio ON pedido(negocio_id);
CREATE INDEX idx_detalle_pedido ON detalle_pedido(pedido_id);
CREATE INDEX idx_detalle_producto ON detalle_pedido(producto_id);