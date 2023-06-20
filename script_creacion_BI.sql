USE [GD1C2023]
GO

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE schema_id = SCHEMA_ID('boca_data'))
    BEGIN
--------------------------------------  E L I M I N A R   FUNCTIONS  --------------------------------------
        DECLARE @SQL_FN NVARCHAR(MAX) = N'';

        SELECT @SQL_FN += N'
	DROP FUNCTION boca_data.' + name  + ';'
        FROM sys.objects WHERE type = 'FN'
                           AND schema_id = SCHEMA_ID('boca_data')
                           AND name LIKE 'BI[_]%'
        EXECUTE(@SQL_FN)
--------------------------------------  E L I M I N A R   S P  --------------------------------------
        DECLARE @SQL_SP NVARCHAR(MAX) = N'';

        SELECT @SQL_SP += N'
	DROP PROCEDURE boca_data.' + name  + ';'
        FROM sys.objects WHERE type = 'P'
                           AND schema_id = SCHEMA_ID('boca_data')
                           AND name LIKE 'BI[_]%'
        EXECUTE(@SQL_SP)

--------------------------------------  E L I M I N A R   F K  --------------------------------------
        DECLARE @SQL_FK NVARCHAR(MAX) = N'';

        SELECT @SQL_FK += N'
	ALTER TABLE boca_data.' + OBJECT_NAME(PARENT_OBJECT_ID) + ' DROP CONSTRAINT ' + OBJECT_NAME(OBJECT_ID) + ';'
        FROM SYS.OBJECTS
        WHERE TYPE_DESC LIKE '%CONSTRAINT'
          AND type = 'F'
          AND schema_id = SCHEMA_ID('boca_data')
          AND OBJECT_NAME(PARENT_OBJECT_ID) LIKE 'BI[_]%'
        --PRINT @SQL_FK
        EXECUTE(@SQL_FK)

--------------------------------------  E L I M I N A R   P K  --------------------------------------
        DECLARE @SQL_PK NVARCHAR(MAX) = N'';

        SELECT @SQL_PK += N'
	ALTER TABLE boca_data.' + OBJECT_NAME(PARENT_OBJECT_ID) + ' DROP CONSTRAINT ' + OBJECT_NAME(OBJECT_ID) + ';'
        FROM SYS.OBJECTS
        WHERE TYPE_DESC LIKE '%CONSTRAINT'
          AND type = 'PK'
          AND schema_id = SCHEMA_ID('boca_data')
          AND OBJECT_NAME(PARENT_OBJECT_ID) LIKE 'BI[_]%'

        --PRINT @SQL_PK
        EXECUTE(@SQL_PK)

------------------------------------  D R O P    T A B L E S   -----------------------------------
        DECLARE @SQL_DROP NVARCHAR(MAX) = N'';

        SELECT @SQL_DROP += N'
	DROP TABLE boca_data.' + TABLE_NAME + ';'
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'boca_data'
          AND TABLE_TYPE = 'BASE TABLE'
          AND TABLE_NAME LIKE 'BI[_]%'

        --PRINT @SQL_DROP
        EXECUTE(@SQL_DROP)

---------------------------------------- D R O P   V I E W S  -------------------------------------
        DECLARE @SQL_VIEW NVARCHAR(MAX) = N'';

        SELECT @SQL_VIEW += N'
	DROP VIEW boca_data.' + TABLE_NAME + ';'
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'boca_data'
          AND TABLE_TYPE = 'VIEW'
          AND TABLE_NAME LIKE 'BI[_]%'

        --PRINT @SQL_VIEW
        EXECUTE(@SQL_VIEW)

    END
GO

----------------------------------------- C R E A C I O N  T A B L A S -------------------------------------
BEGIN TRANSACTION

--Tiempo
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_TIEMPO')
CREATE TABLE boca_data.BI_TIEMPO (
                                     id decimal(18,0) IDENTITY PRIMARY KEY,
                                     anio nvarchar(4),
									 mes_nombre nvarchar(50),
									 mes_nro tinyint
);

--D�a de la Semana
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_DIA')
CREATE TABLE boca_data.BI_DIA (
                                     id decimal(18,0) IDENTITY PRIMARY KEY,
                                     dia_nombre nvarchar(50),
									 dia_nro tinyint
);

