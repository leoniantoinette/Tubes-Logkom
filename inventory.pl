:- dynamic(inventory/8).
/* Format Berupa item(ID, Name, Type, Role, Price, isInventory, _)
 * UNTUK TYPE = BARANG, LIST KE-8 (_) BERUPA COUNT
 * UNTUK TYPE = EQUIPMENT, LIST KE-8(_) BERUPA LEVEL
 */

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
        write(C), write(' '), write(A), nl,
        writeInventory(W,X,Y)
    ;   writeInventory(W,X,Y)
    ).

isMemberInventory(ID,[ID|_]).
isMemberInventory(ID,[_|T]):-
    isMemberInventory(ID,T).

isNameInventory(NAME,[NAME|_]).
isNameInventory(NAME,[_|T]):-
    isNameInventory(NAME,T).

addInventory(_,_):-
    totalInventory(Total),
    Total >= 100,
    write('Your inventory is full!'),
    !,fail.
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
    totalInventory(Sum),
    format('Your inventory: (~w/100)', [Sum]), nl,
    makeListInventory(Name, ListType, Count),
    writeInventory(Name, ListType, Count).

throwItem:-
    write('Your inventory'), nl,
    makeListInventory(Name, ListType, Count),
    writeInventory(Name, ListType, Count), nl,
    write('What do you want to throw?'), nl,
    write('> '),
    read(User_input),
    inventory(_,User_input,Type,_,_,_,_,_),
    (   Type == equipment ->
        write('You can\'t throw it away because it\'s your equipment!')
    ;   
        Type == barang -> 
        getCountBarang(User_input,Amount),
        format('You have ~w ~w. How many do you want to throw?', [Amount,User_input]), nl,
        write('> '),
        read(Reduce),
        (   (Reduce < Amount) ->
            reduceInventory(User_input,Reduce),
            format('You threw away ~w ~w.', [Reduce,User_input]), nl
         ;  format('You don\'t have enough ~w. Cancelling...', [User_input]), nl
        )
    ).















