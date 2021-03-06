:- dynamic(inventory/8).
/* Format Berupa item(ID, Name, Type, Role, Price, isInventory, _)
 * UNTUK TYPE = BARANG, LIST KE-8 (_) BERUPA COUNT
 * UNTUK TYPE = EQUIPMENT, LIST KE-8(_) BERUPA LEVEL
 */

totalSellableItem(Sum):-
    findall(Count, inventory(_,_,_,_,_,_,sell,Count),List),
    sum_list(List,Sum).
    
totalInventoryWithoutEquipment(Sum):-
    findall(Count, inventory(_,_,barang,_,_,_,_,Count), List),
    sum_list(List,Sum).

totalInventory(Total):-
    totalInventoryWithoutEquipment(Sum),
    Total is Sum + 2.

isInventoryPenuh:-
    totalInventory(Total),
    Total == 100.

makeListInventory(ListName, ListType, ListCount):-
    findall(Name, inventory(_,Name,_,_,_,true,_,_), ListName),
    findall(Type, inventory(_,_,Type,_,_,true,_,_), ListType),
    findall(Count, inventory(_,_,_,_,_,true,_,Count), ListCount).

writeInventory([], [], []).
writeInventory([A|W], [B|X], [C|Y]):-
    (   (B == equipment) ->
        write('1 Level '), write(C), write(' '), write(A), nl,
        writeInventory(W,X,Y)
    ;   (B == barang) ->
        write(C), 
        write(' '), 
        (   C>1 ->
            plural(A, A1),
            capitalize(A1,A2),
            write(A2)
        ;
            C == 1 ->
            capitalize(A,A1),
            write(A1)
        ),nl,
        writeInventory(W,X,Y)
    ;   writeInventory(W,X,Y)
    ).

isMemberInventory(ID,[ID|_]).
isMemberInventory(ID,[_|T]):-
    isMemberInventory(ID,T).

isNameInventory(NAME,[NAME|_]).
isNameInventory(NAME,[_|T]):-
    isNameInventory(NAME,T).

addInventory(Name,_):-
    totalInventory(Total),
    Total >= 100,
    item(_,Name,Type,_,_,_,_),
    (   
        Type == equipment ->
        retract(inventory(ID,Name,Type,Role,Price,IsInventory,StatusMarket,Count)),
        UpdateCount is Count+1,
        assertz(inventory(ID,Name,Type,Role,Price,IsInventory,StatusMarket,UpdateCount))
    ;
        write('Your inventory is full!'),
        !,fail
    ).

addInventory(Name,Addition):-
    item(ID,Name,_,_,_,_,_),
    findall(Id, inventory(Id,_,_,_,_,_,_,_), ListId),
    (   isMemberInventory(ID,ListId) ->
        item(ID,Name,_,_,_,_,_),
        retract(inventory(ID,Name,Type,Role,Price,IsInventory,StatusMarket,Count)),
        UpdateCount is Count+Addition,
        assertz(inventory(ID,Name,Type,Role,Price,IsInventory,StatusMarket,UpdateCount))
    ;   item(ID,Name,Type,Role,Price,IsInventory,StatusMarket),
        Count is Addition,
        assertz(inventory(ID,Name,Type,Role,Price,IsInventory,StatusMarket,Count))
     ).

reduceInventory(Name,_):-
    item(ID,Name,_,_,_,_,_),
    findall(Id, inventory(Id,_,_,_,_,_,_,_), ListId),
    \+isMemberInventory(ID,ListId),
    write('There is no such item in your inventory!'), nl,
    !,fail.
reduceInventory(Name,Reduction):-
    inventory(ID,Name,_,_,_,_,_,Count),
    NewCount is Count-Reduction,
    (   NewCount =:= 0 ->
        retract(inventory(ID,_,_,_,_,_,_,_))
    ;   retract(inventory(ID,Name,Type,Role,Price,IsInventory,StatusMarket,Count)),
        assertz(inventory(ID,Name,Type,Role,Price,IsInventory,StatusMarket,NewCount))
    ).

getCountBarang(NAME,Count):-
    findall(Name, inventory(_,Name,_,_,_,_,_,_), ListName),
    (   isNameInventory(NAME,ListName) ->
        inventory(_,NAME,_,_,_,_,_,COUNT),
        Count is COUNT
    ;   write('There is no such name in your inventory!')
    ).

inventory:-
    in_game(false),
	!,
	write('You haven\'t started the game! Try using \'start.\' to start the game.'),
	fail.
inventory:-
    in_game(true),
    totalInventory(Sum),
    format('Your inventory: (~w/100)', [Sum]), nl,
    makeListInventory(Name, ListType, Count),
    writeInventory(Name, ListType, Count).

throwItem:-
    in_game(false),
	!,
	write('You haven\'t started the game! Try using \'start.\' to start the game.'),
	fail.
throwItem:-
    in_game(true),
    totalInventoryWithoutEquipment(Total),
    Total == 0,
    write('You have nothing to throw.'),nl,
    !.
throwItem:-
    in_game(true),
    totalInventoryWithoutEquipment(Total),
    Total > 0,
    write('Your inventory'), nl,
    makeListInventory(ItemName, ListType, Count),
    writeInventory(ItemName, ListType, Count), nl,
    write('What do you want to throw?'), nl,
    write('> '),
    read(User_input),
    fixedUserInput(User_input,Fixed),
    findall(Name, inventory(_,Name,_,_,_,_,_,_), ListName),
    (   isNameInventory(Fixed,ListName) ->
        inventory(_,Fixed,Type,_,_,_,_,_),
        (   Type == equipment ->
            write('You can\'t throw it away because it\'s your equipment!')
        ;   
            Type == barang -> 
            getCountBarang(Fixed,Amount),
            (
                Amount > 1 -> 
                plural(Fixed,FixedName),
                format('You have ~w ~w. How many do you want to throw? ~n ', [Amount,FixedName])
            ;
                format('You have ~w ~w. How many do you want to throw? ~n', [Amount,Fixed])
            ),
            write('> '),
            read(Reduce),
            (   (Reduce =< Amount) ->
                reduceInventory(Fixed,Reduce),
                (
                    Reduce > 1 -> 
                    plural(Fixed,FixedName),
                    format('You threw away ~w ~w. ~n', [Reduce,FixedName])
                ;
                    format('You threw away ~w ~w. ~n', [Reduce,Fixed])
                )
            ;  format('You don\'t have enough ~w. Cancelling...', [Fixed]), nl
            )
        )
    ;   write('Your input is invalid! Provide input with item names based on items listed above!')
    ), !.
















