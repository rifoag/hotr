/* Tugas Besar LOGIF */
/* Tim FIGOL */
/* 13516057 - Dafi Ihsandiya Faraz */
/* 13516111 - Rifo Ahmad Genadi */
/* 13516120 - Nuha Adinata */
/* 13516144 - Dias Akbar Nugraha */

/* Pengaturan predikat dinamik */
:- dynamic(at/3).
:- dynamic(position/2).
:- dynamic(health/1).
:- dynamic(hunger/1).
:- dynamic(thirst/1).
:- dynamic(used_weapon/1).
:- dynamic(weapon/2).
:- dynamic(inventory/1).
:- dynamic(enemy/3).
:- dynamic(enemy_num/1).
:- dynamic(medicine/1).
:- dynamic(food/1).
:- dynamic(drink/1).


init :- 
	/*Fakta terkait pemain */
	/* Pengaturan awal pemain */
	asserta(position(5,10)),
	asserta(health(100)),
	asserta(hunger(50)),
	asserta(thirst(70)),
	asserta(used_weapon(none)),
	asserta(inventory([])), /* list dengan dummy element '.' */		
	asserta(inventory_cap(5)), /* kapasitas maksimal inventory */
	/*Fakta-fakta terkait peta*/
	/* Deskripsi peta : */
	/* - Peta direpresentasikan oleh petak-petak dengan koordinat (x,y), yaitu dua buah bilangan bulat. */
	/* - Ukuran peta adalah 10 x 20. */
	/* - Petak yang terletak di ujung kiri atas peta memiliki koordinat (1,1). */
	/* Fakta terkait objek pada permainan */
	/* Objek-objek yang ada dan jenisnya */
	asserta(weapon(knife, 5)), /* knife memiliki attack power sebesar 5 */
	asserta(weapon(sword, 8)),
	asserta(weapon(spear, 11)),
	asserta(weapon(durandal, 14)),
	asserta(weapon(excalibur, 20)),
	asserta(weapon(none, 0)), /* Sad */
	asserta(food(sirloin)),
	asserta(food(tenderloin)),
	asserta(drink(mineralWater)),
	asserta(medicine(antidote)),
	/* Lokasi objek di peta */
	asserta(at(1, 1, sirloin)),
	asserta(at(1, 1, mineralWater)),
	asserta(at(1, 5, durandal)), /* weapon */
	asserta(at(1, 5, mineralWater)), 
	asserta(at(1, 8, mineralWater)),
	asserta(at(1, 9, tenderloin)),
	asserta(at(1, 15, sirloin)),
	asserta(at(1, 18, holyWater)), /* medicine + drink */
	asserta(at(2, 6, tenderloin)),
	asserta(at(2, 13, mineralWater)),
	asserta(at(3, 12, sword)), /* weapon */
	asserta(at(4, 7, spear)), /* weapon */
	asserta(at(4, 13, mineralWater)),
	asserta(at(4, 19, sirloin)),
	asserta(at(5, 4, mineralWater)),
	asserta(at(10, 20, excalibur)), /* weapon */
	asserta(at(6, 2, antidote)),
	asserta(at(6, 9, knife)), /* weapon */
	asserta(at(6, 16, antidote)),
	asserta(at(7, 11, mineralWater)),
	asserta(at(7, 8, antidote)),
	asserta(at(8, 17, sirloin)),
	asserta(at(8, 18, antidote)),
	asserta(at(9, 2, holyWater)), /* medicine + drink */
	asserta(at(10, 2, tenderloin)),
	asserta(at(10, 18, tenderloin)),
	asserta(at(10, 10, radar)), /* objek spesial */
	asserta(at(10, 1, mineralWater)),
	asserta(at(10, 12, mineralWater)),
	asserta(at(10, 7, holyWater)), /* medicine + drink */
	/* Fakta terkait musuh */
	/* Daftar musuh */
	asserta(enemy_num(10)), /* jumlah musuh */
	/* format : enemy(Name, Health, Power). */
	asserta(enemy(gawain, 60, 7)),
	asserta(enemy(kay, 40, 5)),
	asserta(enemy(tristan, 35, 12)),
	asserta(enemy(lancelot, 50, 12)),
	asserta(enemy(galahad, 70, 3)),
	asserta(enemy(bedivere, 40, 9)),
	asserta(enemy(mordred, 45, 10)),
	asserta(enemy(palamedes, 50, 4)),
	asserta(enemy(agravain, 35, 6)),
	asserta(enemy(gareth ,55, 4)).

