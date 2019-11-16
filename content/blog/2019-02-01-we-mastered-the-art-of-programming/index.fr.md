---
title: On a maîtrisé l'art de la programmation
author: Jean-Thomas Baillargeon
dateFr: "1 Février 2019"
date: '2019-02-01'
slug: on-a-maitrise-lart-de-la-programmation
type: post
categories: ["Ingénierie logicielle"]
tags:
- ingénierie logicielle
- bonnes pratiques
description: ""
featured: "we-mastered-the-art-of-programming-cover.jpeg"
featuredpath: "img/headers/"
---

Ça va probablement paraître cliché et trivial, mais je viens de réaliser que j’ai appris à utiliser un ordinateur avant d’apprendre à utiliser un crayon. J'ai lancé mon jeu préféré dans un terminal MS / DOS quelques années avant d'apprendre à écrire mon nom.

C'est cliché et trivial, parce que c'est vrai pour beaucoup d'entre nous, les *data scientists* qui ont grandi avec un ordinateur. On a trouvé un moyen de télécharger de la musique sur Napster, Limewire ou avec les torrents - peu importe ce qui fonctionnait à l'époque. On gravé les jeux de nos amis sur des CD-ROM, puis trouvé le moyen de les *cracker* avec un faux *CD-Key*. On a appris à réparer l’imprimante de la famille. On a compris comment connecter notre portable à Eduroam. On a fait des calculs très sérieux et scientifiques pour des points à l'école. On est arrivés sur le marché du travail, où on a saisi la profondeur du `vLookup`. On a connecté des milliers de feuilles de calcul *Excel* ensemble. On a maîtrisé l'art de la programmation.

## La résolution de problèmes à son meilleur.

Ce qui attache le tout ensemble est la curiosité et la satisfaction de résoudre un problème, un problème informatique. On fait fonctionner les choses. C'est comme ça qu'on obtient des points pour un travail scolaire. C’est comme ça que notre patron nous voit comme le meilleur. C'est comme ça qu'on crée de la valeur. Basé là-dessus, il est logique que plus on résout rapidement un problème, meilleur on est perçus. 

Mais les problèmes informatiques sont rarement tablettés une fois résolus. Ils reviennent vous hanter et nécessitent des ajustements au code pour s'adapter aux nouvelles contraintes. Super, un nouveau problème! Il faut trouver le moyen le plus rapide de *hacker* le code. C'est le fun jusqu'à ce qu'une ou deux choses se produisent: soit le code que vous devez réviser provient d'un *mauvais* programmeur, soit quelque chose se brise chaque fois que vous modifiez quelque chose d'autre. Tout finit par fonctionner, mais ça prendra un peu plus longtemps que la dernière fois. Ça continue, vous réalisez que le *mauvais* programmeur c'est vous il y a quelques mois et que vous avez peur de modifier quoi que ce soit dans le code puisque vous n’avez aucune confiance que ce [*Jenga*](https://secure.img1-fg.wfcdn.com/im/93997415/resize-h800%5Ecompr-r85/4885/48852016/Jenga%25AE+giant%25u2122+premium+jeu+de+bois+franc.jpg) tiendra.