--Horario
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_RANGO_HORARIO')
CREATE TABLE boca_data.BI_RANGO_HORARIO(
    id decimal(18, 0) IDENTITY PRIMARY KEY,
    rango_horario nvarchar(50) NOT NULL
)

--Provincia/Localidad
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_LOCALIDAD_PROVINCIA')
CREATE TABLE boca_data.BI_LOCALIDAD_PROVINCIA(
                                    id decimal(18,0) IDENTITY PRIMARY KEY,
									localidad nvarchar(255),
                                    provincia nvarchar(255)
                                    
);

--Rango Etario
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_RANGO_ETARIO')
CREATE TABLE boca_data.BI_RANGO_ETARIO(
    id decimal(18, 0) IDENTITY PRIMARY KEY,
    rango_edad nvarchar(50) NOT NULL
)

--Tipo Medio de pago
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_MEDIO_DE_PAGO_TIPO')
CREATE TABLE boca_data.BI_MEDIO_DE_PAGO_TIPO(
                                             id decimal(18,0) IDENTITY PRIMARY KEY,
                                             nombre nvarchar(50)
);

--Categoria_Tipo
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_LOCAL_CATEGORIA_TIPO')
CREATE TABLE boca_data.BI_LOCAL_CATEGORIA_TIPO (
											id decimal(18,0) IDENTITY PRIMARY KEY,
											categoria nvarchar(50),
											tipo nvarchar(50)
);

--Local
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_LOCAL')
CREATE TABLE boca_data.BI_LOCAL(
                                id decimal(18,0) IDENTITY PRIMARY KEY,
                                nombre nvarchar(255)
);

--Tipo de Movilidad
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_MOVILIDAD_TIPO')
CREATE TABLE boca_data.BI_MOVILIDAD_TIPO(
										id decimal(18,0) IDENTITY PRIMARY KEY,
										nombre nvarchar(255)
);

--Tipo de Paquete
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_PAQUETE_TIPO')
CREATE TABLE boca_data.BI_PAQUETE_TIPO(
										id decimal(18,0) IDENTITY PRIMARY KEY,
										nombre nvarchar(255)
);

--Estados Pedidos
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_PEDIDO_ESTADO')
CREATE TABLE boca_data.BI_PEDIDO_ESTADO(
										id decimal(18,0) IDENTITY PRIMARY KEY,
										nombre nvarchar(255)
);

--Estado Env�o Mensajer�a
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_ENVIO_MENSAJERIA_ESTADO')
CREATE TABLE boca_data.BI_ENVIO_MENSAJERIA_ESTADO(
												id decimal(18,0) IDENTITY PRIMARY KEY,
												nombre nvarchar(255)
);

--Estados Reclamos
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_RECLAMO_ESTADO')
CREATE TABLE boca_data.BI_RECLAMO_ESTADO(
										id decimal(18,0) IDENTITY PRIMARY KEY,
										nombre nvarchar(255)
);

--Tipos Reclamo
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_RECLAMO_TIPO')
CREATE TABLE boca_data.BI_RECLAMO_TIPO(
                                            id decimal(18,0) IDENTITY PRIMARY KEY,
                                            nombre nvarchar(255)
);


CREATE TABLE boca_data.BI_HECHOS_ENVIO_MENSAJERIA (
                                  id_tiempo decimal(18,0),
                                  id_envio_mensajeria_estado decimal(18,0),
                                  id_paquete_tipo decimal(18,0),
                                  valor_asegurado decimal(18,2),
                                  PRIMARY KEY(id_tiempo,id_envio_mensajeria_estado,id_paquete_tipo)
);

COMMIT TRANSACTION


--------------------------------------- C R E A C I O N   F K ---------------------------------------