/*Aturan penalaran*/
/* start - Memulai permainan. */
start :-
	retractall(at(_,_,_)), retractall(position(_)), 
	retractall(health(_)), retractall(thirst(_)), retractall(hunger(_)),
	retractall(used_weapon(_)), retractall(weapon(_,_)),
	retractall(inventory(_)), retractall(enemy(_,_,_)),
	retractall(enemy_num(_)),
	asserta(at(0,_, fence)),
	asserta(at(11,_, fence)),
	asserta(at(_,0, fence)),
	asserta(at(_,21, fence)),
	print('Welcome to the Hunger Games of the Round Table!'), nl,
	print('O Arthur Pendragon, show them that you are worthy to be the King of Knights!'), nl,
	help,
	print('Happy hunger games! and may the odds be in your favor.'), nl,
	init,
	setenemy.

/* help - Menampilkan command yang tersedia serta legenda peta. */
help :-
	nl, print('Available commands : '), nl,
	print('start. -- start the game'), nl,
	print('help. -- show available commands'), nl,
	print('quit. -- quit the game'), nl,
	print('look. -- look around you'), nl,
	print('n. s. e. w. -- move'), nl,
	print('map. -- look at the map and detect enemies (need radar to use)'), nl,
	print('take(Object). -- pick up an object'), nl,
	print('drop(Object). -- drop an object'), nl,
	print('use(Object). -- use an object'), nl,
	print('combine(Object1, Object2) -- combining two object to create an even more powerful object'), nl,
	print('enhance(W,O) -- enhance weapon W by sacrificing object O'), nl,
	print('attack. -- attack enemy that crosses your path'), nl,
	print('status. -- show your status'), nl,
	print('save(Filename). -- save your game'), nl,
	print('loadGame(Filename). -- load previously saved game'), nl,
	nl,
	print('Legends : '), nl,
	print('M : Medicine'), nl,
	print('F : Food'), nl,
	print('W : Water'), nl,
	print('P : Player'), nl,
	print('E : Enemy'), nl,
	print('X : Weapon'), nl,
	print('- : Accessible'), nl,
	print('# : Inaccessible'), nl.	

/* quit -  Mengakhiri permainan */
quit :- 
	print('You have left the battlefield.'), nl, 
	retractall(at(_,_,_)), retractall(position(_)), 
	retractall(health(_)), retractall(thirst(_)), retractall(hunger(_)),
	retractall(used_weapon(_)), retractall(weapon(_,_)),
	retractall(inventory(_)), retractall(enemy(_,_,_)),
	retractall(enemy_num(_)).

/* Pilihan user sebelum quit. */

/* look - Melihat keadaan di sekitar player. */
look :- check_enemy, fail.
look :- check_medicine, fail.
look :- check_food, fail.
look :- check_drink, fail.
look :- check_holyWater, fail.
look :- check_weapon, fail.
look :- check_radar, fail.
look :- print_threexthree, !, !.
/* aturan-aturan bantuan untuk command look */
check_enemy :- position(X,Y), at(X,Y, Object), enemy(Object,_,_), print('You see an enemy('),print(Object), print(') in front of you.'), nl, fail.
check_enemy :- !.
check_medicine :- position(X,Y), at(X,Y,Object), medicine(Object), print('You see an antidote in the ground.'), nl, !.
check_food :- position(X,Y), at(X,Y,Object), food(Object), print('You see a food in the ground. Is it a sirloin or a tenderloin?'), nl, !.
check_drink :- position(X,Y), at(X,Y,Object), drink(Object), print('You see a '), print(Object),  print(' in the ground.'), nl, !.
check_holyWater :- position(X,Y), at(X,Y,holyWater), print('You see a holyWater in the ground.'), nl, !.
check_weapon :- position(X,Y), at(X,Y,Object), weapon(Object,_), wut_weapon(Object), !.
check_radar :- position(A,B), at(A,B,radar), print('You see a radar!'), nl.
wut_weapon(Object) :- Object = excalibur, print('You see the legendary holy sword, excalibur!'), nl, !.
wut_weapon(Object) :- Object = spear, print('You see a spear lying on the ground'), nl, !.
wut_weapon(Object) :- Object = knife, print('You see a knife lying on the ground'), nl, !.
wut_weapon(Object) :- Object = sword, print('You see a sword lying on the ground'), nl, !.
wut_weapon(Object) :- Object = durandal, print('You see the peerless sword, durandal!'), nl, !.
print_threexthree :- position(X,Y),
	Xmin is X-1, Xplus is X+1, Ymin is Y-1, Yplus is Y+1,
	print_petak(Xmin, Ymin), print_petak(Xmin, Y), print_petak(Xmin, Yplus), nl,
	print_petak(X, Ymin), print('P'), print_petak(X, Yplus), nl,
	print_petak(Xplus, Ymin), print_petak(Xplus, Y), print_petak(Xplus, Yplus),!.
