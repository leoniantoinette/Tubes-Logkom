%TODO: 
%trowitem
:- dynamic(inventory/2).
:- dynamic(inventory_capacity/1).
% :- dynamic(level_fishingrod/1).
% :- dynamic(level_shovel/1).

inventory('carrot seed', 0).
inventory('corn seed', 0).
inventory('tomato seed', 0).
inventory('carrot', 0).
inventory('corn', 0).
inventory('tomato', 0).
inventory('tuna', 0).
inventory('salmon', 0).
inventory('trout', 0).
inventory('egg', 0).
inventory('milk', 0).
inventory('bacon', 0).
% level_fishingrod(1).
% level_shovel(1).
inventory_capacity(2).

display_inventory([]).
display_inventory([Head|Tail]) :- 
	inventory(Head,0),
	display_inventory(Tail).
display_inventory([Head|Tail]) :-
	\+ inventory(Head,0),
	inventory(Head,Amount),
	format('~w ~w ~n',[Amount, Head]),
	display_inventory(Tail).

update_inventory(Name, Amount) :-
	inventory_capacity(Cap),
	Inventory_cap_now is Cap + Amount,
	asserta(inventory_capacity(Inventory_cap_now)),
	retract(inventory_capacity(Cap)),
	inventory(Name, Now),
	New is Now + Amount,
	asserta(inventory(Name,New)),
	retract(inventory(Name,Now)).

inventory :-
	inventory_capacity(Cap),
	format('Your inventory (~w/100)',[Cap]),nl,
	level_fishingrod(Fishingrod_level),
	level_shovel(Shovel_level),
	format('1 Level ~w shovel ~n',[Shovel_level]),
	format('1 Level ~w fishing rod ~n',[Fishingrod_level]),
	display_inventory(['carrot seed','corn seed','tomato seed','carrot','corn','tomato','tuna','salmon','trout']).