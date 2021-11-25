% X menunjukkan baris ke-X dan Y menunjukkan kolom ke-Y

:- dynamic(pos_digged/2). % lokasi digged tile

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
pos_fishing(6,3). % lokasi untuk fishing
pos_fishing(6,4).
pos_fishing(6,5).
pos_fishing(7,2).
pos_fishing(7,6).
pos_fishing(8,1).
pos_fishing(8,7).
pos_fishing(9,2).
pos_fishing(9,6).
pos_fishing(10,3).
pos_fishing(10,4).
pos_fishing(10,5).

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
  forall(between(Rowborder1,Rowborder2,X), (forall(between(Colborder1,Colborder2,Y), (drawPos(X,Y))),nl)),
  !.
/* referensi: https://learnxinyminutes.com/docs/prolog/ */

/* fungsi untuk mengetahui apakah player berada di lokasi tertentu */
atHouse :- pos_house(X_house, Y_house), posisi(X, Y), X =:= X_house, Y =:= Y_house.
atRanch :- pos_ranch(X_ranch, Y_ranch), posisi(X, Y), X =:= X_ranch, Y =:= Y_ranch.
atMarketplace :- pos_marketplace(X_marketplace, Y_marketplace), posisi(X, Y), X =:= X_marketplace, Y =:= Y_marketplace.
atQuest :- pos_quest(X_quest, Y_quest), posisi(X, Y), X =:= X_quest, Y =:= Y_quest.
atAir :- pos_air(X_air, Y_air), posisi(X, Y), X =:= X_air, Y =:= Y_air.
atDigged :- pos_digged(X_digged, Y_digged), posisi(X, Y), X =:= X_digged, Y =:= Y_digged.
atFishingSpot :- pos_fishing(X_fishing, Y_fishing), posisi(X, Y), X =:= X_fishing, Y =:= Y_fishing.

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
  pos_air(Xnew,Ynew),
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
  write('You moved north! Try using \'map\' to see your position now.'),
  addMove.

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
  pos_air(Xnew,Ynew),
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
  write('You moved south! Try using \'map\' to see your position now.'),
  addMove.

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
  pos_air(Xnew,Ynew),
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
  write('You moved east! Try using \'map\' to see your position now.'),
  addMove.

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
  pos_air(Xnew,Ynew),
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
  write('You moved west! Try using \'map\' to see your position now.'),
  addMove.

/* addMove digunakan untuk menambah banyak move dan mengecek banyak langkah yang telah dilakukan
   jika banyak langkah telah melebihi batas, yaitu 48 maka hari akan bertambah */
addMove :-
  retract(move(PrevMove)),
  NewMove is PrevMove + 1,
  ( NewMove =:= 48
    -> NewMovee = 0,
    retract(day(PrevDay)),
    NewDay is PrevDay + 1,
    assertz(day(NewDay))
    ; NewMovee = NewMove
  ),
  assertz(move(NewMovee)),
  updateProcessRanch.
