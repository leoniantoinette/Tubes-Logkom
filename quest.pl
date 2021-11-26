:- dynamic(quest/5).
/* Format berupa : ( X,Y,Z,Exp,Gold )
 * X berupa hasil yang dipanen
 * Y berupa ikan yang diperoleh
 * Z berupa hasil ternak yang diperoleh
 */

quest :-
  in_game(false),
  !, 
  write('You haven\'t started the game! Try using \'start.\' to start the game.').
quest :-
  in_game(true),
  atQuest,
  in_quest(true),
  !,
  write('You have an on-going quest!').
quest :-
  in_game(true),
  atQuest,
  in_quest(false),
  !,
  retract(in_quest(false)),
  assertz(in_quest(true)),
  random(3,8,X),
  random(3,8,Y),
  random(3,8,Z),
  Exp is (X + Y + Z) * 5,
  Gold is (X + Y + Z) * 10,
  assertz(quest(X,Y,Z,Exp,Gold)),
  write('You got a new quest!'), nl, nl,
  write('You need to collect:'), nl,
  format('- ~w harvest item ~n',[X]),
  format('- ~w fish ~n',[Y]),
  format('- ~w animal product ~n',[Z]).
quest :-
  in_game(true),
  write('You can call quest command only if you are at Q.').

/* my_quest: untuk menampilkan sisa quest yang harus dikerjakan */
my_quest :-
  in_game(false),
  !, 
  write('You haven\'t started the game! Try using \'start.\' to start the game.').
my_quest :-
  in_game(true),
  in_quest(false),
  !,
  write('You don\'t have any on-going quest.').
my_quest :-
  !,
  quest(X,Y,Z,_,_),
  write('You need to collect:'), nl,
  format('- ~w harvest item ~n',[X]),
  format('- ~w fish ~n',[Y]),
  format('- ~w animal product ~n',[Z]).

updateQuestWhenHaverst :-
  in_game(true),
  in_quest(true),
  !,
  retract(quest(X,Y,Z,Exp,Gold)),
  (   X > 0 ->
      Xnew is X - 1
  ; Xnew = X
  ),
  assertz(quest(Xnew,Y,Z,Exp,Gold)),
  checkQuest.
updateQuestWhenHaverst :- !.

updateQuestWhenGetFish :-
  in_game(true),
  in_quest(true),
  !,
  retract(quest(X,Y,Z,Exp,Gold)),
  (   Y > 0 -> 
      Ynew is Y - 1
  ; Ynew = Y 
  ),
  assertz(quest(X,Ynew,Z,Exp,Gold)),
  checkQuest.
updateQuestWhenGetFish :- !.

updateQuestWhenGetProductFromAnimal(Amount) :-
  in_game(true),
  in_quest(true),
  !,
  retract(quest(X,Y,Z,Exp,Gold)),
  (   Z > 0 ->
      Znew is Z - Amount,
      (   Znew < 0 ->
          Zneww = 0
      ; Zneww = Znew
      )
  ; Zneww = Z
  ),
  assertz(quest(X,Y,Zneww,Exp,Gold)),
  checkQuest.
updateQuestWhenGetProductFromAnimal(_) :- !.

/* Cek jika Quest telah selesai dilaksanakan */
checkQuest :-
  in_game(true),
  in_quest(true),
  quest(X,Y,Z,Exp,Gold),
  X =:= 0,
  Y =:= 0,
  Z =:= 0,
  !,
  retract(in_quest(true)),
  assertz(in_quest(false)),
  retract(exp_pemain(CurrentExp)),
  retract(gold(CurrentGold)),
  NewExp is CurrentExp + Exp,      % cek naik level ga
  NewGold is CurrentGold + Gold,
  assertz(exp_pemain(NewExp)),
  assertz(gold(NewGold)),
  retract(quest(_,_,_,_,_)),
  write('Congratulations! You have done your quest!').
checkQuest :- !.
