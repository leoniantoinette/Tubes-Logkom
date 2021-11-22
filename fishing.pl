%TODO: 
%nambahin_exp
%update quest

:-include('map.pl').
:-include('inventory.pl').

%:- dynamic(level_fishing/1).
%:- dynamic(valid_fish/2).

%level_fishing(1).

fish_type(0):-
    write('You got tuna!'),nl,
    inventory('tuna',Now),
    New is Now + 1,
    asserta(inventory('tuna',New)),
    retract(inventory('tuna',Now)).
fish_type(1):-
    write('You got salmon!'),nl,
    inventory('salmon',Now),
    New is Now + 1,
    asserta(inventory('salmon',New)),
    retract(inventory('salmon',Now)).
fish_type(2) :-
    write('You got trout!'),nl,
    inventory('trout',Now),
    New is Now + 1,
    asserta(inventory('trout',New)),
    retract(inventory('trout',Now)).

get_fish(Level_fishing) :-
    Level_fishing >= 1,
    Level_fishing =< 2,
    write('You got tuna!'),nl.
get_fish(Level_fishing) :-
    Level_fishing >=3,
    Level_fishing =<4,
    random(1,90,Number),
    Fish is mod(Number,2),
    fish_type(Fish).
get_fish(5) :-
    random(1,90,Number),
    Fish is mod(Number,3),
    fish_type(Fish).

fishing(X,Fishing_level) :-
    X \= 0,
    write('You didn\'t get anything!'),nl,
    write('You gained 5 fishing exp!'),nl,!.
fishing(0,Fishing_level) :-
    get_fish(Fishing_level),
    write('You gained 10 fishing exp!'),nl,
    inventory_capacity(Now),
    New is Now + 1,
    asserta(inventory_capacity(New)),
    retract(inventory_capacity(Now)).

fish :-
    in_game(false),!,
    write('You haven\'t started the game! Try using \'start.\' to start the game.'),
    fail.
fish :-
    in_game(true),
    atFishingSpot,!,
    level_fishing(Fishing_level),
    level_fishingrod(Fishingrod_level),
    Multiply is 11 - Fishing_level - Fishingrod_level,
    random(1,90,Number),
    Result is mod(Number,Multiply),
    fishing(Result,Fishing_level).
fish :-
    !,
    write('You can call fish command only if you near water.').
    
