use trivial;

drop procedure if exists Registro; 
drop procedure if exists Login; 
drop procedure if exists AñadirImagen;
drop procedure if exists AñadirTema; 
drop procedure if exists AñadirPregunta; 
drop procedure if exists AgregarPartida; 
drop procedure if exists AñadirLeaderboard; 
drop procedure if exists DatosPartida; 
drop procedure if exists PartidasUsuario;
drop procedure if exists Top;
drop procedure if exists Juego;
drop procedure if exists PartidaLeaderboard;

DELIMITER $$
CREATE PROCEDURE Registro(in _nombre varchar(50),
						  in _contrasena varchar(50),
                          in _email varchar(100),
                          in _img int,
                          out _resultado int)

pa:
BEGIN
declare aux int;

-- Caso -1: Usuario nulo
	if _nombre is null or _nombre like "" then
		set _resultado = -1;
        leave pa;
    end if;
    
-- Caso -2: Usuario repetido
	set aux = null;
	select id from usuarios where nick like _nombre into aux;
    
    if aux is not null then
		set _resultado = -2;
        leave pa;
    end if;
    
-- Caso -3: Contraseña vacia
	if _contrasena is null or _contrasena like "" then
		set _resultado = -3;
        leave pa;
    end if;

-- Caso -4: Email vacio
	if _email is null or _email like "" then
		set _resultado = -4;
        leave pa;
    end if;

-- Caso -5: Email repetido
	set aux = null;
	select id from usuarios where email like _email into aux;
    
    if aux is not null then
		set _resultado = -5;
        leave pa;
    end if;

-- Caso -6: La imagen no existe
	set aux = null;
	select id from img_perfil where id like _img into aux;
    
    if aux is null then
		set _resultado = -6;
        leave pa;
    end if;

-- Caso 0
INSERT INTO usuarios (nick,pass,email,fk_img) VALUES (_nombre,_contrasena,_email,_img);
set _resultado = 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Login(in _usuario varchar(50),
					   in _contrasena varchar(50),
					   out _resultado int)

pa:
BEGIN
declare aux varchar(50);

-- Caso -1: No hay usuario o vacio
set aux = null;
select nick from usuarios where nick like _usuario into aux;

if aux is null or _usuario like "" or _usuario is null then 
	set _resultado = -1;
    leave pa;
end if;

-- Caso -2: Contraseña vacia
if _contrasena like "" or _contrasena is null then
	set _resultado = -2;
    leave pa;
end if;

-- 	Caso -3: No coincide la contraseña
set aux = null;
select id from usuarios where nick like _usuario and pass like _contrasena into aux;
if aux is null then 
	set _resultado = -3;
    leave pa;
end if;

-- Caso 0
select id from usuarios where nick like _usuario and pass like _contrasena into _resultado;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE AñadirImagen(in _ruta varchar(256),
					   out _resultado int)

pa:
BEGIN
declare aux int;

-- Caso -1: Campo vacio
if _ruta is null or _ruta like "" then
	set _resultado = -1;
    leave pa;
end if;

-- Caso -2: Imagen repetida
set aux = null;
select id from img_perfil where img like _ruta into aux;

if aux is not null then
	set _resultado = -2;
    leave pa;
end if;

-- Caso 0:
INSERT INTO img_perfil (img) VALUES (_ruta);
set _resultado = 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE AñadirTema(in _tipo varchar(100),
					   in _ruta varchar(256),
					   out _resultado int)

pa:
BEGIN
declare aux int;

-- Caso -1: Algun campo vacio
if _ruta is null or _ruta like "" or _tipo is null or _tipo like "" then
	set _resultado = -1;
    leave pa;
end if;

-- Caso -2: Imagen repetida
set aux = null;
select id from tema where img_java like _ruta into aux;

if aux is not null then
	set _resultado = -2;
    leave pa;
end if;

-- Caso -3: Tema repetido
set aux = null;
select id from tema where tipo like _tipo into aux;

if aux is not null then
	set _resultado = -3preguntas_respuestaspartidas;
    leave pa;
end if;

-- Caso 0:
INSERT INTO tema (tipo,img_web,img_java) VALUES (_tipo,_rutaweb,_rutajava);
set _resultado = 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE AñadirPregunta(in _pregunta varchar(256),
						  in _rc varchar(256),
                          in _rf1 varchar(100),
                          in _rf2 varchar(100),
                          in _rf3 varchar(100),
                          in _tema varchar(100),
                          out _resultado int)

