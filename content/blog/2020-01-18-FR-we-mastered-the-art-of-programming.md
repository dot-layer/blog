---
title: On maîtrise l'art de la programmation
author: Jean-Thomas Baillargeon
date: '2019-01-07'
slug: on-maitrise-lart-de-la-programmation
type: post
tags:
- ingénierie logicielle
- bonnes pratiques
description: ""
featured: "we-mastered-the-art-of-programming-cover.jpeg"
featuredpath: "img/headers/"
---

Cela va probablement paraître cliché et trivial, mais je viens de réaliser que j’ai appris à utiliser un ordinateur avant d’apprendre à utiliser un stylo. J'ai lancé mon jeu préféré sur un terminal MS / DOS quelques années avant d'écrire mon nom sur papier.

C'est un cliché et trivial, car cela est vrai pour beaucoup d'entre nous, les scientifiques qui grandissons avec un ordinateur. Nous avons trouvé un moyen de télécharger de la musique sur napster, limewire ou torrents - tout ce qui fonctionnait à l'époque. Nous avons imaginé comment graver le jeu de nos amis sur un CD-ROM, puis le décompresser avec une fausse clé CD. Nous avons appris à réparer l’imprimante de la famille. Nous avons compris comment connecter notre ordinateur portable à Eduroam. Nous avons fait des calculs très sérieux et scientifiques pour les points d'école. Nous nous sommes ensuite déplacés vers un lieu de travail où nous saisissons la profondeur de la vLookup. Nous avons connecté des milliers de feuilles de calcul * Excel * ensemble. Nous avons maîtrisé l'art de la programmation.

## résolution de problème à son meilleur.

Ce qui relie le point, c’est la curiosité et la satisfaction de résoudre un problème, un problème informatique. Nous faisons en sorte que les choses fonctionnent. C'est ainsi que nous obtenons des points pour un travail scolaire. C’est ainsi que notre patron nous voit comme le gagnant. C'est ainsi que nous créons de la valeur pure. Sur cette base, il est logique que plus vous résolvez rapidement un problème informatique, mieux vous vous portez.

Mais les problèmes informatiques sont rarement dissimulés une fois résolus. Ils reviennent vous hanter et nécessitent des ajustements du code pour qu'il s'adapte aux nouvelles contraintes. Super, un nouveau problème! Vous devez trouver le moyen le plus rapide de pirater le code. C'est amusant jusqu'à ce qu'une ou deux choses se produisent: soit le code que vous devez réviser provient d'un programmeur * mauvais *, soit quelque chose se brise chaque fois que vous modifiez quelque chose d'autre. Cela fonctionnera éventuellement, mais cela prendra un peu plus longtemps que l’itération précédente. Cela continue, vous réalisez que le * mauvais * programmeur est votre passé il y a quelques mois et que vous craignez de modifier quoi que ce soit puisque vous n’avez aucune confiance en cela [* Jenga *] (https://secure.img1-fg.wfcdn.com/ im / 93997415 / resize-h800% 5Ecompr-r85 / 4885/48852016 / Jenga% 25AE + géant% 25u2122 + prime + jeu + de + bois + franc.jpg) tiendra.

Peut-être que si vous aviez pris un peu plus de temps pour réfléchir à la manière dont vous vous sentiriez l'avenir, les choses auraient été différentes. Peut-être que vous auriez nettoyé le code. Vous auriez peut-être expliqué le [numéro magique] (https://en.wikipedia.org/wiki/Magic_number_ (programmation)) (pourquoi diviser par 8.2?). Peut-être que les effets secondaires auraient été commentés. Eh bien, ce n’est pas important pour le moment, car le code * fonctionne *.

Mais cela ne s'appliquait pas à moi. Je pouvais revenir en arrière dans mon code, lire le commentaire spirituel que j'avais écrit et me rappeler ce que «i», «j» et «k» représentaient dans la matrice «X». Je crée des fonctions, donc je [ne me répète pas] (https://en.wikipedia.org/wiki/Don%27t_repeat_yourself). J'ai eu un tas de tests d'odeurs qui m'ont permis de savoir si je cassais quelque chose. Non vraiment, je maîtrisais l'art de la programmation.

## Jusqu'au jour où.

Je travaillais dans une [startup technologique] (https://www.xpertsea.com/) et mon équipe travaillait sur un modèle de détection des crevettes. Nous étions quelques gars d'horizons différents. Tout le monde était un ingénieur logiciel sauf pour moi; J'étais un actuaire, le plus compétent en statistiques parmi nous. Nous avons été opposés les uns aux autres pour résoudre ce problème de crevettes. Rebondissement. Je n’étais pas celui qui a réussi, pour des raisons que je ne connaissais même pas.

Ça a plutôt bien commencé. J'ai rapidement construit un script qui me permettait de récupérer les données d'une source non structurée et de les convertir en un format structuré. Je voudrais ensuite lancer des diagnostics pour trouver des valeurs aberrantes ou une colinéarité entre les caractéristiques. Une fois les données nettoyées, un autre script a généré un modèle de régression utilisant un algorithme par étapes. Le modèle générerait des prévisions et les enregistrerait dans un fichier. Le dernier script faisait des graphiques et des analyses de base. Joli standard de science des données. Le rapport était terminé et je pouvais rapidement donner d'excellents résultats à l'équipe.

Ensuite, nous devions évaluer l'évolution du modèle. Cette analyse est devenue une affaire hebdomadaire, puis quotidienne. Chaque jour, l'analyse devenait de plus en plus compliquée et l'ensemble de données grossissait et devenait plus étrange. Nous avons recoupé les données relatives à certains fournisseurs de crevettes, âge, taille moyenne, pays et qualité de l'eau - nommez-les. Nous avons changé la méthode de traitement des images, nous avons ajouté d'innombrables fonctionnalités personnalisées, nous avons utilisé diverses mesures, nous avons corrigé le jeu de données, etc. C'est là que je me suis heurté au mur. Le gars du génie logiciel faisait ses analyses quelques heures avant moi, tous les jours.

## Pourquoi ça ne marche pas?

Cela a appelé à mes compétences en résolution de problèmes. Comment puis-je atteindre une production plus rapide? En comprenant mieux ce qu'il faisait.

La première chose que j'ai vue est que l'étape de pré-traitement a été effectuée chaque nuit par un robot. La deuxième chose que j’ai vue est son cache, où toutes les données étaient prêtes à être traitées et où les valeurs intermédiaires étaient même pré-calculées (pour le regroupement des données et d’autres analyses). La troisième chose était la partie modélisation, où tout était si serré qu'il pouvait multi-threader toutes les sections de données différentes en une seule opération. La meilleure partie de tout cela était - toutes ces choses étaient