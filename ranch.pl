:- dynamic(ternakStatus/4).
/* Format berupa : ternakStatus(Name, Count, Processing Time , Deadline) */

% TODO
% blm tambah exp

addTernakStatus(Name, Addition):-
  (   Name = 'cow' ->
      assertz(ternakStatus(Name,Addition,0,48))
  ;   Name = 'chicken' ->
      assertz(ternakStatus(Name,Addition,0,44))
  ;   Name = 'pig' ->
      assertz(ternakStatus(Name,Addition,0,68))
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
            CountNew is Count+Amount,
            checkWhoCanBeTaken(W,X,Y,CountNew,Name)
        ;   checkWhoCanBeTaken(W,X,Y,Count,Name)
        )
    ;   checkWhoCanBeTaken(W,X,Y,Count,Name)
    ).

ranch :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.').
ranch :-
  in_game(true),
  atRanch,
  write('Welcome to the ranch! You have:'), nl,
  makeListRanch(ListName, ListCount),
  totalOnTheRanch(ListName, ListCount, CountCow, CountChicken, CountPig),
  (   CountCow \= 0 ->
      format('- ~w Cow ~n',[CountCow])
  ;   nl
  ),
  (   CountChicken \= 0 ->
      format('- ~w Chicken ~n',[CountChicken])
  ;   nl
  ),
  (   CountPig \= 0 ->
      format('- ~w Pig ~n',[CountPig])
  ;   nl
  ),
  write('What do you want to do?').
ranch :-
  in_game(true),
  !,
  write('You can call quest command only if you are at ranch.').

cow :-
  makeListWhoCanBeTaken(ListName, ListTProcess, ListTDeadline),
  Count is 0,
  checkWhoCanBeTaken(ListName, ListTProcess, ListTDeadline, Count, 'cow'),
  (   Count == 0 ->
      write('Your cow hasn\'t produced any milk.'), nl,
      write('Please check again later.')
  ;   format('Your cow has produced ~w milks. ~n',[Count]),
      format('You got ~w milks! ~n',[Count])
  ).

chicken :-
  makeListWhoCanBeTaken(ListName, ListTProcess, ListTDeadline),
  Count is 0,
  checkWhoCanBeTaken(ListName, ListTProcess, ListTDeadline, Count, 'chicken'),
  (   Count == 0 ->
      write('Your cow hasn\'t produced any egg.'), nl,
      write('Please check again later.')
  ;   format('Your chicken has produced ~w eggs. ~n',[Count]),
      format('You got ~w eggs! ~n',[Count])
  ).

pig :-
  makeListWhoCanBeTaken(ListName, ListTProcess, ListTDeadline),
  Count is 0,
  checkWhoCanBeTaken(ListName, ListTProcess, ListTDeadline, Count, 'pig'),
  (   Count == 0 ->
      write('Your cow hasn\'t produced any bacon.'), nl,
      write('Please check again later.')
  ;   format('Your chicken has produced ~w bacons. ~n',[Count]),
      format('You got ~w bacons! ~n',[Count])
  ).

/* Setiap melakukan aktivitas */
updateProcessRanch :-
  makeListRanch(ListName, ListCount),
  updateTernakStatus(ListName, ListCount, true, false),!.

/* Setiap kenaikan level fishing */
updateLevelRanch :-
  makeListRanch(ListName, ListCount),
  updateTernakStatus(ListName, ListCount, false, true),!.
