-- CONSULTAS SQL
-- Mostrar los datos de los participantes y sus puntajes según el tipo de torneo de los torneos del 2021.
SELECT 
    p.participanteID, p.nombre, t.tipo, SUM(pp.puntos) as sumadepuntos  
FROM 
    Inscripcion i
INNER JOIN 
    Participante p ON p.participanteID = i.participanteID
INNER JOIN 
    Torneo t ON t.torneoID = i.torneoID
INNER JOIN 
    puesto_puntos pp ON pp.puesto = i.posicion
WHERE 
    YEAR(t.fecha) = 2021
GROUP BY 
    p.participanteID, p.nombre, t.tipo

-- Del total de inscripciones de cada participante, mostrar cual fue el mayor puntaje, cual 
-- fue el promedio y cuál fue el menor valor para cada tipo de torneo.
SELECT 
    i.participanteID, t.tipo, 
    MIN(pp.puntos) as minimopuntaje, 
    MAX(pp.puntos) as maximopuntaje, 
    AVG(pp.puntos) as promediopuntos
FROM 
    Inscripcion i
INNER JOIN 
    puesto_puntos pp ON pp.puesto = i.posicion
INNER JOIN 
    torneo t ON t.torneoID = i.torneoID
GROUP BY 
    i.participanteID, t.tipo

-- Para cada tipo de torneo con alguno finalizado, mostrar nombre, país, ciudad, nivel, 
-- cantidad de participantes. Si algún tipo de torneo está planificado o en progreso, 
-- también deben mostrarse sus datos.
SELECT 
    t.tipo, t.nombre, l.pais, l.ciudad, t.Nivel
FROM 
    torneo t
INNER JOIN 
    Locacion l ON l.locID = t.locID
WHERE 
    t.torneoID NOT IN (SELECT t1.torneoID FROM torneo t1 WHERE t1.estado = 'cancelado')
    AND EXISTS (
        SELECT 1
        FROM Torneo t2
        WHERE t2.tipo = t.tipo AND t2.estado = 'finalizado'
    )
	SELECT * FROM Inscripcion


-- Mostrar los datos de los participantes que se inscribieron en todos los torneos de los 
-- últimos 2 años pero nunca se inscribieron en torneos tipo Racing.
SELECT 
    p.participanteID, p.fecha_nacimiento, p.experiencia 
FROM  
    Participante p
INNER JOIN  
    Inscripcion i ON i.participanteID = p.participanteID
INNER JOIN 
    Torneo t ON t.torneoID = i.torneoID
WHERE  
    NOT EXISTS (
        SELECT 1
        FROM Torneo t
        JOIN Inscripcion i ON t.torneoID = i.torneoID
        WHERE 
            i.participanteID = p.participanteID AND
            YEAR(t.fecha) > YEAR(GETDATE()) - 2 AND
            t.tipo = 'Racing'
    )
    AND EXISTS (
        SELECT 1
        FROM Torneo t1
        WHERE YEAR(t1.fecha) > YEAR(GETDATE()) - 2
    )

GROUP BY 
    p.participanteID, p.fecha_nacimiento, p.experiencia 
HAVING 
    COUNT(p.participanteID) = (
        SELECT COUNT(t1.torneoid) 
        FROM torneo t1
        WHERE YEAR(t1.fecha) > YEAR(GETDATE()) - 2
    )

-- Mostrar los kiters que tengan años de competencia con más de 1.200 puntos 
-- acumulados y no tengan años con menos de 3 inscripciones en torneos de freestyle o 
-- kite-surf.
SELECT 
    DISTINCT i.participanteID
FROM 
    Inscripcion i
INNER JOIN  
    Torneo t ON t.torneoID = i.torneoID
WHERE 
    i.participanteID IN (
        SELECT ins.participanteID 
        FROM Inscripcion ins, torneo t 
        WHERE t.torneoID = ins.torneoID AND t.tipo IN ('freestyle', 'Kite-Surf') 
        GROUP BY ins.participanteID, YEAR(t.fecha) 
        HAVING COUNT(*) >= 3
    )
    AND i.participanteID IN (
        SELECT i2.participanteID 
        FROM Inscripcion i2, puesto_puntos p, torneo t
        WHERE p.puesto = i2.posicion AND t.torneoID = i2.torneoID
        GROUP BY i2.participanteID, YEAR(t.fecha)
        HAVING SUM(p.puntos) > 1200
    )

-- Mostrar los datos del torneo que recibió la mayor cantidad de inscripciones de los últimos 
-- 5 años, que no se realizaron en Brasil y que no tenga ganadores de Brasil. 
SELECT TOP 1
    T.torneoID, T.nombre AS nombre_torneo, T.fecha, L.pais AS país_torneo, L.ciudad AS ciudad_torneo, T.tipo, T.estado, T.Nivel,
    COUNT(I.inscripcionID) AS cantidad_inscripciones
FROM
    Torneo T
JOIN
    Inscripcion I ON T.torneoID = I.torneoID
JOIN
    Participante P ON I.participanteID = P.participanteID
JOIN
    Locacion L ON T.locID = L.locID
WHERE
    YEAR(T.fecha) > YEAR(GETDATE()) - 5
    AND L.pais <> 'Brasil'
    AND P.locID NOT IN (SELECT locID FROM Locacion WHERE pais = 'Brasil')
GROUP BY 
    T.torneoID, T.nombre, T.fecha, L.pais, L.ciudad, T.tipo, T.estado, T.Nivel
ORDER BY
    cantidad_inscripciones DESC;