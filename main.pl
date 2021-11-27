:- dynamic(posisi/2). % lokasi pemain
:- dynamic(in_game/1). % status permainan
:- dynamic(in_quest/1). % menunjukkan apakah memiliki on-going quest
:- dynamic(day/1). % menunjukkan hari ke berapa
:- dynamic(time/1). % jumlah time yang telah dilewati dalam satu hari
:- dynamic(gold/1). % jumlah gold dari pemain
:- dynamic(exp_pemain/1). % jumlah exp pemain
:- dynamic(exp_farming/1). % jumlah exp farming
:- dynamic(exp_fishing/1). % jumlah exp fishing
:- dynamic(exp_ranching/1). % jumlah exp ranching
:- dynamic(fisherman/1).
:- dynamic(farmer/1).
:- dynamic(rancher/1).
:- dynamic(level_pemain/1).
:- dynamic(level_farming/1).
:- dynamic(level_fishing/1).
:- dynamic(level_ranching/1).
:- dynamic(diary/2). % format : (Day, IsiDiary)

:- include('item.pl').
:- include('map.pl').
:- include('inventory.pl').
:- include('farm.pl').
:- include('fishing.pl').
:- include('ranch.pl').
:- include('market.pl').
:- include('house.pl').
:- include('quest.pl').
:- include('time.pl').
:- include('grammar.pl').

in_game(false).

save(_) :-
	in_game(false),
	write('Unable to save because the game hasn\'t started yet!'), nl,
	write('You have to give startGame command to start the game first'), nl, !.
save(FileName) :-
	tell(FileName),
                writeStatGame,
		writeInventory,
		writeCropStat,
		writePosisi,
		writeDay,
		writeTime,
		writeGold,
		writeExpPemain,
                writeExpFarming,
                writeExpFishing,
                writeExpRanching,
                writeFisherman,
                writeFarmer,
                writeRancher,
		writeLevelPemain,
                writeLevelFarming,
                writeLevelFishing,
                writeLevelRanching,
		writeListDiary,
		writePosDigged,
		writeQuest,
	told, !.

writeStatGame:-
        in_game(Stat),
        write('in_game('),
        write(Stat), write(').'),nl.

writeInventory:-
	\+inventory(_,_,_,_,_,_,_,_),
	!.
writeInventory :-
	forall(inventory(ID, Name, Type, Role, Price, IsInventory, StatusMarket, Count),
               (
                   write('inventory('),
                   write(ID), write(', '),
                   write('\''), write(Name), write('\''), write(', '),
                   write(Type), write(', '),
                   write(Role), write(', '),
                   write(Price), write(', '),
                   write(IsInventory), write(', '),
                   write(StatusMarket), write(', '),
                   write(Count), write(').'), nl
               )
              ),
        !.
writeCropStat:-
        \+crop_stat(_,_,_,_),
        !.
writeCropStat:-
        forall(crop_stat(Plant, Absis, Ordinat, Age),
               (
                   write('inventory('),
                   write(Plant), write(', '),
                   write(Absis), write(', '),
                   write(Ordinat), write(', '),
                   write(Age), write(').'), nl
               )
              ),
        !.

writePosisi:-
        posisi(X,Y),
        write('posisi('),
        write(X), write(', '),
        write(Y), write(').'), nl.

writeDay:-
        day(A),
        write('day('),
        write(A), write(').'), nl.

writeTime:-
        time(T),
        write('time('),
        write(T), write(').'), nl.

writeGold:-
        gold(G),
        write('gold('),
        write(G), write(').'), nl.

writeExpPemain:-
        exp_pemain(XP),
        write('exp_pemain('),
        write(XP), write(').'), nl.

writeExpFarming:-
        exp_farming(XP),
        write('exp_farming('),
        write(XP), write(').'), nl.

writeExpFishing:-
        exp_fishing(XP),
        write('exp_fishing('),
        write(XP), write(').'), nl.

