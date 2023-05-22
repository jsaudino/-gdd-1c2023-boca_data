USE [GD1C2023]
GO

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE schema_id = SCHEMA_ID('boca_data'))
BEGIN
-----------------------------------  E L I M I N A R  F U N C T I O N S  -----------------------------
        DECLARE @SQL_FN NVARCHAR(MAX) = N'';

SELECT @SQL_FN += N'
	DROP FUNCTION boca_data.' + name  + ';'
FROM sys.objects WHERE type = 'FN'
                   AND schema_id = SCHEMA_ID('boca_data')

    EXECUTE(@SQL_FN)
--------------------------------------  E L I M I N A R   S P  --------------------------------------
DECLARE @SQL_SP NVARCHAR(MAX) = N'';

SELECT @SQL_SP += N'
	DROP PROCEDURE boca_data.' + name  + ';'
FROM sys.objects WHERE type = 'P'
                   AND schema_id = SCHEMA_ID('boca_data')

    EXECUTE(@SQL_SP)

--------------------------------------  E L I M I N A R   F K  --------------------------------------
DECLARE @SQL_FK NVARCHAR(MAX) = N'';

SELECT @SQL_FK += N'
	ALTER TABLE boca_data.' + OBJECT_NAME(PARENT_OBJECT_ID) + ' DROP CONSTRAINT ' + OBJECT_NAME(OBJECT_ID) + ';'
FROM SYS.OBJECTS
WHERE TYPE_DESC LIKE '%CONSTRAINT'
  AND type = 'F'
  AND schema_id = SCHEMA_ID('boca_data')

    EXECUTE(@SQL_FK)
--------------------------------------  E L I M I N A R   P K  --------------------------------------
DECLARE @SQL_PK NVARCHAR(MAX) = N'';

SELECT @SQL_PK += N'
	ALTER TABLE boca_data.' + OBJECT_NAME(PARENT_OBJECT_ID) + ' DROP CONSTRAINT ' + OBJECT_NAME(OBJECT_ID) + ';'
FROM SYS.OBJECTS
WHERE TYPE_DESC LIKE '%CONSTRAINT'
  AND type = 'PK'
  AND schema_id = SCHEMA_ID('boca_data')

    EXECUTE(@SQL_PK)
----------------------------------------- D R O P   T A B L E S -------------------------------------
DECLARE @SQL2 NVARCHAR(MAX) = N'';

SELECT @SQL2 += N'
	DROP TABLE boca_data.' + TABLE_NAME + ';'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'boca_data'
  AND TABLE_TYPE = 'BASE TABLE'

    EXECUTE(@SQL2)

----------------------------------------- D R O P   S C H E M A -------------------------------------
DROP SCHEMA boca_data
END
GO


----------------------------------------- C R E A C I O N  S C H E M A -------------------------------------

IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name = 'boca_data')
BEGIN
EXECUTE('CREATE SCHEMA boca_data')
END
GO

----------------------------------------- C R E A C I O N  T A B L A S -------------------------------------

BEGIN TRANSACTION

--Categoria
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'CATEGORIA')
CREATE TABLE boca_data.CATEGORIA (
                                     id decimal(18,0) IDENTITY PRIMARY KEY,
                                     nombre nvarchar(50),
                                     tipo_id decimal(18,0)
);

--Local
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'LOCAL')
CREATE TABLE boca_data.LOCAL(
                                id decimal(18,0) IDENTITY PRIMARY KEY,
                                nombre nvarchar(255),
                                descripcion nvarchar(255),
                                direccion nvarchar(255),
                                localidad_id decimal(18,0),
                                categoria_id decimal(18,0)
);

--Tipo de Local
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'LOCAL_TIPO')
CREATE TABLE boca_data.LOCAL_TIPO(
                                     id decimal(18,0) IDENTITY PRIMARY KEY,
                                     nombre nvarchar(50)
);

--Repartidor
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'REPARTIDOR')
CREATE TABLE boca_data.REPARTIDOR(
                                     id decimal(18,0) IDENTITY PRIMARY KEY,
                                     nombre nvarchar(255),
                                     apellido nvarchar(255),
                                     dni decimal(18, 0),
                                     telefono decimal(18, 0),
                                     direccion nvarchar(255),
                                     email nvarchar(255),
                                     fecha_nacimiento date,
                                     movilidad_id decimal(18, 0),
                                     localidad_id decimal (18, 0)
);