pa:
BEGIN
declare aux varchar(256);
-- Caso -1: Algun campo vacio
if _pregunta is null or _pregunta like "" or _rc is null or _rc like "" or _rf1 is null or _rf1 like "" or _rf2 is null or _rf2 like "" or _rf3 is null or _rf3 like "" or _tema is null or _tema like "" then
	set _resultado = -1;
    leave pa;
end if;

-- Caso -2: Pregunta repetida
set aux = null;
select id from preguntas_respuestas where pregunta like _pregunta into aux;

if aux is not null then
	set _resultado = -2;
    leave pa;
end if;

-- Caso -3: Respuesta repetida
if _rc like _rf1 or _rc like _rf2 or _rc like _rf3 or _rf1 like _rf2 or _rf1 like _rf3 or _rf2 like _rf3 then
	set _resultado = -3;
    leave pa;
end if;

-- Caso 4: El tema no existe
set aux = null;
select id from tema where tipo like _tema into aux;

if aux is null then
	set _resultado = -4;
    leave pa;
end if;

-- Caso 0
set aux = null;
select id from tema where tipo like _tema into aux;
INSERT INTO preguntas_respuestas (pregunta,rcorrecta,rfalsa1,rfalsa2,rfalsa3,fk_tema) VALUES (_pregunta,_rc,_rf1,_rf2,_rf3,aux);
set _resultado = 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE AgregarPartida(in _jug varchar(50),
                          out _resultado int)

pa:
BEGIN
declare aux int;

-- Caso -1: Alguna pregunta vacia
if _jug is null or _jug = "" then
	set _resultado = -1;
    leave pa;
end if;

-- Caso -2: El jugador no existe
set aux = null;
select id from usuarios where nick like _jug into aux;

if aux is null then
	set _resultado = -2;
    leave pa;
end if;

-- Caso 0
INSERT INTO partidas (player) VALUES (_jug);
set _resultado = 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE AñadirLeaderboard(in _punt int,
						  in _partida int,
						  in _nombre int,
                          out _resultado int)

pa:
BEGIN
declare aux int;

-- Caso -1: Algun campo vacio
if _punt is null or _partida is null or _nombre is null then
	set _resultado = -1;
    leave pa;
end if;

-- Caso -2: No existe el jugador
set aux = null;
select id from usuarios where id = _nombre into aux;

if aux is null then
	set _resultado = -2;
    leave pa;
end if;

-- Caso -3: No existe la partida
set aux = null;
select id from partidas where id = _partida into aux;

if aux is null then
	set _resultado = -3;
    leave pa;
end if;

-- Caso -4: Ya esta asociado
set aux = null;
select id from leaderboard where fk_partida = _partida and fk_jugador = _nombre into aux;

if aux is not null then
	set _resultado = -4;
    leave pa;
end if;

-- Caso -5: La puntuacion no está en rango
if _punt < 0 or punt > 10 then
	set _resultado = -5;
    leave pa;
end if;

-- Caso 0
INSERT INTO leaderboard(puntuacion,fk_partida,fk_jugador) VALUES (_punt,_partida,_nombre);
set _resultado = 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE DatosPartida(in _usuario varchar(50),
						  in _partida int,
                          out _resultado int)

pa:
BEGIN
declare aux int;
-- Caso -1: Algun campo vacio
if _usuario is null or _usuario like "" or _partida is null then
	set _resultado = -1;
    leave pa;
end if;

-- Caso -2: El usuario no existe
set aux = null;
select id from usuarios where nick = _usuario into aux;

if aux is null then
	set _resultado = -2;
    leave pa;
end if;

-- Caso -3: La partida no existe
set aux = null;
select id from partidas where id = _partida into aux;

if aux is null then
	set _resultado = -3;
    leave pa;
end if;

-- Caso -4: La partida no es del usuario
set aux = null;
select leaderboard.id from leaderboard 
join usuarios on leaderboard.fk_jugador = usuarios.id
join partidas on leaderboard.fk_partida = partidas.id
where usuarios.nick like _usuario and partidas.id = _partida into aux;

if aux is null then
	set _resultado = -4;
    leave pa;
end if;

