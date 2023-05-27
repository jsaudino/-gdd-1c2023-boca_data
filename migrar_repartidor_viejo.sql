
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