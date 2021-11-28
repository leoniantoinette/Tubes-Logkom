:- dynamic(ternakStatus/4).
/* Format berupa : ternakStatus(Name, Count, Processing Time , Deadline) */

/* Sistem ranch sebagai berikut.
 * Saat terjadi peningkatan level pada equipment shovel, maka ternak yang sedang berjalan waktu batas untuk garapnya tidak akan mengalami perubahan.
 * Jadi yang mengalami perubahan itu sewaktu membeli hewan ternak, maka batas waktu garap hasil ternaknya akan berkurang.
 */

updateRanchExp :-
    retract(exp_ranching(A)),
    retract(exp_pemain(B)),
    (
        rancher(true) ->
             A1 is A + 15,
             B1 is B + 15,
             asserta(exp_ranching(A1)),
             asserta(exp_pemain(B1))
    ;   A1 is A + 10,
        B1 is B + 10,
        asserta(exp_ranching(A1)),
        asserta(exp_pemain(B1))
    ).

addTernakStatus(Name, Addition):-
  level_ranching(Level),
  (   Name = 'cow' ->
      (   Level == 1 ->
          assertz(ternakStatus(Name,Addition,0,48))
      ;   Level == 2 ->
          assertz(ternakStatus(Name,Addition,0,44))
      ;   Level == 3 ->
          assertz(ternakStatus(Name,Addition,0,40))
      ;   Level == 4 ->
          assertz(ternakStatus(Name,Addition,0,36))
      ;   Level == 5 ->
          assertz(ternakStatus(Name,Addition,0,32))
      )
  ;   Name = 'chicken' ->
      (   Level == 1 ->
          assertz(ternakStatus(Name,Addition,0,44))
      ;   Level == 2 ->
          assertz(ternakStatus(Name,Addition,0,40))
      ;   Level == 3 ->
          assertz(ternakStatus(Name,Addition,0,36))
      ;   Level == 4 ->
          assertz(ternakStatus(Name,Addition,0,32))
      ;   Level == 5 ->
          assertz(ternakStatus(Name,Addition,0,28))
      )
  ;   Name = 'pig' ->
      (   Level == 1 ->
          assertz(ternakStatus(Name,Addition,0,68))
      ;   Level == 2 ->
          assertz(ternakStatus(Name,Addition,0,64))
      ;   Level == 3 ->
          assertz(ternakStatus(Name,Addition,0,60))
      ;   Level == 4 ->
          assertz(ternakStatus(Name,Addition,0,56))
      ;   Level == 5 ->
          assertz(ternakStatus(Name,Addition,0,52))
      )
  ).

makeListRanch(ListName, ListCount):-
    findall(Name, ternakStatus(Name,_,_,_), ListName),
    findall(Count, ternakStatus(_,Count,_,_), ListCount).

updateTernakStatus([],[]):- !.
updateTernakStatus([A|W], [B|X]):-
   ternakStatus(A,B,TProcess,TDeadline),
   retract(ternakStatus(A,B,TProcess,TDeadline)),
   TProcessNew is TProcess+1,
   assertz(ternakStatus(A,B,TProcessNew,TDeadline)),
   updateTernakStatus(W,X).

totalOnTheRanch([], [], 0, 0, 0).
totalOnTheRanch([A|W], [B|X], CountCow, CountChicken, CountPig):-
	(   A == 'cow' ->
            totalOnTheRanch(W,X, CountCowCurrent, CountChicken, CountPig),
            CountCow is CountCowCurrent+B
        ;   A == 'chicken' ->
            totalOnTheRanch(W,X, CountCow, CountChickenCurrent, CountPig),
            CountChicken is CountChickenCurrent+B
        ;   A == 'pig' ->
            totalOnTheRanch(W,X, CountCow, CountChicken, CountPigCurrent),
            CountPig is CountPigCurrent+B
        ).

makeListWhoCanBeTaken(ListName, ListTProcess, ListTDeadline) :-
    findall(Name, ternakStatus(Name,_,_,_), ListName),
    findall(TProcess, ternakStatus(_,_,TProcess,_), ListTProcess),
    findall(TDeadline, ternakStatus(_,_,_,TDeadline), ListTDeadline).

checkWhoCanBeTaken([], [], [], 0, _).
checkWhoCanBeTaken([A|W], [B|X], [C|Y], Count, Name):-
    (   A == Name ->
        (   B > C ->
            retract(ternakStatus(A,Amount,B,C)),
	    addTernakStatus(A,Amount),
            checkWhoCanBeTaken(W,X,Y,CountCurrent,Name),
            Count is CountCurrent+Amount
        ;   checkWhoCanBeTaken(W,X,Y,Count,Name)
        )
    ;   checkWhoCanBeTaken(W,X,Y,Count,Name)
    ).

checkWhenRanchEmpty :-
  makeListRanch(ListName, ListCount),
  totalOnTheRanch(ListName, ListCount, CountCow, CountChicken, CountPig),
  CountCow == 0,
  CountChicken == 0,
  CountPig == 0,
  !.

