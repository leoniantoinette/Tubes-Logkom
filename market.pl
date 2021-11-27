%TODO:
%handle user input

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
	    (	Item >= 1, Item =< 3, Money >= Totalprice  ->
			item(ItemID,ItemName,_,_,_,_,_),
	        addInventory(ItemName,Amount),
				(
					Amount > 1 ->
					plural(ItemName,FixedName),
					format('You have bought ~w ~w. ~n',[Amount, FixedName])
				;
					format('You have bought ~w ~w. ~n',[Amount, ItemName])
				),
				format('You are charged ~w golds. ~n ~n',[Totalprice]),
				retract(gold(Money)),
				Currentmoney is Money - Totalprice,
				assertz(gold(Currentmoney))
	    ;	Item >= 4, Item=<6, Money >= Totalprice ->
			item(ItemID,ItemName,_,_,_,_,_),
	        addTernakStatus(ItemName,Amount),
				(
					Amount > 1 ->
					plural(ItemName,FixedName),
					format('You have bought ~w ~w. ~n',[Amount, FixedName]),
					format('You are charged ~w golds. ~n',[Totalprice]),
	        		format('Your ~w is already on the ranch. ~n ~n ', [FixedName])
				;
					format('You have bought ~w ~w. ~n',[Amount, ItemName]),
					format('You are charged ~w golds. ~n',[Totalprice]),
	        		format('Your ~w is already on the ranch. ~n ~n ',[ItemName])
				),
				retract(gold(Money)),
				Currentmoney is Money - Totalprice,
				assertz(gold(Currentmoney))
		;
		format('You don\'t have enough money. Your money now is ~w golds ~n ~n', [Money])
        )
        ;   write('Your input is invalid! Provide input with numbers based on the numbers listed on the market! or input exitShop if you want to exit'),nl,nl
	),
	buy.
shop(Item,forsale) :-
	findall(Name, inventory(_,Name,_,_,_,_,_,_), ListName),
	(   isNameInventory(Item,ListName) ->
	    inventory(_,Item,_,_,Price,_,_,Count),
	    write('How many do you want to sell?'),nl,
		write('> '),
	    read(Amount),
	    (	Amount =< Count ->
	        reduceInventory(Item,Amount),
			(
				Amount > 1 ->
				plural(Item, FixedName),
				format('You sold ~w ~w. ~n', [Amount,FixedName])
			;
				format('You sold ~w ~w. ~n', [Amount,Item])
			),
			PriceTotal is Price*Amount,
			format('You received ~w golds.~n ~n', [PriceTotal]),
			retract(gold(Money)),
			Currentmoney is Money + PriceTotal,
			assertz(gold(Currentmoney))
	    ;	format('You don\'t have enough ~w to sell.~n ~n',[Item])
	    )
	;   write('Your input is invalid! Provide input with item names based on items listed on the market! or enter exitShop if you want to exit'),nl,nl
	),
	sell.

buy :-
	in_game(false),!,
	write('You haven\'t started the game! Try using \'start.\' to start the game.'),nl,
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
	write('* Input exitShop if you\'re done shopping'), nl,
	write('> '),
	read(Item),
	shop(Item,bought), !.
buy :-
	!,
	write('You can call buy command only if you are at market.'),nl.

makeListSell(ListName, ListCount):-
    findall(Name, inventory(_,Name,_,_,_,true,sell,_), ListName),
    findall(Count, inventory(_,_,_,_,_,true,sell,Count), ListCount).

displayListSell([], []).
displayListSell([A|W], [B|X]):-
	write('-   '),
	write(B),
	write(' '),
	(
		B > 1 ->
		plural(A, A1),
		capitalize(A1,A2),
		write(A2) 
	;
		B == 1 ->
		capitalize(A,A1),
		write(A1)
	),nl,
        displayListSell(W,X).

sell :-
	in_game(false),!,
	write('You haven\'t started the game! Try using \'start.\' to start the game.'),nl,
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
		write('* Input exitShop if you\'re done'), nl,
		write('> '),
		read(Item),
		shop(Item,forsale)
	;	write('You have nothing to sell.'),nl,nl
	).
sell :-
	!,
	write('You can call sell command only if you are at market.'),nl.

market :-
	in_game(false),
	!,
	write('You haven\'t started the game! Try using \'start.\' to start the game.'),
	fail.
market :-
	in_game(true),
	atMarketplace,!,
	write('                                   .-.,-.'),nl,
	write('                                  _|_||_|_'),nl,
	write('                                ,\'|--\'  __|'),nl,
	write('                                |,\'.---\'-.\''),nl,
	write('  ___                            |:|] .--|'),nl,
	write(' (__ ```----........_________...-|-|__\'--|-........_________.....'),nl,
	write('  \\._,```----........__________..::|--\' _|--........_________....'),nl,
	write('  :._,._,._,._,._,._,._,._,._,._,\\\\|___\'-|._,._,._,._,._,._,._,._'),nl,
	write('  |._,._,._,._,._,._,._,._,._,._,.`\'-----\'._,._,._,._,._,._,._,._'),nl,
	write('  |._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._'),nl,
	write('  |._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._'),nl,
	write('  ;._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._'),nl,
	write(' /,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._,._'),nl,
	write(' )________)________)________)________)________)________)_______)_'),nl,
	write('  |::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::.-'),nl,
	write('  :(o))---------------------------------------------:(o))--------'),nl,
	write('  |`-:  .-.   .-.  .--.  .----. .-. .-..----..---.  |`-: ((_ |||\\'),nl,
	write('  |  |  |  `.\'  | / {} \\ | {}  }| |/ / | {_ {_   _} |  | _))|||`'),nl,
	write('  |__|  | |\\ /| |/  /\\  \\| .-. \\| |\\ \\ | {__  | |   |__| ((_ |||\\'),nl,
	write('  |  |  `-\' ` `-\'`-\'  `-\'`-\' `-\'`-\' `-\'`----\' `-\'   |  | _))|||`'),nl,
	write('  |--|____________________________________________  |--|  _______'),nl,
	write('  |  |       |`-||__|--|__|--|__|--|__|--|__|--|__| |__| ||__|--|'),nl,
	write('  |  |_____  |._|.-------..-------..-------..----.| |  | |.------'),nl,
	write('  |  |.-.-.| |  ||::\'    ||::\'    ||::\'    ||:\'  || |  | ||:\''),nl,
	write('  |  || | || |  ||\'      ||\'      ||\'      ||    || |  | ||____.:'),nl,
	write('  |  ||-|-|| |  ||       ||       ||       ||    || |  | |.------'),nl,
	write('  |  || | || |  ||      .||      .||      .||    || |  | ||:\''),nl,
	write('  |__|\'-\'-\'|/:._||___..::||___..::||___..::||__.:|| |__| ||____.:'),nl,
	write('  |  |     || `-|---------------------------------.\'|  |\'.-------'),nl,
	write(' _|__|-----\'\'-..| ________________________________|_|__|_|_______'),nl,nl,
	write(' ________________________________________________________________'),nl,nl,
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
	write('You can call market command only if you are at market place.'),nl.