print_petak(A,B) :- at(A,B, fence), print('#'), !.
print_petak(A,B) :- at(A,B, radar), print('R'), !.
print_petak(A,B) :- at(A,B, Objek), enemy(Objek,_,_), print('E'), !.
print_petak(A,B) :- at(A,B, Objek), medicine(Objek), print('M'), !.
print_petak(A,B) :- at(A,B, Objek), food(Objek), print('F'), !.
print_petak(A,B) :- at(A,B, Objek), drink(Objek), print('W'), !.
print_petak(A,B) :- at(A,B, Objek), weapon(Objek,_), print('X'), !.
print_petak(A,B) :- print('-'), !.

/* n,s,e,w - Mekanisme gerakan pemain */
w :- position(X,Y), F is Y - 1, \+ at(X,F,fence), retract(position(_,_)), sengsara, !, asserta(position(X,F)), print('You moved to the west.'), nl, !, movenemy, !.
w :- print('You cannot move there, the path is blocked'), nl, !.

e :- position(X,Y), F is Y + 1, \+ at(X,F,fence), retract(position(_,_)), sengsara, !, asserta(position(X,F)), print('You moved to the east.'), nl, !, movenemy, !.
e :- print('You cannot move there, the path is blocked'), nl, !.

n :- position(X,Y), F is X - 1, \+ at(F,Y,fence), retract(position(_,_)), sengsara, !, asserta(position(F,Y)), print('You moved to the north.'), nl, !, movenemy, !.
n :- print('You cannot move there, the path is blocked'), nl, !.

s :- position(X,Y), F is X + 1, \+ at(F,Y,fence), retract(position(_,_)), sengsara, !, asserta(position(F,Y)), print('You moved to the south.'), nl, !, movenemy, !.
s :- print('You cannot move there, the path is blocked'), nl, !.
			
sengsara :- hunger(H), thirst(T), H1 is H - 1, T1 is T - 3, 
	retract(hunger(_)), retract(thirst(_)),
	asserta(hunger(H1)), asserta(thirst(T1)), die, !.		
/* map - Menampilkan peta */
map :- in_inventory(radar), printMap(0,0), !.
map :- print('You dont have a radar!').
/* Kasus khusus */
printMap(11,21) :- print('#'), !.
printMap(X,21) :- print('#'), nl, !, F is X+1, printMap(F, 0).
/* Kasus umum */
printMap(X,Y) :- position(X,Y), print('P'), !, F is Y+1, printMap(X,F).
printMap(X,Y) :- at(X,Y, fence), print('#'), !, F is Y+1, printMap(X,F).
printMap(X,Y) :- at(X,Y, Objek), enemy(Objek,_,_), print('E'), !, F is Y+1, printMap(X,F).
printMap(X,Y) :- print('-'), F is Y + 1, printMap(X,F).

/* Pengelolaan inventory */
/* in_inventory digunakan untuk memeriksa apakah objek X berada di inventory */
in_inventory(X) :- 
	inventory(L),
	member(X,L), !.

/* take - mengambil objek yang ada di petak */
take(Object) :- position(X,Y), at(X,Y, Object), enemy(Object,_,_), print('You cannot take that!'), !.
take(Object) :- position(X,Y), at(X,Y, Object), !, put_in_inventory(X,Y,Object).
take(Object) :- print('There are no such item!'), nl, !.
put_in_inventory(X,Y,Object) :- inventory(L), length(L,Z), Z < 5, 
	retract(inventory(_)),
	retract(at(X,Y,Object)),
	print('You put '), print(Object), print(' to your inventory.'), nl,
	asserta(inventory([Object|L])), movenemy, !.

put_in_inventory(X,Y,Object) :- inventory(L), length(L,Z), Z = 5, print('Your inventory has reached its maximum capacity!'), nl, !.

/* drop - meletakkan objek yang ada di inventory ke petak yang sedang ditempati */
drop(Object) :- 
	position(X,Y), in_inventory(Object), 
	inventory(L1),
	select(Object, L1, L2),
	asserta(at(X,Y, Object)),
	retractall(inventory(_)),
	asserta(inventory(L2)), 
	print('You dropped '), print(Object), movenemy, !.

/* use - menggunakan objek yang ada di inventory */

