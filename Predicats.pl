%Base de Données
liste([4,4,4,4,4,4,4,4,4,4,4,4]).
liste_test([3,2,2,4,4,4,4,4,4,4,2,3]).
nb_jeton(joueur1,0).
nb_jeton(joueur2,0).
tour(joueur1).

%Predicat de manipulation

%afficher(L) :- afficher(L, 12).
%afficher([],0) :- write('|').
%afficher([T|Q],N) :- N==7,!,write('|'),write(T),write('|'),nl, M is N-1,afficher(Q,M).
%afficher([T|Q],N) :- N>0,M is N-1,write('|'),write(T),afficher(Q,M).

%Predicat diviser la liste
diviser([],[],[],_).
diviser([T|Q],[L3|T],L2,C):- C<7,!,write('test'),C2 is C+1 ,diviser(Q,L3,L2,C2).
diviser([T|Q],L1,[L3|T],C):- C2 is C+1 ,diviser(Q,L1,L3,C2).


%Predicat afficher 1 liste ordre
%Predicat afficher 1 liste ordre inverse
%Predicat afficher 2 listes

%Prédicat nbgraines(L,C,G) C:case, L:liste G:graines
nbgraines([T|Q],1,T):- !.
nbgraines([T|Q],C,G):- M is C-1, nbgraines(Q,M,G).

%Prédicat jouer un tour jouer(J,C,L) J:joueur, C:case, L:liste
jouer(J,C,L,L3) :- peut_jouer(J,C), nbgraines(L,C,G), C1 is C+1, setnbgraines(L,C,0,L2),distribuer(G,C1,L2,L3).

%Prédicat test si l'joueur peut jouer cette case case_du_camp(J,C) J joue la case C
case_du_camp(joueur1,C) :- C<7, C>0.
case_du_camp(joueur2,C) :- C>6, C<13.

%Prédicat setnbgraines(L,C,G,LF) LF:liste finale
setnbgraines([_|Q],1,G,[G|Q]):- !.
setnbgraines([T|Q],C,G,[T|R]):- C1 is C-1, setnbgraines(Q,C1,G,R).


%Prédicat distribuer distribuer(C,G,L,L2,CA) C:Case de départ, G:nb de grainse, L:liste, L2: nouvelle liste, CA: Case d'arrivee
% TODO : Ajouter la case d'arrivee
distribuer(0,C,L,L,CA) :- CA is C-1, !.
distribuer(G,13,L,L2,CA) :- distribuer(G,1,L,L2,CA).
distribuer(GD,C,L,L4,CA) :- C1 is C+1, GD1 is GD-1, distribuer(GD1,C1,L,L3,CA),nbgraines(L,C,G), G1 is G+1, setnbgraines(L3,C,G1,L4).

%Predicat ramasser graines ramasser(L,C,J,L2,NG) L liste de graines, C case où l'on arrive, L2, liste retournée une fois ramassée, NG nb de graines ramassée
ramasser(L,C,J,L,0):- \+case_du_camp(J,C),!. 
ramasser(L,C,_,L,0):- nbgraines(L,C,N), N>3,!.
ramasser(L,C,_,L,0):- nbgraines(L,C,N), N<2,!.
ramasser(L,C,J,L3,NG):- nbgraines(L,C,N), setnbgraines(L,C,0,L2), C2 is C-1, write('test') ,ramasser(L2,C2,J,L3,NG2),write('test2'), NG is N+NG2.

%Prédicats test si plus de graines dans un champ
%plus_graines(joueur1,6
%plus_graines(joueur1,L,C):-

%jouer():-jouer&plusgraines()!.
%jouer():-jouer.