--Horario
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'HORARIO')
CREATE TABLE boca_data.HORARIO(
                                  id decimal(18,0) IDENTITY PRIMARY KEY,
                                  dia decimal(18,0),
                                  hora_apertura decimal(18,0),
                                  hora_cierre decimal(18,0),
                                  local_id decimal(18,0)
);

--Dia
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'DIA')
CREATE TABLE boca_data.DIA(
                              id decimal(18,0) IDENTITY PRIMARY KEY,
                              nombre nvarchar(50)
);

--Producto
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'PRODUCTO')
CREATE TABLE boca_data.PRODUCTO(
                                   codigo_producto nvarchar(50) primary key,
                                   nombre nvarchar(50),
                                   descripcion nvarchar(255),
                                   precio decimal(18,2),
                                   local_id decimal(18,0)
);

--Pedido_Producto
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'PEDIDO_PRODUCTO')
CREATE TABLE boca_data.PEDIDO_PRODUCTO(
                                          producto_codigo nvarchar(50),
                                          pedido_numero decimal(18,0),
                                          cantidad_productos decimal(18,0),
                                          precio_unitario decimal(18,2),
                                          total_producto decimal(18,2),
                                          primary key(producto_codigo, pedido_numero)
);

--Pedido
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'PEDIDO')
CREATE TABLE boca_data.PEDIDO(
                                 numero_pedido decimal(18,0) identity primary key,
                                 fecha datetime2(3),
                                 usuario_id decimal(18,0),
                                 local_id decimal(18,0),
                                 total_productos decimal(18,2),
                                 tarifa_servicio decimal(18,2),
                                 total_cupones decimal(18,2),
                                 total_servicio decimal(18,2),
                                 observacion nvarchar(255),
                                 fecha_entrega datetime2(3),
                                 tiempo_estimado decimal(18,2),
                                 calificacion decimal(18,0),
                                 nro_envio decimal(18,0),
                                 pedido_estado_id decimal(18,0),
                                 medio_de_pago_id decimal(18,0)
);

--Tipo de Paquete
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'PAQUETE_TIPO')
CREATE TABLE boca_data.PAQUETE_TIPO(
                                       id decimal(18,0) IDENTITY PRIMARY KEY,
                                       nombre nvarchar(50),
                                       precio_tipo decimal(18, 2),
                                       alto_max decimal(18,2),
                                       ancho_max decimal(18,2),
                                       peso_max decimal(18,2),
                                       largo_max decimal(18,2)
);

--Paquete
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'PAQUETE')
CREATE TABLE boca_data.PAQUETE(
                                  id decimal(18,0) IDENTITY PRIMARY KEY,
                                  paquete_tipo_id decimal(18, 0),
                                  precio decimal(18, 2)
);

--Envio de Mensajeria
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'ENVIO_MENSAJERIA')
CREATE TABLE boca_data.ENVIO_MENSAJERIA(
                                           nro_envio decimal(18,0) IDENTITY PRIMARY KEY,
                                           usuario_id decimal(18, 0),
                                           fecha_mensajeria datetime2(3),
                                           direccion_origen nvarchar(255),
                                           direccion_destino nvarchar(255),
                                           localidad_id decimal(18,0),
                                           kilometros decimal(18, 2),
                                           valor_asegurado decimal(18, 2),
                                           observacion nvarchar(255),
                                           precio_envio decimal(18, 2),
                                           precio_seguro decimal(18, 2),
                                           propina decimal(18, 2),
                                           medio_pago_id decimal(18, 0),
                                           precio_total decimal(18, 2),
                                           envio_estado_id decimal(18, 0),
                                           fecha_entrega datetime2(3),
                                           calificacion decimal(18, 0),
                                           paquete_id decimal(18, 0),
                                           repartidor_id decimal(18, 0),
                                           tiempo_estimado decimal(18, 2)
);

--Tipo de Movilidad
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'TIPO_MOVILIDAD')
CREATE TABLE boca_data.TIPO_MOVILIDAD(
                                         id decimal(18,0) IDENTITY PRIMARY KEY,
                                         nombre nvarchar(50)
);

