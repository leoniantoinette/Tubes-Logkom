house :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
house :-
  in_game(true),
  atHouse,
  !,
  write('Welcome Home!'), nl,
  write('What do you want to do?'), nl,
  write(' - sleep'), nl,
  write(' - writeDiary'), nl,
  write(' - readDiary'), nl,
  write(' - exit'), nl.

house :-
  !,
  write('You can call house command only if you are at home.').

sleep :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
sleep :-
  in_game(true),
  atHouse,
  !,
  write('You went to sleep...'),
  nl, nl,
  retract(day(PrevDay)),
  NewDay is PrevDay + 1,
  assertz(day(NewDay)),
  format('Good morning! Today is day ~w', [NewDay]).
sleep :-
  !,
  write('You can call sleep command only if you are at home.').

exit :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
exit :-
  in_game(true),
  atHouse,
  !,
  write('Have a nice day!').
exit :-
  !,
  write('You can call exit command only if you are at home.').