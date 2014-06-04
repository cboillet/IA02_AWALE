/* Base de Données */

%include('Donnees.pl').
jeu([4,4,4,4,4,4,4,4,4,4,4,4]).
liste_test([1,2,3,4,5,6,7,8,9,10,11,12]).

nb_jetons(joueur1,0).
nb_jetons(joueur2,0).

tour(joueur1).


/* Predicat de manipulation */

%Affichage de la liste du jeu
	%Predicat diviser(L,L1,L2,C) : divise la liste L en deux sous-listes L1 et L2
	diviser([],[],[],_) :- !.
	diviser([T|Q],[T|L1],L2,C) :- C<7, !, C2 is C+1, diviser(Q,L1,L2,C2).
	diviser([T|Q],L1,[T|L2],C) :- C2 is C+1, diviser(Q,L1,L2,C2).

	%Predicat afficher(L) : affiche une liste L dans l'ordre
	affiche1([]) :- write('|').
	affiche1([T|Q]) :- write('|'), write(T), affiche1(Q).

	%Predicat afficher2(L) : affiche une liste L dans l'ordre inverse
	affiche2([]) :- write('|').
	affiche2([T|Q]) :- affiche2(Q), write(T), write('|').

	%Predicat afficher(L) : affiche la liste L du jeu
	afficher(L) :- diviser(L,L1,L2,1), affiche2(L2), nl, affiche1(L1).
	
	
%Prédicat jouer(J,C,L) : le joueur J joue la case C
jouer(J,C,L,LA) :- case_du_camp(J,C), nb_graines(C,L,G), C1 is C+1, set_nb_graines(C,L,0,L2), distribuer(G,C1,L2,LA,_).

%Prédicat case_du_camp(J,C) : teste si le joueur peut jouer la case C
case_du_camp(joueur1,C) :- C =< 6, C >= 1.
case_du_camp(joueur2,C) :- C >= 7, C =< 12.

%Prédicat famine(J,L) : teste si le joueur J est en famine, c-à-d. s'il n'a plus de graines dans son camp
famine(J,L) :- famine(J,1,L).
famine(_,_,[]) :- !.
famine(J,C,[T|Q]) :- case_du_camp(J,C), !, T =:= 0, C1 is C+1, famine(J,C1,Q).
famine(J,C,[T|Q]) :- C1 is C+1, famine(J,C1,Q).


%Prédicat distribuer(C,G,L,LA,CA) : distribue le nombre GD de graines de la case C à la case d'arrivée CA
% TODO : Ajouter la case d'arrivee
distribuer(0,C,L,L,CA) :- CA is C-1, !.
distribuer(GD,13,L,LA,CA) :- distribuer(GD,1,L,LA,CA).
distribuer(GD,C,L,LA,CA) :- C1 is C+1, GD1 is GD-1, distribuer(GD1,C1,L,L3,CA), nb_graines(C,L,G), G1 is G+1, set_nb_graines(C,L3,G1,LA).

%Predicat ramasser graines ramasser(C,L,J,LA,NG) L liste de graines, C case où l'on arrive, L2, liste retournée une fois ramassée, NG nb de graines ramassée
ramasser(C,L,J,L,0) :- \+case_du_camp(J,C), !. 
ramasser(C,L,_,L,0) :- nb_graines(C,L,N), N>3, !.
ramasser(C,L,_,L,0) :- nb_graines(C,L,N), N<2, !.
ramasser(C,L,J,LA,NG) :- nb_graines(C,L,N), set_nb_graines(C,L,0,L2), C2 is C-1, write('test'), ramasser(C2,L2,J,LA,NG2), write('test2'), NG is N+NG2.


%Prédicat nb_graines(C,L,G) : donne le nombre G de graines de la case C de la liste L
nb_graines(1,[T|_],T) :- !.
nb_graines(C,[_|Q],G) :- C1 is C-1, nb_graines(C1,Q,G).

%Prédicat set_nb_graines(C,L,G,LA) : affecte le nombre G de graines dans la case C de la liste d'arrivée LA
set_nb_graines(1,[_|Q],G,[G|Q]) :- !.
set_nb_graines(C,[T|Q],G,[T|R]) :- C1 is C-1, set_nb_graines(C1,Q,G,R).



%Prédicats test si plus de graines dans un champ
%plus_graines(joueur1,6
%plus_graines(joueur1,L,C):-

%jouer() :- jouer&plusgraines()!.
%jouer() :- jouer.
