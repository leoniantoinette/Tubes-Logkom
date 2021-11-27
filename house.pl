house :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
house :-
  in_game(true),
  atHouse,
  !,
  write(' __        __   _                            _   _                      _'), nl,
  write(' \\ \\      / /__| | ___ ___  _ __ ___   ___  | | | | ___  _ __ ___   ___| |'), nl,
  write('  \\ \\ /\\ / / _ \\ |/ __/ _ \\| \'_ ` _ \\ / _ \\ | |_| |/ _ \\| \'_ ` _ \\ / _ \\ |'), nl,
  write('   \\ V  V /  __/ | (_| (_) | | | | | |  __/ |  _  | (_) | | | | | |  __/_|'), nl,
  write('    \\_/\\_/ \\___|_|\\___\\___/|_| |_| |_|\\___| |_| |_|\\___/|_| |_| |_|\\___(_)'), nl, nl,
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
  retract(time(_)),
  NewDay is PrevDay + 1,
  NewTime = 0,
  assertz(day(NewDay)),
  assertz(time(NewTime)),
  format('Good morning! Today is day ~w ~n', [NewDay]),
  meetSleepFairy,
  checkState.
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

writeDiary :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
writeDiary :-
  in_game(true),
  atHouse,
  day(Day),
  diary(Day,_),
  !,
  write('You have written your diary today.').
writeDiary :-
  in_game(true),
  atHouse,
  !,
  day(Day),
  format('Write your diary for Day ~w ~n', [Day]),
  write('> '),
  read(Diary), % format input : 'blabla'.
  format('Day ~w entry saved.', [Day]),
  assertz(diary(Day, Diary)).
writeDiary :-
  !,
  write('You can call writeDiary command only if you are at home.').

readDiary :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
readDiary :-
  in_game(true),
  atHouse,
  diary(_,_),
  !,
  write('Here are the list of your entries:'), nl,
  forall(diary(Day,_), format(' - Day ~w ~n ~n', [Day])),
  write('Which entry do you want to read?'), nl,
  write('> '),
  read(InputDay),
  ( diary(InputDay, Diary)
  -> format('Here is your entry for day ~w : ~n', [InputDay]),
  format('~?', [Diary])
  ; write('You didn\'t write diary that day.')).
readDiary :-
  in_game(true),
  atHouse,
  !,
  write('You haven\'t written any diary yet.').
readDiary :-
  !,
  write('You can call readDiary command only if you are at home.').

meetSleepFairy :-
  random(1,20,Num),
  Result is mod(Num,10),
  !,
  ( Result =:= 0
  -> write('                     ,_  .--.'), nl,
  write('               , ,   _)\\/    ;--.'), nl,
  write('       . \' .    \\_\\-\'   |  .\'    \\'), nl,
  write('      -= * =-   (.-,   /  /       |'), nl,
  write('       \' .\\\'    ).  ))/ .\'   _/\\ /'), nl,
  write('           \\_   \\_  /( /     \\ /('), nl,
  write('           /_\\ .--\'   `-.    //  \\'), nl,
  write('           ||\\/        , \'._//    |'), nl,
  write('           ||/ /`(_ (_,;`-._/     /'), nl,
  write('           \\_.\'   )   /`\\       .\''), nl,
  write('                .\' .  |  ;.   /`'), nl,
  write('               /      |\\(  `.('), nl,
  write('              |   |/  | `    `'), nl,
  write('              |   |  /'), nl,
  write('              |   |.\''), nl,
  write('           __/\'  /'), nl,
  write('       _ .\'  _.-`'), nl,
  write('    _.` `.-;`/'), nl,
  write('   /_.-\'` / /'), nl,
  write('         | /'), nl,
  write('        ( /'), nl,
  write('       /_/'), nl,
  write('You met sleep fairy last night!'), nl, nl,
  whereToGo
  ; ! ).

whereToGo :-
  write('Where do you want to go today?'), nl,
  drawMap,
  write('In which row do you want to go?'), nl,
  write('> '),
  read(Row),
  write('In which column do you want to go?'), nl,
  write('> '),
  read(Column),
  checkInputPos(Row, Column).

checkInputPos(Row, Column) :-
  mapSize(ValidRow, ValidColumn),
  (Row =< 0; Column =< 0; Row > ValidRow; Column > ValidColumn; pos_air(Row, Column)),
  !,
  write('You can\'t go to that position.'), nl, nl,
  whereToGo.
checkInputPos(Row, Column) :-
  !,
  retract(posisi(_,_)),
  assertz(posisi(Row, Column)),
  write('You managed to go to that position.').