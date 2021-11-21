:- include('map.pl').
:- include('house.pl').

:- dynamic(posisi/2). % lokasi pemain
:- dynamic(in_game/1). % status permainan
:- dynamic(day/1). % menunjukkan hari ke berapa
:- dynamic(move/1). % jumlah move dalam satu hari
:- dynamic(gold/1). % jumlah gold dari pemain

posisi(1,1). %testing -> ntar diimplemen di start
in_game(true). %testing -> ntar diimplemen di start
day(1). %testing -> ntar diimplemen di start
move(0). %testing -> ntar diimplemen di start
gold(1000).

yes_stmt(yes).

/* quit untuk keluar dari game */
quit :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
quit :-
  in_game(true),
  !,
  write('Are you sure you want to quit this game?'),
  nl,
  write('Type \'yes.\' to quit, or type \'no.\' to cancel'),
  nl,
  read(Ans),
  ( yes_stmt(Yes), Ans = Yes
  -> halt
  ; fail ).


goalState(d, g) :- day(d), gold(g), d < 365, g >= 20000.

failState(d, g) :- day(d), gold(g), d >= 365, g < 20000.