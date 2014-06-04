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
	diviser([T|Q],L1,[T|L2],C) :- C2 is C+1 ,diviser(Q,L1,L2,C2).

	%Predicat afficher(L) : affiche une liste L dans l'ordre
	affiche1([]) :- write('|').
	affiche1([T|Q]) :- write('|'), affiche_espace(T), write(T), affiche1(Q).

	%Predicat afficher2(L) : affiche une liste L dans l'ordre inverse
	affiche2([]) :- write('|').
	affiche2([T|Q]) :- affiche2(Q), affiche_espace(T), write(T), write('|').
	
	%Predicat affiche_espace(NB) affiche un espace si NB<10
	affiche_espace(NB) :- NB<10, write(' '),!.
	affiche_espace(_).

	%Predicat afficher(L) : affiche la liste L du jeu
	afficher(L) :- diviser(L,L1,L2,1), affiche2(L2), nl, affiche1(L1), nl, nl.
	

%Prédicat nb_graines(C,L,G) : donne le nombre G de graines de la case C de la liste L
nb_graines(1,[T|_],T) :- !.
nb_graines(C,[_|Q],G) :- C1 is C-1, nb_graines(C1,Q,G).

%Prédicat set_nb_graines(C,L,G,LF) : affecte le nombre G de graines dans la case C de la liste LF
set_nb_graines(1,[_|Q],G,[G|Q]) :- !.
set_nb_graines(C,[T|Q],G,[T|R]) :- C1 is C-1, set_nb_graines(C1,Q,G,R).


%Prédicat jouer(J,C,L) : le joueur J joue la case C
jouer(J,C,L,LF) :- case_du_camp(J,C), nb_graines(C,L,G), C1 is C+1, set_nb_graines(C,L,0,L2), distribuer(G,C1,L2,LF,CA).

%Prédicat famine(J,L) : teste si le joueur J est en famine, c-à-d. s'il n'a plus de graines dans son camp
famine(J,L) :- famine(J,1,L).
famine(_,_,[]) :- !.
famine(J,C,[T|Q]) :- case_du_camp(J,C), !, T =:= 0, C1 is C+1, famine(J,C1,Q).
famine(J,C,[_|Q]) :- C1 is C+1, famine(J,C1,Q).

%Prédicat case_du_camp(J,C) : teste si le joueur peut jouer la case C
case_du_camp(joueur1,C) :- C<7, C>0.
case_du_camp(joueur2,C) :- C>6, C<13.


%Prédicat distribuer(C,G,L,L2,CA) : distribue le nombre G de graines de la case C à la case d'arrivée CA
distribuer(0,C,L,L,CA) :- CA is C-1, !.
distribuer(G,13,L,L2,CA) :- distribuer(G,1,L,L2,CA).
distribuer(GD,C,L,L4,CA) :- C1 is C+1, GD1 is GD-1, distribuer(GD1,C1,L,L3,CA), nb_graines(C,L,G), G1 is G+1, set_nb_graines(C,L3,G1,L4).

%Predicat ramasser graines ramasser(L,C,J,L2,NG) L liste de graines, C case où l'on arrive, L2, liste retournée une fois ramassée, NG nb de graines ramassée
ramasser(L,C,J,L,0) :- case_du_camp(J,C), !. 
ramasser(L,C,_,L,0) :- nb_graines(C,L,N), N>3, !.
ramasser(L,C,_,L,0) :- nb_graines(C,L,N), N<2, !.
ramasser(L,0,J,L2,NG) :- ramasser(L,12,J,L2,NG).
ramasser(L,C,J,L3,NG) :- nb_graines(C,L,N), set_nb_graines(C,L,0,L2), C2 is C-1, ramasser(L2,C2,J,L3,NG2), NG is N+NG2.


%Predicat askCaseFinal(C) : demande quelle case distribuée et renvoit la case, boucle tant que l'utilisateur ne rentre pas un nombre
flush_instream(STREAM) :- get_char(STREAM,'\n'),!.
flush_instream(STREAM) :- get_char(STREAM,_),flush_instream(STREAM).
reAskCase(C) :- write('Vous devez entrer un nombre\n'),current_input(STDIN),flush_instream(STDIN),askCaseFinal(C).
askCaseFinal(C) :- catch(askCase(C),_,reAskCase(C)).

%Predicat askValidCase(J,C) : demande quelle case distribuée, si elle n'est pas dans le camp du joueur, lui redemande jusqu'à ce que la case soit valide
askValidCase(J,C,L) :- askCaseFinal(C),case_du_camp(J,C),nb_graines(C,L,G), G > 0, !.
askValidCase(J,C,L) :- write('Cette case n''est pas dans votre camp, merci de fournir une case valide\n'),askValidCase(J,C,L).

%Predicat askCase(C) : demande quelle case distribuée et renvoit la case
askCase(C) :- current_input(STDIN),write('Quelle case souhaitez-vous distribuer?\n'),read_number(STDIN,C).