ALTER TABLE boca_data.BI_HECHOS_ENVIO_MENSAJERIA
    WITH CHECK
        ADD CONSTRAINT FK_HECHOS_ENVIO_MENSAJERIA_TIEMPO FOREIGN KEY(id_tiempo)
        REFERENCES boca_data.BI_TIEMPO (id),
        CONSTRAINT FK_HECHOS_ENVIO_MENSAJERIA_ESTADO FOREIGN KEY (id_envio_mensajeria_estado)
            REFERENCES boca_data.BI_ENVIO_MENSAJERIA_ESTADO (id),
        CONSTRAINT FK_HECHOS_ENVIO_MENSAJERIA_PAQUETE_TIPO FOREIGN KEY (id_paquete_tipo)
            REFERENCES boca_data.BI_PAQUETE_TIPO (id);


--------------------------------------- C R E A C I O N   S P ---------------------------------------
GO
--Tiempo (VER SI NUMERO O NOMBRE)
--ESTRATEGIA: no ponemos fechas de reclamo porque son las mismas de los pedidos
CREATE PROCEDURE boca_data.BI_migrar_tiempo
AS
BEGIN
	INSERT INTO boca_data.BI_TIEMPO (anio, mes_nombre, mes_nro)
	SELECT DISTINCT
		YEAR(fecha),
		DATENAME(MONTH,fecha),
		MONTH(fecha)
	FROM boca_data.PEDIDO
END
GO
	
--Dia (VER SI NUMERO O NOMBRE)
CREATE PROCEDURE boca_data.BI_migrar_dia
AS
BEGIN
	INSERT INTO boca_data.BI_DIA (dia_nombre, dia_nro)
	SELECT DISTINCT
		DATENAME(WEEKDAY,fecha),
		DATEPART(WEEKDAY,fecha)
	FROM boca_data.PEDIDO
END
GO

--Horario
CREATE PROCEDURE boca_data.BI_migrar_horario
AS
BEGIN
	--SET IDENTITY_INSERT boca_data.BI_Rango_Horario ON
	INSERT INTO boca_data.BI_Rango_Horario(rango_horario ) 
	VALUES	('8-10'), 
			('10-12'),
			('12-14'), 
			('14-16'),
			('16-18'),
			('18-20'), 
			('20-22'), 
			('22-0')	
END
GO

--Localidad_Provincia
CREATE PROCEDURE boca_data.BI_migrar_localidad_provincia
AS
BEGIN
	INSERT INTO boca_data.BI_LOCALIDAD_PROVINCIA(localidad, provincia)
	SELECT
		l.nombre,
		p.nombre
	FROM boca_data.LOCALIDAD l
	JOIN boca_data.PROVINCIA p ON p.id = l.provincia_id
END
GO

--Rango Etario
CREATE PROCEDURE boca_data.BI_migrar_rango_etario
AS
BEGIN
	SET IDENTITY_INSERT boca_data.BI_RANGO_ETARIO ON
	INSERT INTO boca_data.BI_RANGO_ETARIO (id, rango_edad)
	VALUES (1, '<25'),
			(2, '25-35'), 
			(3, '35-55'),
			(4,'>55')
END
GO

--Tipo Medio de pago
CREATE PROCEDURE boca_data.BI_migrar_medio_de_pago_tipo
AS
BEGIN
	INSERT INTO boca_data.BI_MEDIO_DE_PAGO_TIPO(nombre)
	SELECT
		nombre
	FROM boca_data.MEDIO_DE_PAGO_TIPO
END
GO

--Tipo de Local/Categor�a de Local
CREATE PROCEDURE boca_data.BI_migrar_categorias
AS
BEGIN
	INSERT INTO boca_data.BI_LOCAL_CATEGORIA_TIPO (categoria, tipo)
	SELECT
		c.nombre,
		t.nombre
	FROM boca_data.CATEGORIA c
	JOIN boca_data.LOCAL_TIPO t ON t.id = c.tipo_id
END
GO

--Local
CREATE PROCEDURE boca_data.BI_migrar_local
AS
BEGIN
	INSERT INTO boca_data.BI_LOCAL (nombre)
    SELECT
		l.nombre
	FROM boca_data.LOCAL l
END
GO

--Tipo de Movilidad
CREATE PROCEDURE boca_data.BI_migrar_tipos_movilidad
AS
BEGIN
	INSERT INTO boca_data.BI_MOVILIDAD_TIPO (nombre)
	SELECT
		m.nombre
	FROM boca_data.TIPO_MOVILIDAD m
