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

updateTernakStatus([],[],_,_):- !.
updateTernakStatus([A|W], [B|X], StatusProcess, StatusLevel):-
  (   StatusProcess == true ->
      ternakStatus(A,B,TProcess,TDeadline),
      retract(ternakStatus(A,B,TProcess,TDeadline)),
      TProcessNew is TProcess+1,
      assertz(ternakStatus(A,B,TProcessNew,TDeadline)),
      updateTernakStatus(W,X,StatusProcess, StatusLevel)
  ;   StatusLevel == true ->
      ternakStatus(A,B,TProcess,TDeadline),
      retract(ternakStatus(A,B,TProcess,TDeadline)),
      TDeadlineNew is TDeadline-4,
      assertz(ternakStatus(A,B,TProcess,TDeadlineNew)),
      updateTernakStatus(W,X,StatusProcess, StatusLevel)
  ).

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
          format('- ~w Cow ~n',[CountCow])
      ;!
      ),
      (   CountChicken \= 0 ->
          format('- ~w Chicken ~n',[CountChicken])
      ;!
      ),
      (   CountPig \= 0 ->
          format('- ~w Pig ~n',[CountPig])
      ;!
      ),
      write('What do you want to do?')
  ).
ranch :-
  !,
  write('You can call ranch command only if you are at ranch.').

cow :-
  makeListWhoCanBeTaken(ListName, ListTProcess, ListTDeadline),
  checkWhoCanBeTaken(ListName, ListTProcess, ListTDeadline, Count, 'cow'),
  (   Count == 0 ->
      write('Your cow hasn\'t produced any milk.'), nl,
      write('Please check again later.')
  ;   format('Your cow has produced ~w milks. ~n',[Count]),
      format('You got ~w milks! ~n',[Count]),
      updateRanchExp,
      updateQuestWhenGetProductFromAnimal(Count)
  ),
  addTime.

chicken :-
  makeListWhoCanBeTaken(ListName, ListTProcess, ListTDeadline),
  checkWhoCanBeTaken(ListName, ListTProcess, ListTDeadline, Count, 'chicken'),
  (   Count == 0 ->
      write('Your chicken hasn\'t produced any egg.'), nl,
      write('Please check again later.')
  ;   format('Your chicken has produced ~w eggs. ~n',[Count]),
      format('You got ~w eggs! ~n',[Count]),
      updateRanchExp,
      updateQuestWhenGetProductFromAnimal(Count)
  ),
  addTime.

pig :-
  makeListWhoCanBeTaken(ListName, ListTProcess, ListTDeadline),
  checkWhoCanBeTaken(ListName, ListTProcess, ListTDeadline, Count, 'pig'),
  (   Count == 0 ->
      write('Your pig hasn\'t produced any bacon.'), nl,
      write('Please check again later.')
  ;   format('Your pig has produced ~w bacons. ~n',[Count]),
      format('You got ~w bacons! ~n',[Count]),
      updateRanchExp,
      updateQuestWhenGetProductFromAnimal(Count)
  ),
  addTime.

/* Setiap melakukan aktivitas */
updateProcessRanch :-
  makeListRanch(ListName, ListCount),
  updateTernakStatus(ListName, ListCount, true, false),!.