--Estado de Envio
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'ENVIO_ESTADO')
CREATE TABLE boca_data.ENVIO_ESTADO(
                                       id decimal(18,0) IDENTITY PRIMARY KEY,
                                       nombre nvarchar(50)
);

--Estado de Pedido
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'PEDIDO_ESTADO')
CREATE TABLE boca_data.PEDIDO_ESTADO(
                                        id decimal(18,0) IDENTITY PRIMARY KEY,
                                        nombre nvarchar(50)
);

--Envio
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'ENVIO')
CREATE TABLE boca_data.ENVIO(
                                nro_envio decimal(18,0) IDENTITY PRIMARY KEY,
                                direccion_usuario_id decimal(18,0),
                                precio_envio decimal(18,2),
                                propina decimal(18,2),
                                repartidor_id decimal(18,0)
);

--Operador
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'OPERADOR')
CREATE TABLE boca_data.OPERADOR(
                                   id decimal(18,0) IDENTITY PRIMARY KEY,
                                   nombre nvarchar(255),
                                   apellido nvarchar(255),
                                   dni decimal(18,0),
                                   telefono decimal(18,0),
                                   mail nvarchar(255),
                                   fecha_nacimiento date,
                                   direccion nvarchar(255)
);

--Direccion de Usuario
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'DIRECCION_USUARIO')
CREATE TABLE boca_data.DIRECCION_USUARIO(
                                            id decimal(18,0) IDENTITY PRIMARY KEY,
                                            usuario_id decimal(18,0),
                                            nombre nvarchar(50),
                                            direccion nvarchar(255),
                                            localidad_id decimal(18,0)
);

--Usuario
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'USUARIO')
CREATE TABLE boca_data.USUARIO(
                                  id decimal(18,0) IDENTITY PRIMARY KEY,
                                  nombre nvarchar(255),
                                  apellido nvarchar(255),
                                  dni decimal(18,0),
                                  fecha_registro datetime2(3),
                                  telefono decimal(18,0),
                                  mail nvarchar(255),
                                  fecha_nacimiento date
);

--Tarjeta
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'TARJETA')
CREATE TABLE boca_data.TARJETA (
                                   id decimal(18,0) IDENTITY PRIMARY KEY,
                                   numero nvarchar(50),
                                   marca nvarchar(100),
                                   usuario_id decimal(18,0)
);

--Cupon
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'CUPON')
CREATE TABLE boca_data.CUPON(
                                numero decimal(18,0) IDENTITY PRIMARY KEY,
                                fecha_alta datetime2(3),
                                fecha_vencimiento datetime2(3),
                                monto decimal(18,2),
                                tipo decimal(18,0),
                                usuario_id decimal(18,0)
);

--Tipo de Cupon
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'CUPON_TIPO')
CREATE TABLE boca_data.CUPON_TIPO(
                                     id decimal(18,0) IDENTITY PRIMARY KEY,
                                     nombre nvarchar(50)
);

--Reclamo
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'RECLAMO')
CREATE TABLE boca_data.RECLAMO(
                                  numero_reclamo decimal(18,0) IDENTITY PRIMARY KEY,
                                  usuario_id decimal(18,0),
                                  pedido_id decimal(18,0),
                                  tipo decimal(18,0),
                                  descripcion nvarchar(255),
                                  fecha_reclamo datetime2(3),
                                  operador_id decimal(18,0),
                                  estado decimal(18,0),
                                  solucion nvarchar(255),
                                  calificacion decimal(18,0),
                                  fecha_solucion datetime2(3)
);

--Cupon de Reclamo
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'RECLAMO_CUPON')
CREATE TABLE boca_data.RECLAMO_CUPON(
                                        reclamo_id decimal(18,0),
                                        cupon_id decimal(18,0),
                                        primary key (reclamo_id,cupon_id)
);

--Cupon de Pedido
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'CUPON_PEDIDO')
CREATE TABLE boca_data.CUPON_PEDIDO(
                                       pedido_id decimal(18,0),
                                       cupon_id decimal(18,0),
                                       primary key (pedido_id,cupon_id)
);

--Tipo de Reclamo
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'RECLAMO_TIPO')
CREATE TABLE boca_data.RECLAMO_TIPO(
                                       id decimal(18,0) IDENTITY PRIMARY KEY,
                                       nombre nvarchar(50)
);

