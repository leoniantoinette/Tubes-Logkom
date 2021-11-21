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
    write('You have : ~n')
    forall((seed(X), inventory(X,Y), Y > 0), format('- ~w ~w ~n', [Y, X])),
    read(In),
    In = 'carrot', 
    inventory('Carrot seed', W), W > 0, 
    write('You planted a carrot seed.')
    retract(inventory('Carrot seed', W)),
    assertz(inventory('Carrot seed', W-1)),
    assertz(crop_stat(carrot_plant, X, Y, 0)).
plant :-
    In = 'corn',
    inventory('Corn seed', U), U > 0, 
    write('You planted a corn seed.')
    retract(inventory('Corn seed', U)),
    assertz(inventory('Corn seed', U-1)),
    assertz(crop_stat(corn_plant, X, Y, 0)).
plant :-
    In = 'tomato',
    inventory('Tomato seed', V), V > 0, 
    write('You planted a tomato seed.')
    retract(inventory('Tomato seed', V)),
    assertz(inventory('Tomato seed', V-1)),
    assertz(crop_stat(tomato_plant, X, Y, 0)).
plant :-
    write('There is no such seed in your inventory.').

harvest :-
    posisi(X,Y),
    crop_stat(carrot_plant,X,Y,W), W >= 14,
    write('You harvested carrot.'),
    retract(crop_stat(carrot_plant,X,Y,W)),
    retract(inventory('Carrot',U)), 
    assertz(inventory('Carrot',U+1)).
harvest :-
    crop_stat(corn_plant,X,Y,V), V >= 12,
    write('You harvested corn.'),
    retract(crop_stat(corn_plant,X,Y,V)),
    retract(inventory('Corn',Z)), 
    assertz(inventory('Corn',Z+1)).
harvest :-
    crop_stat(tomato_plant,X,Y,A), A >= 20,
    write('You harvested tomato.'),
    retract(crop_stat(tomato_plant,X,Y,A)),
    retract(inventory('Tomato',B)), 
    assertz(inventory('Tomato',B+1)).
harvest :-
    write('Nothing can be harvested yet.').
