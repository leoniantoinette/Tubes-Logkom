
displaytime:-
    time(Time),
    H is Time//4,
    Hour is H + 7,
    (   Hour > 24 -> Hours is Hour - 24
    ;
        Hour > 12 -> Hours is Hour - 12
    ;
        Hours is Hour),
    Minute is mod(Time,4),
    Minutes is Minute*15,
    (   Hours < 10, Minutes =:= 0 ->
        format('Time: 0~w:0~w ', [Hours, Minutes])
    ;
        Hours < 10, Minutes > 0 -> 
        format('Time: 0~w:~w ', [Hours, Minutes])
    ;
        Hours >= 10, Minutes =:= 0 ->
        format('Time: ~w:0~w ', [Hours, Minutes])
    ;
        Hours >= 10, Minutes >0 ->
        format('Time: ~w:~w ', [Hours, Minutes]) 
    ),
    (
        Time >= 20, Time <68 -> 
        write('PM'),nl
    ;
        write('AM'),nl
    ).
    