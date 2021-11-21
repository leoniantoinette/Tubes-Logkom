%belom_handle_max_level_equipment
%belom_handle_input_amount_bukan_harga
%belom_handle_inventory_kosong
%belom_handle_inventory_penuh
%belom_pake_gold
:- include('inventory.pl').
:- include('item.pl').

harga(50, 'carrot seed').
harga(50, 'corn seed').
harga(50, 'tomato seed').
harga(500, 'cow').
harga(200, 'chicken').
harga(1000, 'pig').
harga(300, 'shovel').
harga(500, 'fishing rod').
harga(75,'carrot').
harga(70,'corn').
harga(100,'tomato').
harga(200,'salmon').
harga(150,'tuna').
harga(250,'trout').
harga(120,'milk').
harga(100,'egg').
harga(220,'bacon').

item_name(1, 'carrot seed').
item_name(2, 'corn seed').
item_name(3, 'tomato seed').
item_name(4, 'chicken').
item_name(5, 'cow').
item_name(6, 'pig').
item_name(7, 'shovel').
item_name(8, 'fishing rod').

display_buy([],7).
display_buy([Head|Tail],Num) :-
	format('~w. ',[Num]),
  	write(Head),
	harga(X,Head),
	format(' (~w golds)',[X]),nl,
	New is Num+1,
  	display_buy(Tail,New).	

item_type(X) :- 
	ternak(X), !,
	write('How many do you want to buy?'),nl,
	read(Amount),
	format('You have bought ~w ~w.',[Amount,X]), nl,
	harga(Y,X),
	Total is Y*Amount ,
	format('You are charged ~w golds ~n.',[Total]).
item_type(X) :-
	seed(X),!,
	write('How many do you want to buy?'),nl,
	read(Amount),
	format('You have bought ~w ~w.',[Amount,X]), nl,
	harga(Y,X),
	Total is Y*Amount ,
	format('You are charged ~w golds.~n',[Total]),
	update_inventory(X,Amount).
item_type(X) :-
	equipment(X),
	X \= 'fishing rod',
	level_shovel(Now),
	New is Now+1,
	format('You have bought Level ~w shovel.',[New]), nl,
	harga(Y,X),
	format('You are charged ~w golds. ~n',[Y]),
	asserta(level_shovel(New)),
	retract(level_shovel(Now)).
item_type(X) :-
	equipment(X),
	X \= 'shovel',
	level_fishingrod(Now),
	New is Now+1,
	format('You have bought Level ~w fishing rod.',[New]), nl,
	harga(Y,X),
	format('You are charged ~w golds. ~n',[Y]),
	asserta(level_fishingrod(New)),
	retract(level_fishingrod(Now)).

shop('exitShop') :-
	write('Thanks for coming.'),!.

shop(Item) :-
	item_name(Item,Name),
	item_type(Name),nl,
	write('What do you want to buy?'),nl,
	display_buy(['carrot seed','corn seed','tomato seed','chicken','cow','pig'],1),
	level_shovel(Shovel_now),
	Shovel_new is Shovel_now +1,
	level_fishingrod(Fishingrod_now),
	Fishingrod_new is Fishingrod_now + 1,
	format('7. Level ~w shovel (300 golds) ~n', [Shovel_new]),
	format('8. Level ~w fishing rod (500 golds) ~n', [Fishingrod_new]),
	read(New_item),
	shop(New_item).

buy :- 
	write('What do you want to buy?'),nl,
	display_buy(['carrot seed','corn seed','tomato seed','chicken','cow','pig'],1),
	level_shovel(Shovel_now),
	Shovel_new is Shovel_now +1,
	level_fishingrod(Fishingrod_now),
	Fishingrod_new is Fishingrod_now + 1,
	format('7. Level ~w shovel (300 golds) ~n', [Shovel_new]),
	format('8. Level ~w fishing rod (500 golds) ~n', [Fishingrod_new]),
	read(Item),
	shop(Item).

display_sell([]).
display_sell([Head|Tail]) :-
    inventory(Head,0),
    display_sell(Tail).
display_sell([Head|Tail]) :-
	\+ inventory(Head,0),
	inventory(Head,Amount),
	format('- ~w ~w ~n',[Amount,Head]),
	display_sell(Tail).

validity_amount(Item, Amount):-
    inventory(Item,Valid_amount),
    Amount > Valid_amount,
    format('You don\'t have enough ~w to sell. ~n',[Item]),nl,!.
validity_amount(Item,Amount) :-
    inventory(Item,Valid_amount),
    Amount =< Valid_amount,
    format('You sold ~w ~w.~n',[Amount,Item]),
    harga(Price,Item),
    Total is Amount*Price,
    format('You received ~w golds.~n',[Total]),nl,
    New_amount is Valid_amount - Amount,
    asserta(inventory(Item,New_amount)),
    retract(inventory(Item,Valid_amount)).

validity_Item(Item) :-
    hasil_tani(Item),
    write('How many do you want to sell?'),nl,
	read(Amount),
    validity_amount(Item,Amount),!.
validity_Item(Item) :-
    hasil_ternak(Item),
    write('How many do you want to sell?'),nl,
	read(Amount),
    validity_amount(Item,Amount),!.
validity_Item(Item) :-
    ikan(Item),
    write('How many do you want to sell?'),nl,
	read(Amount),
    validity_amount(Item,Amount),!.
validity_Item(Item) :-
    write('Input invalid.'),nl,nl.

sell_item('exitShop'):- !.
sell_item(Item) :-
    validity_Item(Item),
    write('Here are the items in your inventory'),nl,
	display_sell(['carrot','corn','tomato','egg','milk','bacon','tuna','salmon','trout']),
	write('What do you want to sell? '),nl,
	read(New_item),
    sell_item(New_item).

sell :- 
	write('Here are the items in your inventory'),nl,
	display_sell(['carrot','corn','tomato','egg','milk','bacon','tuna','salmon','trout']),
	write('What do you want to sell? '),nl,
	read(Item),
    sell_item(Item).
	
market :-
	write('What do you want to do?'),nl,
	write('1. Buy'),nl,
	write('2. Sell'),nl,
	read(User_input),
	User_input.
