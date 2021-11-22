:- include('inventory.pl')

:- dynamic(cow/1).
:- dynamic(chicken/1).
:- dynamic(pig/1).
:- dynamic(t_cow/2). % menunjukkan waktu tunggu cow dan waktu tersisa untuk cow menghasilkan milk
:- dynamic(t_chicken/2).
:- dynamic(t_pig/2).

t_cow(12,12).
t_chicken(11,11).
t_pig(17,17).

ranch :-
  in_game(false),
  !, 
  write('You haven\'t started the game! Try using \'start.\' to start the game.').
ranch :-
  in_game(true),
  atRanch,
  write('Welcome to the ranch! You have:'), nl,
  cow(Ncow), chicken(Nchicken), pig(Npig),
  format('- ~w cow ~n',[Ncow]),
  format('- ~w chicken ~n',[Nchicken]),
  format('- ~w pig ~n',[Npig]),
  write('What do you want to do?').
ranch :-
  in_game(true),
  !,
  write('You can call quest command only if you are at ranch.').

% blm tambah exp
cow :- 
  t_cow(T1,T2),
  T2 =:= 0,
  !,
  cow(Ncow),
  format('Your cow has produced ~w milks. ~n',[Ncow]),
  format('You got ~w milks! ~n',[Ncow]),
  update_inventory('milk', Ncow).
cow :-
  !,
  write('Your cow hasn\'t produced any milk.'), nl,
  write('Please check again later.').

chicken :-
  t_chicken(T1,T2),
  T2 =:= 0,
  !,
  chicken(Nchicken),
  format('Your chicken has produced ~w eggs. ~n',[Nchicken]),
  format('You got ~w eggs! ~n',[Nchicken]),
  update_inventory('egg', Nchicken).
chicken :-
  !,
  write('Your chicken hasn\'t produced any egg.'), nl,
  write('Please check again later.').

pig :-
  t_pig(T1,T2),
  T2 =:= 0,
  !,
  pig(Npig),
  format('Your pig has produced ~w bacons. ~n',[Npig]),
  format('You got ~w bacons! ~n',[Npig]),
  update_inventory('bacon', Ncow).
pig :-
  !,
  write('Your pig hasn\'t produced any bacon.'), nl,
  write('Please check again later.').

updateRanch :-
  updateCow,
  updateChicken,
  updatePig.

updateCow :-
  cow(Ncow),
  Ncow > 0,
  !,
  retract(t_cow(T1,T2)),
  ( T2 > 0
  -> T2new is T2 - 1
  ; T2new = T2),
  assertz(t_cow(T1,T2new)).
updateCow :- !.

updateChicken :-
  chicken(Nchicken),
  Nchicken > 0,
  !,
  retract(t_chicken(T1,T2)),
  ( T2 > 0
  -> T2new is T2 - 1
  ; T2new = T2),
  assertz(t_chicken(T1,T2new)).
updateChicken :- !.

updatePig :-
  pig(Npig),
  Npig > 0,
  !,
  retract(t_pig(T1,T2)),
  ( T2 > 0
  -> T2new is T2 - 1
  ; T2new = T2),
  assertz(t_pig(T1,T2new)).
updatePig :- !.