writeExpRanching:-
        exp_ranching(XP),
        write('exp_ranching('),
        write(XP), write(').'), nl.

writeFisherman:-
        fisherman(STAT),
        write('fisherman('),
        write(STAT), write(').'), nl.

writeFarmer:-
        farmer(STAT),
        write('farmer('),
        write(STAT), write(').'), nl.

writeRancher:-
        rancher(STAT),
        write('rancher('),
        write(STAT), write(').'), nl.

writeLevelPemain:-
        level_pemain(LVL),
        write('level_pemain('),
        write(LVL), write(').'), nl.

writeLevelFarming:-
        level_farming(LVL),
        write('level_farming('),
        write(LVL), write(').'), nl.

writeLevelFishing:-
        level_fishing(LVL),
        write('level_fishing('),
        write(LVL), write(').'), nl.

writeLevelRanching:-
        level_ranching(LVL),
        write('level_ranching('),
        write(LVL), write(').'), nl.

writeListDiary:-
        \+diary(_,_),
        !.
writeListDiary:-
        forall(diary(Day, Text),
               (
                   write('diary('),
                   write(Day), write(', '),
                   write(Text), write(').'), nl
               )
              ),
        !.

writePosDigged:-
        \+pos_digged(_,_),
        !.
writePosDigged:-
        forall(pos_digged(X, Y),
               (
                   write('pos_digged('),
                   write(X), write(', '),
                   write(Y), write(').'), nl
               )
              ),
        !.

writeQuest:-
        in_quest(Stat),
        (   Stat == true ->
            write('in_quest('),
            write(Stat), write(').'),nl,
            quest(X,Y,Z,Exp,Gold),
            forall(quest(X,Y,Z,Exp,Gold),
                   (   write('quest('),
                       write(X), write(', '),
                       write(Y), write(', '),
                       write(Z), write(', '),
                       write(Exp), write(', '),
                       write(Gold), write(').'), nl
                   )
                  )
        ;   write('in_quest('),
            write(Stat), write(').'),nl
        ).

loadFile(_) :-
        in_game(true),
	write('Unable to load because the game has started!'), nl, !.
loadFile(FileName):-
	\+file_exists(FileName),
	write('File not found!'), nl, !.
loadFile(FileName):-
	open(FileName, read, S),
        readAll(S,Lines),
        close(S),
        assertAll(Lines),
        retract(in_game(false)),
	write('WELCOME BACK!'),nl,
	map, !.

assertAll([]) :- !.
assertAll([X|L]):-
	asserta(X),
	assertAll(L), !.

readAll(S,[]) :-
    at_end_of_stream(S).
readAll(S,[X|L]) :-
    \+ at_end_of_stream(S),
    read(S,X),
    readAll(S,L).

/* startGame */
startGame :-
  in_game(true),
  !,
  write('You have started this game').
startGame :-
	!,
  write('  _                               _'), nl,
  write(' | |__   __ _ _ ____   _____  ___| |_'), nl,
  write(' | \'_ \\ / _` | \'__\\ \\ / / _ \\/ __| __|'), nl,
  write(' | | | | (_| | |   \\ V /  __/\\__ \\ |_'), nl,
  write(' |_| |_|\\__,_|_|    \\_/ \\___||___/\\__|'), nl, nl,
  write('            Harvest Star!'), nl,
  write(' Let\'s play and pay our debts together!'), nl, nl,
  write('************************************************************'), nl,
  write('*                       Harvest Star                       *'), nl,
  write('* 1. start  : untuk memulai permainan                      *'), nl,
  write('* 2. map    : menampilkan peta                             *'), nl,
  write('* 3. status : menampilkan status terkini                   *'), nl,
  write('* 4. w      : bergerak ke utara 1 langkah                  *'), nl,
  write('* 5. s      : bergerak ke selatan 1 langkah                *'), nl,
  write('* 6. d      : bergerak ke timur 1 langkah                  *'), nl,
  write('* 7. a      : bergerak ke barat 1 langkah                  *'), nl,
  write('* 8. help   : menampilkan bantuan                          *'), nl,
  write('* 9. quit   : untuk mengakhiri permainan                   *'), nl,
  write('************************************************************').