use(X) :- 
	in_inventory(X),
	medicine(X),
	inventory(L1),
	select(X, L1, L2),
	retractall(inventory(_)),
	asserta(inventory(L2)), 
	health(H), H1 is H + 15,
	retract(health(_)), asserta(health(H1)), !.

use(sirloin) :- 
	in_inventory(sirloin),
	inventory(L1),
	select(sirloin, L1, L2),
	retractall(inventory(_)),
	asserta(inventory(L2)), 
	hunger(H), H1 is H + 4,
	retract(hunger(_)), asserta(hunger(H1)), !.

use(tenderloin) :- 
	in_inventory(tenderloin),
	inventory(L1),
	select(tenderloin, L1, L2),
	retractall(inventory(_)),
	asserta(inventory(L2)), 
	hunger(H), H1 is H + 6,
	retract(hunger(_)), asserta(hunger(H1)), !.

use(superSteak) :- 
	in_inventory(superSteak),
	inventory(L1),
	select(superSteak, L1, L2),
	retractall(inventory(_)),
	asserta(inventory(L2)), 
	hunger(H), H1 is H + 15,
	retract(hunger(_)), asserta(hunger(H1)), !.

use(X) :- 
	in_inventory(X),
	drink(X),
	inventory(L1),
	select(X, L1, L2),
	retractall(inventory(_)),
	asserta(inventory(L2)), 
	thirst(H), H1 is H + 15,
	retract(thirst(_)), asserta(thirst(H1)), !.

use(holyWater) :- 
	in_inventory(holyWater),
	inventory(L1),
	select(holyWater, L1, L2),
	retractall(inventory(_)),
	asserta(inventory(L2)), 
	health(H), H1 is H + 25,
	retract(health(_)), asserta(health(H1)),
	thirst(J), J1 is J + 25,
	retract(thirst(_)), asserta(thirst(J1)), !.

use(X) :- 
	used_weapon(none),
	weapon(X,_),
	inventory(L1),
	select(X, L1, L2),
	retractall(inventory(_)),
	retract(used_weapon(_)), asserta(used_weapon(X)),
	asserta(inventory(L2)), !.

use(X) :- 
	in_inventory(X),
	weapon(X,_),
	inventory(L1),
	select(X, L1, L2),
	retractall(inventory(_)),
	used_weapon(W), retract(used_weapon(_)), asserta(used_weapon(X)),
	asserta(inventory([W|L2])), !.

/* attack - menyerang musuh yang berada di petak yang sama */
attack:- position(X,Y), at(X,Y, Name), enemy(Name,H,P), 
	used_weapon(none), weapon(W,A),
	print('You cannot attack, you dont have a weapon'),!.

attack:- position(X,Y), at(X,Y, Name), enemy(Name,H,P), 
	used_weapon(W), weapon(W,A),
	H1 is H - A, retract(enemy(Name,H,P)),
	print(Name), print(' HP dropped to '), check_health(H1), nl,
	asserta(enemy(Name,H1,P)), checkdeath(Name),
	H1 > 0, retaliate(P), fail.

attack :- !.

check_health(A) :- A < 1, print('0'), !.
check_health(A) :- print(A), !.

/* status - menampilkan keadaan player saat ini */
status :- 
	health(H), print('Health: '), print(H), nl,
	hunger(Hg), print('Hunger: '), print(Hg), nl,
	thirst(T), print('Thirst: '), print(T), nl,
	used_weapon(W), print('Weapon: '), print(W), nl,
	weapon(W,P), print('Weapon power : '), print(P), nl,
	inventory(L), print('Inventory : '), print(L), nl, 
	enemy_num(E), print('Enemy left : '), print(E), nl,
	fail.


/* save - menyimpan data permainan saat ini ke file eksternal */
save(Filename) :- 
	telling(Old), tell(Filename), 
	listing(at/3), listing(position/2),
	listing(health/1), listing(hunger/1),
	listing(thirst/1), listing(used_weapon/1), listing(weapon/2),
	listing(inventory/1), listing(enemy/3), listing(enemy_num/1),
	told, tell(Old).

/* loadGame - memuat data permainan yang tersimpan di file eksternal (tba) */
loadGame(Filename) :-
	quit,
	asserta(at(0,_, fence)),
	asserta(at(11,_, fence)),
	asserta(at(_,0, fence)),
	asserta(at(_,21, fence)),
	seeing(Old),
	see(Filename),
	repeat,
	read(Data),
	process(Data),
	seen,
	print('Your previous game session : ('), print(Filename), print(') succesfully loaded!'),
	see(Old),
	!.

