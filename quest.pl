:- include('map.pl').

:- dynamic(quest/5). % (X,Y,Z,Exp,Gold) : hasil panen, ikan, ternak yg harus dikumpulkan, exp, gold yang diperoleh

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
  write('You can call quest command only if you are at home.').

addHarvestToQuest :-
  in_game(true),
  in_quest(true),
  !,
  retract(quest(X,Y,Z,Exp,Gold)),
  ( X > 0
  -> Xnew is X - 1
  ; Xnew = X ),
  assertz(quest(Xnew,Y,Z,Exp,Gold)),
  checkQuest.
addHarvestToQuest :- !.

addFishToQuest :-
  in_game(true),
  in_quest(true),
  !,
  retract(quest(X,Y,Z,Exp,Gold)),
  ( Y > 0
  -> Ynew is Y - 1
  ; Ynew = Y ),
  assertz(quest(X,Ynew,Z,Exp,Gold)),
  checkQuest.
addFishToQuest :- !.

addProductToQuest(Amount) :-
  in_game(true),
  in_quest(true),
  !,
  retract(quest(X,Y,Z,Exp,Gold)),
  ( Z > 0
  -> Znew is Y - Amount,
    ( Znew < 0
    -> Zneww = 0
    ; Zneww = Znew )
  ; Zneww = Z ),
  assertz(quest(X,Y,Zneww,Exp,Gold)),
  checkQuest.
addProductToQuest :- !.

checkQuest :- % jika quest telah selesai
  in_game(true),
  in_quest(true),
  quest(X,Y,Z,Exp,Gold),
  X =:= 0,
  Y =:= 0,
  Z =:= 0,
  !,
  retract(in_quest(true)),
  assertz(in_quest(false)),
  retract(exp(CurrentExp)),
  retract(gold(CurrentGold)),
  NewExp is CurrentExp + Exp,      % cek naik level ga
  NewGold is CurrentGold + Gold,
  assertz(exp(NewExp)),
  assertz(gold(NewGold)),
  retract(quest(_,_,_,_,_)).

checkQuest :- !.