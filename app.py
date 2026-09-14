from peewee import *
import datatime

# ================================
# 1. CONFIGURACIÓN DE CONEXIÓN
# Opciones: "sqlite" | "mysql_aiven" | "postgres_neon" | "postgres_render"
# ================================
MOTOR_ACTIVO = "sqlite"

if MOTOR_ACTIVO == "sqlite":
    db = SqliteDatabase("kioskoExpress.db")

elif MOTOR_ACTIVO == "mysql_aiven":
    db = MySQLDatabase(
        "nombre_bd",
        user="usuario",
        password="password",
        host="mysql-aiven.com",
        port=12345,
        ssl={"ssl_mode": "REQUIRED"}
    )

elif MOTOR_ACTIVO == "postgres_neon":
    db = PostgresqlDatabase(
        "nombre_bd",
        user="usuario",
        password="password",
        host="ep-xyz.neon.tech",
        port=5432,
        sslmode="require"
    )

elif MOTOR_ACTIVO == "postgres_render":
    db = PostgresqlDatabase(
        "nombre_bd",
        user="usuario",
        password="password",
        host="dpg-xyz.oregon-postgres.render.com",
        port=5432,
        sslmode="require"
    )


# ================================
# 2. MODELOS RELACIONALES (ORM)
# ================================

class BaseModel(Model):
    class Meta:
        database = db


class negocio(BaseModel):
    nombre = CharField(max_length=150, null=False)
    telefono_whatsapp = CharField(max_length=20, null=False, unique=True)
    direccion = CharField(max_length=255, null=True)
    configuracion_mensaje = TextField(null=True)
    creado_en = DateTimeField(default=datetime.datetime.now)



class producto(BaseModel):
    negocio_id = ForeignKeyField(
        negocio,
        backref="productos",
        column_name="negocio_id",
        on_delete="RESTRICT",
        on_update="CASCADE",
    )
    nombre = CharField(max_length=150, null=False)
    precio_venta = DecimalField(max_digits=12, decimal_places=2, null=False)
    costo = DecimalField(max_digits=12, decimal_places=2, null=False)
    stock = IntegerField(default=0)
    activo = BooleanField(default=True)
    creado_en = DateTimeField(default=datetime.datetime.now)



class cliente(BaseModel):
    negocio_id = ForeignKeyField(
        negocio,
        backref="clientes",
        column_name="negocio_id",
        on_delete="RESTRICT",
        on_update="CASCADE",
    )
    nombre = CharField(max_length=150, null=False)
    telefono = CharField(max_length=20, null=False)
    direccion = CharField(max_length=255, null=True)
    creado_en = DateTimeField(default=datetime.datetime.now)



ESTADOS_PEDIDO = ("PENDIENTE", "CONFIRMADO", "ENTREGADO", "CANCELADO")


class pedido(BaseModel):
    negocio_id = ForeignKeyField(
        negocio,
        backref="pedidos",
        column_name="negocio_id",
        on_delete="RESTRICT",
        on_update="CASCADE",
    )
    cliente_id = ForeignKeyField(
        cliente,
        backref="pedidos",
        column_name="cliente_id",
        on_delete="RESTRICT",
        on_update="CASCADE",
    )
    fecha_pedido = DateTimeField(default=datetime.datetime.now)
    estado = CharField(
        max_length=20,
        choices=[(e, e) for e in ESTADOS_PEDIDO],
        default="PENDIENTE",
    )
    total = DecimalField(max_digits=12, decimal_places=2, default=0)



class detalle_pedido(BaseModel):
    pedido_id = ForeignKeyField(
        pedido,
        backref="detalles",
        column_name="pedido_id",
        on_delete="CASCADE",
        on_update="CASCADE",
    )
    producto_id = ForeignKeyField(
        producto,
        backref="detalles",
        column_name="producto_id",
        on_delete="RESTRICT",
        on_update="CASCADE",
    )
    cantidad = IntegerField(null=False)
    precio_unitario = DecimalField(max_digits=12, decimal_places=2, null=False)
    subtotal = DecimalField(max_digits=12, decimal_places=2, null=False)



# ================================
# 3. OPERACIONES CRUD Y PRUEBAS
# ================================
def ejecutar_pruebas():
    db.connect()
    db.create_tables([negocio, producto, cliente, pedido, detalle_pedido], safe=True)
    print(f"---- CONECTADO EXITOSAMENTE A: {MOTOR_ACTIVO.upper()} ----")


    # ---------- CREATE (Crear) ----------
    print("\n=== CREATE ===")
    nuevo_negocio = negocio.create(
        nombre="Pizzería El Sabroso",
        telefono_whatsapp="+573001112233",
        direccion="Cra 45 #12-30, Medellín",
        configuracion_mensaje="Bienvenido a Pizzería El Sabroso"
    )
    print(f"Negocio creado -> id={nuevo_negocio.id}, nombre={nuevo_negocio.nombre}")

    # ---------- READ (Leer) ----------
    print("\n=== READ ===")
    consultado = negocio.get(negocio.id == nuevo_negocio.id)
    print(f"Negocio leído  -> id={consultado.id}, nombre={consultado.nombre}, "
        f"telefono={consultado.telefono_whatsapp}")

    # ---------- UPDATE (Actualizar) ----------
    print("\n=== UPDATE ===")
    consultado.direccion = "Cra 45 #12-30, Local 2, Medellín"
    consultado.save()
    actualizado = negocio.get(negocio.id == nuevo_negocio.id)
    print(f"Negocio actualizado -> id={actualizado.id}, nueva direccion={actualizado.direccion}")

    # ---------- DELETE (Eliminar) ----------
    print("\n=== DELETE ===")
    filas_borradas = negocio.delete().where(negocio.id == nuevo_negocio.id).execute()
    print(f"Filas eliminadas: {filas_borradas}")

    existe = negocio.select().where(negocio.id == nuevo_negocio.id).exists()
    print(f"¿Sigue existiendo el negocio tras el DELETE? {existe}")

    db.close()


if __name__ == "__main__":
    ejecutar_pruebas()