--Estado de Reclamo
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'RECLAMO_ESTADO')
CREATE TABLE boca_data.RECLAMO_ESTADO(
                                         id decimal(18,0) IDENTITY PRIMARY KEY,
                                         nombre nvarchar(50)
);

--Medio de Pago
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'MEDIO_DE_PAGO')
CREATE TABLE boca_data.MEDIO_DE_PAGO(
                                        id decimal(18,0) IDENTITY PRIMARY KEY,
                                        tipo_id decimal(18,0),
                                        tarjeta_id decimal(18,0)
);

--Provincia
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'PROVINCIA')
CREATE TABLE boca_data.PROVINCIA(
                                    id decimal(18,0) IDENTITY PRIMARY KEY,
                                    nombre nvarchar(255)
);

--Localidad
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'LOCALIDAD')
CREATE TABLE boca_data.LOCALIDAD(
                                    id decimal(18,0) IDENTITY PRIMARY KEY,
                                    provincia_id decimal(18,0),
                                    nombre nvarchar(255)
);

--Tipo de Medio de Pago
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'MEDIO_DE_PAGO_TIPO')
CREATE TABLE boca_data.MEDIO_DE_PAGO_TIPO(
                                             id decimal(18,0) IDENTITY PRIMARY KEY,
                                             nombre nvarchar(50)
);

COMMIT TRANSACTION


--------------------------------------- C R E A C I O N   F K ---------------------------------------

BEGIN TRANSACTION

--Categoria -> Tipo de Local
ALTER TABLE boca_data.CATEGORIA
    WITH CHECK ADD CONSTRAINT FK_CATEGORIA_LOCAL_TIPO
	FOREIGN KEY(tipo_id)
    REFERENCES boca_data.LOCAL_TIPO (id);

--Local -> Localidad
--Local -> Categoria
ALTER TABLE boca_data.LOCAL
    WITH CHECK ADD CONSTRAINT FK_LOCAL_LOCALIDAD
	FOREIGN KEY(localidad_id)
    REFERENCES boca_data.LOCALIDAD (id),
    CONSTRAINT FK_LOCAL_CATEGORIA
	FOREIGN KEY (categoria_id)
    REFERENCES boca_data.CATEGORIA (id);

--Repartidor -> Localidad
--Repartidor --> Tipo de Movilidad
ALTER TABLE boca_data.REPARTIDOR
    WITH CHECK ADD CONSTRAINT FK_REPARTIDOR_LOCALIDAD
	FOREIGN KEY (localidad_id)
	REFERENCES boca_data.LOCALIDAD (id),
    CONSTRAINT FK_REPARTIDOR_TIPO_MOVILIDAD
	FOREIGN KEY (movilidad_id)
	REFERENCES boca_data.TIPO_MOVILIDAD (id);

--Horario -> Dia
--Horario -> Local
ALTER TABLE boca_data.HORARIO
    WITH CHECK ADD CONSTRAINT FK_HORARIO_DIA
	FOREIGN KEY(dia)
    REFERENCES boca_data.DIA (id),
    CONSTRAINT FK_HORARIO_LOCAL
	FOREIGN KEY (local_id)
    REFERENCES boca_data.LOCAL (id);

--Producto -> Local
ALTER TABLE boca_data.PRODUCTO
    WITH CHECK ADD CONSTRAINT FK_PRODUCTO_LOCAL
	FOREIGN KEY(local_id)
    REFERENCES boca_data.LOCAL (id);

--Pedido_Producto -> Producto
--Pedido_Producto -> Pedido
ALTER TABLE boca_data.PEDIDO_PRODUCTO
    WITH CHECK ADD CONSTRAINT FK_PEDIDO_PRODUCTO_PRODUCTO
	FOREIGN KEY(producto_codigo)
    REFERENCES boca_data.PRODUCTO (codigo_producto),
    CONSTRAINT FK_PEDIDO_PRODUCTO_PEDIDO
	FOREIGN KEY (pedido_numero)
    REFERENCES boca_data.PEDIDO (numero_pedido);