END
GO

--Tipo de Paquete
CREATE PROCEDURE boca_data.BI_migrar_tipos_paquete
AS
BEGIN
	INSERT INTO boca_data.BI_PAQUETE_TIPO (nombre)
	SELECT
		p.nombre
	FROM boca_data.PAQUETE_TIPO p
END
GO

--Estados Pedidos
CREATE PROCEDURE boca_data.BI_migrar_estados_pedido
AS
BEGIN
	INSERT INTO boca_data.BI_PEDIDO_ESTADO
	SELECT
		p.nombre
	FROM boca_data.PEDIDO_ESTADO p
END
GO

--Estado Env�o Mensajer�a
CREATE PROCEDURE boca_data.BI_migrar_estados_mensajeria
AS
BEGIN
	INSERT INTO boca_data.BI_ENVIO_MENSAJERIA_ESTADO
	SELECT
		e.nombre
	FROM boca_data.ENVIO_ESTADO e
END
GO

--Estados Reclamos
CREATE PROCEDURE boca_data.BI_migrar_estados_reclamo
AS
BEGIN
	INSERT INTO boca_data.BI_RECLAMO_ESTADO
	SELECT
		r.nombre
	FROM boca_data.RECLAMO_ESTADO r
END
GO

--Tipos Reclamos
CREATE PROCEDURE boca_data.BI_migrar_reclamo_tipo
AS
BEGIN
    INSERT INTO boca_data.BI_RECLAMO_TIPO
    SELECT
        r.nombre
    FROM boca_data.RECLAMO_TIPO r
END
GO

--------------------------------------- MIGRAR HECHOS ---------------------------------------

--Tipos Reclamos
CREATE PROCEDURE boca_data.BI_migrar_hechos_envio_mensajeria
AS
BEGIN
    INSERT INTO boca_data.BI_HECHOS_ENVIO_MENSAJERIA(id_tiempo,
                                                     id_envio_mensajeria_estado,
                                                    id_paquete_tipo,
                                                    valor_asegurado)
    SELECT
        bi_t.id,
        bi_eme.id,
        bi_pt.id,
        SUM(em.valor_asegurado)
    FROM boca_data.ENVIO_MENSAJERIA em
             JOIN boca_data.BI_TIEMPO bi_t on  bi_t.mes_nro = MONTH(em.fecha_entrega) AND bi_t.anio = YEAR(em.fecha_entrega)
             JOIN boca_data.ENVIO_ESTADO ee on ee.id = em.envio_estado_id
             JOIN boca_data.BI_ENVIO_MENSAJERIA_ESTADO bi_eme ON bi_eme.nombre = ee.nombre
             JOIN boca_data.PAQUETE p ON p.nro_envio = em.nro_envio
             JOIN boca_data.PAQUETE_TIPO pt ON pt.id = p.paquete_tipo_id
             JOIN boca_data.BI_PAQUETE_TIPO bi_pt ON bi_pt.nombre = pt.nombre
    GROUP BY bi_t.id, bi_eme.id, bi_pt.id
END
GO

--------------------------------------- C R E A C I O N   F U N C I O N E S ---------------------------------------

--Horario
CREATE FUNCTION boca_data.BI_obtener_rango_horario (@fecha_de_pedido date)
    RETURNS varchar(10)
AS
BEGIN
    DECLARE @returnvalue varchar(10);
    DECLARE @horario int;
    SELECT @horario = (CONVERT(int,DATEPART(HOUR, @fecha_de_pedido)));

    IF (@horario >= 8 and @horario <10)
        BEGIN
            SET @returnvalue = '8-10';
        END
    ELSE IF (@horario >= 10 AND @horario <12)
        BEGIN
            SET @returnvalue = '10-12';
        END
    ELSE IF (@horario >= 12 AND @horario <14)
        BEGIN
            SET @returnvalue = '12-14';
        END
    ELSE IF (@horario >= 14 AND @horario <16)
        BEGIN
            SET @returnvalue = '14-16';
        END
    ELSE IF (@horario >= 16 AND @horario <18)
        BEGIN
            SET @returnvalue = '16-18';
        END
        ELSE IF (@horario >= 18 AND @horario <20)
        BEGIN
            SET @returnvalue = '18-20';
        END
    ELSE IF (@horario >= 20 AND @horario <22)
        BEGIN
            SET @returnvalue = '20-22';
        END
    ELSE IF (@horario >= 22 AND @horario <24)
        BEGIN
            SET @returnvalue = '22-0';
        END
    RETURN @returnvalue;
