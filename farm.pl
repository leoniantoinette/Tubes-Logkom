:- dynamic(crop_stat/4).
/* lokasi dan umur crop
 * crop_stat(plant, absis, ordinat, age)
 * List of plants :
 *  carrot_plant
 *  corn_plant
 *  tomato_plant
 */

updateFarmExp :-
    retract(exp_farming(A)),
    ((farmer(true) -> (A1 is A + 15, asserta(exp_farming(A1))));
    (A1 is A + 10, asserta(exp_farming(A+10)))).

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
    ;   (
            assertz(pos_digged(X,Y)),
            write('You digged the tile.'),
            updateFarmExp,
            addMove
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
        addMove,
        write('You planted a carrot seed.\n')
    ;   In = 'corn' ->
        inventory(_,'corn seed',_,_,_,_,_,Count),
        Count > 0,
        reduceInventory('corn seed',1),
        assertz(crop_stat(corn_plant, X, Y, 0)),
        updateFarmExp,
        addMove,
        write('You planted a corn seed.\n')
    ;   In = 'tomato' ->
        inventory(_,'tomato seed',_,_,_,_,_,Count),
        Count > 0,
        reduceInventory('tomato seed',1),
        assertz(crop_stat(tomato_plant, X, Y, 0)),
        updateFarmExp,
        addMove,
        write('You planted a tomato seed.\n')
    ;   write('There are no such seeds in your inventory!\n')
    ).

/* metode untuk melakukan haverst/panen */
harvestCarrot :-
    posisi(X,Y),
    crop_stat(carrot_plant,X,Y,W),
    (   W >= 56 ->
        write('You harvested carrot.\n'),
        retract(crop_stat(carrot_plant,X,Y,W)),
        addInventory('carrot',1)
    ;   write('Your carrot is not ready to be harvested yet!\n')
    ).

harvestCorn :-
    posisi(X,Y),
    crop_stat(corn_plant,X,Y,V),
    (   V >= 48 ->
        write('You harvested corn.\n'),
        retract(crop_stat(corn_plant,X,Y,V)),
        addInventory('corn',1)
    ;   write('Your corn is not ready to be harvested yet!\n')
    ).

harvestTomato :-
    posisi(X,Y),
    crop_stat(tomato_plant,X,Y,A),
    (   A >= 80 ->
        write('You harvested tomato.\n'),
        retract(crop_stat(tomato_plant,X,Y,A)),
        addInventory('tomato',1)
    ;   write('Your tomato is not ready to be harvested yet!\n')
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
         updateFarmExp,
         addHarvestToQuest,
         addMove
    ;   crop_stat(corn_plant,X,Y,_) ->
         harvestCorn,
         updateFarmExp,
         addHarvestToQuest,
         addMove
    ;   crop_stat(tomato_plant,X,Y,_) ->
        harvestTomato,
        updateFarmExp,
        addHarvestToQuest,
        addMove
    ;   (write('There is no plant here.'))
    ).
















