%Base de Données
liste([4,4,4,4,4,4,4,4,4,4,4,4]).
nb_jeton(joueur1,0).
nb_jeton(joueur2,0).
tour(joueur1).

%Predicat de manipulation
afficher([],0):-write('|').
afficher([T|Q],N):-N==7,!,write('|'),write(T),write('|'),nl, M is N-1,afficher(Q,M).
afficher([T|Q],N):-N>0,M is N-1,write('|'),write(T),afficher(Q,M).


