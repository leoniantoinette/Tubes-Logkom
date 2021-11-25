/* TO DO :
    tambahin exp
    setelah harvest update quest
    setelah setiap activity tambahin move */

:- include('item.pl').
:- include('map.pl').
:- include('inventory.pl').

:- dynamic(crop_stat/4). % lokasi dan umur crop
% crop_stat(plant, absis, ordinat, age)
/* List of plants :
    carrot_plant
    corn_plant
    tomato_plant */

updateFarmExp :-
    retract(exp_farming(A)),
    ((farmer(true) -> (A1 is A + 15, asserta(exp_farming(A1))));
    (A1 is A + 10, asserta(exp_farming(A+10)))).

% metode untuk melakukan dig/penggalian
dig :-
    in_game(false),
    !,
    write('You haven\'t started the game! Try using \'start.\' to start the game.'),
    fail.
dig :-
    in_game(true),
    posisi(X,Y),
    ((pos_air(X,Y) -> write('You can\'t dig on water!\n'), !);
    (pos_house(X,Y) -> write('You can\'t dig on house!\n'), !);
    (pos_marketplace(X,Y) -> write('You can\'t dig on market!\n'), !);
    (pos_quest(X,Y) -> write('You can\'t dig on quest headquarters!\n'), !);
    (pos_ranch(X,Y) -> write('You can\'t dig on ranch!\n'), !);
    (assertz(pos_digged(X,Y)),
    write('You digged the tile.\n'),
    updateFarmExp)).

plantCarrot :-
    inventory('carrot seed', A),
    ((A > 0 -> (update_inventory('carrot seed', -1), write('You planted a carrot seed.\n')));
    (write('You don\'t have any carrot seed! Buy it first from the market!'))).

plantCorn :-
    inventory('corn seed', A),
    ((A > 0 -> update_inventory('corn seed', -1), write('You planted a corn seed.\n'));
    (write('You don\'t have any corn seed! Buy it first from the market!'))).

plantTomato :-
    inventory('tomato seed', A),
    ((A > 0 -> update_inventory('tomato seed', -1), write('You planted a tomato seed.\n'));
    (write('You don\'t have any tomato seed! Buy it first from the market!'))).

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
    write('You have : \n'),
    forall((seed(X), inventory(X,Y)), format('- ~w ~w ~n', [Y, X])),
    read(In),
    ((In == 'carrot' -> plantCarrot, updateFarmExp);
    (In == 'corn' -> plantCorn, updateFarmExp);
    (In == 'tomato' -> plantTomato, updateFarmExp);
    (write('There is no such seed in your inventory.\n'))).

harvestCarrot :-
    posisi(X,Y),
    crop_stat(carrot_plant,X,Y,A),
    ((A >= 14 -> write('You harvested carrot.\n'), update_inventory('carrot', 1));
    (write('Your carrot is not ready to be harvested yet!\n'))).

harvestCorn :-
    posisi(X,Y),
    crop_stat(corn_plant,X,Y,A),
    ((A >= 12 -> write('You harvested corn.\n'), update_inventory('corn', 1));
    (write('Your corn is not ready to be harvested yet!\n'))).

harvestTomato :-
    posisi(X,Y),
    crop_stat(tomato_plant,X,Y,A),
    ((A >= 20 -> write('You harvested tomato.\n'), update_inventory('tomato', 1));
    (write('Your tomato is not ready to be harvested yet!\n'))).

harvest :- 
    in_game(false),
    !,
    write('You haven\'t started the game! Try using \'start.\' to start the game.'),
    fail.
harvest :-
    in_game(true),
    posisi(X,Y),
    ((crop_stat(carrot_plant,X,Y,_) -> harvestCarrot, updateFarmExp);
    (crop_stat(corn_plant,X,Y,_) -> harvestCorn, updateFarmExp);
    (crop_stat(tomato_plant,X,Y,_) -> harvestTomato, updateFarmExp);
    (write('There is no plant here.'))).
