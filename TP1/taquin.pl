:- lib(listut).       % a placer en commentaire si on utilise Swi-Prolog
                      % (le predicat delete/3 est predefini)
                      
                      % Indispensable dans le cas de ECLiPSe Prolog
                      % (le predicat delete/3 fait partie de la librairie listut)
                      
%***************************
%DESCRIPTION DU JEU DU TAKIN
%***************************

   %********************
   % ETAT INITIAL DU JEU
   %********************   

/*
initial_state([ [a, b, c],
                [g, h, d],
                [vide,f,e] ]). % h=2, f*=2
 
initial_state([ [b, h, c],     % EXEMPLE
                [a, f, d],     % DU COURS
                [g,vide,e] ]). % h=5 = f* = 5actions



*/
initial_state([ [a,b,c],
		[g,vide,d],
		[h,f,e]]). % h=10 f*=10
	
/*		
initial_state([ [f, g, a],
                [h,vide,b],
                [d, c, e]  ]). % h=16, f*=20




		
initial_state([ [e, f, g],
                [d,vide,h],
                [c, b, a]  ]). % h=24, f*=30 
  
*/


   %******************
   % ETAT FINAL DU JEU
   %******************
   
final_state([[a, b,  c],
             [h,vide,d],
             [g, f,  e]]).

   %********************
   % AFFICHAGE D'UN ETAT
   %********************

write_state([]).
write_state([Line|Rest]) :-
   writeln(Line),
   write_state(Rest).
   

%**********************************************
% REGLES DE DEPLACEMENT (up, down, left, right)             
%**********************************************
   % format :   rule(+Rule_Name, ?Rule_Cost, +Current_State, ?Next_State)
   
rule(up,   1, S1, S2) :-
   vertical_permutation(_X,vide,S1,S2).

rule(down, 1, S1, S2) :-
   vertical_permutation(vide,_X,S1,S2).

rule(left, 1, S1, S2) :-
   horizontal_permutation(_X,vide,S1,S2).

rule(right,1, S1, S2) :-
   horizontal_permutation(vide,_X,S1,S2).

   %***********************
   % Deplacement horizontal            
   %***********************
   
horizontal_permutation(X,Y,S1,S2) :-
   append(Above,[Line1|Rest], S1),
   exchange(X,Y,Line1,Line2),
   append(Above,[Line2|Rest], S2).

   %***********************************************
   % Echange de 2 objets consecutifs dans une liste             
   %***********************************************
   
exchange(X,Y,[X,Y|List], [Y,X|List]).
exchange(X,Y,[Z|List1],  [Z|List2] ):-
   exchange(X,Y,List1,List2).

   %*********************
   % Deplacement vertical            
   %*********************
   
vertical_permutation(X,Y,S1,S2) :-
   append(Above, [Line1,Line2|Below], S1), % decompose S1
   delete(N,X,Line1,Rest1),    % enleve X en position N a Line1,   donne Rest1
   delete(N,Y,Line2,Rest2),    % enleve Y en position N a Line2,   donne Rest2
   delete(N,Y,Line3,Rest1),    % insere Y en position N dans Rest1 donne Line3
   delete(N,X,Line4,Rest2),    % insere X en position N dans Rest2 donne Line4
   append(Above, [Line3,Line4|Below], S2). % recompose S2 

   %***********************************************************************
   % Retrait d'une occurrence X en position N dans une liste L (resultat R) 
   %***********************************************************************
   % use case 1 :   delete(?N,?X,+L,?R)
   % use case 2 :   delete(?N,?X,?L,+R)   
   
delete(1,X,[X|L], L).
delete(N,X,[Y|L], [Y|R]) :-
   delete(N1,X,L,R),
   N is N1 + 1.

   %**********************************
   % HEURISTIQUES (PARTIE A COMPLETER)
   %**********************************
   
heuristique(U,H) :-
   heuristique1(U, H).  % choisir l'heuristique 

