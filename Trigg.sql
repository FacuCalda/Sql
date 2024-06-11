-- Realizar un disparador que, ante la modificación de cualquier resultado de un torneo, 
-- lleve un registro detallado en la tabla AuditTorneo (ver estructura de la tabla en el 
-- anexo del presente obligatorio).

CREATE TRIGGER Trg_RegistroenAudit
ON inscripcion
AFTER UPDATE
AS
BEGIN 
    IF (UPDATE(posicion))
    BEGIN
        INSERT INTO AuditInscripcion
        SELECT GETDATE(), USER, D.posicion, I.posicion
        FROM inserted I
        INNER JOIN deleted D ON I.inscripcionID = D.inscripcionID;
    END
END;

-- Realizar un disparador que cuando se registra un kiter en un torneo se valide que el 
-- kiter tiene el nivel igual o superior al del torneo. Mostrar la lista de kiters que no se 
-- pudieron inscribir por no alcanzar el nivel. 
CREATE TRIGGER Trg_verificarKiterNivel
ON Inscripcion
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        DECLARE @idp INT;
        INSERT INTO Inscripcion 
        SELECT I.torneoID, I.participanteID, I.posicion
        FROM inserted I
        INNER JOIN Participante p ON p.participanteID = i.participanteID
        WHERE p.experiencia >= (SELECT t.nivel FROM Torneo t WHERE t.torneoID = i.torneoID)
		PRINT 'No se inscribio'
    END
END

-- Realizar un disparador que lleve un mantenimiento de los puntos acumulados de un 
-- participante en el año actual, este disparador debe controlar los puntos acumulados y 
-- al siguiente año debe reiniciar el contador. Agregar las columnas necesarias en las 
-- tablas. 

CREATE TRIGGER Trg_PuntosAcumulados
ON Inscripcion
INSTEAD OF UPDATE
AS
BEGIN
    IF (UPDATE(posicion))

    BEGIN
    DECLARE @AñoActual INT;
		SET @AñoActual = YEAR(GETDATE());
		--reinicio el contador si el año de la ultima inscripcion ya no es igual al año actual
		UPDATE Participante 
		SET puntosacumulados = 0
		WHERE participanteID IN
		(SELECT i.participanteID FROM inserted i
		WHERE YEAR(Participante.fecha_ultimaInscripcion) <> @AñoActual);
		
		UPDATE Participante 
		SET fecha_ultimaInscripcion = GETDATE()
		WHERE participanteID IN (SELECT i.participanteID FROM Inserted i);

		UPDATE Participante 
		SET puntosacumulados = puntosacumulados +
		(SELECT distinct pp.puntos 
		FROM puesto_puntos pp
		WHERE  pp.puesto IN (SELECT i.posicion FROM Inserted i) )
		WHERE participanteID IN (SELECT i.participanteID FROM Inserted i);
		
	
		UPDATE Inscripcion
		SET posicion = ins.posicion
		FROM Inscripcion 
		INNER JOIN inserted ins ON Inscripcion.inscripcionID = ins.inscripcionID;

		END
END