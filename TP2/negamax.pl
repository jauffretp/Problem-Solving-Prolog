	/*
	Ce programme met en oeuvre l'algorithme Minmax (avec convention
	negamax) et l'illustre sur le jeu du TicTacToe (morpion 3x3)
	*/
	
:- [tictactoe].
:- lib(listut). 


	/****************************************************
  	ALGORITHME MINMAX avec convention NEGAMAX : negamax/5
  	*****************************************************/

	/*
	negamax(+J, +Etat, +P, +Pmax, [?Coup, ?Val])

	SPECIFICATIONS :

	retourne pour un joueur J donne, devant jouer dans
	une situation donnee Etat, de profondeur donnee P,
	le meilleur couple [Coup, Valeur] apres une analyse
	pouvant aller jusqu'a la profondeur Pmax.

	Il y a 3 cas a decrire (donc 3 clauses pour negamax/5)
	
	1/ la profondeur maximale est atteinte : on ne peut pas
	developper cet Etat ; 
	il n'y a donc pas de coup possible a jouer (Coup = rien)
	et l'evaluation de Etat est faite par l'heuristique.

	2/ la profondeur maximale n'est pas  atteinte mais J ne
	peut pas jouer ; au TicTacToe un joueur ne peut pas jouer
	quand le tableau est complet (totalement instancie) ;
	il n'y a pas de coup a jouer (Coup = rien)
	et l'evaluation de Etat est faite par l'heuristique.

	3/ la profondeur maxi n'est pas atteinte et J peut encore
	jouer. Il faut evaluer le sous-arbre complet situe sous Etat ; 

	- on determine d'abord la liste de tous les couples
	[Coup_possible, Situation_suivante] via le predicat
	 successeurs/3 (deja fourni, voir plus bas).

	- cette liste est passee a un predicat intermediaire :
	loop_negamax/5, charge d'appliquer negamax sur chaque
	Situation_suivante ; loop_negamax/5 retourne une liste de
	couples [Coup_possible, Valeur]

	- parmi cette liste, on garde le meilleur couple, c-a-d celui
	qui a la plus petite valeur (cf. predicat meilleur/2);
	soit [C1,V1] ce couple optimal. Le predicat meilleur/2
	effectue cette selection.

	- finalement le couple retourne par negamax est [Coup, V2]
	avec : V2 is -V1 (cf. convention negamax vue en cours).

A FAIRE : ECRIRE ici les 3 clauses de negamax/5


	
.....................................
	*/


	negamax(J, Etat, Pmax, Pmax, [rien, H]):-
	heuristique(J,Etat,H).
	
	negamax(J, Etat, P, Pmax, [rien, H]):-
	ground(Etat),	
	heuristique(J,Etat,H).

	negamax(J, Etat, P, Pmax, [C1,V2]):-
	not ground(Etat),
	successeurs(J,Etat,Succ),
	loop_negamax(J,P,Pmax,Succ,Liste),
	meilleur(Liste,[C1,V1]),
	V2 is -V1.
	


	


	/*******************************************
	 DEVELOPPEMENT D'UNE SITUATION NON TERMINALE
	 successeurs/3 
	 *******************************************/

	 /*
   	 successeurs(+J,+Etat, ?Succ)

   	 retourne la liste des couples [Coup, Etat_Suivant]
 	 pour un joueur donne dans une situation donnee 
	 */

successeurs(J,Etat,Succ) :-
	findall([Coup,Etat_Suiv],
		(copy_term(Etat, Etat_Suiv), successeur(J,Etat_Suiv,Coup)),
		 Succ).

	/*************************************
         Boucle permettant d'appliquer negamax 
         a chaque situation suivante :
	 loop_negamax/5
         *************************************/

	/*
	loop_negamax(+J,+P,+Pmax,+Successeurs,?Liste_Couples)
	retourne la liste des couples [Coup, Valeur_Situation_Suivante]
	a partir de la liste des couples [Coup, Situation_Suivante]
	*/

loop_negamax(_,_, _  ,[                ],[			    ]).
loop_negamax(J,P,Pmax,[[Coup,Suiv]|Succ],[[Coup,Vsuiv]|Reste_Couples]) :-
	loop_negamax(J,P,Pmax,Succ,Reste_Couples),
	adversaire(J,A),
	Pnew is P+1,
	negamax(A,Suiv,Pnew,Pmax, [_,Vsuiv]).

	/*

A FAIRE : commenter chaque litteral de la 2eme clause de loop_negamax/5,
	en particulier la forme du terme [_,Vsuiv] dans le dernier
	litteral ?
	*/

	/*********************************
	 Selection du couple qui a la plus
	 petite valeur V 
	 *********************************/


		
/*
	SPECIFICATIONS :
	On suppose que chaque element de la liste est du type [C,V]
	- le meilleur dans une liste a un seul element est cet element
	- le meilleur dans une liste [X|L] avec L \= [], est obtenu en comparant
	  X et Y,le meilleur couple de L 
	  Entre X et Y on garde celui qui a la petite valeur de V.

A FAIRE : ECRIRE ici les clauses de meilleur/2
*/
	meilleur([X],X).


	meilleur([[Cx,Vx]|L],[Resc,Resv]):-
	L \= [],
	meilleur(L,[Cy,Vy]),
	((Vx > Vy)->
			[Resc,Resv]=[Cy,Vy]
			;
			[Resc,Resv]=[Cx,Vx]).


	/******************
  	PROGRAMME PRINCIPAL
  	*******************/

put_90([[A,B,C],[D,F,F],[G,H,I]]) :-
	 writeln('----------------------------------'),
	 write(A),  write(' '),write(B),  write('.'), write(C), nl,
	 write(D),  write(' '),write(E),  write('.'), write(F), nl,
	 write(G),  write(' '),write(H),  write('.'), write(I), nl,
 	 writeln('----------------------------------').




main :-
	situation_initiale(Ini),
	joueur_initial(J),
	adversaire(J,A),
	play_and_display(J,Ini,2,[B,V]),
	play_and_display(A,Ini,2,[B1,V1]),
	play_and_display(J,Ini,2,[B2,V2]),
	play_and_display(A,Ini,2,[B3,V3]),
	play_and_display(J,Ini,2,[B4,V4]),
	play_and_display(A,Ini,2,[B5,V5]),
	play_and_display(J,Ini,2,[B6,V6]),
	play_and_display(A,Ini,2,[B7,V7]),
	play_and_display(J,Ini,2,[B8,V8]).



	%play_and_display(A,Ini,2,[B1,V1]).
	%negamax(J, Ini, 1, Pmax, [B, V]),
	%successeur(J,Ini,B),
	%write(Ini),nl.
	%negamax(A,Ini,1,3,[B1,V1]),
	%successeur(A,Ini,B1),
	%writeln(Ini).

play_and_display(J,Situation,Pmax,[B,V]) :-
	negamax(J, Situation, 1, Pmax, [B, V]),
	successeur(J,Situation,B),
	write('Joueur : '),
	write(J), nl,
	write(Situation),nl.
	/*
A FAIRE :
	Tester ce programme pour plusieurs valeurs de la profondeur maximale.
	Pmax = 1, 2, 3, 4 ...
	Commentez les résultats obtenus.
	*/




