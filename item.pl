/* Items
 * Terdiri dari equipment dan inventory
 * Format berupa
 * item(ID, Name, Type, Role, Price, IsInventory, StatusMarket)
 */

/* Equipments untuk Player (dapat dibeli untuk meningkatkan level) */
item(1, 'shovel', equipment, farming,  300, true, buy).
item(2, 'fishing rod', equipment, fishing, 500, true, buy).

/* Barang untuk Player*/

/* Barang yang dapat dijual */
item(3, 'carrot', barang, farming, 75, true, sell).
item(4, 'corn', barang, farming, 70, true, sell).
item(5, 'tomato', barang, farming, 100, true, sell).
item(6, 'salmon', barang, fishing, 200, true, sell).
item(7, 'tuna', barang, fishing, 150, true, sell).
item(8, 'trout', barang, fishing, 250, true, sell).
item(9, 'milk', barang, fishing, 120, true, sell).
item(10, 'egg', barang, fishing, 100, true, sell).
item(11, 'bacon', barang, fishing, 220, true, sell).

/* Barang yang dapat dibeli */
item(12, 'carrot seed', barang, farming, 50, true, buy).
item(13, 'corn seed', barang, farming, 50, true, buy).
item(14, 'tomato seed', barang, farming, 50, true, buy).
item(15, 'cow', barang, ranching, 500, false, buy).
item(16, 'chicken', barang, ranching, 200, false, buy).
item(17, 'pig', barang, ranching, 1000, false, buy).

/* TESTING

makeListItem(ListName, ListType) :-
    findall(Name, item(_,Name,_,_,_,true,_), ListName),
    findall(ListType, item(_,_,ListType,_,_,true,_), ListType).


writeItem([], []).
writeItem([A|W], [B|X]) :-
    (   (B == equipment) ->
        write('1 '), write(A), nl,
        writeItem(W,X)
    ;   (B == barang) ->
        write(A), nl,
        writeItem(W,X)
    ;   writeItem(W,X)
    ).

item :-
    makeListItem(Name, ListType),
    writeItem(Name, ListType).

 */






