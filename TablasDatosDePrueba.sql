CREATE TABLE Locacion (
    locID INT IDENTITY(1,1) PRIMARY KEY,
    pais VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100)
);

CREATE TABLE Torneo (
    torneoID INT IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha DATE CHECK (YEAR(fecha) > 2016),
    locID INT,
    tipo VARCHAR(50),
    estado VARCHAR(50),
    Nivel INT CHECK (Nivel >= 1 AND Nivel <= 10),
    FOREIGN KEY (locID) REFERENCES Locacion(locID)
);

-- Creación de la tabla Participante
CREATE TABLE Participante (
    participanteID INT IDENTITY PRIMARY KEY,
    nombre  VARCHAR(100) UNIQUE,
    locID INT, 
    fecha_nacimiento DATE,
    experiencia INT CHECK (experiencia >= 0 AND experiencia <= 10),
    puntosacumulados int ,
	fecha_ultimaInscripcion date
    FOREIGN KEY (locID) REFERENCES Locacion(locID)
);

-- Creación de la tabla Inscripcion
CREATE TABLE Inscripcion (
    inscripcionID INT IDENTITY,
    torneoID INT,
    participanteID INT, 
    posicion INT,
    FOREIGN KEY (torneoID) REFERENCES Torneo(torneoID),
    FOREIGN KEY (participanteID) REFERENCES Participante(participanteID)
);

CREATE TABLE puesto_puntos (
    puesto INT,
    puntos INT
);

CREATE TABLE AuditInscripcion(
    AuditID int identity not null,
    AuditFecha datetime,
    AuditHost varchar(30),
    posAnterior decimal,
    posActual decimal
);
INSERT INTO Locacion (pais, ciudad)
VALUES 
    ('USA', 'Miami'),
    ('Brasil', 'Cumbuco'),
    ('España', 'Tarifa'),
    ('Australia', 'Gold Coast'),
    ('Mauritius', 'Le Morne'),
    ('Portugal', 'Lisbon'),
    ('Tailandia', 'Phuket');
--insert de torneos con el nivel incorrecto
INSERT INTO Torneo (nombre, fecha, locID, tipo, estado, Nivel)
VALUES 
	 ('Torneo Kite Pro Nivel 11', '2023-06-15', 1, 'freestyle', 'en competencia', 11),
    ('Torneo Kite Pro Nivel -1', '2016-06-15', 1, 'freestyle', 'en competencia', -1)

INSERT INTO Torneo (nombre, fecha, locID, tipo, estado, Nivel)
VALUES 
    ('Torneo Kite Pro 2023', '2023-06-15', 1, 'freestyle', 'en competencia', 10),
    ('Kite Clash 2023', '2023-07-20', 1, 'Kite-Surf', 'en competencia', 6),
    ('Parkstyle Jam 2023', '2023-08-25', 3, 'parkstyle', 'finalizado', 7);

INSERT INTO Torneo (nombre, fecha, locID, tipo, estado, Nivel)
VALUES 
    ('Kite Masters 2022', '2022-05-10', 2, 'freestyle', 'competencia', 10),
    ('KiteFest 2022', '2022-07-15', 2, 'Kite-Surf', 'finalizado', 5),
    ('Parkstyle Challenge 2022', '2022-09-01', 4, 'parkstyle', 'finalizado', 6);

INSERT INTO Torneo (nombre, fecha, locID, tipo, estado, Nivel)
VALUES 
    ('KiteJam 2021', '2021-04-20', 4, 'freestyle', 'cancelado', 4),
    ('KiteFusion 2021', '2021-06-25', 1, 'Kite-Surf', 'finalizado', 8),
    ('Parkstyle Fest 2021', '2021-08-10', 1, 'parkstyle', 'finalizado', 5);

INSERT INTO Torneo (nombre, fecha, locID, tipo, estado, Nivel)
VALUES 
    ('Racing Invitational', '2021-09-25', 1, 'Racing', 'finalizado', 5),
    ('FreeJam 2019', '2021-02-22', 4, 'freestyle', 'en competencia', 9),
    ('FreeJam 2021', '2021-09-30', 1, 'freestyle', 'en competencia', 4);

	

-- Inserts para participantes en USA 
INSERT INTO Participante (nombre, locID, fecha_nacimiento, experiencia,puntosacumulados)
VALUES 
    ('John Doe', 1, '1998-05-15', 10,0),
    ('Alice Smith', 1, '2001-02-28', 10,0),
    ('Michael Johnson', 1, '1995-09-10', 10,0),
    ('Emily Davis', 1, '2003-04-05', 10,0),
    ('David Anderson', 1, '1994-11-20', 10,0);

-- Inserts para participantes en Brasil
INSERT INTO Participante (nombre, locID, fecha_nacimiento, experiencia,puntosacumulados)
VALUES 
    ('Luiz Silva', 2, '1979-08-12', 10,0),
    ('Ana Oliveira', 2, '1981-06-30', 10,0),
    ('Marcos Santos', 2, '1980-12-22', 10,0),
    ('Pedro Costa', 2, '1976-03-17', 10,0);
	