END
GO

--Rango Etario
CREATE FUNCTION boca_data.BI_obtener_rango_etario (@fecha_de_nacimiento date)
    RETURNS varchar(10)
AS
BEGIN
    DECLARE @returnvalue varchar(10);
    DECLARE @edad int;
    SELECT @edad = (CONVERT(int,CONVERT(char(8),GetDate(),112))-CONVERT(char(8),@fecha_de_nacimiento,112))/10000;

    IF (@edad < 25)
        BEGIN
            SET @returnvalue = '< 25';
        END
    ELSE IF (@edad > 24 AND @edad <36)
        BEGIN
            SET @returnvalue = '25 - 35';
        END
    ELSE IF (@edad > 35 AND @edad <56)
        BEGIN
            SET @returnvalue = '35 - 55';
        END
    ELSE IF(@edad > 55)
        BEGIN
            SET @returnvalue = '> 50';
        END

    RETURN @returnvalue;
END
GO


--------------------------------------- M I G R A C I O N   B I ---------------------------------------

EXECUTE boca_data.BI_migrar_tiempo
EXECUTE boca_data.BI_migrar_dia
EXECUTE boca_data.BI_migrar_horario
EXECUTE boca_data.BI_migrar_localidad_provincia
EXECUTE boca_data.BI_migrar_rango_etario
EXECUTE boca_data.BI_migrar_medio_de_pago_tipo
EXECUTE boca_data.BI_migrar_categorias
EXECUTE boca_data.BI_migrar_local
EXECUTE boca_data.BI_migrar_tipos_movilidad
EXECUTE boca_data.BI_migrar_tipos_paquete
EXECUTE boca_data.BI_migrar_estados_pedido
EXECUTE boca_data.BI_migrar_estados_mensajeria
EXECUTE boca_data.BI_migrar_estados_reclamo




--------------------------------------- C R E A C I O N   V I S T A S ---------------------------------------
GO

--VISTA 1
--D�a de la semana y franja horaria con mayor cantidad de pedidos seg�n la localidad y categor�a del local, para cada mes de cada a�o.

