:- include('inventory.pl').
:- include('item.pl').

harga(50, 'Carrot seed').
harga(50, 'Corn seed').
harga(50, 'Tomato seed').
harga(500, 'Cow').
harga(200, 'Chicken').
harga(1000, 'Pig').
harga(300, 'shovel').
harga(500, 'fishing rod').

item_name(1, 'Carrot seed').
item_name(2, 'Corn seed').
item_name(3, 'Tomato seed').
item_name(4, 'Chicken').
item_name(5, 'Cow').
item_name(6, 'Pig').
item_name(7, 'shovel').
item_name(8, 'fishing rod').

display_market([],7).
display_market([Head|Tail],Num) :-
	format('~w. ',[Num]),
  	write(Head),
	harga(X,Head),
	format(' (~w golds)',[X]),nl,
	New is Num+1,
  	display_market(Tail,New).	

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
	format('You are charged ~w golds ~n.',[Total]),
	update_inventory(X,Amount).
item_type(X) :-
	equipment(X),
	X \= 'fishing rod',
	level_shovel(Now),
	New is Now+1,
	format('You have bought Level ~w shovel.',[New]), nl,
	harga(Y,X),
	format('You are charged ~w golds ~n.',[Y]),
	asserta(level_shovel(New)),
	retract(level_shovel(Now)).
item_type(X) :-
	equipment(X),
	X \= 'shovel',
	level_fishingrod(Now),
	New is Now+1,
	format('You have bought Level ~w fishing rod.',[New]), nl,
	harga(Y,X),
	format('You are charged ~w golds ~n.',[Y]),
	asserta(level_fishingrod(New)),
	retract(level_fishingrod(Now)).

shop('exitShop') :-
	write('Thanks for coming.'),!.

shop(Item) :-
	item_name(Item,Name),
	item_type(Name),nl,
	write('What do you want to buy?'),nl,
	display_market(['Carrot seed','Corn seed','Tomato seed','Chicken','Cow','Pig'],1),
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
	display_market(['Carrot seed','Corn seed','Tomato seed','Chicken','Cow','Pig'],1),
	level_shovel(Shovel_now),
	Shovel_new is Shovel_now +1,
	level_fishingrod(Fishingrod_now),
	Fishingrod_new is Fishingrod_now + 1,
	format('7. Level ~w shovel (300 golds) ~n', [Shovel_new]),
	format('8. Level ~w fishing rod (500 golds) ~n', [Fishingrod_new]),
	read(Item),
	shop(Item).