-- Caso 0
select partidas.*, leaderboard.puntuacion
from partidas 
join leaderboard 
on partidas.id = leaderboard.fk_partida 
join usuarios 
on leaderboard.fk_jugador = usuarios.id
where usuarios.nick like _usuario
and partidas.id = _partida;

set _resultado = 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE PartidasUsuario(in _usuario varchar(50),
                          out _resultado int)

pa:
BEGIN
declare aux int;

-- Caso -1: Campo vacio
if _usuario is null or _usuario like "" then
	set _resultado = -1;
    leave pa;
end if;

-- Caso -2: No existe el usuario
set aux = null;
select id from usuarios where nick like _usuario into aux;

if aux is null then
	set _resultado = -2;
    leave pa;
end if;

-- Caso -3: El usuario no tiene partidas
set aux = null;
select leaderboard.id from leaderboard
join usuarios on leaderboard.fk_jugador = usuarios.id
where usuarios.nick like _usuario group by usuarios.nick into aux;

if aux is null then
	set _resultado = -3;
    leave pa;
end if;

-- Caso 0
select partidas.*, leaderboard.puntuacion from partidas
join leaderboard on partidas.id = leaderboard.fk_partida
join usuarios on leaderboard.fk_jugador = usuarios.id
where nick like _usuario;

set _resultado = 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Top(in _num int,
					 in _usuario varchar(50),
                     out _resultado int)

pa:
BEGIN
declare aux int;

-- Caso -1: Algun campo vacio
if _num is null or _usuario is null or _usuario like "" then
	set _resultado = -1;
    leave pa;
end if;

-- Caso -2: El usuario no existe
set aux = null;
select id from usuarios where nick like _usuario into aux;

if aux is null then
	set _resultado = -2;
    leave pa;
end if;

-- Caso -3: El usuario no tiene partidas
set aux = null;
select leaderboard.id from leaderboard
join usuarios on leaderboard.fk_jugador = usuarios.id
where usuarios.nick like _usuario group by usuarios.nick into aux;

if aux is null then
	set _resultado = -3;
    leave pa;
end if;

-- Caso 0
select * from top10;

select rank() over (order by leaderboard.puntuacion desc) as top, usuarios.nick, leaderboard.puntuacion
from usuarios join leaderboard on usuarios.id = leaderboard.fk_jugador
join partidas on leaderboard.fk_partida = partidas.id limit 0,_num;

select * from (select rank() over (order by leaderboard.puntuacion desc) as top, usuarios.nick, leaderboard.puntuacion
			   from usuarios join leaderboard on usuarios.id = leaderboard.fk_jugador
			   join partidas on leaderboard.fk_partida = partidas.id) as ranking
where nick like _usuario
order by puntuacion desc limit 1;

set _resultado = 0;
END$$
DELIMITER ;
                       
DELIMITER $$
CREATE PROCEDURE Juego(in _p1 int,
					   in _p2 int,
                       in _p3 int,
                       in _p4 int,
                       in _p5 int,
                       in _p6 int,
                       in _p7 int,
                       in _p8 int,
                       in _p9 int,
                       in _p10 int,
                       out _resultado int)

pa:
BEGIN
declare aux int;
-- Caso -1: Algun campo vacio
if _p1 is null or _p2 is null or _p3 is null or _p4 is null or _p5 is null or _p6 is null or _p7 is null or _p8 is null or _p9 is null or _p10 is null then
	set _resultado = -1;
    leave pa;
end if;

-- Caso -2: No existe alguna pregunta
set aux = null;
select id from preguntas_respuestas where pregunta = _p1 into aux;
if aux is null then
	set _resultado = -2;
    leave pa;
end if;
set aux = null;
select id from preguntas_respuestas where pregunta = _p2 into aux;
if aux is null then
	set _resultado = -2;
    leave pa;
end if;
set aux = null;
select id from preguntas_respuestas where pregunta = _p3 into aux;
if aux is null then
	set _resultado = -2;
    leave pa;
end if;
set aux = null;
select id from preguntas_respuestas where pregunta = _p4 into aux;
if aux is null then
	set _resultado = -2;
    leave pa;
end if;
set aux = null;
select id from preguntas_respuestas where pregunta = _p5 into aux;
if aux is null then
	set _resultado = -2;
    leave pa;
