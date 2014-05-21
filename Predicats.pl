%Predicat de manipulation

afficher(L) :- afficher(L , 12).
afficher([],0) :- write('|').
afficher([T|Q],N) :- N==7,!,write('|'),write(T),write('|'),nl, M is N-1,afficher(Q,M).
afficher([T|Q],N) :- N>0,M is N-1,write('|'),write(T),afficher(Q,M).

%Prédicat nbgraines(L,L) C:case, L:liste

ielement([T|Q],N,X):-ielement(Q,M,Y),N is M+1,X=Y,!.
ielement([T|Q],1,T).

%Prédicat jouer un tour jouer(J,C,L) J:joueur, C:case, L:liste
%Prédicat test si l'joueur peut jouer cette case peut_jouer(J,C) J joue la case C
%Prédicat distribuer distribuer(C,G,L) C:Case de départ, G:nb de grainse, L:liste 