:- include('map.pl').
:- include('house.pl').
:- include('quest.pl').
:- include('inventory.pl').
:- include('market.pl').
:- include('fishing.pl').
:- include('farm.pl').

:- dynamic(posisi/2). % lokasi pemain
:- dynamic(in_game/1). % status permainan
:- dynamic(in_quest/1). % menunjukkan apakah memiliki on-going quest
:- dynamic(day/1). % menunjukkan hari ke berapa
:- dynamic(move/1). % jumlah move dalam satu hari
:- dynamic(gold/1). % jumlah gold dari pemain
:- dynamic(exp_pemain/1). % jumlah exp pemain
:- dynamic(exp_farming/1). % jumlah exp farming
:- dynamic(exp_fishing/1). % jumlah exp fishing
:- dynamic(exp_ranching/1). % jumlah exp ranching
:- dynamic(fisherman/1).
:- dynamic(farmer/1).
:- dynamic(rancher/1).
:- dynamic(level_pemain/1).
:- dynamic(level_farming/1).
:- dynamic(level_fishing/1).
:- dynamic(level_ranching/1).
:- dynamic(level_fishingrod/1).
:- dynamic(level_shovel/1).

in_game(false).

/* startGame */
startGame :-
  write('Harvest Star!'), nl,
  write('Let\'s play and pay our debts togehter!'), nl, nl,
  write('-----------------------------------------------------------'), nl,
  write('|                       Harvest Star                       |'), nl,
  write('| 1. start  : untuk memulai permainan                      |'), nl,
  write('| 2. map    : menampilkan peta                             |'), nl,
  write('| 3. status : menampilkan status terkini                   |'), nl,
  write('| 4. w      : bergerak ke utara 1 langkah                  |'), nl,
  write('| 5. s      : bergerak ke selatan 1 langkah                |'), nl,
  write('| 6. d      : bergerak ke timur 1 langkah                  |'), nl,
  write('| 7. a      : bergerak ke barat 1 langkah                  |'), nl,
  write('| 8. help   : menampilkan bantuan                          |'), nl,
  write('| 9. quit   : untuk mengakhiri permainan                   |'), nl,
  write('-----------------------------------------------------------').

/* start */
start :-
  in_game(true),
  !,
  write('You have started this game').
start :-
  !,
  initialize,
  write('Welcome to Harvest Star. Choose your job'), nl,
  write('1. Fisherman'), nl,
  write('2. Farmer'), nl,
  write('3. Rancher'), nl,
  write('> '),
  read(Num),
  chooseJob(Num).

/* initialize */
initialize :-
  retract(in_game(false)),
  assertz(in_game(true)),
  assertz(posisi(1,1)),
  assertz(in_quest(false)),
  assertz(day(1)),
  assertz(move(0)),
  assertz(gold(1000)),
  assertz(exp_pemain(0)),
  assertz(exp_farming(0)),
  assertz(exp_fishing(0)),
  assertz(exp_ranching(0)),
  assertz(fisherman(false)),
  assertz(farmer(false)),
  assertz(rancher(false)),
  assertz(level_pemain(1)),
  assertz(level_farming(1)),
  assertz(level_fishing(1)),
  assertz(level_ranching(1)),
  assertz(level_fishingrod(1)),
  assertz(level_shovel(1)).

/* chooseJob : untuk memilih job */
chooseJob(Job_num) :-
  Job_num =:= 1,
  !,
  retract(fisherman(false)),
  assertz(fisherman(true)),
  write('You choose fisherman'), nl,
  write('Let\'s start fishing!').
chooseJob(Job_num) :-
  Job_num =:= 2,
  !,
  retract(farmer(false)),
  assertz(farmer(true)),
  write('You choose farmer'), nl,
  write('Let\'s start farming!').
chooseJob(Job_num) :-
  Job_num =:= 3,
  !,
  retract(rancher(false)),
  assertz(rancher(true)),
  write('You choose rancher'), nl,
  write('Let\'s start ranching!').
chooseJob(_) :-
  !,
  write('Please input the valid number').

