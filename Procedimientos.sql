-- Escribir un procedimiento almacenado que reciba como parámetros un rango de fechas 
-- un tipo de torneo y retorne por parámetros el nombre del kiter que ganó más en dicho 
-- rango de fechas (si hay más de uno, mostrar el primero).
CREATE PROCEDURE SP_KITER_FECHA
    @fecha1 DATE,
    @fecha2 DATE,
    @tipotorneo VARCHAR(50),
    @nombrekiter VARCHAR(50) OUTPUT
AS
BEGIN
    SELECT TOP 1 @nombrekiter = p.nombre
    FROM Inscripcion i
    JOIN Torneo t ON i.torneoID = t.torneoID
    JOIN Participante p ON p.participanteID = i.participanteID
    WHERE t.tipo = @tipotorneo AND t.fecha BETWEEN @fecha1 AND @fecha2
    AND i.posicion = 1
    ORDER BY i.posicion;
END

DECLARE @nombrekiter_resul varchar(50)
DECLARE @fecha1 date = '2022-05-01' 
DECLARE @fecha2 date = '2023-12-31'  
DECLARE @tipotorneo varchar(50) = 'Kite-Surf' 

EXEC SP_KITER_FECHA @fecha1, @fecha2, @tipotorneo, @nombrekiter_resul OUTPUT
SELECT @nombrekiter_resul AS 'Nombre del Kiter'

-- Realizar un procedimiento almacenado que dada un torneo valide que el mismo esté 
-- finalizado y que retorne la kiters de otras ciudades que participaron del torneo
CREATE PROCEDURE SP_TORNEO_FINALIZADO3
    @idtorneo int
AS
BEGIN
    IF EXISTS (
        SELECT t.torneoID
        FROM Torneo t
        WHERE torneoID = @idtorneo AND estado = 'Finalizado'
    )
    BEGIN
        SELECT DISTINCT p.participanteID
        FROM Inscripcion i
        JOIN Participante p ON i.participanteID = p.participanteID
        JOIN Torneo t ON i.torneoID = t.torneoID
        WHERE t.torneoID = @idtorneo AND p.locID <> t.locID
    END
    ELSE
    BEGIN
        PRINT 'El torneo no está finalizado.'
    END
END

DECLARE @idtorneoo int
DECLARE @idkiterR INT
SET @idtorneoo = 3

EXEC SP_TORNEO_FINALIZADO3 @idtorneoo

-- Hacer una función que reciba un código de torneo y retorne la cantidad de participantes 
-- en torneos realizados en el mismo pais.
CREATE FUNCTION FN_CANT_PARTICIPANTE (@Codtorneo int) RETURNS int
AS 
BEGIN
    DECLARE @cant int
    SELECT @cant = COUNT(i.participanteID) 
    FROM Inscripcion i
    INNER JOIN torneo t ON t.torneoID = i.torneoID
    WHERE t.locID IN (SELECT t2.locID FROM torneo t2 WHERE t2.torneoID = @Codtorneo)
    RETURN @cant
END

DECLARE @codtorneo int
DECLARE @cantparticipantes int
SET @codtorneo = 3
SET @cantparticipantes = dbo.FN_CANT_PARTICIPANTE(@codtorneo)
PRINT 'Cantidad de participantes: ' + CONVERT(varchar(10), @cantparticipantes)

-- Hacer una función que, para un participante dado, retorne la cantidad total de primeros 
-- puestos en diferentes torneos.
CREATE FUNCTION FN_CANTIDAD_PRIMERPUESTO(@IdParticipante int) RETURNS int
AS 
BEGIN
    DECLARE @cant int
    SELECT @cant = COUNT(i.posicion) 
    FROM Inscripcion i
    WHERE @IdParticipante = i.participanteID 
    AND i.posicion = 1 
    AND i.torneoID IN (SELECT DISTINCT torneoID FROM Inscripcion WHERE torneoID = i.torneoID)
    RETURN @cant
END

DECLARE @codpart int
DECLARE @cantprimerospuestos int
SET @codpart = 2
SET @cantprimerospuestos = dbo.FN_CANTIDAD_PRIMERPUESTO(@codpart)
PRINT 'Cantidad de primeros puestos: ' + CONVERT(varchar(10), @cantprimerospuestos);