%TODO:
%nambahin_exp
%update quest

/* Mendapatkan level equipment Fishing Rod */
getLevelFishingRod(LevelFishingRod):-
    inventory(2,_,_,_,_,_,_,Level),
    LevelFishingRod is Level.

fish_type(0):-
    write('You got tuna!'),nl,
    addInventory('tuna',1).
fish_type(1):-
    write('You got salmon!'),nl,
    addInventory('salmon',1).
fish_type(2) :-
    write('You got trout!'),nl,
    addInventory('trout',1).

get_fish(Level_fishing) :-
    Level_fishing >= 1,
    Level_fishing =< 2,
    fish_type(0).
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

fishing(X,_) :-
    X \= 0,
    write('You didn\'t get anything!'),nl,
    write('You gained 5 fishing exp!'),nl,!.
fishing(0,Fishing_level) :-
    get_fish(Fishing_level),
    write('You gained 10 fishing exp!'),nl.

fish :-
    in_game(false),!,
    write('You haven\'t started the game! Try using \'start.\' to start the game.'),
    fail.
fish :-
    in_game(true),
    atFishingSpot,!,
    level_fishing(Fishing_level),
    getLevelFishingRod(FishingRodLevel),
    Multiply is 11 - Fishing_level - FishingRodLevel,
    random(1,90,Number),
    Result is mod(Number,Multiply),
    fishing(Result,Fishing_level).
fish :-
    !,
    write('You can call fish command only if you near water.').
