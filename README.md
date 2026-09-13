# KioskoExpress 🛒✨
### *Gestión de inventarios y pedidos al instante para pequeños comercios*

---

## 1. Integrantes del Equipo

- Erick Daniel Londoño Jaramillo (1041632489 / [erickdo017@gmail.com](mailto:erickdo017@gmail.com))
- Cristian Camilo Jiménez Ruiz (1021807867 / [cristianjzrz333@gmail.com](mailto:cristianjzrz333@gmail.com))
- Dilan Félipe Vasquez Aristizabal (1000758457 / [dfvasquez369@gmail.com](mailto:dfvasquez369@gmail.com))

---

## 2. Descripción del Negocio y Justificación

### El Problema
Muchos negocios locales (tiendas de barrio, emprendimientos de repostería, tiendas de ropa) siguen controlando sus ventas en cuadernos de papel o en hojas de Excel desordenadas. Esto les hace perder tiempo, cometer errores en las cuentas y, peor aún, perder ventas por no saber con exactitud qué productos tienen disponibles cuando un cliente les pregunta por WhatsApp.

### Nuestra Solución
**KioskoExpress** es una aplicación ligera y rápida que le permite al dueño del negocio:

- Controlar lo que tiene en stock en tiempo real.
- Registrar ventas en solo dos clics.
- Generar resúmenes automáticos para enviar la confirmación del pedido directamente al WhatsApp del cliente.

---

## 3. Entidades Principales del Dominio

- **`Negocio`**: Representa la tienda o emprendimiento registrado en el sistema. Contiene los datos básicos de contacto y configuración del WhatsApp.
- **`Producto`**: Cada uno de los artículos disponibles para la venta. Almacena nombre, precio de venta, costo y stock actual. *(Un Negocio tiene muchos Productos - Relación 1:N)*.
- **`Cliente`**: Persona que realiza las compras. Guarda su teléfono y dirección para facilitar entregas futuras. *(Un Negocio atiende a muchos Clientes - Relación 1:N)*.
- **`Pedido`**: Registro de la transacción realizada. Asocia al cliente con los productos seleccionados y calcula el total. *(Un Cliente puede hacer muchos Pedidos - Relación 1:N)*.
- **`DetallePedido`**: Especifica la cantidad y el precio unitario de cada producto incluido en un pedido puntual. *(Relación N:M entre Pedido y Producto)*.

---

## 4. Matriz de Entornos y Conexiones

Probamos y validamos el correcto funcionamiento del ORM con los siguientes motores y proveedores cloud:

| Motor | Proveedor | Entorno |
| --- | --- | --- |
| **SQLite** | Local (`app.db`) | Desarrollo |
| **MySQL** | Aiven.io | Nube |
| **PostgreSQL** | Neon.tech | Nube (Serverless) |
| **PostgreSQL** | Render.com | Nube |

---

## 5. Instrucciones de Ejecución

### Comando de instalación de librerías:
'pip install peewee psycopg2-binary pymysql'

### Comando para ejecutar la aplicación:
'python app.py'
