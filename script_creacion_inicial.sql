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


--CREACION ESQUEMA --
IF NOT EXISTS ( SELECT * FROM sys.schemas WHERE name = 'boca_data')
BEGIN
EXECUTE('CREATE SCHEMA boca_data')
END
GO

BEGIN TRANSACTION
CREATE TABLE [boca_data].[CATEGORIA] (
                                         id decimal(18,0) IDENTITY PRIMARY KEY,
    nombre nvarchar(50),
    tipo_id decimal(18,0)
    );
CREATE TABLE [boca_data].[LOCAL](
                                    id decimal(18,0) IDENTITY PRIMARY KEY,
    nombre nvarchar(255),
    descripcion nvarchar(255),
    direccion nvarchar(255),
    localidad_id decimal(18,0),
    categoria_id decimal(18,0)
    );

CREATE TABLE [boca_data].[LOCAL_TIPO](
                                         id decimal(18,0) IDENTITY PRIMARY KEY,
    nombre nvarchar(50)
    );

CREATE TABLE [boca_data].[REPARTIDOR](
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

CREATE TABLE [boca_data].[HORARIO](
                                      id decimal(18,0) IDENTITY PRIMARY KEY,
    dia decimal(18,0),
    hora_apertura decimal(18,0),
    hora_cierre decimal(18,0),
    local_id decimal(18,0)
    );

CREATE TABLE [boca_data].[DIA](
                                  id decimal(18,0) IDENTITY PRIMARY KEY,
    nombre nvarchar(50)
    );

CREATE TABLE boca_data.PRODUCTO(
                                   codigo_producto nvarchar(50) primary key,
                                   nombre nvarchar(50),
                                   descripcion nvarchar(255),
                                   precio decimal(18,2),
                                   local_id decimal(18,0)
);

CREATE TABLE boca_data.PEDIDO_PRODUCTO(
                                          producto_codigo nvarchar(50),
                                          pedido_numero decimal(18,0),
                                          cantidad_productos decimal(18,0),
                                          precio_unitario decimal(18,2),
                                          total_producto decimal(18,2),
                                          primary key(producto_codigo, pedido_numero)
);

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

CREATE TABLE boca_data.PAQUETE_TIPO(
                                       id decimal(18,0) IDENTITY PRIMARY KEY,
                                       nombre nvarchar(50),
                                       precio_tipo decimal(18, 2),
                                       alto_max decimal(18,2),
                                       ancho_max decimal(18,2),
                                       peso_max decimal(18,2),
                                       largo_max decimal(18,2)
);
CREATE TABLE boca_data.PAQUETE(
                                  id decimal(18,0) IDENTITY PRIMARY KEY,
                                  paquete_tipo_id decimal(18, 0),
                                  precio decimal(18, 2)
);

CREATE TABLE boca_data.ENVIO_MENSAJERIA(
                                           nro_envio decimal(18,0) IDENTITY PRIMARY KEY,
                                           usuario_id decimal(18, 0),
                                           fecha_mensajeria datetime2(3),
                                           direccion_origen nvarchar(255),
                                           direccion_destino nvarchar(255),
                                           localidad_id nvarchar(255),
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
CREATE TABLE boca_data.TIPO_MOVILIDAD(
                                         id decimal(18,0) IDENTITY PRIMARY KEY,
                                         nombre nvarchar(50)
)

CREATE TABLE boca_data.ENVIO_ESTADO(
                                       id decimal(18,0) IDENTITY PRIMARY KEY,
                                       nombre nvarchar(50)
);
CREATE TABLE boca_data.PEDIDO_ESTADO(
                                        id decimal(18,0) IDENTITY PRIMARY KEY,
                                        nombre nvarchar(50)
);
CREATE TABLE boca_data.ENVIO(
                                nro_envio decimal(18,0) IDENTITY PRIMARY KEY,
                                direccion_usuario_id nvarchar(255),
                                precio_envio decimal(18,2),
                                propina decimal(18,2),
                                repartidor_id decimal(18,0)
);

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

CREATE TABLE boca_data.DIRECCION_USUARIO(
                                            id decimal(18,0) IDENTITY PRIMARY KEY,
                                            usuario_id decimal(18,0),
                                            nombre nvarchar(50),
                                            direccion nvarchar(255),
                                            localidad_id decimal(18,0)
);

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

CREATE TABLE [boca_data].[TARJETA] (
                                       id decimal(18,0) IDENTITY PRIMARY KEY,
    numero nvarchar(50),
    marca nvarchar(100),
    usuario_id decimal(18,0)
    );
CREATE TABLE boca_data.CUPON(
                                numero decimal(18,0) IDENTITY PRIMARY KEY,
                                fecha_alta datetime2(3),
                                fecha_vencimiento datetime2(3),
                                monto decimal(18,2),
                                tipo decimal(18,0),
                                usuario_id decimal(18,0)
);
CREATE TABLE boca_data.CUPON_TIPO(
                                     id decimal(18,0) IDENTITY PRIMARY KEY,
                                     nombre nvarchar(50)
);
CREATE TABLE boca_data.RECLAMO(
                                  numero_reclamo decimal(18,0) IDENTITY PRIMARY KEY,
                                  usuario_id decimal(18,0),
                                  pedido_id decimal(18,0),
                                  tipo decimal(18,0),
                                  descripcion nvarchar(255),
                                  fecha_reclamo datetime2(3),
                                  operador_id decimal(18,0),
                                  estado nvarchar(50),
                                  solucion nvarchar(255),
                                  calificacion decimal(18,0),
                                  fecha_solucion datetime2(3)
);
CREATE TABLE boca_data.RECLAMO_CUPON(
                                        reclamo_id decimal(18,0),
                                        cupon_id decimal(18,0),
                                        primary key (reclamo_id,cupon_id)
);
CREATE TABLE boca_data.CUPON_PEDIDO(
                                       pedido_id decimal(18,0),
                                       cupon_id decimal(18,0),
                                       primary key (pedido_id,cupon_id)
);
CREATE TABLE boca_data.RECLAMO_TIPO(
                                       id decimal(18,0) IDENTITY PRIMARY KEY,
                                       nombre nvarchar(50)
);

CREATE TABLE boca_data.RECLAMO_ESTADO(
                                         id decimal(18,0) IDENTITY PRIMARY KEY,
                                         nombre nvarchar(50)
);
CREATE TABLE boca_data.MEDIO_DE_PAGO(
                                        id decimal(18,0) IDENTITY PRIMARY KEY,
                                        tipo_id decimal(18,0),
                                        tarjeta_id decimal(18,0)
);
COMMIT TRANSACTION