end if;
set aux = null;
select id from preguntas_respuestas where pregunta = _p6 into aux;
if aux is null then
	set _resultado = -2;
    leave pa;
end if;
set aux = null;
select id from preguntas_respuestas where pregunta = _p7 into aux;
if aux is null then
	set _resultado = -2;
    leave pa;
end if;
set aux = null;
select id from preguntas_respuestas where pregunta = _p8 into aux;
if aux is null then
	set _resultado = -2;
    leave pa;
end if;
set aux = null;
select id from preguntas_respuestas where pregunta = _p9 into aux;
if aux is null then
	set _resultado = -2;
    leave pa;
end if;
set aux = null;
select id from preguntas_respuestas where pregunta = _p10 into aux;
if aux is null then
	set _resultado = -2;
    leave pa;
end if;

-- Caso -3: Se repite alguna pregunta
if _p1 = _p2 or _p1 = _p3 or _p1 = _p4 or _p1 = _p5 or _p1 = _p6 or _p1 = _p7 or _p1 = _p8 or _p1 = _p9 or _p1 = _p10 then
	set _resultado = -3;
    leave pa;
end if;
if _p2 = _p3 or _p2 = _p4 or _p2 = _p5 or _p2 = _p6 or _p2 = _p7 or _p2 = _p8 or _p2 = _p9 or _p2 = _p10 then
	set _resultado = -3;
    leave pa;
end if;
if _p3 = _p4 or _p3 = _p5 or _p3 = _p6 or _p3 = _p7 or _p3 = _p8 or _p3 = _p9 or _p3 = _p10 then
	set _resultado = -3;
    leave pa;
end if;
if _p4 = _p5 or _p4 = _p6 or _p4 = _p7 or _p4 = _p8 or _p4 = _p9 or _p4 = _p10 then
	set _resultado = -3;
    leave pa;
end if;
if _p5 = _p6 or _p5 = _p7 or _p5 = _p8 or _p5 = _p9 or _p5 = _p10 then
	set _resultado = -3;
    leave pa;
end if;
if _p6 = _p7 or _p6 = _p8 or _p6 = _p9 or _p6 = _p10 then
	set _resultado = -3;
    leave pa;
end if;
if _p7 = _p8 or _p7 = _p9 or _p7 = _p10 then
	set _resultado = -3;
    leave pa;
end if;
if _p8 = _p9 or _p8 = _p10 then
	set _resultado = -3;
    leave pa;
end if;
if _p9 = _p10 then
	set _resultado = -3;
    leave pa;
end if;

-- Caso 0
select preguntas_respuestas.pregunta, preguntas_respuestas.rcorrecta, preguntas_respuestas.rfalsa1, preguntas_respuestas.rfalsa2, preguntas_respuestas.rfalsa3, tema.tipo, tema.img
from preguntas_respuestas
join tema on preguntas_respuestas.fk_tema = tema.id
where preguntas_respuestas.id = _p1 
or preguntas_respuestas.id = _p2
or preguntas_respuestas.id = _p3
or preguntas_respuestas.id = _p4
or preguntas_respuestas.id = _p5
or preguntas_respuestas.id = _p6
or preguntas_respuestas.id = _p7
or preguntas_respuestas.id = _p8
or preguntas_respuestas.id = _p9
or preguntas_respuestas.id = _p10;

set _resultado = 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE PartidaLeaderboard(in _idusuario int,
					 in _punt int,
                     out _resultado int)

pa:
BEGIN
declare aux varchar(50);
declare auxid int;
declare auxusu varchar(50);

-- Caso -1: Campo vacio
if _idusuario is null or _punt is null then
	set _resultado = -1;
    leave pa;
end if;

-- Caso -2: Usuario no existe
select nick from usuarios where id = _idusuario into aux;

if aux is null then
	set _resultado = -2;
    leave pa;
end if;

-- Caso -3: Puntuacion no válida
if _punt < 0 or _punt > 10 then
	set _resultado = -3;
    leave pa;
end if;

-- Caso 0
select nick from usuarios where id = _idusuario into auxusu;
INSERT INTO partidas (player) VALUES (auxusu);

select max(id) from partidas into auxid;
INSERT INTO leaderboard (puntuacion,fk_partida,fk_jugador) VALUES (_punt, auxid, _idusuario);

set _resultado = 0;
END$$
DELIMITER ;