%   heuristique2(U, H).  % utilisee ( 1 ou 2)  
   
   %****************
   %HEURISTIQUE no 1
   %****************
   

   % Calcul du nombre de pieces mal placees dans l'etat courant U
   % par rapport a l'etat final F

    heuristique1(U, H) :-
		final_state(F),
		diff_matrice(U,F,H).
	
	diff_matrice([],[],0).

	diff_matrice([L1|R1],[L2|R2],Res):-
		diff_ligne(L1,L2,Y),
		diff_matrice(R1,R2,X),
		Res is X+Y.	


	diff_ligne([],[],0).
	
	diff_ligne([E1|R1],[E2|R2],Res):-
		diff_element(E1,E2,Y),
		diff_ligne(R1,R2,X),
		Res is X+Y.

	diff_element(E1,E2,1):-
		E1\=E2,
		E1\=vide.

	diff_element(E1,E2,0) :-
		E1=vide
		;
		E1\=vide, E1=E2.


   %****************
   %HEURISTIQUE no 2
   %****************
   
   % Somme sur l'ensemble des pieces des distances de Manhattan
   % entre la position courante de la piece et sa positon dans l'etat final


    heuristique2(U, H) :- 
		final_state(F),
		findall(Res,dist_manh(E,U,F,Res),Liste),
		sumlist(Liste,H).     %********
                                    % A FAIRE
                                    %********

	
	coord(X,Y,E,M) :-
		nth1(Y,M,Ligne),
		nth1(X,Ligne,E).
	

	dist_manh(E,M1,M2,Res) :-
		coord(X1,Y1,E,M1),E \= vide,
		coord(X2,Y2,E,M2),
		Res is (abs(X1-X2)+ abs(Y1-Y2)).


	afficher_solution(Arbre,[E,_,_,nil]):-
		write_state(E),nl.
		%writeln('fin de la recursion').


	afficher_solution(Arbre,[E,_,Action,Pere]):-
		%writeln('debut de la recursion'),
		suppress([E,_,Action,Pere],Arbre,_),
		suppress([Pere,_,ActionPere,GrPere],Arbre,_),
		afficher_solution(Arbre,[Pere,_,ActionPere,GrPere]),
		writeln(Action),
		write_state(E),nl.

	test_afficher_solution :-
		empty(Q),
		initial_state(I),
		insert([I,[1,2,3],nil,nil],Q,Qout),
		final_state(F),
		insert([F,[1,2,3],up,I],Qout,Qout2),
		writeln('APPEL A AFFICHER SOLUTION'),
		%put_90(Qout2),
		afficher_solution(Qout2,[F,[1,2,3],up,I]).
				
	successeur(I,Fin,Action,[F,H,G]):-
		rule(Action,1,I,Fin),
		heuristique(Fin,H),
		G is G + 1,
		F is H + G.

	expand([U,[_,_,G]],L):-
		Gf is G+1,			
		findall([Fin,[Ff,Hf,Gf],Action,U],(rule(Action,1,U,Fin),heuristique(Fin,Hf),Ff is Hf + Gf),L).

	loop_successeur([],  Pf,Pu,  Pf,Pu, Q).
    loop_successeur([[E,[F,H,G],Action,Pere]|Suiv],Pf,Pu,Pfoutfinal,Puoutfinal,Q):-
		%put_90(Pu),
		%put_90(Pf),
		(belongs([E,_,_,_],Q) ->
			loop_successeur(Suiv,Pf,Pu,Pfoutfinal, Puoutfinal, Q)
			;
			(suppress([E,[Fold,Hold,Gold],Actionold,Pereold],Pu,Puout) ->
				((Fold > F ; (Fold=F, Hold> H)) -> 
					
					insert([E,[F,H,G],Action,Pere],Puout,Puout2),
					%put_90(Puout2),
					suppress([[Fold,Hold,Gold],E],Pf,Pfout),
					insert([[F,H,G],E],Pfout,Pfout2),
					loop_successeur(Suiv,Pfout2,Puout2,Pfoutfinal,Puoutfinal,Q)
					;
					loop_successeur(Suiv,Pf,Pu,Pfoutfinal,Puoutfinal,Q)
					)
				;
				insert([E,[F,H,G],Action,Pere],Pu,Puout2),
				%put_90(Puout2),
				insert([[F,H,G],E],Pf,Pfout2),
				loop_successeur(Suiv,Puout2,Pfout2,Pfoutfinal,Puoutfinal,Q)
			)
		).	

						
				
					
		
	aetoile(Pf,Pu,Q):-
		suppress_min([[F0,H0,G0],I],Pf,Pfout),
		final_state(F),
		(I = F ->
			writeln('Affichage Solution'),
			suppress([I,_,Pere,Action],Pu,Puout),
			insert([I,[F0,H0,G0],Pere,Action],Q,Qout),
			%put_90(Qout),nl,
			afficher_solution(Qout,[I,[F0,H0,G0],Pere,Action])
			;
			%writeln('Nouvelle itération'),
			suppress([I,_,Pere,Action],Pu,Puout),
			insert([I,[F0,H0,G0],Pere,Action],Q,Qout),
			expand([I,[F0,H0,G0]],Liste),
			loop_successeur(Liste,Pfout,Puout,Pfout1,Puout1,Qout),
			aetoile(Pfout1,Puout1,Qout)
		).

	aetoile(empty(_),_,_) :-
	writeln('Aucune solution').
		
	main :-
		initial_state(I),
		%final_state(F),
		heuristique(I,H0),
		G0 is 0,
		F0 is G0 + H0,
		empty(Pf),
		empty(Pu),
		empty(Qs),
		insert([[F0,H0,G0],I],Pf,Pfout),
		%put_90(Pfout),
		insert([I,[F0,H0,G0],nil,nil],Pu,Puout),
		%expand([I,[F0,H0,G0]],L),
		%write_state(L),
		%put_90(Puout),
		%loop_successeur(L,Pfout,Puout,Pffinal,Pufinal,Qs).
		aetoile(Pfout,Puout,Qs).
		%put_90(Puout)
	%	aetoile(Pfout,Puout,Qs).



	/*

	Tableau de resultats :

			2 5     10   	 20		   30  
		h1 	0 0.01  0.01s	 0.04s	  No (0.04s cpu)	
		h2	0 0		0.01s    0.02s     0.19s


	*/
 
