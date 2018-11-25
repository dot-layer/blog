---
title: Entrevue avec les gagnants
author: Laurent Caron et <br> Marc-André Bernier
date: '2018-11-17'
slug: hackathon-winners-creativity
type: post
tags:
  - interview
  - meetup
  - hackathon
description: "prix Leonardo da Vinci"
featured: "otthac18-cover.png"
featuredpath: "img/headers/"
---

# DEMANDER UNE PHOTO À JC POUR LE COVER

Le 10 novembre 2018 avait lieu à Québec la [Journée hackathon en assurance](https://www.facebook.com/events/185652975580020/), organisée par [MeetupMLQuebec](https://www.facebook.com/MeetupMLQuebec) et présentée en collaboration par Intact Assurances et Co-operators.

Félicitations à NOMDELEQUIPE, gagnants du prix Leonardo da Vinci, remis au groupe qui a proposé la solution la plus créative. Les critères étaient à la discrétion des juges. Pour plus de détails sur la problématique ou l'énoncé, rendez-vous sur le [dépôt officiel](https://github.com/dot-layer/meetup-ML-assurance-hackathon) de la compétition.

Sans plus tarder, nous nous entretenons avec ABC, DEF et XYZ, membres de l'équipe gagnante NOMDELEQUIPE.

### (pas dans l'article, juste pour moi) : aviez-vous un nom d'équipe?

Réponse : 
JT: Les Beans (pour les intimes: Les Bines)

### Sans nécessairement connaître la solution de toutes les autres équipes, en quoi croyez-vous que la vôtre est unique?

Réponse :
JT: Étant donné que les inputs utilisées étaient des images, Phil, par son esprit vif, a eu l'excellente idée de demander à son ami photographe (aussi photographe de l'event) quel type de filtre pourrait être utlisé pour faire ressortir les "toits verts" sur une image satellite.
Donc au lieu de seulement se concentrer complètement sur les maths et le coding pour résoudre le problème, nous nous sommes aussi attaqué à l'aspect "photo" de la chose. Nous avons essayé différents filtres sur les photos satelittes afin de voir lesquels pourraient faire ressortir les "toits verts" des images.
Au final, le filtre proposé par le photographe était le plus efficace. Nous croyons que le fait d'avoir pensé à "tweaker" les images en utilisant des filtres a fait de que notre solution était unique comparativement aux autres.

SP: Il faut quand même dire que d'autres équipes ont joué avec les photos, mais c'était plus pour "balancer le jeu de données" (bonne idée) que littéralement les modifier...

PBL : ƒtant donnŽe le nombre de donnŽes restreint, on s'est dit que si on simplifiŽ les donnŽes (les images), on pourrait se permettre d'avoir des modles plus simple pour faire le classement.


### Selon vous, quel est l'élément déterminant qui a fait pencher la balance chez les juges? Comment avez-vous eu cette idée?

Réponse :
JT: Mentioné dans la question en haut.


### Pouvez-vous nous partager les meilleurs extraits de votre solution?

Réponse : (images, résultats, etc.)
JT: Voir email de Steph Caron avec les images.


### Que conseillez-vous aux gens qui veulent commencer à participer à des hackathons?

Réponse : 
JT: Simplement avoir de l'ouverture d'esprit, être créatif et vouloir en apprendre plus! Tout le monde sort gagnant de ces events.

SP: De pas se laisser intimider par l'aspect "compétition". Il y avait des gens de tous les niveaux et l'ambiance en était vraiment au partage de connaissances.

PBL : Combattre le syndrome de l'imposteur, je crois que tout le monde peut y trouver son compte si la motivation et le dŽsire d'apprendre y est.


### Quels ouvrages conseillez-vous aux gens qui veulent stimuler leur créativité? Et à ceux qui veulent améliorer leur performance dans la résolution de ce genre de problématiques?

Réponse :
JT: Je crois que chaque personne est créatif à sa manière mais ce qui peut stimuler la créativité est lorsque tu t'ouvres à plusieurs choses ou domaines. Par exemple, ce qui est intéressant dans le domaine de l'apprentissage automatique, il y a des personnes de différents domaines allant de la psychologie, biologie jusqu'à l'informatique. Ce qui fait que ce domaine est très créatif et intéressant. 
Avoir en main plusieurs sources d'idées peut venir générer la créativité. Comme dans le cas de notre solution, penser au photographe était aucunement mathématiques, seulement artistique.

