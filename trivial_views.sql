use trivial;

drop view if exists select_preg;
drop view if exists top10;
drop view if exists mejorespartidas;

CREATE VIEW select_preg AS
	select preguntas_respuestas.pregunta, preguntas_respuestas.rcorrecta, preguntas_respuestas.rfalsa1, preguntas_respuestas.rfalsa2, preguntas_respuestas.rfalsa3, tema.tipo, tema.img
	from preguntas_respuestas
	join tema on preguntas_respuestas.fk_tema = tema.id
	where preguntas_respuestas.id = (rand()*157)
	or preguntas_respuestas.id = (rand()*157)
	or preguntas_respuestas.id = (rand()*157)
	or preguntas_respuestas.id = (rand()*157)
	or preguntas_respuestas.id = (rand()*157)
	or preguntas_respuestas.id = (rand()*157)
	or preguntas_respuestas.id = (rand()*157)
	or preguntas_respuestas.id = (rand()*157)
	or preguntas_respuestas.id = (rand()*157)
	or preguntas_respuestas.id = (rand()*157);
    
    
CREATE VIEW top10 AS
	select rank() over (order by leaderboard.puntuacion desc) as top, usuarios.nick, leaderboard.puntuacion
	from usuarios join leaderboard on usuarios.id = leaderboard.fk_jugador
	join partidas on leaderboard.fk_partida = partidas.id limit 0,10;
    
CREATE VIEW mejorpartidas as
	select usuarios.nick, leaderboard.puntuacion, partidas.fecha
	from leaderboard
    join partidas on leaderboard.fk_partida = partidas.id
    join usuarios on leaderboard.fk_jugador = usuarios.id
    group by usuarios.nick
    order by leaderboard.puntuacion desc;