# -gdd-1c2023-boca_data
31 tablas:

CATEGORIA...7
LOCAL...506
LOCAL_TIPO .... 2
REPARTIDOR...719
HORARIO... 7102
DIA ... 7
PRODUCTO...2024
PEDIDO_PRODUCTO
PEDIDO
PAQUETE_TIPO...3
PAQUETE
ENVIO_MENSAJERIA...37147
TIPO_MOVILIDAD ... 3
ENVIO_ESTADO...1
PEDIDO_ESTADO...2
ENVIO...64518
OPERADOR...11161
DIRECCION_USUARIO...801
USUARIO...760
TARJETA...760
CUPON...20268
CUPON_TIPO...5
RECLAMO
RECLAMO_CUPON
CUPON_PEDIDO
RECLAMO_TIPO...4
RECLAMO_ESTADO...1
MEDIO_DE_PAGO...760
PROVINCIA... 24
LOCALIDAD...708
MEDIO_DE_PAGO_TIPO...3

41 FKs:
FK_CATEGORIA_LOCAL_TIPO
FK_LOCAL_LOCALIDAD
FK_LOCAL_CATEGORIA
FK_REPARTIDOR_LOCALIDAD
FK_REPARTIDOR_TIPO_MOVILIDAD
FK_HORARIO_DIA
FK_HORARIO_LOCAL
FK_PRODUCTO_LOCAL
FK_PEDIDO_PRODUCTO_PRODUCTO
FK_PEDIDO_PRODUCTO_PEDIDO
FK_PEDIDO_USUARIO
FK_PEDIDO_LOCAL
FK_PEDIDO_ENVIO
FK_PEDIDO_ESTADO
FK_PEDIDO_MEDIO_DE_PAGO
FK_PAQUETE_PAQUETE_TIPO
FK_ENVIO_MENSAJERIA_USUARIO
FK_ENVIO_MENSAJERIA_LOCALIDAD
FK_ENVIO_MENSAJERIA_MEDIO_DE_PAGO
FK_ENVIO_MENSAJERIA_ENVIO_ESTADO
FK_ENVIO_MENSAJERIA_PAQUETE
FK_ENVIO_MENSAJERIA_REPARTIDOR
FK_ENVIO_DIRECCION_USUARIO
FK_ENVIO_REPARTIDOR
FK_DIRECCION_USUARIO_USUARIO
FK_DIRECCION_USUARIO_LOCALIDAD
FK_TARJETA_USUARIO
FK_CUPON_CUPON_TIPO
FK_CUPON_USUARIO
FK_RECLAMO_USUARIO
FK_RECLAMO_PEDIDO
FK_RECLAMO_TIPO
FK_RECLAMO_OPERADOR
FK_RECLAMO_ESTADO
FK_RECLAMO_CUPON_RECLAMO
FK_RECLAMO_CUPON_CUPON
FK_CUPON_PEDIDO_PEDIDO
FK_CUPON_PEDIDO_CUPON
FK_MEDIO_DE_PAGO_TIPO
FK_MEDIO_DE_PAGO_TARJETA
FK_LOCALIDAD_PROVINCIA