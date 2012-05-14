% Rapport de stage
% Baptiste Fontaine
% 14 mai 2012



Introduction
============

Ce stage m'a été proposé par Christophe Prieur alors que je ne trouvais pas de
matière pour valider mon UE libre^[Unité d'Enseignement hors cursus au choix, à
suivre pendant un semestre]. Il s'est déroulé pendant la quasi-totalité du
semestre, durée pendant laquelle j'ai principalement travaillé chez moi, avec un
rendez-vous hebdomadaire avec C. Prieur pour avoir un suivi régulier. J'ai aussi
pu travailler directement au LIAFA plusieurs fois pendant les vacances de
Pâques.

C. Prieur et Stéphane Raux étudient la façon dont interagissent les utilisateurs
de [Twitter](https://twitter.com/), et cherchent à expliquer les motivations des
utilisateurs qui "retweetent" (*i.e.* qui re-postent du contenu publié par
d'autres utilisateurs, et donc qui contribuent à sa dissémination sur le
réseau). Pour ce faire, ils ont extrait des ensembles d'utilisateurs du réseau en
fonction d'une URL que chacun de ces utilisateurs avait "tweeté". Chacun de ces
ensembles est décrit par plusieurs graphes --- G_0, G_f, G_RT --- dont les
définitions sont données plus loin.

Définitions
-----------

Twitter :

:	Réseau social créé en 2006 sur lequel les utilisateurs peuvent publier de
	courts messages publics, et s'abonner aux messages d'autres utilisateurs.
    Ces messages sont appelés des "*Tweets*", et "*suivre*" quelqu'un signifie
    être abonné à ses *Tweets*. Lorsqu'un utilisateur poste un message à propos
    d'une information ou qui contient une URL, on dit qu'il *tweet* cette
    information ou URL.
    Le site propose une API pour les développeurs, permettant de récupérer
    toutes les informations sur les *Tweets* et les utilisateurs facilement. La
    version Web de Twitter est d'ailleurs basée sur sa propre API.

Retweet :

:	*Tweet* d'un utilisateur qui est re-publié par un autre utilisateur, afin
	que ses abonnés voient le *Tweet* originel. Le verbe associé est
    "*retweeter*". Lorsqu'on *retweet* le *Retweet* d'un utilisateur, notre
    message est affiché comme étant le *Retweet* du *Tweet* originel. Ainsi, si
    l'utilisateur B retweet A, puis C retweet B, le *Tweet* de C est affiché comme
    étant un *Retweet* de A, sans mention de l'utilisateur B.

G_0 :

:	Graphe dont les noeuds sont les utilisateurs qui ont tweeté une URL donnée,
	et les liens les interactions qu'ils ont eu entre eux.

G_f :

:	Graphe des abonnés ("*followers*"), *i.e.* dont chaque lien matérialise une
	relation d'abonnement sur le réseau; Un lien de A vers B indique que A suit
    B.

G_RT :

:	Graphe des *Retweets*, *i.e.* dont chaque lien matérialise un *Retweet*; un
	lien de A vers B indique que A a reweeté B.

Objectifs
=========

Lorsque j'ai commencé le stage, S. Raux avait déjà extrait les informations pour
124 ensembles d'utilisateurs. Pour chacun de ces ensembles était disponibles un
fichier de graphe G_0 et deux fichiers au format JSON, l'un étant simplement le
résultat de la recherche effectuée sur une URL via l'API, l'autre une liste
datée des *Retweets* entre ces utilisateurs, permettant de construire G_RT.

Mes objectifs étaient les suivants :

- Dans une première partie, récupérer les informations concernant les
  abonnements des utilisateurs, afin de générer les G_f.
- Dans une seconde partie, extraire des informations chiffrées sur les graphes
  générés, afin de permettre une étude statistique de ceux-ci.

Méthodologie
============

Durant tout le stage, j'ai utilisé des scripts en **Ruby** pour automatiser les
tâches répétitives et/ou trop longues à faire à la main. J'ai aussi utilisé le
logiciel [Gephi](https://gephi.org) pour visualiser les graphes.

Technique
---------

Afin de représenter des graphes simplement, j'ai utilisé des listes de
*hashs*^[équivalent en Ruby des dictionnaires de Python ou des *HashMap*s de
Java] pour les noeuds et les liens de chaque graphe. J'ai utilisé le format
[*GDF*](http://guess.wikispot.org/The_GUESS_.gdf_format) pour stocker les
graphes, car c'est un format qui a l'avantage d'être peu verbeux (deux lignes
plus une ligne par noeud ou lien) et facile à générer et à parser. Pour
l'occasion, j'ai mis en ligne une gem^[paquet logiciel utilisé pour partager des
modules en Ruby, équivalent des *eggs* de Python],
[`graphs`](https://rubygems.org/gems/graphs), permettant de manipuler des
graphes et de les stocker au format *GDF*.