/* quit untuk keluar dari game */
quit :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
quit :-
  in_game(true),
  !,
  write('Are you sure you want to quit this game?'), nl,
  write('Type \'yes.\' to quit, or type \'no.\' to cancel'), nl,
  write('> '),
  read(Ans),
  ( Ans = yes
  -> halt
  ; fail ).

/* status : menampilkan status pemain */
status :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
status :-
  in_game(true),
  !,
  displayJob,
  level_pemain(Lpemain),
  format('Level: ~w ~n',[Lpemain]),
  level_farming(Lfarming),
  format('Level farming: ~w ~n',[Lfarming]),
  exp_farming(Efarming),
  format('Exp farming: ~w/150 ~n',[Efarming]),
  level_fishing(Lfishing),
  format('Level fishing: ~w ~n',[Lfishing]),
  exp_fishing(Efishing),
  format('Exp fishing: ~w/150 ~n',[Efishing]),
  level_ranching(Lranching),
  format('Level ranching: ~w ~n',[Lranching]),
  exp_ranching(Eranching),
  format('Exp ranching: ~w/150 ~n',[Eranching]),
  exp_pemain(Epemain),
  format('Exp: ~w/300 ~n',[Epemain]),
  gold(Gold),
  format('Gold: ~w ~n',[Gold]).

/* displayJob : untuk menampilkan job */
displayJob :-
  fisherman(true),
  !,
  write('Job: Fisherman'), nl.
displayJob :-
  farmer(true),
  !,
  write('Job: Farmer'), nl.
displayJob :-
  rancher(true),
  !,
  write('Job: Rancher'), nl.

/* help */
help :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
help :-
  in_game(true),
  !,
  write('---------------------------------------------------------------'), nl,
  write('|                       Harvest Star                           |'), nl,
  write('|                                                              |'), nl,
  write('| 1. status : menampilkan status terkini                       |'), nl,
  write('| 2. map    : menampilkan peta                                 |'), nl,
  write('| 3. w      : bergerak ke utara 1 langkah                      |'), nl,
  write('| 4. s      : bergerak ke selatan 1 langkah                    |'), nl,
  write('| 5. d      : bergerak ke timur 1 langkah                      |'), nl,
  write('| 6. a      : bergerak ke barat 1 langkah                      |'), nl,
  write('| 7. quit   : untuk mengakhiri permainan                       |'), nl,
  write('| 8. inventory  : menampilkan inventory                        |'), nl,
  write('| 9. quest   : mengambil quest (hanya dapat dilakukan di Q)    |'), nl,
  write('|                                                              |'), nl,
  write('| Aktivitas Farming :                                          |'), nl,
  write('| 1. dig  : untuk menggali tile                                |'), nl,
  write('| 2. plant  : untuk menanam seed                               |'), nl,
  write('| 3. harvest  : untuk memanen tanaman                          |'), nl,
  write('|                                                              |'), nl,
  write('| Aktivitas Fishing : (hanya dapat dilakukan di sekitar danau) |'), nl,
  write('| 1. fish : memancing untuk mendapatkan ikan                   |'), nl,
  write('|                                                              |'), nl,
  write('| Aktivitas Ranching : (hanya dapat dilakukan di R)            |'), nl,
  write('| 1. ranch  : untuk memilih hewan ternak                       |'), nl,
  write('| 2. cow  : untuk mengambil milk                               |'), nl,
  write('| 3. chicken  : untuk mengambil egg                            |'), nl,
  write('| 4. pig  : untuk mengambil bacon                              |'), nl,
  write('---------------------------------------------------------------').

goalState :- 
  day(d), gold(g), 
  d < 365, g >= 20000,
  write('Congratulations! You have finally collected 20000 golds!\n').

failState :- 
  day(d), gold(g), 
  d >= 365, g < 20000,
  write('You have worked hard, but in the end result is all that matters.\n'),
  write('May God bless you in the future with kind people!\n').

addMove :-
  retract(move(M)),
  M_new is M + 1,
  asserta(move(M_new)),
  updateCropAge.