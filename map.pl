% X menunjukkan baris ke-X dan Y menunjukkan kolom ke-Y

:- dynamic(posisi/2). % lokasi pemain -> ntar di main.pl
:- dynamic(pos_digged/2). % lokasi digged tile

posisi(1,1). %testing
in_game(true).

/* FAKTA */
mapSize(10,10). % ukuran map
pos_house(2,8). % lokasi house
pos_ranch(7,9). % lokasi ranch
pos_marketplace(4,5). % lokasi marketplace
pos_quest(3,2). % lokasi pengambilan quest
pos_air(7,3). % tile air
pos_air(7,4).
pos_air(7,5).
pos_air(8,2).
pos_air(8,3).
pos_air(8,4).
pos_air(8,5).
pos_air(8,6).
pos_air(9,3).
pos_air(9,4).
pos_air(9,5).

map :- in_game(true), !, drawMap.
map :- !, write('You haven\'t started the game! Try using \'start.\' to start the game.').

isBorder(X,Y) :- 
  mapSize(Row,Col),
  Xborder is Row + 1,
  Yborder is Col + 1,
  (X =:= 0; Y =:= 0; X =:= Xborder; Y =:= Yborder).

drawPos(X,Y) :- posisi(X,Y), !, write('P').
drawPos(X,Y) :- pos_marketplace(X,Y), !, write('M').
drawPos(X,Y) :- pos_ranch(X,Y), !, write('R').
drawPos(X,Y) :- pos_house(X,Y), !, write('H').
drawPos(X,Y) :- pos_quest(X,Y), !, write('Q').
drawPos(X,Y) :- pos_air(X,Y), !, write('o').
drawPos(X,Y) :- pos_digged(X,Y), !, write('=').
drawPos(X,Y) :- isBorder(X,Y), !, write('#').
drawPos(_,_) :- write('-'),!.

drawMap :-
  mapSize(Row,Col),
  Rowborder1 is 0,
  Rowborder2 is Row + 1,
  Colborder1 is 0,
  Colborder2 is Col + 1,
  forall(between(Rowborder1,Rowborder2,I), (
    forall(between(Colborder1,Colborder2,J), (
      drawPos(I,J)
    )),
    nl
  )),
  !.

/* fungsi untuk mengetahui apakah posisi (X,Y) berada di lokasi tertentu */
atHouse(X,Y) :- pos_house(X_house, Y_house), X =:= X_house, Y =:= Y_house.
atRanch(X,Y) :- pos_ranch(X_ranch, Y_ranch), X =:= X_ranch, Y =:= Y_ranch.
atMarketplace(X,Y) :- pos_marketplace(X_marketplace, Y_marketplace), X =:= X_marketplace, Y =:= Y_marketplace.
atQuest(X,Y) :- pos_quest(X_quest, Y_quest), X =:= X_quest, Y =:= Y_quest.
atAir(X,Y) :- pos_air(X_air, Y_air), X =:= X_air, Y =:= Y_air.
atDigged(X,Y) :- pos_digged(X_digged, Y_digged), X =:= X_digged, Y =:= Y_digged.

/* w : bergerak ke utara 1 langkah */
w :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
w :-
  in_game(true),
  posisi(X,Y),
  Xnew is X - 1,
  Ynew is Y,
  atAir(Xnew,Ynew),
  !,
  write('You can\'t get into water! Try using \'map.\' to display Map.'),
  fail.
w :-
  in_game(true),
  posisi(X,Y),
  Xnew is X - 1,
  Ynew is Y,
  isBorder(Xnew,Ynew),
  !,
  write('You can\'t go outside of the map! Try using \'map.\' to display Map.'),
  fail.
w :-
  in_game(true),
  posisi(X,Y),
  Xnew is X - 1,
  Ynew is Y,
  !,
  retract(posisi(_,_)),
  assertz(posisi(Xnew,Ynew)),
  write('You moved north! Try using \'map\' to see your position now.').

/* s : bergerak ke selatan 1 langkah */
s :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
s :-
  in_game(true),
  posisi(X,Y),
  Xnew is X + 1,
  Ynew is Y,
  atAir(Xnew,Ynew),
  !,
  write('You can\'t get into water! Try using \'map.\' to display Map.'),
  fail.
s :-
  in_game(true),
  posisi(X,Y),
  Xnew is X + 1,
  Ynew is Y,
  isBorder(Xnew,Ynew),
  !,
  write('You can\'t go outside of the map! Try using \'map.\' to display Map.'),
  fail.
s :-
  in_game(true),
  posisi(X,Y),
  Xnew is X + 1,
  Ynew is Y,
  !,
  retract(posisi(_,_)),
  assertz(posisi(Xnew,Ynew)),
  write('You moved south! Try using \'map\' to see your position now.').

/* d : bergerak ke timur 1 langkah */
d :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
d :-
  in_game(true),
  posisi(X,Y),
  Xnew is X,
  Ynew is Y + 1,
  atAir(Xnew,Ynew),
  !,
  write('You can\'t get into water! Try using \'map.\' to display Map.'),
  fail.
d :-
  in_game(true),
  posisi(X,Y),
  Xnew is X,
  Ynew is Y + 1,
  isBorder(Xnew,Ynew),
  !,
  write('You can\'t go outside of the map! Try using \'map.\' to display Map.'),
  fail.
d :-
  in_game(true),
  posisi(X,Y),
  Xnew is X,
  Ynew is Y + 1,
  !,
  retract(posisi(_,_)),
  assertz(posisi(Xnew,Ynew)),
  write('You moved east! Try using \'map\' to see your position now.').

/* a : bergerak ke barat 1 langkah */
a :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
a :-
  in_game(true),
  posisi(X,Y),
  Xnew is X,
  Ynew is Y - 1,
  atAir(Xnew,Ynew),
  !,
  write('You can\'t get into water! Try using \'map.\' to display Map.'),
  fail.
a :-
  in_game(true),
  posisi(X,Y),
  Xnew is X,
  Ynew is Y - 1,
  isBorder(Xnew,Ynew),
  !,
  write('You can\'t go outside of the map! Try using \'map.\' to display Map.'),
  fail.
a :-
  in_game(true),
  posisi(X,Y),
  Xnew is X,
  Ynew is Y - 1,
  !,
  retract(posisi(_,_)),
  assertz(posisi(Xnew,Ynew)),
  write('You moved west! Try using \'map\' to see your position now.').