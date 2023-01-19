Create database if not exists Trivial;
use Trivial;

-- DROPS
drop table if exists leaderboard;
drop table if exists partidas;
drop table if exists preguntas_respuestas;
drop table if exists usuarios;
drop table if exists tema;
drop table if exists img_perfil;

-- CREATES                        
create table img_perfil(id int primary key auto_increment,
                        img varchar(256) not null);
                       
create table tema(id int primary key auto_increment,
                        tipo varchar(100) not null unique,
                        img varchar(256) not null unique);

create table usuarios(id int primary key auto_increment,
                        nick varchar(50) not null unique,
                        pass varchar(50) not null,
                        email varchar(100) not null unique,
                        admin boolean default false not null,
                        baneado boolean default false not null,
                        fk_img int,
                        foreign key (fk_img) references img_perfil(id));
                       
create table preguntas_respuestas(id int primary key auto_increment,
                        pregunta varchar(256) not null unique,
                        rcorrecta varchar(256) not null,
                        rfalsa1 varchar(256) not null,
                        rfalsa2 varchar(256) not null,
                        rfalsa3 varchar(256) not null,
                        fk_tema int not null,
                        foreign key (fk_tema) references tema(id));

create table partidas(id int primary key auto_increment,
                        player varchar(50) not null,
                        fecha timestamp default now(),
                        foreign key(player) references usuarios(nick));
                       
create table leaderboard(id int primary key auto_increment,
                         puntuacion int not null,
                         fk_partida int not null,
                         fk_jugador int not null,
                         foreign key (fk_partida) references partidas(id),
                         foreign key (fk_jugador) references usuarios(id));