--Pedido -> Usuario
--Pedido -> Local
--Pedido -> Envio
--Pedido -> Estado de Pedido
--Pedido -> Medio de Pago
ALTER TABLE boca_data.PEDIDO
    WITH CHECK ADD CONSTRAINT FK_PEDIDO_USUARIO
	FOREIGN KEY(usuario_id)
    REFERENCES boca_data.USUARIO (id),
    CONSTRAINT FK_PEDIDO_LOCAL
	FOREIGN KEY (local_id)
    REFERENCES boca_data.LOCAL (id),
    CONSTRAINT FK_PEDIDO_ENVIO
	FOREIGN KEY (nro_envio)
    REFERENCES boca_data.ENVIO (nro_envio),
    CONSTRAINT FK_PEDIDO_ESTADO
	FOREIGN KEY (pedido_estado_id)
    REFERENCES boca_data.PEDIDO_ESTADO (id),
    CONSTRAINT FK_PEDIDO_MEDIO_DE_PAGO
	FOREIGN KEY (medio_de_pago_id)
    REFERENCES boca_data.MEDIO_DE_PAGO (id);

--CHECK!
--Paquete -> Tipo de Paquete
ALTER TABLE boca_data.PAQUETE
	WITH CHECK ADD CONSTRAINT FK_PAQUETE_PAQUETE_TIPO
	FOREIGN KEY(paquete_tipo_id)
	REFERENCES boca_data.PAQUETE_TIPO (id);

--Envio de Mensajeria -> Usuario
--Envio de Mensajeria -> Localidad
--Envio de Mensajeria -> Medio de Pago
--Envio de Mensajeria -> Estado de Envio
--Envio de Mensajeria -> Paquete
--Envio de Mensajeria -> Repartidor
ALTER TABLE boca_data.ENVIO_MENSAJERIA
    WITH CHECK ADD CONSTRAINT FK_ENVIO_MENSAJERIA_USUARIO
	FOREIGN KEY (usuario_id)
	REFERENCES boca_data.USUARIO (id),
    CONSTRAINT FK_ENVIO_MENSAJERIA_LOCALIDAD
	FOREIGN KEY (localidad_id)
	REFERENCES boca_data.LOCALIDAD (id),
    CONSTRAINT FK_ENVIO_MENSAJERIA_MEDIO_DE_PAGO
	FOREIGN KEY (medio_pago_id)
	REFERENCES boca_data.MEDIO_DE_PAGO (id),
    CONSTRAINT FK_ENVIO_MENSAJERIA_ENVIO_ESTADO
	FOREIGN KEY (envio_estado_id)
	REFERENCES boca_data.ENVIO_ESTADO (id),
    CONSTRAINT FK_ENVIO_MENSAJERIA_PAQUETE
	FOREIGN KEY (paquete_id)
	REFERENCES boca_data.PAQUETE (id),
    CONSTRAINT FK_ENVIO_MENSAJERIA_REPARTIDOR
	FOREIGN KEY (repartidor_id)
	REFERENCES boca_data.REPARTIDOR (id);

--Envio -> Direccion de Usuario
--Envio -> Repartidor
ALTER TABLE boca_data.ENVIO
    WITH CHECK ADD CONSTRAINT FK_ENVIO_DIRECCION_USUARIO
	FOREIGN KEY(direccion_usuario_id)
    REFERENCES boca_data.DIRECCION_USUARIO (id),
    CONSTRAINT FK_ENVIO_REPARTIDOR
	FOREIGN KEY (repartidor_id)
    REFERENCES boca_data.REPARTIDOR (id);

--Direccion de Usuario -> Usuario
--Direccion de Usuario -> Localidad
ALTER TABLE boca_data.DIRECCION_USUARIO
    WITH CHECK ADD CONSTRAINT FK_DIRECCION_USUARIO_USUARIO
	FOREIGN KEY(usuario_id)
    REFERENCES boca_data.USUARIO (id),
    CONSTRAINT FK_DIRECCION_USUARIO_LOCALIDAD
	FOREIGN KEY (localidad_id)
    REFERENCES boca_data.LOCALIDAD (id);

--Tarjeta -> Usuario
ALTER TABLE boca_data.TARJETA
    WITH CHECK ADD CONSTRAINT FK_TARJETA_USUARIO
	FOREIGN KEY(usuario_id)
    REFERENCES boca_data.USUARIO (id);

