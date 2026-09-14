
-- seed_data.sql
-- Script DML ÚNICO y compatible con PostgreSQL, MySQL y SQLite.

BEGIN;

-- ---------------------------------------------------------------------
-- 1. NEGOCIO (5 registros) -> IDs generados: 1,2,3,4,5
-- ---------------------------------------------------------------------
INSERT INTO negocio (nombre, telefono_whatsapp, direccion, configuracion_mensaje) VALUES
('Pizzería El Sabroso',      '+573001112233', 'Cra 45 #12-30, Medellín',  'Bienvenido a Pizzería El Sabroso, ¿en qué te ayudamos hoy?'),
('Panadería Dulce Hogar',    '+573002223344', 'Calle 10 #5-20, Envigado', 'Gracias por escribirnos a Dulce Hogar'),
('Ferretería Total',         '+573003334455', 'Av. 33 #80-15, Itagüí',    'Ferretería Total, calidad y precio.'),
('Farmacia San José',        '+573004445566', 'Cra 50 #40-10, Bello',     'Farmacia San José a tu servicio.'),
('Tienda La Esquina',        '+573005556677', 'Calle 70 #25-08, Sabaneta','La Esquina, siempre cerca de ti.');

-- ---------------------------------------------------------------------
-- 2. PRODUCTO (10 registros, 2 por negocio) -> IDs generados: 1..10
-- ---------------------------------------------------------------------
INSERT INTO producto (negocio_id, nombre, precio_venta, costo, stock, activo) VALUES
(1, 'Pizza Margherita',     25000, 12000, 50, TRUE),
(1, 'Pizza Pepperoni',      28000, 14000, 40, TRUE),
(2, 'Pan Francés (unidad)',  2500,  1000, 200, TRUE),
(2, 'Torta de Chocolate',   45000, 20000, 15, TRUE),
(3, 'Martillo',             35000, 18000, 30, TRUE),
(3, 'Taladro Eléctrico',   250000,150000, 10, TRUE),
(4, 'Paracetamol 500mg',     8000,  3000, 100, TRUE),
(4, 'Ibuprofeno 400mg',      9500,  4000, 80, TRUE),
(5, 'Arroz 1kg',             3500,  2200, 150, TRUE),
(5, 'Aceite 1L',            12000,  8000, 60, TRUE);

-- ---------------------------------------------------------------------
-- 3. CLIENTE (10 registros, 2 por negocio) -> IDs generados: 1..10
-- ---------------------------------------------------------------------
INSERT INTO cliente (negocio_id, nombre, telefono, direccion) VALUES
(1, 'Juan Pérez',    '+573101112233', 'Cra 1 #1-01, Medellín'),
(1, 'María Gómez',   '+573101112234', 'Calle 2 #2-02, Medellín'),
(2, 'Carlos Ruiz',   '+573101112235', 'Cra 3 #3-03, Envigado'),
(2, 'Ana Torres',    '+573101112236', 'Calle 4 #4-04, Envigado'),
(3, 'Luis Herrera',  '+573101112237', 'Cra 5 #5-05, Itagüí'),
(3, 'Sofía Ramírez', '+573101112238', 'Calle 6 #6-06, Itagüí'),
(4, 'Pedro Castaño', '+573101112239', 'Cra 7 #7-07, Bello'),
(4, 'Laura Muñoz',   '+573101112240', 'Calle 8 #8-08, Bello'),
(5, 'Diego Vélez',   '+573101112241', 'Cra 9 #9-09, Sabaneta'),
(5, 'Camila Ríos',   '+573101112242', 'Calle 10 #10-10, Sabaneta');

-- ---------------------------------------------------------------------
-- 4. PEDIDO (8 registros) -> IDs generados: 1..8
-- ---------------------------------------------------------------------
INSERT INTO pedido (negocio_id, cliente_id, estado, total) VALUES
(1, 1, 'CONFIRMADO',  78000),
(1, 2, 'PENDIENTE',   75000),
(2, 3, 'ENTREGADO',  115000),
(2, 4, 'PENDIENTE',   45000),
(3, 5, 'CONFIRMADO', 535000),
(3, 6, 'CANCELADO',   35000),
(4, 7, 'ENTREGADO',   25500),
(5, 9, 'PENDIENTE',   10500);

-- ---------------------------------------------------------------------
-- 5. DETALLE_PEDIDO (12 registros) -> IDs generados: 1..12
-- ---------------------------------------------------------------------
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(1, 1,  2,  25000,  50000),
(1, 2,  1,  28000,  28000),
(2, 1,  3,  25000,  75000),
(3, 3, 10,   2500,  25000),
(3, 4,  2,  45000,  90000),
(4, 4,  1,  45000,  45000),
(5, 5,  1,  35000,  35000),
(5, 6,  2, 250000, 500000),
(6, 5,  1,  35000,  35000),
(7, 7,  2,   8000,  16000),
(7, 8,  1,   9500,   9500),
(8, 9,  3,   3500,  10500);

COMMIT;