-- Insert para participante en Australia 
INSERT INTO Participante (nombre, locID, fecha_nacimiento, experiencia,puntosacumulados)
VALUES 
    ('Sarah Smith', 4, '1995-07-18', 10,0);

-- Inserts para participantes en Portugal 
INSERT INTO Participante (nombre, locID, fecha_nacimiento, experiencia,puntosacumulados)
VALUES 
    ('Ricardo Fernandes', 6, '1991-11-05', 10,0),
    ('Marta Pereira', 6, '1992-09-14', 10,0);

-- Insert para participante en Tailandia
INSERT INTO Participante (nombre, locID, fecha_nacimiento, experiencia,puntosacumulados)
VALUES 
    ('Somsak Kritsada', 7, '1997-12-03', 10,0);

-- Inserts para participantes en España
INSERT INTO Participante (nombre, locID, fecha_nacimiento, experiencia,puntosacumulados)
VALUES 
    ('Carlos Rodriguez', 3, '1999-02-20', 10,0),
    ('Laura García', 3, '2002-07-12', 10,0),
    ('Pablo Martínez', 3, '2000-10-08', 2,0);



-- Insert para participante en Mauritius 
INSERT INTO Participante (nombre, locID, fecha_nacimiento, experiencia,puntosacumulados)
VALUES 
    ('Jean Baptiste', 5, '1996-06-25', 9,0);
	
	--error en experiencia
INSERT INTO Participante (nombre, locID, fecha_nacimiento, experiencia)
VALUES ('Pablo Martínezz', 7, '2010-10-08', 11);
--nombre repetido
INSERT INTO Participante (nombre, locID, fecha_nacimiento, experiencia)
VALUES ('Pablo Martínez', 7, '2010-10-08', 11);

-- Participantes en todos los torneos 
INSERT INTO Inscripcion (torneoID, participanteID, posicion)
VALUES 
    -- participante 1
 (1, 1, 4) ,   (2, 1, 8), (3, 1, 5), (4, 1, 2), (5, 1, 6), (6, 1, 7), (7, 1, 1), (8, 1, 3), (9, 1, 9),(10, 1, 5),(11, 1, 4),
    -- participante 2
 (1, 2, 8) ,   (2, 2, 3), (3, 2, 4), (4, 2, 1), (5, 2, 5), (6, 2, 8), (7, 2, 4), (8, 2, 2), (9, 2, 10), (10, 2, 6),(11, 2, 7),
    -- participante 3
  (1, 3, 3),   (2, 3, 2), (3, 3, 2), (4, 3, 6), (5, 3, 4), (6, 3, 6), (7, 3, 7), (8, 3, 8), (9, 3, 3),(10, 3, 4),(11, 3, 9),(12, 3, 2);
	
-- Participantes que varían en algunos torneos
-- Participante 13
INSERT INTO Inscripcion (torneoID, participanteID, posicion)
VALUES 
    (1, 13, 2), (2, 13, 4), (3, 13, 1), (4, 13, 7), (5, 13, 7);
-- Participante 14
INSERT INTO Inscripcion (torneoID, participanteID, posicion)
VALUES 
    (2, 14, 1), (3, 14, 3), (4, 14, 5), (5, 14, 3);

-- Participante 15
INSERT INTO Inscripcion (torneoID, participanteID, posicion)
VALUES 
    (3, 15, 6), (4, 15, 4), (5, 15, 2);



-- Participante 17
INSERT INTO Inscripcion (torneoID, participanteID, posicion)
VALUES 
    (3, 17, 7), (4, 17, 3), (5, 17, 8);
-- Participante 16 ERROR POR NIVEL (TRIG)
INSERT INTO Inscripcion (torneoID, participanteID, posicion)
VALUES 
    (4, 16, 10);

-- Inserts para PUESTO_PUNTOS
INSERT INTO PUESTO_PUNTOS (puesto, puntos)
VALUES 
    (1, 1000), -- Puesto 1 tiene 1000 puntos
    (2, 870),  -- Puesto 2 tiene 870 puntos
    (3, 770),  -- Puesto 3 tiene 770 puntos
    (4, 700),  -- Puesto 4 tiene 700 puntos
    (5, 580),  -- Puesto 5 tiene 580 puntos
    (6, 580),  -- Puesto 6 tiene 580 puntos
    (7, 580),  -- Puesto 7 tiene 580 puntos
    (8, 580),  -- Puesto 8 tiene 580 puntos
    (9, 420),  -- Puesto 9 tiene 420 puntos
    (10, 420), -- Puesto 10 tiene 420 puntos
    (11, 420), -- Puesto 11 tiene 420 puntos
    (12, 420), -- Puesto 12 tiene 420 puntos
    (13, 280), -- Puesto 13 tiene 280 puntos
    (14, 245); -- Puesto 14 tiene 245 puntos

-- CREACION DE INDICE
CREATE INDEX Ind_LocTorneo ON torneo(locID)
CREATE INDEX Ind_LocParticipante ON participante(locID)
CREATE INDEX Ind_ParticipanteInsc ON inscripcion(participanteID)