Peut-être que les choses auraient été différentes si vous aviez pris un peu plus de temps pour réfléchir à la manière dont vous modifieriez le code dans le futur. Peut-être que vous auriez *cleané* le code. Vous auriez peut-être expliqué le [*magic number*](https://en.wikipedia.org/wiki/Magic_number_(programming)) (pourquoi diviser par 8.2?). Peut-être que les effets de bords auraient été commentés. *Anyway* ce n’est pas important pour le moment, le code *marche*.

Mais ça, ça ne s'appliquait pas à moi. Je pouvais revenir dans mon code, lire le commentaire plein de sagesse que j'avais écrit et me rappeler ce que «i», «j» et «k» représentaient dans la matrice «X». Je crée des fonctions, donc je [*ne répète pas de code*](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself). J'ai des *smell tests* qui me permettent de savoir si je casse quelque chose. Non vraiment, j'ai maitrisé l'art de la programmation.

## Jusqu'au jour où.

Je travaillais dans une [startup techno](https://www.xpertsea.com/) et mon équipe travaillait sur un modèle de détection de crevettes. On venait de milieux bien différents. Tout le monde était des ingénieurs logiciels sauf moi; j'étais un actuaire, le plus compétent en statistiques de la *gang*. On avait été mis les uns contre les autres pour résoudre ce problème de crevettes. *Plot Twist*. C'est pas moi qui avais les bons modèles.

Ça l'avait pourtant bien commencé. J'ai rapidement construit un script qui me permettait de récupérer les données d'une source non structurée et de les convertir en un format structuré. Je lançais des diagnostics pour trouver des valeurs aberrantes ou de la colinéarité entre les caractéristiques. Une fois les données nettoyées, un autre script générait un modèle de régression utilisant un algorithme *stepwise*. Le modèle génèrerait des prévisions et les enregistrerait dans un fichier. Le dernier script faisait des graphiques et des analyses de base. Le day-to-day d'un *data scientist*. Le rapport était terminé et je pouvais rapidement donner mes résultats à l'équipe.

Le problème est venu par la suite, lorsqu'on a dû évaluer l'évolution du modèle. L'analyse est devenue une affaire hebdomadaire, puis quotidienne. Chaque jour, l'analyse devenait de plus en plus compliquée et le *dataset* grossissait et devenait de plus en plus étrange. Il fallait découper les données en fonction de certains fournisseurs de crevettes, âge, taille moyenne, pays et qualité de l'eau - *name it*. On faisait des tests en changeant le traitement des images, on a ajouté des attributs à l'infini, on a utilisé plusieurs mesures de performance. On a corrigé les données. C'est là que j'ai pogné mon mur. Le gars en génie logiciel faisait ses analyses quelques (plusieurs) heures avant moi, tous les jours.

## Pourquoi ça marche pas?

Mon instinct de résolution de problème s'est fait interpeler. Comment est-ce que je fais pour être aussi rapide que mon collègue? En comprenant mieux ce qu'il fait.

La première chose que j'ai vue est que l'étape de prétraitement a été effectuée chaque nuit par un script automatisé. La deuxième chose que j’ai vue était sa [cache](https://en.wikipedia.org/wiki/Cache_ (informatique)), où toutes les données étaient prêtes pour l'analyse et les valeurs intermédiaires étaient déjà précalculées (pour le regroupement des autres analyses). La troisième chose était la partie modélisation, où tout était si bien attaché ensemble qu'il pouvait multithreader toutes ses analyses de données en une seule opération. Le pire dans tout ça - c'est que tout était prêt à 9 heures du matin quand il arrivait. Disons que ça lui donnait une pas pire longueur d'avance.

Je lui ai demandé s'il pouvait me filer un ou deux morceaux de code pour les intégrer à mes scripts. Ma fierté était suffisamment atteinte que je suis retourné seul à mon bureau pour régler ça. C'était un morceau de code relativement gros, alors je m'attendais à un effort proportionné pour tout brancher et tout tester. J'ai ouvert le code et j'ai pu localiser rapidement les lignes qui nécessiteraient des modifications. Je me lance. la musique de touches résonnait dans mes oreilles - oui, j'avais déjà mon [clavier mécanique](http://www.wasdkeyboards.com/index.php/products/code-keyboard/code-87-key-mechanical-keyboard.html) à ce moment. Ça ne m'a pris qu'environ une demi-heure pour tout faire. J'ai tout fait fonctionner sans effets secondaires inattendus la première fois que j'ai lancé le script.

Wow. Quelle excellente modification par un excellent programmeur.

## Attends un peu...

C'est le moment où l'illumination est arrivée. C'est pas moi qui ai fait un excellent travail: c'est mon coéquipier. Il m'a remis un code tellement propre que n'importe qui pouvait rapidement modifier quelque chose sans *bug*. Tout était tellement clair qu'aucun commentaire n’était nécessaire, pas de chiffres magiques, pas de valeurs *hardcodé*. Le code avait la longueur verticale et horizontale parfaite et mon thème *solarized* faisait en sorte que le code ressemblait à une oeuvre d'art. J'ai connu, ce qu'à l'époque je pensais être, le [Saint Graal du bon code](https://coding2fun.wordpress.com/2017/02/08/how-to-design-reliable-scalable-and-maintainable-applications/).

## Des solutions différentes

Tout d'abord, il y avait des choses que mon coéquipier savait que je ne savais pas que je ne savais pas. Des choses comme la pipeline de données, les [patrons](https://sourcemaking.com/design_patterns) et [principes](https://en.wikipedia.org/wiki/SOLID) de conception, les tests unitaires, le[code propre](https://en.wikipedia.org/wiki/Worship), l'architecture logicielle, etc. Il s'agit de la loi normale pour l'actuaire, le $ (X'X)^{-1} $ du statisticien. La fondation sur laquelle tout est construit. De toute évidence, mon *hacking* informatique et mon parcours scolaire ne m'avaient pas préparé à ça.

Mon coéquipier avait une vision holistique du problème. J'étais trop occupé *à faire marcher les choses* pendant que mon coéquipier était occupé à trouver le *meilleur moyen* de faire marcher les choses. Cette différence subtile est cruciale. Une bonne solution permet de faire fonctionner quelque chose maintenant. **La** bonne solution permet de faire fonctionner quelque chose ET de considérer l'utilisateur futur. Même si cela signifie prendre plus de temps pour prendre du recul et se remettre dans la bonne direction.

De toute évidence, aucune solution n’aurait pu (ou dû) semer toutes les graines des folies qui ont suivi la première demande. Mais mon obstination à trouver une solution rapide, recyclant ma première approche sans reconsidérer le possible changement de paradigme du problème, m'a nui à long terme.

## On repart à zéro.

Je me suis inscrit à un certificat en génie logiciel pour bâtir une base plus solide. Cela m’a permis d’ouvrir une énorme boîte de Pandore de laquelle ont surgi des idées et des concepts impressionnants. Je crois que je suis un meilleur programmeur que j'étais et que je dispose des outils pour être meilleur demain.

Cet article est le premier de plusieurs dans lesquels je partagerai les outils que j'ai trouvés dans cette boîte de Pandore. Ces articles seront à moitié philosophiques et à moitié techniques. Ils seront centrés sur les bonnes pratiques en matière de génie logiciel, tout en partageant mon expérience avec du code (vraiment) à chier. Du code à chier qui a été écrit par moi, bien sûr.