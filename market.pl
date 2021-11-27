%TODO:
%handle_max_level_equipment
%handle_input_amount_bukan_integer
%handle_inventory_penuh
%pake_gold
%masukin_time

checkLevelEquipment(Name):-
	inventory(_,Name,_,_,_,_,_,Level),
	(   Level >= 3 ->
	    write('You can`t level up your equipment anymore because it`s already reached its maximum!')
	;   addInventory(Name,1),
	    write('Yeay, your shovel equipment level has increased~'),nl
	).

shop('exitShop',_) :-
	write('Thanks for coming.'),!.

shop(Item,bought) :-
	(   (Item == 7 ; Item == 8) ->
	    (	Item == 7 ->
		checkLevelEquipment('shovel')
	    ;   checkLevelEquipment('fishing rod')
	    )
	;   (Item == 1 ; Item == 2 ; Item == 3 ; Item == 4 ; Item == 5 ; Item == 6) ->
            write('How many do you want to buy?'),nl,
			write('> '),
	    read(Amount),
		ItemID is Item + 11,
		item(ItemID,_,_,_,Price,_,_),
		Totalprice is Price*Amount,
		gold(Money),
	    (	Item == 1, Money >= Totalprice  ->
	        addInventory('carrot seed',Amount),
                format('You have bought ~w carrot seed. ~n',[Amount]),
				format('You are charged ~w golds. ~n ~n',[Totalprice]),
				retract(gold(Money)),
				Currentmoney is Money - Totalprice,
				assertz(gold(Currentmoney))
	    ;	Item == 2, Money >= Totalprice->
	        addInventory('corn seed',Amount),
                format('You have bought ~w corn seed.~n',[Amount]),
				format('You are charged ~w golds. ~n ~n',[Totalprice]),
				retract(gold(Money)),
				Currentmoney is Money - Totalprice,
				assertz(gold(Currentmoney))
	    ;	Item == 3, Money >= Totalprice ->
	        addInventory('tomato seed',Amount),
                format('You have bought ~w tomato seed.~n',[Amount]),
				format('You are charged ~w golds.~n ~n',[Totalprice]),
				retract(gold(Money)),
				Currentmoney is Money - Totalprice,
				assertz(gold(Currentmoney))
	    ;	Item == 4, Money >= Totalprice ->
	        addTernakStatus('cow',Amount),
                format('You have bought ~w cow. ~n ',[Amount]),
				format('You are charged ~w golds. ~n',[Totalprice]),
	        	write('Your cow is already on the ranch '),nl,nl,
				retract(gold(Money)),
				Currentmoney is Money - Totalprice,
				assertz(gold(Currentmoney))
	    ;	Item == 5, Money >= Totalprice ->
	        addTernakStatus('chicken',Amount),
                format('You have bought ~w chicken. ~n',[Amount]),
				format('You are charged ~w golds. ~n',[Totalprice]),
				write('Your chicken is already on the ranch'),nl,nl,
				retract(gold(Money)),
				Currentmoney is Money - Totalprice,
				assertz(gold(Currentmoney))
	    ;   Item == 6, Money >= Totalprice ->
			addTernakStatus('pig',Amount),
                format('You have bought ~w pig ~n.',[Amount]),
				format('You are charged ~w golds. ~n',[Totalprice]),
				write('Your pig is already on the ranch'),nl,nl,
				retract(gold(Money)),
				Currentmoney is Money - Totalprice,
				assertz(gold(Currentmoney))
		;
		format('You don\'t have enough money. Your money now is ~w golds ~n ~n', [Money])
        )
        ;   write('Your input is invalid! Provide input with numbers based on the numbers listed on the market! or input exitShop if you want to exit ~n'),nl
	),
	buy.
shop(Item,forsale) :-
	findall(Name, inventory(_,Name,_,_,_,_,_,_), ListName),
	(   isNameInventory(Item,ListName) ->
	    inventory(_,Item,_,_,Price,_,_,Count),
	    write('How many do you want to sell?'),nl,
		write('> '),
	    read(Amount),
	    (	Amount < Count ->
	        reduceInventory(Item,Amount),
	        format('You sold ~w ~w. ~n', [Amount,Item]),
			PriceTotal is Price*Amount,
			format('You received ~w golds.~n', [PriceTotal]),
			retract(gold(Money)),
			Currentmoney is Money + PriceTotal,
			assertz(gold(Currentmoney))
	    ;	format('You don\'t have enough ~w to sell.~n',[Item])
	    )
	;   write('Your input is invalid! Provide input with item names based on items listed on the market! or enter exitShop if you want to exit'),nl
	),
	sell.

buy :-
	in_game(false),!,
	write('You haven\'t started the game! Try using \'start.\' to start the game.'),
	fail.
buy :-
	in_game(true),
	atMarketplace,!,
	write('What do you want to buy?'),nl,
	write('1. Carrot seed (50 golds)'),nl,
	write('2. Corn seed (50 golds)'),nl,
	write('3. Tomato seed (50 golds)'),nl,
	write('4. Cow (500 golds)'),nl,
	write('5. Chicken (200 golds)'),nl,
	write('6. Pig (1000 golds)'),nl,
	write('7. Increase your shovel level (300 golds/level)'),nl,
	write('8. Increase your fishing rod level (500 golds/level)'),nl,
	write('> '),
	read(Item),
	shop(Item,bought).
buy :-
	!,
	write('You can call buy command only if you are at market.').

makeListSell(ListName, ListCount):-
    findall(Name, inventory(_,Name,_,_,_,true,sell,_), ListName),
    findall(Count, inventory(_,_,_,_,_,true,sell,Count), ListCount).

displayListSell([], []).
displayListSell([A|W], [B|X]):-
	write('-   '), write(B), write(' '), write(A), nl,
        displayListSell(W,X).

sell :-
	in_game(false),!,
	write('You haven\'t started the game! Try using \'start.\' to start the game.'),
	fail.
sell :-
	in_game(true),
	atMarketplace,!,
	totalSellableItem(Total),
	(	Total > 0 ->
		write('Here are the items in your inventory'),nl,
		makeListSell(ListName, ListCount),
		displayListSell(ListName, ListCount),
		write('What do you want to sell? '),nl,
		write('> '),
		read(Item),
		shop(Item,forsale)
	;	write('You have nothing to sell.'),nl
	).
sell :-
	!,
	write('You can call sell command only if you are at market.').

market :-
	in_game(false),
	!,
	write('You haven\'t started the game! Try using \'start.\' to start the game.'),
	fail.
market :-
	in_game(true),
	atMarketplace,!,
	write('What do you want to do?'),nl,
	write('1. buy'),nl,
	write('2. sell'),nl,
	write('> '),
        read(User_input),
	(   User_input =  buy ->
            buy
        ;   
			User_input = sell ->
            sell
        ;   
			User_input = 1 ->
			buy
		;
			User_input = 2 ->
			sell
		;
			write('Your Input is invalid!'),nl,
            write('If you want to buy, input buy or 1.'),nl,
            write('If you want to sell, input sell or 2.'),nl,nl,
            market
        ).
market :-
	!,
	write('You can call market command only if you are at market place.').