/* start */
start :-
  in_game(true),
  !,
  write('You have started this game').
start :-
  !,
  initialize,
  write('Welcome to Harvest Star. Choose your job'), nl,
  write('1. Fisherman'), nl,
  write('2. Farmer'), nl,
  write('3. Rancher'), nl,
  write('> '),
  read(Num),
  !,
  chooseJob(Num).

/* initialize */
initialize :-
  retract(in_game(false)),
  assertz(in_game(true)),
  assertz(posisi(1,1)),
  assertz(in_quest(false)),
  assertz(day(1)),
  assertz(time(0)),
  assertz(gold(1000)),
  assertz(exp_pemain(0)),
  assertz(exp_farming(0)),
  assertz(exp_fishing(0)),
  assertz(exp_ranching(0)),
  assertz(fisherman(false)),
  assertz(farmer(false)),
  assertz(rancher(false)),
  assertz(level_pemain(1)),
  assertz(level_farming(1)),
  assertz(level_fishing(1)),
  assertz(level_ranching(1)),
  addInventory('shovel',1),
  addInventory('fishing rod',1),
  init_farm.

/* chooseJob : untuk memilih job */
chooseJob(Job_num) :-
  Job_num =:= 1,
  !,
  retract(fisherman(false)),
  assertz(fisherman(true)),
  write('You choose fisherman'), nl,
  write('Let\'s start fishing!').
chooseJob(Job_num) :-
  Job_num =:= 2,
  !,
  retract(farmer(false)),
  assertz(farmer(true)),
  write('You choose farmer'), nl,
  write('Let\'s start farming!').
chooseJob(Job_num) :-
  Job_num =:= 3,
  !,
  retract(rancher(false)),
  assertz(rancher(true)),
  write('You choose rancher'), nl,
  write('Let\'s start ranching!').
chooseJob(_) :-
  !,
  write('Please input the valid number').

/* quit untuk keluar dari game */
quit :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
quit :-
  in_game(true),
  !,
  write('Are you sure you want to quit this game?'), nl,
  write('Type \'yes.\' to quit, or type \'no.\' to cancel'), nl,
  write('> '),
  read(Ans),
  ( Ans = yes
  -> halt
  ; fail ).

/* status : menampilkan status pemain */
status :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
status :-
  in_game(true),
  !,
  day(Day),
  format('Day ~w ~n',[Day]),
  displaytime,
  displayJob,
  level_pemain(Lpemain),
  format('Level: ~w ~n',[Lpemain]),
  level_farming(Lfarming),
  format('Level farming: ~w ~n',[Lfarming]),
  exp_farming(Efarming),
  format('Exp farming: ~w/150 ~n',[Efarming]),
  level_fishing(Lfishing),
  format('Level fishing: ~w ~n',[Lfishing]),
  exp_fishing(Efishing),
  format('Exp fishing: ~w/150 ~n',[Efishing]),
  level_ranching(Lranching),
  format('Level ranching: ~w ~n',[Lranching]),
  exp_ranching(Eranching),
  format('Exp ranching: ~w/150 ~n',[Eranching]),
  exp_pemain(Epemain),
  format('Exp: ~w/300 ~n',[Epemain]),
  gold(Gold),
  format('Gold: ~w ~n',[Gold]).

/* displayJob : untuk menampilkan job */
displayJob :-
  fisherman(true),
  !,
  write('Job: Fisherman'), nl.
displayJob :-
  farmer(true),
  !,
  write('Job: Farmer'), nl.
displayJob :-
  rancher(true),
  !,
  write('Job: Rancher'), nl.

/* help */
help :-
  in_game(false),
  !,
  write('You haven\'t started the game! Try using \'start.\' to start the game.'),
  fail.