ranch :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
ranch :-
  in_game(true),
  atRanch,!,
  write('Welcome to the ranch!'), nl,
  (   checkWhenRanchEmpty ->
      write('You don`t have any animals in the ranch'),
      !
  ;   makeListRanch(ListName, ListCount),
      totalOnTheRanch(ListName, ListCount, CountCow, CountChicken, CountPig),
      write('You have:'),nl,
      (   CountCow \= 0 ->
          (
              CountCow == 1 ->
              format('- ~w Cow ~n',[CountCow])
          ;
              format('- ~w Cows ~n',[CountCow])
          )
      ;!
      ),
      (   CountChicken \= 0 ->
          (
              CountChicken == 1 ->
              format('- ~w Chicken ~n',[CountChicken])
          ;
              format('- ~w Chickens ~n',[CountChicken])
          )
      ;!
      ),
      (   CountPig \= 0 ->
          (
              CountPig == 1 ->
              format('- ~w Pig ~n',[CountPig])
          ;
              format('- ~w Pigs ~n',[CountPig])
          )
      ;!
      ),
      write('What do you want to do?')
  ).
ranch :-
  !,
  write('You can call ranch command only if you are at ranch.').

cow :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
cow :-
  in_game(true),
  atRanch,!,
  makeListWhoCanBeTaken(ListName, ListTProcess, ListTDeadline),
  checkWhoCanBeTaken(ListName, ListTProcess, ListTDeadline, Count, 'cow'),
  makeListRanch(ListRanch, ListCount),
  totalOnTheRanch(ListRanch, ListCount, CountCow,_,_),
  (   Count == 0 ->
      (   CountCow == 1 ->
          write('Your cow hasn\'t produced any milk.'), nl
      ;
          write('Your cows haven\'t produced any milk.'), nl
      ),
      write('Please check again later.')
  ;   
      (
          CountCow ==1 ->
          format('Your cow has produced ~w milk. ~n',[Count])
      ;
          format('Your cows have produced ~w milk. ~n',[Count])
      ),
      addInventory('milk',Count),
      format('You got ~w milk! ~n',[Count]),
      updateRanchExp,
      updateQuestWhenGetProductFromAnimal(Count)
  ),
  addTime.
cow :-
  !,
  write('You can call cow command only if you are at ranch.').

chicken :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
chicken :-
  in_game(true),
  atRanch,!,
  makeListWhoCanBeTaken(ListName, ListTProcess, ListTDeadline),
  checkWhoCanBeTaken(ListName, ListTProcess, ListTDeadline, Count, 'chicken'),
  makeListRanch(ListRanch, ListCount),
  totalOnTheRanch(ListRanch, ListCount,_, CountChicken,_),
  (   Count == 0 ->
      (
          CountChicken == 1 -> 
          write('Your chicken hasn\'t produced any egg.'), nl
      ;
          write('Your chickens haven\'t produced any egg.'), nl
      ),
      write('Please check again later.')
  ;   
      Count == 1 ->
      (
          CountChicken == 1 -> 
          format('Your chicken has produced ~w egg. ~n',[Count])
      ;
          format('Your chickens have produced ~w egg. ~n',[Count])
      ),
      addInventory('egg',Count),
      format('You got ~w egg! ~n',[Count]),
      updateRanchExp,
      updateQuestWhenGetProductFromAnimal(Count)
  ;
      (
          CountChicken == 1 -> 
          format('Your chicken has produced ~w eggs. ~n',[Count])
      ;
          format('Your chickens have produced ~w eggs. ~n',[Count])
      ),
      addInventory('egg',Count),
      format('You got ~w eggs! ~n',[Count]),
      updateRanchExp,
      updateQuestWhenGetProductFromAnimal(Count)
  ),
  addTime.
chicken :-
  !,
  write('You can call chicken command only if you are at ranch.').

pig :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
pig :-
  in_game(true),
  atRanch,!,
  makeListWhoCanBeTaken(ListName, ListTProcess, ListTDeadline),
  checkWhoCanBeTaken(ListName, ListTProcess, ListTDeadline, Count, 'pig'),
  makeListRanch(ListRanch, ListCount),
  totalOnTheRanch(ListRanch, ListCount,_,_,CountPig),
  (   Count == 0 ->
      (
          CountPig == 1 ->
          write('Your pig hasn\'t produced any bacon.'), nl
      ;
          write('Your pigs haven\'t produced any bacon.'), nl
      ),
      write('Please check again later.')
  ;
      Count == 1 ->
      (
          CountPig == 1 ->
          format('Your pig has produced ~w bacon. ~n',[Count])
      ;
          format('Your pigs have produced ~w bacon. ~n',[Count])
      ),
      addInventory('bacon',Count),
      format('You got ~w bacon! ~n',[Count]),
      updateRanchExp,
      updateQuestWhenGetProductFromAnimal(Count)
  ;   
      (
          CountPig == 1 ->
          format('Your pig has produced ~w bacons. ~n',[Count])
      ;
          format('Your pigs have produced ~w bacons. ~n',[Count])
      ),
      addInventory('bacon',Count),
      format('You got ~w bacons! ~n',[Count]),
      updateRanchExp,
      updateQuestWhenGetProductFromAnimal(Count)
  ),
  addTime.
pig :-
  !,
  write('You can call pig command only if you are at ranch.').

/* Setiap melakukan aktivitas */
updateProcessRanch :-
  makeListRanch(ListName, ListCount),
  updateTernakStatus(ListName, ListCount),!.