--Toda la info del pedido para un mismo a�o, mes, localidad y categoria:
/*SELECT
	b_t.a�o as a�o,
	b_t.mes_nombre as mes,
	b_loc.provincia as provincia,
	b_loc.localidad as localidad,
	b_cat.tipo as tipo_local,
	b_cat.categoria as categoria_local,
	p.*
FROM boca_data.PEDIDO p
JOIN boca_data.BI_TIEMPO b_t ON b_t.a�o = YEAR(p.fecha) AND
								b_t.mes_nro = MONTH(p.fecha)
JOIN boca_data.LOCAL l ON l.id = p.local_id
JOIN boca_data.LOCALIDAD loc ON loc.id = l.localidad_id
JOIN boca_data.PROVINCIA prov ON prov.id = loc.provincia_id
JOIN boca_data.BI_LOCALIDAD_PROVINCIA b_loc ON b_loc.localidad = loc.nombre AND
												b_loc.provincia = prov.nombre
JOIN boca_data.CATEGORIA c ON c.id = l.categoria_id
JOIN boca_data.LOCAL_TIPO lt ON lt.id = c.tipo_id
JOIN boca_data.BI_LOCAL_CATEGORIA_TIPO b_cat ON b_cat.categoria = c.nombre AND
												b_cat.tipo = lt.nombre
ORDER BY b_t.a�o, b_t.mes_nro, b_loc.provincia, b_loc.localidad, b_cat.tipo, b_cat.categoria

GO
CREATE VIEW boca_data.BI_VW_PEDIDOS_MAYOR_CANT
AS
SELECT
	t.a�o as a�o,
	t.mes_nombre as mes,
	lp.provincia as provincia,
	lp.localidad as localidad,
	ct.tipo as tipo_local,
	ct.categoria as categoria_local,
	(
		SELECT TOP 1
			DATENAME(WEEKDAY, p.fecha)
		FROM boca_data.PEDIDO p
		JOIN boca_data.LOCAL l ON l.id = p.local_id
		JOIN boca_data.LOCALIDAD loc ON loc.id = l.localidad_id
		JOIN boca_data.PROVINCIA prov ON prov.id = loc.provincia_id
		JOIN boca_data.CATEGORIA c ON c.id = l.categoria_id
		JOIN boca_data.LOCAL_TIPO tipo ON tipo.id = c.tipo_id
		WHERE YEAR(p.fecha) = t.a�o AND
				MONTH(p.fecha) = t.mes_nro AND
				loc.nombre = lp.localidad AND
				prov.nombre = lp.provincia AND
				c.nombre = ct.categoria AND
				tipo.nombre = ct.tipo
		GROUP BY DATENAME(WEEKDAY, p.fecha), FORMAT(p.fecha,'HH')
		ORDER BY COUNT(p.numero_pedido) DESC
	) as diaMayorCantPedidos,
	(
		SELECT TOP 1
			FORMAT(p.fecha,'HH')
		FROM boca_data.PEDIDO p
		JOIN boca_data.LOCAL l ON l.id = p.local_id
		JOIN boca_data.LOCALIDAD loc ON loc.id = l.localidad_id
		JOIN boca_data.PROVINCIA prov ON prov.id = loc.provincia_id
		JOIN boca_data.CATEGORIA c ON c.id = l.categoria_id
		JOIN boca_data.LOCAL_TIPO tipo ON tipo.id = c.tipo_id
		WHERE YEAR(p.fecha) = t.a�o AND
				MONTH(p.fecha) = t.mes_nro AND
				loc.nombre = lp.localidad AND
				prov.nombre = lp.provincia AND
				c.nombre = ct.categoria AND
				tipo.nombre = ct.tipo
		GROUP BY DATENAME(WEEKDAY, p.fecha), FORMAT(p.fecha,'HH')
		ORDER BY COUNT(p.numero_pedido) DESC
	) as horarioMayorCantPedidos
FROM boca_data.BI_TIEMPO t
JOIN boca_data.BI_LOCALIDAD_PROVINCIA lp ON lp.id IS NOT NULL
JOIN boca_data.BI_LOCAL_CATEGORIA_TIPO ct ON ct.id IS NOT NULL
WHERE t.a�o = '2023' AND
		t.mes_nro = 2 AND
		lp.localidad = 'Ines Indart' AND
		lp.provincia = 'Buenos Aires' AND
		ct.categoria = 'Kiosco' AND
		ct.tipo = 'Tipo Local Mercado'
--ORDER BY 1,2,3,4,5,6
GO

--Ejemplo para Febrero de 2023 en Agustin Ferrari (BsAs) para los Mercados que son Kioscos:
SELECT
	DATENAME(WEEKDAY, p.fecha) dia_semana,
	FORMAT(p.fecha,'HH') franja_horaria,
	*
FROM boca_data.PEDIDO p
JOIN boca_data.LOCAL l ON l.id = p.local_id
JOIN boca_data.LOCALIDAD loc ON loc.id = l.localidad_id
JOIN boca_data.PROVINCIA prov ON prov.id = loc.provincia_id
JOIN boca_data.CATEGORIA c ON c.id = l.categoria_id
JOIN boca_data.LOCAL_TIPO tipo ON tipo.id = c.tipo_id
WHERE YEAR(p.fecha) = '2023' AND
		MONTH(p.fecha) = 2 AND
		loc.nombre = 'Ines Indart' AND
		prov.nombre = 'Buenos Aires' AND
		c.nombre = 'Kiosco' AND
		tipo.nombre = 'Tipo Local Mercado'
ORDER BY DATEPART(WEEKDAY, p.fecha), FORMAT(p.fecha,'HH')

*/
--VISTA 2
--Monto total no cobrado por cada local en funci�n de los pedidos cancelados seg�n el d�a de la semana y 
--la franja horaria (cuentan como pedidos cancelados tanto los que cancela el usuario como el local).
