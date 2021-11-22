:- include('item.pl').
:- include('map.pl').
:- include ('item.pl').
:- include ('inventory.pl').

:- dynamic(crop_stat/4) % lokasi dan umur crop
% crop_stat(plant, absis, ordinat, age)
/* List of plants :
    carrot_plant
    corn_plant
    tomato_plant */


% metode untuk melakukan dig/penggalian
dig :-
    posisi(X,Y),
    \+pos_air(X,Y), !,
    \+pos_house(X,Y), !,
    \+pos_marketplace(X,Y), !,
    \+pos_quest(X,Y), !,
    \+pos_ranch(X,Y), !,
    assertz(pos_digged(X,Y)),
    write('You digged the tile.').

plant :-
    posisi(X,Y),
    \+pos_digged(X,Y), !, write('The tile is not digged yet.').
plant :-
    write('You have : \n')
    forall((seed(X), inventory(X,Y), Y > 0), format('- ~w ~w ~n', [Y, X])),
    read(In),
    In = 'carrot', 
    inventory('carrot seed', W), W > 0, 
    write('You planted a carrot seed.\n')
    retract(inventory('carrot seed', W)),
    assertz(inventory('carrot seed', W-1)),
    assertz(crop_stat(carrot_plant, X, Y, 0)).
plant :-
    In = 'corn',
    inventory('corn seed', U), U > 0, 
    write('You planted a corn seed.\n')
    retract(inventory('corn seed', U)),
    assertz(inventory('corn seed', U-1)),
    assertz(crop_stat(corn_plant, X, Y, 0)).
plant :-
    In = 'tomato',
    inventory('tomato seed', V), V > 0, 
    write('You planted a tomato seed.\n')
    retract(inventory('tomato seed', V)),
    assertz(inventory('tomato seed', V-1)),
    assertz(crop_stat(tomato_plant, X, Y, 0)).
plant :-
    write('There is no such seed in your inventory.\n').

harvest :-
    posisi(X,Y),
    crop_stat(carrot_plant,X,Y,W), W >= 14,
    write('You harvested carrot.\n'),
    retract(crop_stat(carrot_plant,X,Y,W)),
    retract(inventory('carrot',U)), 
    assertz(inventory('carrot',U+1)).
harvest :-
    crop_stat(corn_plant,X,Y,V), V >= 12,
    write('You harvested corn.\n'),
    retract(crop_stat(corn_plant,X,Y,V)),
    retract(inventory('corn',Z)), 
    assertz(inventory('corn',Z+1)).
harvest :-
    crop_stat(tomato_plant,X,Y,A), A >= 20,
    write('You harvested tomato.\n'),
    retract(crop_stat(tomato_plant,X,Y,A)),
    retract(inventory('tomato',B)), 
    assertz(inventory('tomato',B+1)).
harvest :-
    write('Nothing can be harvested yet.\n').