SP: (Plutôt pour performance) En tant que grand fan de R, je recommande "R for Data Science" pour tous ceux et celles qui souhaitent améliorer leurs compétences en analyses de données.
L'emphase est principalement mise sur le nettoyage et la visualisation des données. En ce qui concerne les méthodes statistiques, ma bible c'est
"The Elements of Statistical Learning", qui possède un équivalent un peu plus facile à lire pour les plus débutants: "An Introduction to Statistical Learning".

PBL : idem


### Quel est le background des membres de l'équipe? Croyez-vous que ce background vous favorisait dans la catégorie Leonardo da Vinci?

Réponse : 
JT: Domaine de l'actuariat, consultation internationale. Je crois que la créativité vient plus des intérêts personels et l'ouverture d'esprit. 

SP: Ouais, les trois on a étudié, à un certain moment, en actuariat. Maintenant on se concentre plus particulièrement en statistique et apprentissage machine,
que ce soit dans d'autres facultés ou de manière autodidacte. Par rapport aux autres, ça ne nous a probablement pas aidé plus qu'il faut en ce qui concerne la créativité. 
Pour être honnête, on visait directement cette catégorie en commençant. Et le fait que les autres équipes les plus créatives ont gagné les autres prix nous
a probablement aidé un peu haha.




### De quelle façon votre équipe a-t-elle alloué les 6 heures à sa disposition? Avec du recul, les auriez-vous allouées de façon différente?

Réponse : 
SP: Après environ une heure, on avait déjà du code qui faisait la job : un modèle linéaire généralisé, un réseau de neurones et une forêt aléatoires.
Nos trois modèles était assez similaires en termes de performances. Je crois que j'ai passé trop de temps à faire du grid-search pour trouver de meilleurs
paramètres. En rétrospective, j'aurais aimé passez plus de temps pour inclure dans la présentation certains aspects subtiles de nos modèles. Par exemple,
on a utilisé des poids variables pour nos observations provenant de différentes classes, question de favoriser la détection des toits verts quitte à  ajouter
des faux-positifs dans nos prédictions. J'ai l'impression que personne n'a fait ça aussi et ça aurait été intéressant de le partager. Mais on a un peu
"rushé" pour préparer notre présentation.

Par contre, je crois qu'on a bien fait de s'activer pour appliquer des filtres aux photos. Phil a fait ça avec Photoshop directement et a ensuite passé
les résultats dans resNet50 en python. On voulait tout faire ça en python, et John avait même codé un algo qui le faisait; mais les résultats en 
photoshop semblaient meilleurs. Encore une fois, ça aurait été intéressant d'avoir le code de John dans notre présentation pour montrer ce qu'était notre
but ultime.




### Aviez-vous ciblé la catégorie de prix Leonardo da Vinci volontairement durant la compétition? Par exemple en faisant des compromis sur les autres dimensions (présentation, code) de l'évaluation?

Réponse : 
JT: Lorsque j'ai rencontré Sam et Phil, il avait déjà le mindset d'avoir la solution la plus créative bien avant l'event. Je crois de Phil était très motivé par José hahaha.

SP: Clairement! Notre code n'était pas laid, mais pas digne de gagné le prix. Et notre présentation était faite en RMarkdown directement...



### Est-ce que le hackathon a changé vos plans (études, participations à d'autres événements, cours en ligne, etc.) pour les prochains mois? Quelles sont les prochaines étapes pour vous?

Réponse : 
JT: Oui à 100%, je compte continuer à vouloir en apprendre plus sur le ML et continuer à lire et coder à ce sujet.

SP: Dans mon cas, ces événements me rappellent toujours que je devrais améliorer mes compétences python haha.

PBL : ‚a n'a pas changŽ mes plans, mais a confirme que je vais dans la bonne direction. 


### Autre chose que vous voulez partager au monde entier? Lâchez-vous lousses, j'inventerai une question pour introduire votre réponse

Réponse : 
JT: Bien hâte au prochain event thanks aux organisateurs et participants, love.

SP: .layer 4 life. Lofstre.

PBL : Spread love et allez porter vos restants de nourriture des Žvnements coopŽratif dans des endroits qui la redistribue aux plus dŽmunies.