process(end_of_file) :- !.
process(Data) :- asserta(Data), fail.

/* Aturan terkait musuh */
/* Menetapkan lokasi awal musuh di peta*/
setenemy:- 
	random(1,10,X), random(1,20,Y), asserta(at(X,Y, gawain)),
	random(1,10,X1), random(1,20,Y1), asserta(at(X1,Y1, kay)),
	random(1,10,X2), random(1,20,Y2), asserta(at(X2,Y2, tristan)),
	random(1,10,X3), random(1,20,Y3), asserta(at(X3,Y3, lancelot)),
	random(1,10,X4), random(1,20,Y4), asserta(at(X4,Y4, galahad)),
	random(1,10,X5), random(1,20,Y5), asserta(at(X5,Y5, bedivere)),
	random(1,10,X6), random(1,20,Y6), asserta(at(X6,Y6, mordred)),
	random(1,10,X7), random(1,20,Y7), asserta(at(X7,Y7, palamedes)),
	random(1,10,X8), random(1,20,Y8), asserta(at(X8,Y8, agravain)),
	random(1,10,X9), random(1,20,Y9), asserta(at(X9,Y9, gareth)).

/* Musuh menyerang balik */
retaliate(P) :- 
	health(X), X1 is X - P,
	retractall(health(_)),
	print('Your HP dropped to '), print(X1), nl,
	asserta(health(X1)), die, !.
	
/* Pergerakan musuh */
movenemy :- move_enemy(gawain), move_enemy(kay), move_enemy(tristan), move_enemy(lancelot), move_enemy(galahad), move_enemy(bedivere), move_enemy(mordred), move_enemy(palamedes), move_enemy(agravain), move_enemy(gareth), !.
move_enemy(Name) :- at(A,B, Name), random(-1,1,X), C is A + X, C > 0, C < 11, retract(at(_,_,Name)), asserta(at(C,B, Name)), \+ C = A, !. 
move_enemy(Name) :- at(A,B, Name), random(-1,1,Y), C is B + Y, C > 0, C < 21, retract(at(_,_,Name)), asserta(at(A,C, Name)), !. 

/* Mekanisme kematian musuh */
checkdeath(X) :- enemy(X, A, _), A < 1, retract(enemy(X,_,_)),
	print(X), print(' is dead.'), nl,
	retract(at(_,_,X)), enemy_num(B), retract(enemy_num(_)), B1 is B - 1, asserta(enemy_num(B1)), checkvictory, !. 
checkdeath(A) :- !.

/* Kondisi menang */
checkvictory :- enemy_num(0), print('Congratulations, you win the game, you truly are the King of Knights!'), nl, quit, !.

/* Kondisi kalah */
die :- health(A), A < 1,
	print('Your health dropped to zero, you are dead.'), nl,
	quit, fail, !.

die :- thirst(A), A < 1,
	print('You are dehydrated, you are dead.'), nl,
	quit, fail, !.

die :- hunger(A), A < 1,
	print('You are starving to death, you lose the game.'), nl,
	quit, fail, !.

die :- !.

/* Command Tambahan */
/* combine -- menggabungkan dua buah object */
combine(sirloin, tenderloin) :- 
	in_inventory(sirloin), in_inventory(tenderloin),
	inventory(L), 
	select(sirloin, L, L1), select(tenderloin, L1, L2),
	retractall(inventory(_)),
	asserta(inventory([superSteak|L2])), print('You got superSteak!'), !.

combine(spear, sword) :- 
	in_inventory(O1), in_inventory(O2),
	inventory(L), 
	select(spear, L, L1), select(sword, L1, L2),
	retractall(inventory(_)),
	asserta(inventory([durandal|L2])), print('You got durandal!'), !.

combine(O1, O2) :-
	print('You cannot combine those items!'), nl,
	print('PS : those two items must be in your inventory.'), nl.

/* enhance(W, O) -- mengasah senjata W dengan mengorbankan Object O */
enhance(W,O) :-
	in_inventory(W), in_inventory(O),
	weapon(W, P), P1 is P + 2,
	retract(weapon(W,_)),
	inventory(L), select(O, L, L1), retractall(inventory(_)), asserta(inventory(L1)),
	asserta(weapon(W, P1)), print('Your weapon enhanced succesfully!'), nl,
	print('Its power has been increased!'), nl, !.


enhance(W,O) :- 
	print('enhance(W,O) fail!'), nl,
	print('W must be a weapon in your inventory and O can be any object that is also in your inventory'), nl.