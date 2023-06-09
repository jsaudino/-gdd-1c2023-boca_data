USE [GD2C2022]
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



        ----------------------------------------- D R O P   V I E W  -------------------------------------
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