help :-
  in_game(true),
  !,
  write('*****************************************************************'), nl,
  write('*                       ~ Harvest Star ~                        *'), nl,
  write('*                                                               *'), nl,
  write('* 1. status      : menampilkan status terkini                   *'), nl,
  write('* 2. map         : menampilkan peta                             *'), nl,
  write('* 3. w           : bergerak ke utara 1 langkah                  *'), nl,
  write('* 4. s           : bergerak ke selatan 1 langkah                *'), nl,
  write('* 5. d           : bergerak ke timur 1 langkah                  *'), nl,
  write('* 6. a           : bergerak ke barat 1 langkah                  *'), nl,
  write('* 7. quit        : untuk mengakhiri permainan                   *'), nl,
  write('* 8. inventory   : menampilkan inventory                        *'), nl,
  write('* 9. throwItem   : membuang item yang ada di inventory          *'), nl,
  write('* 10. quest      : mengambil quest (hanya dapat dilakukan di Q) *'), nl,
  write('* 11. my_quest   : menampilkan on-going quest                   *'), nl,
  write('*                                                               *'), nl,
  write('* Aktivitas Farming                                             *'), nl,
  write('* 1. dig         : menggali tile                                *'), nl,
  write('* 2. plant       : menanam seed                                 *'), nl,
  write('* 3. harvest     : memanen tanaman                              *'), nl,
  write('*                                                               *'), nl,
  write('* Aktivitas Fishing (hanya dapat dilakukan di sekitar danau)    *'), nl,
  write('* 1. fish        : memancing untuk mendapatkan ikan             *'), nl,
  write('*                                                               *'), nl,
  write('* Aktivitas Ranching (hanya dapat dilakukan di R)               *'), nl,
  write('* 1. ranch       : menampilkan hewan ternak yang dimiliki       *'), nl,
  write('* 2. cow         : mengambil milk                               *'), nl,
  write('* 3. chicken     : mengambil egg                                *'), nl,
  write('* 4. pig         : mengambil bacon                              *'), nl,
  write('*                                                               *'), nl,
  write('* House (hanya dapat dilakukan di H)                            *'), nl,
  write('* 1. house       : menampilkan menu house                       *'), nl,
  write('* 2. sleep       : tidur                                        *'), nl,
  write('* 3. writeDiary  : menulis diary                                *'), nl,
  write('* 4. readDiary   : membaca diary                                *'), nl,
  write('* 5. exit        : keluar dari house                            *'), nl,
  write('*                                                               *'), nl,
  write('* Marketplace (hanya dapat dilakukan di M)                      *'), nl,
  write('* 1. market      : menampilkan menu market                      *'), nl,
  write('* 2. buy         : membeli barang                               *'), nl,
  write('* 3. sell        : menjual barang                               *'), nl,
  write('*****************************************************************').

goalState :-
  day(D), gold(G),
  D =< 365, G >= 20000, 
  !, nl,
  write('                                  _         _       _   _                 _'), nl,
  write('   ___ ___  _ __   __ _ _ __ __ _| |_ _   _| | __ _| |_(_) ___  _ __  ___| |'), nl,
  write('  / __/ _ \\| \'_ \\ / _` | \'__/ _` | __| | | | |/ _` | __| |/ _ \\| \'_ \\/ __| |'), nl,
  write(' | (_| (_) | | | | (_| | | | (_| | |_| |_| | | (_| | |_| | (_) | | | \\__ \\_|'), nl,
  write('  \\___\\___/|_| |_|\\__, |_|  \\__,_|\\__|\\__,_|_|\\__,_|\\__|_|\\___/|_| |_|___(_)'), nl,
  write('                  |___/     '), nl,
  write('  You have finally collected 20000 golds!\n'),
  retract(in_game(true)),
  assertz(in_game(false)).
goalState :- !.                                              

