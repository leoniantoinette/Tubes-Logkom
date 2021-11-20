:- dynamic(inventory/2).

harga(50, 'Carrot seed').
harga(50, 'Corn seed').
harga(50, 'Tomato seed').
harga(500, 'Cow').
harga(200, 'Chicken').
harga(1000, 'Pig').
harga(300, 'Upgrade shovel').
harga(500, 'Upgrade fishing rod').

item_name(1, 'Carrot seed').
item_name(2, 'Corn seed').
item_name(3, 'Tomato seed').
item_name(4, 'Cow').
item_name(5, 'Chicken').
item_name(6, 'Pig').
item_name(7, 'Upgrade shovel').
item_name(8, 'Upgrade fishing rod').

display_list([],9).
display_list([Head|Tail],Num) :-
	format('~w. ',[Num]),
  	write(Head),
	harga(X,Head),
	format(' (~w golds)',[X]),nl,
	New is Num+1,
  	display_list(Tail,New).	


buy :- 
	write('What do you want to buy?'),nl,
	display_list(['Carrot seed','Corn seed','Tomato seed','Chicken','Cow','Pig','Upgrade shovel','Upgrade fishing rod'],1),
	read(Item),
	item_name(Item,Name),
	write('How many do you want to buy?'),nl,
	read(Amount),
	format('You have bought ~w ~w.',[Amount,Name]), nl,
	harga(X,Name),
	Total is X*Amount ,
	format('You are charged ~w golds',[Total]).