--Cupon -> Tipo de Cupon
--Cupon -> Usuario
ALTER TABLE boca_data.CUPON
    WITH CHECK ADD CONSTRAINT FK_CUPON_CUPON_TIPO
	FOREIGN KEY(tipo)
    REFERENCES boca_data.CUPON_TIPO (id),
    CONSTRAINT FK_CUPON_USUARIO
	FOREIGN KEY (usuario_id)
    REFERENCES boca_data.USUARIO (id);

--Reclamo -> Usuario
--Reclamo -> Pedido
--Reclamo -> Tipo de Reclamo
--Reclamo -> Operador
--Reclamo -> Estado de Reclamo
ALTER TABLE boca_data.RECLAMO
    WITH CHECK ADD CONSTRAINT FK_RECLAMO_USUARIO
	FOREIGN KEY(usuario_id)
    REFERENCES boca_data.USUARIO (id),
    CONSTRAINT FK_RECLAMO_PEDIDO
	FOREIGN KEY (pedido_id)
    REFERENCES boca_data.PEDIDO (numero_pedido),
    CONSTRAINT FK_RECLAMO_TIPO
	FOREIGN KEY (tipo)
    REFERENCES boca_data.RECLAMO_TIPO (id),
    CONSTRAINT FK_RECLAMO_OPERADOR
	FOREIGN KEY (operador_id)
    REFERENCES boca_data.OPERADOR (id),
    CONSTRAINT FK_RECLAMO_ESTADO
	FOREIGN KEY (estado)
    REFERENCES boca_data.RECLAMO_ESTADO (id);

--Cupon de Reclamo -> Reclamo
--Cupon de Reclamo -> Cupon
ALTER TABLE boca_data.RECLAMO_CUPON
    WITH CHECK ADD CONSTRAINT FK_RECLAMO_CUPON_RECLAMO
	FOREIGN KEY(reclamo_id)
    REFERENCES boca_data.RECLAMO (numero_reclamo),
    CONSTRAINT FK_RECLAMO_CUPON_CUPON
	FOREIGN KEY (cupon_id)
    REFERENCES boca_data.CUPON (numero);

--Cupon de Pedido -> Pedido
--Cupon de Pedido -> Cupon
ALTER TABLE boca_data.CUPON_PEDIDO
    WITH CHECK ADD CONSTRAINT FK_CUPON_PEDIDO_PEDIDO
	FOREIGN KEY(pedido_id)
    REFERENCES boca_data.PEDIDO (numero_pedido),
    CONSTRAINT FK_CUPON_PEDIDO_CUPON
	FOREIGN KEY (cupon_id)
    REFERENCES boca_data.CUPON (numero);

--Medio de Pago -> Tipo de Medio de Pago
--Medio de Pago -> Tarjeta
ALTER TABLE boca_data.MEDIO_DE_PAGO
    WITH CHECK ADD CONSTRAINT FK_MEDIO_DE_PAGO_TIPO
	FOREIGN KEY(tipo_id)
    REFERENCES boca_data.MEDIO_DE_PAGO_TIPO (id),
    CONSTRAINT FK_MEDIO_DE_PAGO_TARJETA
	FOREIGN KEY (tarjeta_id)
    REFERENCES boca_data.TARJETA (id);

--Localidad -> Provincia
ALTER TABLE boca_data.LOCALIDAD
    ADD CONSTRAINT FK_LOCALIDAD_PROVINCIA
	FOREIGN KEY(provincia_id)
	REFERENCES boca_data.PROVINCIA (id);

COMMIT TRANSACTION


/*
31 tablas:

CATEGORIA
LOCAL
LOCAL_TIPO
REPARTIDOR
HORARIO
DIA
PRODUCTO
PEDIDO_PRODUCTO
PEDIDO
PAQUETE_TIPO
PAQUETE
ENVIO_MENSAJERIA
TIPO_MOVILIDAD
ENVIO_ESTADO
PEDIDO_ESTADO
ENVIO
OPERADOR
DIRECCION_USUARIO
USUARIO
TARJETA
CUPON
CUPON_TIPO
RECLAMO
RECLAMO_CUPON
CUPON_PEDIDO
RECLAMO_TIPO
RECLAMO_ESTADO
MEDIO_DE_PAGO
PROVINCIA
LOCALIDAD
MEDIO_DE_PAGO_TIPO

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
*/