failState :-
  day(D), gold(G),
  D > 365, G < 20000,
  !, nl,
  write('   ____                         ___ '), nl,
  write('  / ___| __ _ _ __ ___   ___   / _ \\__   _____ _ __'), nl,
  write(' | |  _ / _` | \'_ ` _ \\ / _ \\ | | | \\ \\ / / _ \\ \'__|'), nl,
  write(' | |_| | (_| | | | | | |  __/ | |_| |\\ V /  __/ |'), nl,
  write('  \\____|\\__,_|_| |_| |_|\\___|  \\___/  \\_/ \\___|_|'), nl,
  write(' You have worked hard, but in the end result is all that matters.\n'),
  write(' May God bless you in the future with kind people!\n'),
  retract(in_game(true)),
  assertz(in_game(false)).
failState :- !.

checkState :- !, goalState, failState.

/* updateLevel : untuk mengupdate level jika telah melewati batas tertentu */
updateLevel :-
  updateLevelFarming,
  updateLevelFishing,
  updateLevelRanching.

updateLevelFarming :-
  retract(exp_farming(ExpFarming)),
  retract(exp_pemain(ExpPemain)),
  retract(level_farming(LevelFarming)),
  retract(level_pemain(LevelPemain)),
  ( ExpFarming >= 150
  -> ExpFarmingNew is ExpFarming - 150,
  (LevelFarming < 5
  -> LevelFarmingNew is LevelFarming + 1
  ; LevelFarmingNew is 5)
  ; ExpFarmingNew = ExpFarming,
  LevelFarmingNew is LevelFarming ),
  assertz(exp_farming(ExpFarmingNew)),
  assertz(level_farming(LevelFarmingNew)),
  update_harvestTime,
  ( ExpPemain >= 300
  -> ExpPemainNew is ExpPemain - 300,
  LevelPemainNew is LevelPemain + 1
  ; ExpPemainNew = ExpPemain,
  LevelPemainNew = LevelPemain ),
  assertz(exp_pemain(ExpPemainNew)),
  assertz(level_pemain(LevelPemainNew)).

  updateLevelFishing :-
  retract(exp_fishing(ExpFishing)),
  retract(exp_pemain(ExpPemain)),
  retract(level_fishing(LevelFishing)),
  retract(level_pemain(LevelPemain)),
  ( ExpFishing >= 150
  -> ExpFishingNew is ExpFishing - 150,
  (LevelFishing < 5
  -> LevelFishingNew is LevelFishing + 1
  ; LevelFishingNew is 5)
  ; ExpFishingNew = ExpFishing,
  LevelFishingNew is LevelFishing ),
  assertz(exp_fishing(ExpFishingNew)),
  assertz(level_fishing(LevelFishingNew)),
  ( ExpPemain >= 300
  -> ExpPemainNew is ExpPemain - 300,
  LevelPemainNew is LevelPemain + 1
  ; ExpPemainNew = ExpPemain,
  LevelPemainNew = LevelPemain ),
  assertz(exp_pemain(ExpPemainNew)),
  assertz(level_pemain(LevelPemainNew)).

updateLevelRanching :-
  retract(exp_ranching(ExpRanching)),
  retract(exp_pemain(ExpPemain)),
  retract(level_ranching(LevelRanching)),
  retract(level_pemain(LevelPemain)),
  ( ExpRanching >= 150
  -> ExpRanchingNew is ExpRanching - 150,
  (LevelRanching < 5
  -> LevelRanchingNew is LevelRanching + 1
  ; LevelRanchingNew is 5)
  ; ExpRanchingNew = ExpRanching,
  LevelRanchingNew is LevelRanching ),
  assertz(exp_ranching(ExpRanchingNew)),
  assertz(level_ranching(LevelRanchingNew)),
  ( ExpPemain >= 300
  -> ExpPemainNew is ExpPemain - 300,
  LevelPemainNew is LevelPemain + 1
  ; ExpPemainNew = ExpPemain,
  LevelPemainNew = LevelPemain ),
  assertz(exp_pemain(ExpPemainNew)),
  assertz(level_pemain(LevelPemainNew)).
