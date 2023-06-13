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
                                     año tinyint,
									 mes tinyint
);

--Día de la Semana
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_DIA')
CREATE TABLE boca_data.BI_DIA (
                                     id decimal(18,0) IDENTITY PRIMARY KEY,
                                     nombre nvarchar(50)
);

--Horario


--Provincia/Localidad
--Provincia
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_PROVINCIA')
CREATE TABLE boca_data.BI_PROVINCIA(
                                    id decimal(18,0) IDENTITY PRIMARY KEY,
                                    nombre nvarchar(255)
);

--Localidad
IF NOT EXISTS(SELECT [name] FROM sys.tables WHERE [name] = 'BI_LOCALIDAD')
CREATE TABLE boca_data.BI_LOCALIDAD(
                                    id decimal(18,0) IDENTITY PRIMARY KEY,
                                    provincia_id decimal(18,0),
                                    nombre nvarchar(255)
);

--Rango Etario


COMMIT TRANSACTION


--------------------------------------- C R E A C I O N   F K ---------------------------------------

BEGIN TRANSACTION

--Localidad -> Provincia
ALTER TABLE boca_data.BI_LOCALIDAD
    ADD CONSTRAINT BI_FK_LOCALIDAD_PROVINCIA
        FOREIGN KEY(provincia_id)
            REFERENCES boca_data.BI_PROVINCIA (id);

COMMIT TRANSACTION


--------------------------------------- C R E A C I O N   S P ---------------------------------------
GO
--Tiempo (VER SI NUMERO O NOMBRE)
CREATE PROCEDURE boca_data.BI_migrar_tiempo
AS
BEGIN
	INSERT INTO boca_data.BI_TIEMPO (año, mes)
	SELECT DISTINCT
		YEAR(fecha),
		MONTH(fecha)
	FROM boca_data.PEDIDO
END
GO
	
--Dia (VER SI NUMERO O NOMBRE)
CREATE PROCEDURE boca_data.BI_migrar_dia
AS
BEGIN
	INSERT INTO boca_data.BI_DIA (nombre)
	SELECT DISTINCT
		DATENAME(WEEKDAY,fecha)
	FROM boca_data.PEDIDO
END
GO

--Horario


--Provincia
CREATE PROCEDURE boca_data.BI_migrar_provincia
AS
BEGIN
    INSERT INTO boca_data.BI_PROVINCIA (nombre)
    SELECT
		nombre
	FROM boca_data.PROVINCIA
END
GO

--Localidad
CREATE PROCEDURE boca_data.BI_migrar_localidad
AS
BEGIN
	INSERT INTO boca_data.BI_LOCALIDAD (nombre, provincia_id)
	SELECT
		l.nombre,
		bp.id
	FROM boca_data.LOCALIDAD l
	JOIN boca_data.PROVINCIA p ON p.id = l.provincia_id
	JOIN boca_data.BI_PROVINCIA bp ON bp.nombre = p.nombre
END
GO

--Rango Etario
CREATE FUNCTION boca_data.bi_obtener_rango_etario (@fecha_de_nacimiento date)
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






--------------------------------------- C R E A C I O N   V I S T A S ---------------------------------------

--Día de la semana y franja horaria con mayor cantidad de pedidos según la localidad y categoría del local, para cada mes de cada año.CREATE VIEW boca_data.BI_VW_MAYOR_CANT_PEDIDOS (año, mes, provincia, localidad, categoria, dia, horario)ASSELECT	1 as año,	1 as mes,	1 as provincia,	1 as localidad,	1 as categoria,	1 as dia,	1 as horario