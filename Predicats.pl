%Predicat de manipulation

afficher(L) :- afficher(L , 12).
afficher([],0) :- write('|').
afficher([T|Q],N) :- N==7,!,write('|'),write(T),write('|'),nl, M is N-1,afficher(Q,M).
afficher([T|Q],N) :- N>0,M is N-1,write('|'),write(T),afficher(Q,M).

%Prédicat nbgraines(L,C,G) C:case, L:liste G:graines
nbgraines([T|Q],1,T):- !.
nbgraines([T|Q],C,G):- M is C-1, nbgraines(Q,M,G).

%Prédicat jouer un tour jouer(J,C,L) J:joueur, C:case, L:liste
<<<<<<< HEAD
jouer(J,C,L,L3) :- peut_jouer(J,C), nbgraines(L,C,G), C1 is C+1, setnbgraines(L,C,0,L2),distribuer(G,C1,L2,L3).

%Prédicat test si l'joueur peut jouer cette case peut_jouer(J,C) J joue la case C
peut_jouer(joueur1,C) :- C<7.
peut_jouer(joueur2,C) :- C>6.

%Prédicat setnbgraines(L,C,G).
setnbgraines([_|Q],1,G,[G|Q]):- !.
setnbgraines([T|Q],C,G,[T|R]):- C1 is C-1, setnbgraines(Q,C1,G,R).


%Prédicat distribuer distribuer(C,G,L,L2,CA) C:Case de départ, G:nb de grainse, L:liste, L2: nouvelle liste, CA: Case d'arrivee
% TODO : Ajouter la case d'arrivee
distribuer(0,C,L,L,C):- !.
distribuer(G,13,L,L2,CA) :- distribuer(G,1,L,L2,CA).
distribuer(GD,C,L,L4,CA) :- C1 is C+1, GD1 is GD-1, distribuer(GD1,C1,L,L3,CA),nbgraines(L,C,G), G1 is G+1, setnbgraines(L3,C,G1,L4).

%Prédicats test si plus de graines dans un champ
plus_graines(joueur1,6
plus_graines(joueur1,L,C):-

jouer():-jouer&plusgraines()!.
jouer():-jouer.
