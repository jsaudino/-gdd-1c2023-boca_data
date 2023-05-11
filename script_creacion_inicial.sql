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
