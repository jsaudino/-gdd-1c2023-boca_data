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
                                   id decimal(18,0) IDENTITY PRIMARY KEY,
                                   codigo_producto nvarchar(50),
                                   nombre nvarchar(50),
                                   descripcion nvarchar(255),
                                   precio decimal(18,2),
                                   local_id decimal(18,0)
);

--Pedido_Producto
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'PEDIDO_PRODUCTO')
CREATE TABLE boca_data.PEDIDO_PRODUCTO(
                                          producto_id decimal(18,0),
                                          pedido_numero decimal(18,0),
                                          cantidad_productos decimal(18,0),
                                          precio_unitario decimal(18,2),
                                          total_producto decimal(18,2),
                                          primary key(producto_id, pedido_numero)
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
                                  precio decimal(18, 2),
                                  nro_envio decimal(18,0)
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
	FOREIGN KEY(producto_id)
    REFERENCES boca_data.PRODUCTO (id),
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

--Paquete -> Tipo de Paquete
--Envio de Mensajeria -> Paquete

ALTER TABLE boca_data.PAQUETE
	WITH CHECK ADD CONSTRAINT FK_PAQUETE_PAQUETE_TIPO
	FOREIGN KEY(paquete_tipo_id)
	REFERENCES boca_data.PAQUETE_TIPO (id),
    CONSTRAINT FK_PAQUETE_ENVIO_MENSAJERIA
    FOREIGN KEY(nro_envio)
    REFERENCES boca_data.ENVIO_MENSAJERIA (nro_envio);

--Envio de Mensajeria -> Usuario
--Envio de Mensajeria -> Localidad
--Envio de Mensajeria -> Medio de Pago
--Envio de Mensajeria -> Estado de Envio
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



--------------------------------------- C R E A C I O N   S P ---------------------------------------

BEGIN TRANSACTION

--Tipo de Local
GO
CREATE PROCEDURE boca_data.migrar_local_tipo
 AS
  BEGIN
	INSERT INTO boca_data.LOCAL_TIPO (nombre)
	SELECT DISTINCT LOCAL_TIPO
	FROM gd_esquema.Maestra
	WHERE LOCAL_TIPO IS NOT NULL
  END
GO
--delete from boca_data.LOCAL_TIPO
--select * from boca_data.LOCAL_TIPO

CREATE PROCEDURE boca_data.migrar_provincia
 AS
  BEGIN
	INSERT INTO boca_data.PROVINCIA (nombre)
	SELECT DISTINCT LOCAL_PROVINCIA
	FROM gd_esquema.Maestra
	WHERE LOCAL_PROVINCIA IS NOT NULL
    union
    SELECT DISTINCT ENVIO_MENSAJERIA_PROVINCIA
    FROM gd_esquema.Maestra
    WHERE ENVIO_MENSAJERIA_PROVINCIA IS NOT NULL
    union
    SELECT DISTINCT DIRECCION_USUARIO_PROVINCIA
    FROM gd_esquema.Maestra
    WHERE DIRECCION_USUARIO_PROVINCIA IS NOT NULL
  END
GO

--select distinct LOCAL_PROVINCIA from gd_esquema.Maestra
--select * from boca_data.PROVINCIA

CREATE PROCEDURE boca_data.migrar_dia
 AS
  BEGIN
	INSERT INTO boca_data.DIA (nombre)
	SELECT DISTINCT HORARIO_LOCAL_DIA
	FROM gd_esquema.Maestra
	WHERE HORARIO_LOCAL_DIA IS NOT NULL
  END
GO

--select distinct HORARIO_LOCAL_DIA from gd_esquema.Maestra
--select * from boca_data.DIA

CREATE PROCEDURE boca_data.migrar_tipo_movilidad
 AS
  BEGIN
	INSERT INTO boca_data.TIPO_MOVILIDAD (nombre)
	SELECT DISTINCT REPARTIDOR_TIPO_MOVILIDAD
	FROM gd_esquema.Maestra
	WHERE REPARTIDOR_TIPO_MOVILIDAD IS NOT NULL
  END
GO

--delete from boca_data.TIPO_MOVILIDAD
--select distinct REPARTIDOR_TIPO_MOVILIDAD from gd_esquema.Maestra
--select * from boca_data.TIPO_MOVILIDAD

CREATE PROCEDURE boca_data.migrar_cupon_tipo
 AS
  BEGIN
	INSERT INTO boca_data.CUPON_TIPO (nombre)
	SELECT DISTINCT CUPON_TIPO
	FROM gd_esquema.Maestra
	WHERE CUPON_TIPO IS NOT NULL
  END
GO

--delete from boca_data.TIPO_MOVILIDAD
--select distinct CUPON_TIPO from gd_esquema.Maestra
--select * from boca_data.CUPON_TIPO

CREATE PROCEDURE boca_data.migrar_medio_de_pago_tipo
 AS
  BEGIN
	INSERT INTO boca_data.MEDIO_DE_PAGO_TIPO (nombre)
	SELECT DISTINCT MEDIO_PAGO_TIPO
	FROM gd_esquema.Maestra
	WHERE MEDIO_PAGO_TIPO IS NOT NULL
  END
GO
--select distinct MEDIO_PAGO_TIPO from gd_esquema.Maestra
--select * from boca_data.MEDIO_DE_PAGO_TIPO

CREATE PROCEDURE boca_data.migrar_pedido_estado
 AS
  BEGIN
	INSERT INTO boca_data.PEDIDO_ESTADO (nombre)
	SELECT DISTINCT PEDIDO_ESTADO
	FROM gd_esquema.Maestra
	WHERE PEDIDO_ESTADO IS NOT NULL
  END
GO

--delete from boca_data.migrar_pedido_estado
--select distinct PEDIDO_ESTADO from gd_esquema.Maestra
--select * from boca_data.PEDIDO_ESTADO

CREATE PROCEDURE boca_data.migrar_reclamo_tipo
 AS
  BEGIN
	INSERT INTO boca_data.RECLAMO_TIPO (nombre)
	SELECT DISTINCT RECLAMO_TIPO
	FROM gd_esquema.Maestra
	WHERE RECLAMO_TIPO IS NOT NULL
  END
GO

--delete from boca_data.migrar_pedido_estado
--select distinct RECLAMO_TIPO from gd_esquema.Maestra
--select * from boca_data.RECLAMO_TIPO

CREATE PROCEDURE boca_data.migrar_reclamo_estado
 AS
  BEGIN
	INSERT INTO boca_data.RECLAMO_ESTADO (nombre)
	SELECT DISTINCT RECLAMO_ESTADO
	FROM gd_esquema.Maestra
	WHERE RECLAMO_ESTADO IS NOT NULL
  END
GO

--delete from boca_data.migrar_reclamo_estado
--select distinct RECLAMO_ESTADO from gd_esquema.Maestra
--select * from boca_data.RECLAMO_ESTADO

CREATE PROCEDURE boca_data.migrar_envio_estado
 AS
  BEGIN
	INSERT INTO boca_data.ENVIO_ESTADO (nombre)
	SELECT DISTINCT ENVIO_MENSAJERIA_ESTADO
	FROM gd_esquema.Maestra
	WHERE ENVIO_MENSAJERIA_ESTADO IS NOT NULL
  END
GO

--delete from boca_data.migrar_pedido_estado
--select distinct ENVIO_MENSAJERIA_ESTADO from gd_esquema.Maestra
--select * from boca_data.ENVIO_ESTADO

CREATE PROCEDURE boca_data.migrar_usuario
 AS
  BEGIN
	INSERT INTO boca_data.USUARIO (nombre, apellido, dni, fecha_registro, telefono, mail, fecha_nacimiento)
	SELECT DISTINCT USUARIO_NOMBRE, USUARIO_APELLIDO, USUARIO_DNI, USUARIO_FECHA_REGISTRO, USUARIO_TELEFONO, USUARIO_MAIL, USUARIO_FECHA_NAC
	FROM gd_esquema.Maestra
  END
GO

--delete from boca_data.migrar_pedido_estado
--select distinct USUARIO_NOMBRE, USUARIO_APELLIDO, USUARIO_DNI, USUARIO_FECHA_REGISTRO, USUARIO_TELEFONO, USUARIO_MAIL, USUARIO_FECHA_NAC from gd_esquema.Maestra
--select * from boca_data.USUARIO

CREATE PROCEDURE boca_data.migrar_paquete_tipo
 AS
  BEGIN
	INSERT INTO boca_data.PAQUETE_TIPO (nombre, precio_tipo, alto_max, ancho_max, peso_max, largo_max)
	SELECT DISTINCT PAQUETE_TIPO, PAQUETE_TIPO_PRECIO, PAQUETE_ALTO_MAX, PAQUETE_ANCHO_MAX, PAQUETE_PESO_MAX, PAQUETE_LARGO_MAX
	FROM gd_esquema.Maestra
	WHERE PAQUETE_TIPO IS NOT NULL
  END
GO

--delete from boca_data.PAQUETE_TIPO
--select distinct PAQUETE_TIPO, PAQUETE_TIPO_PRECIO, PAQUETE_ALTO_MAX, PAQUETE_ANCHO_MAX, PAQUETE_PESO_MAX, PAQUETE_LARGO_MAX from gd_esquema.Maestra
--select * from boca_data.PAQUETE_TIPO

CREATE PROCEDURE boca_data.migrar_operador
 AS
  BEGIN
	INSERT INTO boca_data.OPERADOR (nombre, apellido, dni, telefono, mail, fecha_nacimiento, direccion)
	SELECT DISTINCT OPERADOR_RECLAMO_NOMBRE, OPERADOR_RECLAMO_APELLIDO, OPERADOR_RECLAMO_DNI, OPERADOR_RECLAMO_TELEFONO, OPERADOR_RECLAMO_MAIL, OPERADOR_RECLAMO_FECHA_NAC, OPERADOR_RECLAMO_DIRECCION
	FROM gd_esquema.Maestra
	WHERE OPERADOR_RECLAMO_NOMBRE IS NOT NULL
  END
GO

--delete from boca_data.OPERADOR
--select distinct OPERADOR_RECLAMO_NOMBRE, OPERADOR_RECLAMO_APELLIDO, OPERADOR_RECLAMO_DNI, OPERADOR_RECLAMO_TELEFONO, OPERADOR_RECLAMO_MAIL, OPERADOR_RECLAMO_FECHA_NAC, OPERADOR_RECLAMO_DIRECCION from gd_esquema.Maestra
--select * from boca_data.OPERADOR
CREATE PROCEDURE boca_data.migrar_paquete
AS
    BEGIN
        INSERT INTO boca_data.PAQUETE (paquete_tipo_id, precio,nro_envio)
        SELECT
            pt.id,
            m.PAQUETE_TIPO_PRECIO,
            m.ENVIO_MENSAJERIA_NRO
        FROM gd_esquema.Maestra m
        JOIN boca_data.PAQUETE_TIPO pt on pt.nombre = m.PAQUETE_TIPO
    END
GO


CREATE PROCEDURE boca_data.migrar_localidad
AS
    BEGIN
        INSERT INTO boca_data.LOCALIDAD (provincia_id, nombre)
        SELECT DISTINCT
            p.id,
            m.ENVIO_MENSAJERIA_LOCALIDAD
        FROM gd_esquema.Maestra m
                 JOIN boca_data.PROVINCIA p on p.nombre = m.ENVIO_MENSAJERIA_PROVINCIA
        WHERE ENVIO_MENSAJERIA_LOCALIDAD IS NOT NULL
        union
        SELECT DISTINCT
            p.id,
            m.LOCAL_LOCALIDAD
        FROM gd_esquema.Maestra m
                 JOIN boca_data.PROVINCIA p on p.nombre = m.LOCAL_PROVINCIA
        WHERE LOCAL_LOCALIDAD IS NOT NULL
        union
        SELECT DISTINCT
            p.id,
            m.DIRECCION_USUARIO_LOCALIDAD
        FROM gd_esquema.Maestra m
                 JOIN boca_data.PROVINCIA p on p.nombre = m.DIRECCION_USUARIO_PROVINCIA
        WHERE DIRECCION_USUARIO_LOCALIDAD IS NOT NULL

    END
GO


CREATE PROCEDURE boca_data.migrar_direccion_usuario
AS
    BEGIN
        INSERT INTO boca_data.DIRECCION_USUARIO (usuario_id, nombre, direccion, localidad_id)
        SELECT DISTINCT
            u.id,
            m.DIRECCION_USUARIO_NOMBRE,
            m.DIRECCION_USUARIO_DIRECCION,
            l.id
        FROM gd_esquema.Maestra m
                 JOIN boca_data.USUARIO u on u.apellido = m.USUARIO_APELLIDO and
                                             u.dni = m.USUARIO_DNI and
                                             u.fecha_nacimiento = m.USUARIO_FECHA_NAC and
                                             u.fecha_registro = m.USUARIO_FECHA_REGISTRO and
                                             u.mail = m.USUARIO_MAIL and
                                             u.nombre = m.USUARIO_NOMBRE and
                                             u.telefono = m.USUARIO_TELEFONO
                 JOIN boca_data.LOCALIDAD l on l.nombre = m.DIRECCION_USUARIO_LOCALIDAD
        WHERE DIRECCION_USUARIO_LOCALIDAD IS NOT NULL
    END
GO

CREATE PROCEDURE boca_data.crear_categorias_mercado
AS
    BEGIN
        INSERT INTO boca_data.CATEGORIA (nombre, tipo_id)
        SELECT
        'Kiosco',
        lt.id
        FROM boca_data.LOCAL_TIPO lt
        WHERE lt.nombre = 'Tipo Local Mercado'

        INSERT INTO boca_data.CATEGORIA (nombre, tipo_id)
        SELECT
            'Supermercado',
            lt.id
        FROM boca_data.LOCAL_TIPO lt
        WHERE lt.nombre = 'Tipo Local Mercado'

        INSERT INTO boca_data.CATEGORIA (nombre, tipo_id)
        SELECT
            'Minimercado',
            lt.id
        FROM boca_data.LOCAL_TIPO lt
        WHERE lt.nombre = 'Tipo Local Mercado'

    END
GO


CREATE PROCEDURE boca_data.crear_categorias_restaurante
AS
    BEGIN
        INSERT INTO boca_data.CATEGORIA (nombre, tipo_id)
        SELECT
            'Parrilla',
            lt.id
        FROM boca_data.LOCAL_TIPO lt
        WHERE lt.nombre = 'Tipo Local Restaurante'

        INSERT INTO boca_data.CATEGORIA (nombre, tipo_id)
        SELECT
            'Cafeteria',
            lt.id
        FROM boca_data.LOCAL_TIPO lt
        WHERE lt.nombre = 'Tipo Local Restaurante'

        INSERT INTO boca_data.CATEGORIA (nombre, tipo_id)
        SELECT
            'Heladeria',
            lt.id
        FROM boca_data.LOCAL_TIPO lt
        WHERE lt.nombre = 'Tipo Local Restaurante'

        INSERT INTO boca_data.CATEGORIA (nombre, tipo_id)
        SELECT
            'Comidas Rapidas',
            lt.id
        FROM boca_data.LOCAL_TIPO lt
        WHERE lt.nombre = 'Tipo Local Restaurante'
    END
GO


CREATE PROCEDURE boca_data.migrar_local
AS
    BEGIN
        INSERT INTO boca_data.LOCAL (nombre, descripcion, direccion, localidad_id, categoria_id)
        SELECT DISTINCT
            m.LOCAL_NOMBRE,
            m.LOCAL_DESCRIPCION,
            m.LOCAL_DIRECCION,
            l.id,
            ( SELECT TOP 1 id FROM boca_data.CATEGORIA WHERE tipo_id = lt.id ORDER BY nombre)

            FROM gd_esquema.Maestra m
                JOIN boca_data.LOCALIDAD l on  l.nombre = m.LOCAL_LOCALIDAD
                JOIN boca_data.LOCAL_TIPO lt on lt.nombre = m.LOCAL_TIPO
        WHERE m.LOCAL_NOMBRE IS NOT NULL
    END
GO


CREATE PROCEDURE boca_data.migrar_horario
AS
    BEGIN
        INSERT INTO boca_data.HORARIO (dia, hora_apertura, hora_cierre, local_id)
        SELECT DISTINCT
            d.id,
            m.HORARIO_LOCAL_HORA_APERTURA,
            m.HORARIO_LOCAL_HORA_CIERRE,
            l.id
        FROM gd_esquema.Maestra m
                 JOIN boca_data.LOCAL l on  l.nombre = m.LOCAL_NOMBRE and
                                            l.descripcion = m.LOCAL_DESCRIPCION and
                                            l.direccion = m.LOCAL_DIRECCION
                 JOIN boca_data.DIA d on d.nombre = m.HORARIO_LOCAL_DIA
        WHERE m.LOCAL_NOMBRE IS NOT NULL
    END
GO


CREATE PROCEDURE boca_data.migrar_producto
AS
BEGIN
    INSERT INTO boca_data.PRODUCTO (codigo_producto, nombre, descripcion, precio, local_id)
    SELECT DISTINCT
        m.PRODUCTO_LOCAL_CODIGO,
        m.PRODUCTO_LOCAL_NOMBRE,
        m.PRODUCTO_LOCAL_DESCRIPCION,
        m.PRODUCTO_LOCAL_PRECIO,
        l.id
    FROM gd_esquema.Maestra m
             JOIN boca_data.LOCAL l on  l.nombre = m.LOCAL_NOMBRE and
                                        l.descripcion = m.LOCAL_DESCRIPCION and
                                        l.direccion = m.LOCAL_DIRECCION
    WHERE m.PRODUCTO_LOCAL_CODIGO IS NOT NULL
END
GO





/* MOVER DE ACA */


-- traerse de la tabla maestra las fechas de PEDIDO y ENVIO_MENSAJERIA para ese repartidor
-- elegir la última, con eso nos quedamos una localidad(nombre)
-- y traemos de la tabla LOCALIDAD el id



CREATE PROCEDURE boca_data.migrar_repartidor
AS
BEGIN
    INSERT INTO boca_data.REPARTIDOR (nombre, apellido, dni, telefono, direccion, email, fecha_nacimiento, movilidad_id, localidad_id)
    SELECT DISTINCT
        REPARTIDOR_NOMBRE,
        REPARTIDOR_APELLIDO,
        REPARTIDOR_DNI,
        REPARTIDOR_TELEFONO,
        REPARTIDOR_DIRECION,
        REPARTIDOR_EMAIL,
        REPARTIDOR_FECHA_NAC,
        mov.id,
        loc.id
    from
        (SELECT DISTINCT
             isnull(LOCAL_LOCALIDAD,
                    ENVIO_MENSAJERIA_LOCALIDAD) as localidad,
             isnull([PEDIDO_FECHA], ENVIO_MENSAJERIA_FECHA) as fecha,
             isnull(LOCAL_PROVINCIA, ENVIO_MENSAJERIA_PROVINCIA) as provincia,
             [PEDIDO_FECHA],
             ENVIO_MENSAJERIA_FECHA,
             LOCAL_LOCALIDAD,
             ENVIO_MENSAJERIA_LOCALIDAD,
             REPARTIDOR_APELLIDO,
             REPARTIDOR_NOMBRE,
             REPARTIDOR_DNI,
             REPARTIDOR_TELEFONO,
             REPARTIDOR_DIRECION,
             REPARTIDOR_EMAIL,
             REPARTIDOR_FECHA_NAC,
             REPARTIDOR_TIPO_MOVILIDAD movilidad,
             ROW_NUMBER() OVER (PARTITION BY REPARTIDOR_DNI,REPARTIDOR_APELLIDO, REPARTIDOR_NOMBRE ORDER BY isnull([PEDIDO_FECHA], ENVIO_MENSAJERIA_FECHA) DESC) rownum
         FROM gd_esquema.Maestra) as FECHAS
            JOIN boca_data.LOCALIDAD loc on loc.nombre = localidad
            JOIN boca_data.PROVINCIA pro on pro.nombre = provincia and loc.provincia_id = pro.id
            JOIN boca_data.TIPO_MOVILIDAD mov on mov.nombre = movilidad
    where rownum=1
END
GO




/*
CREATE FUNCTION boca_data.obtener_localidad_id (@repartidor_nombre nvarchar(255), @repartidor_apellido nvarchar(255), @repartidor_dni decimal(18, 0),
@ENVIO_MENSAJERIA_FECHA datetime, @PEDIDO_FECHA datetime)
    returns decimal(18,0)
AS
BEGIN
	DECLARE @fecha datetime =
			CASE WHEN @ENVIO_MENSAJERIA_FECHA  >  @PEDIDO_FECHA THEN @ENVIO_MENSAJERIA_FECHA
			ELSE @PEDIDO_FECHA
		END
	DECLARE @localidad_nombre nvarchar(255);
	DECLARE @provincia_nombre nvarchar(255);


	SELECT TOP 1 @localidad_nombre =
			CASE WHEN ISNULL(ENVIO_MENSAJERIA_FECHA, 0)  >  ISNULL(PEDIDO_FECHA,0) THEN ENVIO_MENSAJERIA_LOCALIDAD
			ELSE LOCAL_LOCALIDAD
		END,
		@provincia_nombre =
			CASE WHEN ISNULL(ENVIO_MENSAJERIA_FECHA, 0)  >  ISNULL(PEDIDO_FECHA,0) THEN ENVIO_MENSAJERIA_PROVINCIA
			ELSE LOCAL_PROVINCIA
		END
		FROM gd_esquema.Maestra m
		WHERE m.REPARTIDOR_NOMBRE = @repartidor_nombre AND m.REPARTIDOR_APELLIDO = @repartidor_apellido AND m.REPARTIDOR_DNI = @repartidor_dni
		AND (m.ENVIO_MENSAJERIA_FECHA = @fecha OR m.PEDIDO_FECHA = @fecha)
			AND (ENVIO_MENSAJERIA_LOCALIDAD IS NOT NULL OR LOCAL_LOCALIDAD IS NOT NULL)

	return
	(
		SELECT l.id FROM boca_data.LOCALIDAD l
		JOIN boca_data.PROVINCIA p ON p.id = l.provincia_id
		WHERE l.nombre = @localidad_nombre AND p.nombre = @provincia_nombre
	)
END
GO

CREATE PROCEDURE boca_data.migrar_repartidor
AS
BEGIN
    INSERT INTO boca_data.REPARTIDOR (nombre, apellido, dni, telefono, direccion, email, fecha_nacimiento, movilidad_id, localidad_id)
	SELECT DISTINCT
        m.REPARTIDOR_NOMBRE,
        m.REPARTIDOR_APELLIDO,
        m.REPARTIDOR_DNI,
        m.REPARTIDOR_TELEFONO,
        m.REPARTIDOR_DIRECION,
        m.REPARTIDOR_EMAIL,
        m.REPARTIDOR_FECHA_NAC,
        mov.id
		,(SELECT boca_data.obtener_localidad_id(m.REPARTIDOR_NOMBRE, m.REPARTIDOR_APELLIDO, m.REPARTIDOR_DNI,MAX(ENVIO_MENSAJERIA_FECHA), MAX(PEDIDO_FECHA)))

    FROM gd_esquema.Maestra m

    JOIN boca_data.TIPO_MOVILIDAD mov on mov.nombre = m.REPARTIDOR_TIPO_MOVILIDAD
    WHERE m.REPARTIDOR_NOMBRE IS NOT NULL

	GROUP BY m.REPARTIDOR_NOMBRE,
        m.REPARTIDOR_APELLIDO,
        m.REPARTIDOR_DNI,
        m.REPARTIDOR_TELEFONO,
        m.REPARTIDOR_DIRECION,
        m.REPARTIDOR_EMAIL,
        m.REPARTIDOR_FECHA_NAC,
        mov.id
END
GO

TIEMPO: 1m 06
*/


COMMIT



--------------------------------------- M I G R A C I O N ---------------------------------------

BEGIN TRANSACTION
    BEGIN TRY
        EXECUTE boca_data.migrar_local_tipo
        EXECUTE boca_data.migrar_provincia
        EXECUTE boca_data.migrar_dia
        EXECUTE boca_data.migrar_tipo_movilidad
        EXECUTE boca_data.migrar_cupon_tipo
        EXECUTE boca_data.migrar_medio_de_pago_tipo
        EXECUTE boca_data.migrar_pedido_estado
        EXECUTE boca_data.migrar_reclamo_tipo
        EXECUTE boca_data.migrar_reclamo_estado
        EXECUTE boca_data.migrar_envio_estado
        EXECUTE boca_data.migrar_usuario
        EXECUTE boca_data.migrar_paquete_tipo
        EXECUTE boca_data.migrar_operador
        EXECUTE boca_data.migrar_localidad
        EXECUTE boca_data.migrar_direccion_usuario
        EXECUTE boca_data.crear_categorias_restaurante
        EXECUTE boca_data.crear_categorias_mercado
        EXECUTE boca_data.migrar_local
        EXECUTE boca_data.migrar_horario
        EXECUTE boca_data.migrar_producto
        EXECUTE boca_data.migrar_repartidor

        --EXECUTE boca_data.migrar_paquete

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW 50001, 'Error al migrar todoooooooooo aaaaaaaaaaaah', 1;
    END CATCH
COMMIT

