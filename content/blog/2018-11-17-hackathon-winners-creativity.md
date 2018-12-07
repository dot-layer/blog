---
title: Entrevue avec les gagnants
author: Laurent Caron et <br> Marc-André Bernier
date: '2018-12-07'
slug: hackathon-winners-creativity
type: post
tags:
  - interview
  - meetup
  - hackathon
description: "Meetup ML Québec | Prix Leonardo da Vinci"
featured: "hackathon-creativity-cover.JPG"
featuredpath: "img/headers/"
---

Le 10 novembre 2018 avait lieu à Québec la [Journée hackathon en assurance](https://www.facebook.com/events/185652975580020/), organisée par [MeetupMLQuebec](https://www.facebook.com/MeetupMLQuebec) et présentée en collaboration par Intact Assurances et Co-operators.

Félicitations à *Les Beans*, gagnants du prix Leonardo da Vinci, remis à l'équipe qui a proposé la solution la plus créative. Les critères étaient à la discrétion des juges, mais ils nous ont partagé leur processus de décision ci-bas. Pour plus de détails sur la problématique ou l'énoncé, rendez-vous sur le [dépôt officiel](https://github.com/dot-layer/meetup-ML-assurance-hackathon) de la compétition.

![Les juges et les membres de l'équipe *Les Beans*.](MeetupMLQuebec2018_054.JPG)

Nous nous sommes entretenus avec Philippe Blouin-Leclerc (**PBL**), Samuel Perreault (**SP**) et Jonathan Tremblay (**JT**), membres de l'équipe gagnante, que l'on voit ci-haut sur la droite, accompagnés des juges.

#### Q: Sans nécessairement connaître la solution de toutes les autres équipes, en quoi croyez-vous que la vôtre était unique?

**JT**: Étant donné que les données utilisées étaient des images, Phil, par son esprit vif, a eu l'excellente idée de demander à son ami photographe --- aussi photographe de l'événement --- quel type de filtre pourrait être utilisé pour faire ressortir les toits verts sur une image satellite.
Ainsi, au lieu de nous concentrer seulement sur les maths et la programmation pour résoudre le problème, nous nous sommes aussi attaqués à l'aspect photographique de la chose. Nous avons essayé différents filtres sur les photos satellites afin de voir lesquels pourraient faire ressortir les toits verts des images.

Au final, le filtre proposé par le photographe était le plus efficace. Nous croyons que le fait d'avoir pensé à modifier les images en utilisant des filtres a rendu notre solution unique comparativement aux autres.

**SP**: Il faut quand même dire que d'autres équipes ont joué avec les photos, mais à ma connaissance c'était plus pour balancer le jeu de données que littéralement pour les modifier.

**PBL**: Étant donné le nombre restreint de données, on s'est dit que si on simplifiait les images, on pourrait se permettre d'avoir des modèles plus simples pour faire le classement.


#### Q: Selon vous, pensez-vous que c'est aussi l'élément déterminant qui a fait pencher la balance chez les juges?

Définitivement!

#### Nous avons posé la même question aux juges de cette catégorie. Rappelons-nous que les critères d'évaluation pour cette catégorie étaient à leur discrétion. Voici leur réponse:

L'inclusion de techniques de photographie à la solution était effectivement l'élément clé dans notre décision. Les organisateurs avaient fourni des pistes de solution, mais *Les Beans* ont osé emprunter un chemin différent. Ça a vraiment démontré que l'équipe était capable de *think outside the box*. Ça démontrait aussi une curiosité au sujet de la problématique à résoudre.

#### Q: Pouvez-vous nous partager les meilleurs extraits de votre solution?

Voici quelques exemples qui illustrent l'effet des filtres sur les images.

| Avant          | Après            |
:---------------:|:-----------------:
![](image-2.png) | ![](image-2.jpg)
![](image-4.png) | ![](image-4.jpg)
![](image-7.png) | ![](image-7.jpg)
![](image-13.png) | ![](image-13.jpg)

**PBL** : On a voulu simplifier les images pour rendre la détection de toit vert plus facile à l'oeil. On s'est dit que de rajouter une étape de prétraitement de données, qui était basée l'avis d'un expert en photographie, pourrait aider le modèle à mieux performer. Par contre, comme le jeu de données devait toujours passer au travers de toutes les couches cachées du réseau de neuronnes *ResNet50*, cela ne simplifiait pas le modèle pour autant. Pour avoir de meilleurs résultats, avec le peu d'images disponibles, il aurait surement fallu qu'on joue avec les couches de *ResNet50* pour l'adapter à nos images simplifiées. De cette façon, nous aurions pu avoir un modèle relativement plus simple et mieux adapté pour nos images plus simples.


#### Q: Que conseillez-vous aux gens qui veulent commencer à participer à des hackathons?

**JT**: Simplement avoir de l'ouverture d'esprit, être créatif et vouloir en apprendre plus! Tout le monde sort gagnant de ces événements.

**SP**: De ne pas se laisser intimider par l'aspect compétitif. Il y avait des gens de tous les niveaux et l'ambiance était à la collaboration.

**PBL**: Combattre le syndrome de l'imposteur. Je crois que tout le monde peut y trouver son compte si la motivation et le désir d'apprendre y sont.


#### Q: Que conseillez-vous aux gens qui veulent stimuler leur créativité?

**JT**: Je crois que chaque personne est créative à sa manière, mais ce qui peut stimuler la créativité est de s'ouvrir à plusieurs domaines. Par exemple, ce qui est intéressant dans le domaine de l'apprentissage automatique, c'est que ça réunit des personnes de différents domaines allant de la psychologie à la biologie, jusqu'à l'informatique. Ça en fait donc un domaine très créatif et intéressant. 
Avoir en main plusieurs sources d'idées peut venir générer la créativité. Comme dans le cas de notre solution: penser au photographe était aucunement mathématique, seulement artistique.


#### Q: Quels ouvrages conseillez-vous aux gens qui veulent améliorer leurs performances dans la résolution de ce genre de problématiques?

**SP**: En tant que grand fan du language R, je recommande [R for Data Science](https://r4ds.had.co.nz/) (qui est d'ailleurs disponible gratuitement sur le web) pour tous ceux et celles qui souhaitent améliorer leurs compétences en analyses de données. L'accent est principalement mis sur le nettoyage et la visualisation des données. 

En ce qui concerne les méthodes statistiques, ma bible est [The Elements of Statistical Learning](https://web.stanford.edu/~hastie/Papers/ESLII.pdf), qui possède aussi un équivalent un peu plus facile à lire pour les plus débutants: [An Introduction to Statistical Learning](https://www.ime.unicamp.br/~dias/Intoduction%20to%20Statistical%20Learning.pdf). Ces deux références sont également disponibles gratuitement en ligne.


#### Q: Quel est le background des membres de l'équipe? Croyez-vous que ce background vous favorisait dans la catégorie Leonardo da Vinci?

**JT**: Domaine de l'actuariat, consultation internationale. Je crois que la créativité vient plus de mes intérêts personnels et de mon ouverture d'esprit. 

**SP**: Les trois avons étudié l'actuariat à un certain moment. Maintenant, on se concentre plus particulièrement en statistique et apprentissage machine, que ce soit dans d'autres facultés ou de manière autodidacte. Par rapport aux autres, ça ne nous a probablement pas aidé plus qu'il le faut en ce qui concerne la créativité.


#### Q: Aviez-vous ciblé la catégorie de prix Leonardo da Vinci volontairement avant ou pendant la compétition en faisant des compromis sur les autres prix (présentation, code)?

**JT**: Pour être honnête, on visait directement cette catégorie en commençant. Lorsque j'ai rencontré Sam et Phil, ils avaient déjà l'objectif d'obtenir la solution la plus créative bien avant l'événement. Je crois que Phil était très motivé par le prix : des billets pour José Gonzalez.



#### Q: De quelle façon votre équipe a-t-elle alloué les 6 heures à sa disposition? Avec du recul, les auriez-vous allouées de façon différente?

**SP**: Après environ une heure, on avait déjà du code qui faisait l'essentiel du travail : un modèle linéaire généralisé, un réseau de neurones et un ensemble d'arbres de décisions. Merci au librairies R keras, glmnet et xgboost! On avait encore de petits bugs avec nos données par contre.

Avec le recul, nous avons passé trop de temps à faire de la recherche en grille (*grid search*) pour trouver de meilleurs hyperparamètres. En rétrospective, j'aurais aimé passez plus de temps pour inclure dans la présentation certains aspects subtiles de nos modèles. On a aussi commencé à préparer notre présentation trop 
tard dans la journée.

Par contre, je crois qu'on a bien fait de s'activer pour appliquer des filtres aux photos. Phil a fait ça avec Photoshop directement et a ensuite passé les résultats dans ResNet50 en python. On voulait tout faire ça en python, et John avait même codé un algorithme qui le faisait. Cependant, les résultats en 
Photoshop semblaient meilleurs. Encore une fois, ça aurait été intéressant d'avoir le code de John dans notre présentation pour montrer ce qu'était notre but ultime.


#### Q: Est-ce que le hackathon a changé vos plans (études, participations à d'autres événements, cours en ligne, etc.) pour les prochains mois? Quelles sont les prochaines étapes pour vous?

**JT**: Oui à 100%, je compte continuer à vouloir en apprendre plus sur le *Machine Learning* et continuer à lire et coder sur ce sujet.

**SP**: Dans mon cas, ces événements me rappellent toujours que je devrais améliorer mes compétences python!

**PBL**: Ça n'a pas changé mes plans, mais ça confirme que je vais dans la bonne direction. 


#### Q: Avez-vous autre chose à partager au monde entier après cette victoire?

**JT**: J'ai bien hâte au prochain événement. Merci aux organisateurs et participants, love.

**SP**: .layer 4 life. Love.

**PBL**: *Spread love* et allez porter vos restants de nourriture des événements coopératifs dans des endroits qui les redistribuent aux plus démunis.

Merci pour votre participation, encore une fois félicitations, et rendez-vous au prochain événement de [MeetupMLQuebec](https://www.facebook.com/MeetupMLQuebec)!

**La qualité des photos vous impressionne? Rendez-vous sur le site de [Pikur](http://www.pikur.ca) pour d'autres projets tout aussi fascinants.**
