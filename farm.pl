:- dynamic(crop_stat/4).
/* lokasi dan umur crop
 * crop_stat(plant, absis, ordinat, age)
 * List of plants :
 *  carrot_plant
 *  corn_plant
 *  tomato_plant
 */
:- dynamic(harvestTime/2). % harvestTime(plant, time)

% Inisialisasi waktu harvest setiap tanaman.
init_farm :-
    assertz(harvestTime(carrot_plant, 56)),
    assertz(harvestTime(corn_plant, 48)),
    assertz(harvestTime(tomato_plant, 80)).

update_harvestTime :-
    level_farming(L),
    ((L =:= 1 -> (retractall(harvestTime(_,_)),
                assertz(harvestTime(carrot_plant, 56)),
                assertz(harvestTime(corn_plant, 48)),
                assertz(harvestTime(tomato_plant, 80)), !));
    (L =:= 2 -> (retractall(harvestTime(_,_)),
                assertz(harvestTime(carrot_plant, 52)),
                assertz(harvestTime(corn_plant, 44)),
                assertz(harvestTime(tomato_plant, 76)), !));
    (L =:= 3 -> (retractall(harvestTime(_,_)),
                assertz(harvestTime(carrot_plant, 48)),
                assertz(harvestTime(corn_plant, 40)),
                assertz(harvestTime(tomato_plant, 72)), !));
    (L =:= 4 -> (retractall(harvestTime(_,_)),
                assertz(harvestTime(carrot_plant, 44)),
                assertz(harvestTime(corn_plant, 35)),
                assertz(harvestTime(tomato_plant, 68)), !));
    (L >= 5 -> (retractall(harvestTime(_,_)),
                assertz(harvestTime(carrot_plant, 40)),
                assertz(harvestTime(corn_plant, 30)),
                assertz(harvestTime(tomato_plant, 64)), !))).

updateFarmExp :-
    retract(exp_farming(A)),
    retract(exp_pemain(B)),
    (
        farmer(true) ->
             A1 is A + 15,
             B1 is B + 15,
             asserta(exp_farming(A1)),
             asserta(exp_pemain(B1))
    ;   A1 is A + 10,
        B1 is B + 10,
        asserta(exp_farming(A1)),
        asserta(exp_pemain(B1))
    ).

updateCropAge :-
    forall(crop_stat(P,X,Y,A),
           (retract(crop_stat(P,X,Y,A)),
            A_new is A + 1,
            assertz(crop_stat(P,X,Y,A_new)))
          ).

/* metode untuk melakukan dig/penggalian */
dig :-
    in_game(false),
    !,
    write('You haven\'t started the game! Try using \'start.\' to start the game.'),
    fail.
dig :-
    in_game(true),
    posisi(X,Y),
    (
        pos_air(X,Y) ->
        write('You can\'t dig on water!\n'), !
    ;   pos_house(X,Y) ->
        write('You can\'t dig on house!\n'), !
    ;   pos_marketplace(X,Y) ->
        write('You can\'t dig on market!\n'), !
    ;   pos_quest(X,Y) ->
        write('You can\'t dig on quest headquarters\n'), !
    ;   pos_ranch(X,Y) ->
        write('You can\'t dig on ranch!\n'), !
    ;   
        pos_digged(X,Y) ->
        write('This tile is digged!\n'), !
    ;
        (
            assertz(pos_digged(X,Y)),
            write('You digged the tile.'),
            addTime
        )
    ).

/* metode untuk melakukan plant/penanaman */
plant :-
    in_game(false),
    !,
    write('You haven\'t started the game! Try using \'start.\' to start the game.'),
    fail.
plant :-
    in_game(true),
    posisi(X,Y),
    \+pos_digged(X,Y), !, write('The tile is not digged yet.').
plant :- 
    posisi(X,Y),
    crop_stat(P,X,Y,_), !, 
    write('You have planted '),
    ((P == carrot_plant) -> write('carrot ');
    (P == corn_plant) -> write('corn ');
    (P == tomato_plant) -> write('tomato ')),
    write('here!\n').
plant :-
    posisi(X,Y),
    write('You have : \n'),
    forall((inventory(_,Name,barang,farming,_,_,buy,Count)),
           format('- ~w ~w ~n', [Count, Name])),
    write('What do you want to plant?'), nl,
    write('> '),
    read(In),
    (
        In = 'carrot' ->
        inventory(_,'carrot seed',_,_,_,_,_,Count),
        Count > 0,
        reduceInventory('carrot seed',1),
        assertz(crop_stat(carrot_plant, X, Y, 0)),
        updateFarmExp,
        addTime,
        write('You planted a carrot seed.\n'), !
    ;   In = 'corn' ->
        inventory(_,'corn seed',_,_,_,_,_,Count),
        Count > 0,
        reduceInventory('corn seed',1),
        assertz(crop_stat(corn_plant, X, Y, 0)),
        updateFarmExp,
        addTime,
        write('You planted a corn seed.\n'), !
    ;   In = 'tomato' ->
        inventory(_,'tomato seed',_,_,_,_,_,Count),
        Count > 0,
        reduceInventory('tomato seed',1),
        assertz(crop_stat(tomato_plant, X, Y, 0)),
        updateFarmExp,
        addTime,
        write('You planted a tomato seed.\n'), !
    ;   write('There are no such seeds in your inventory!\n')
    ).

/* metode untuk melakukan haverst/panen */
harvestCarrot :-
    posisi(X,Y),
    crop_stat(carrot_plant,X,Y,W),
    (   (harvestTime(carrot_plant, T), W >= T) ->
        write('You harvested carrot.\n'),
        retract(crop_stat(carrot_plant,X,Y,W)),
        addInventory('carrot',1),
        updateFarmExp,
        addTime,
        !
    ;   write('Your carrot is not ready to be harvested yet!\n'),
        !
    ).

harvestCorn :-
    posisi(X,Y),
    crop_stat(corn_plant,X,Y,V),
    (   (harvestTime(corn_plant, T), V >= T) ->
        write('You harvested corn.\n'),
        retract(crop_stat(corn_plant,X,Y,V)),
        addInventory('corn',1),
        updateFarmExp,
        addTime,
        !
    ;   write('Your corn is not ready to be harvested yet!\n'),
        !
    ).

harvestTomato :-
    posisi(X,Y),
    crop_stat(tomato_plant,X,Y,A),
    (   (harvestTime(tomato_plant, T), A >= T) ->
        write('You harvested tomato.\n'),
        retract(crop_stat(tomato_plant,X,Y,A)),
        addInventory('tomato',1),
        updateFarmExp,
        addTime,
        !
    ;   write('Your tomato is not ready to be harvested yet!\n'),
        !
    ).

harvest :-
    in_game(false),
    !,
    write('You haven\'t started the game! Try using \'start.\' to start the game.'),
    fail.
harvest :-
    in_game(true),
    posisi(X,Y),
    (
        crop_stat(carrot_plant,X,Y,_) ->
        harvestCarrot,
        updateQuestWhenHaverst, !
    ;   crop_stat(corn_plant,X,Y,_) ->
        harvestCorn,
        updateQuestWhenHaverst, !
    ;   crop_stat(tomato_plant,X,Y,_) ->
        harvestTomato,
        updateQuestWhenHaverst, !
    ;   write('There is no plant here.')
    ).
