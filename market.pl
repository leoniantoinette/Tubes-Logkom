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
	    read(Amount),
	    (	Item == 1 ->
	        addInventory('carrot seed',Amount),
                format('You have bought ~w carrot seed.',[Amount]),nl
	    ;	Item == 2 ->
	        addInventory('corn seed',Amount),
                format('You have bought ~w corn seed.',[Amount]),nl
	    ;	Item == 3 ->
	        addInventory('tomato seed',Amount),
                format('You have bought ~w tomato seed.',[Amount]),nl
	    ;	Item == 4 ->
	        addTernakStatus('cow',Amount),
                format('You have bought ~w cow.',[Amount]),nl,
	        write('Your cow is already on the ranch'),nl
	    ;	Item == 5 ->
	        addTernakStatus('chicken',Amount),
                format('You have bought ~w chicken.',[Amount]),nl,
		write('Your chicken is already on the ranch'),nl
	    ;   addTernakStatus('pig',Amount),
                format('You have bought ~w pig.',[Amount]),nl,
		write('Your pig is already on the ranch'),nl
            )
        ;   write('Your input is wrong! Provide input with numbers based on the numbers listed on the market! or input exitShop if you want to exit'),nl
	),
	buy.
shop(Item,forsale) :-
	findall(Name, inventory(_,Name,_,_,_,_,_), ListName),
	(   isNameInventory(Item,ListName) ->
	    inventory(_,Item,_,_,Price,_,_,Count),
	    write('How many do you want to sell?'),nl,
	    read(Amount),
	    (	Amount < Count ->
	        reducedInventory(Item,Count),
	        format('You sold ~w ~w.', [Amount,Item]),nl,
		PriceTotal is Price*Amount,
		format('You received ~w golds.', [PriceTotal]),nl
	    ;	format('You don\'t have enough ~w to sell.',[Item]),nl
	    )
	;   write('Your input is wrong! Provide input with item names based on items listed on the market! or enter exitShop if you want to exit'),nl
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
	write('Here are the items in your inventory'),nl,
	makeListSell(ListName, ListCount),
	displayListSell(ListName, ListCount),
	write('What do you want to sell? '),nl,
	read(Item),
        shop(Item,forsale).
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
        ;   User_input = sell ->
            sell
        ;   write('Your Input is Wrong! You are forced out of the market.')
        ).
market :-
	!,
	write('You can call market command only if you are at market place.').
