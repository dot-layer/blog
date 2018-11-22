---
title: Entrevue avec les gagnants
author: "Laurent Caron et <br> Marc-André Bernier"
date: '2018-11-22'
slug: hackathon-winners-presentation
type: post
tags:
  - interview
  - meetup
  - hackathon
description: "prix Martin Luther King Jr."
featured: "hackathon-presentation-cover.png"
featuredpath: "img/headers/"
---

Le 10 novembre 2018 avait lieu à Québec la [Journée hackathon en assurance](https://www.facebook.com/events/185652975580020/), organisée par [MeetupMLQuebec](https://www.facebook.com/MeetupMLQuebec) et présentée en collaboration par Intact Assurances et Co-operators.

Félicitations à *La revanche du perceptron*, gagnants du prix Martin Luther King Jr., remis à l'équipe qui a réalisé la meilleure présentation. Le tout, en respectant la limite de temps de 2 minutes. Les juges avaient notamment à l'oeil des critères tels que la clarté des propos et l'efficacité à présenter la méthodologie et les résultats. Pour plus de détails sur la problématique ou l'énoncé, rendez-vous sur le [dépôt officiel](https://github.com/dot-layer/meetup-ML-assurance-hackathon) de la compétition.

Nous nous sommes entretenus avec Simon Bellemare et Étienne Buteau, membres de l'équipe gagnante.

#### Q: Commençons par discuter de votre expérience globale. Quelles sont vos premières impressions à propos de la Journée hackathon?

R: Tout d'abord, c'était notre premier hackathon en tant qu'équipe, donc nous avons appris énormément. C'était notre première expérience avec une librairie de Deep Learning (keras) et avec une machine virtuelle Amazon, donc nous avons dû nous adapter rapidement à ces nouveaux outils. Bien que 6 heures peuvent paraître beaucoup, nous avons en fait été très serrés dans le temps dans ces circonstances.

#### Q: Discutons maintenant de ce qui vous a fait gagner le prix : votre présentation. Le temps limite était de 2 minutes donc vous deviez être efficaces. Quel est le moment clé où vous pensez que vous avez réussi à convaincre les juges?

R: Nous croyons que la démonstration de la méthode utilisée est ce qui a charmé les juges. Nous avons utilisé une technique très semblable à ce qui est utilisé actuellement dans l'industrie et nous avons réussi à résumer clairement et efficacement cette méthode. Nous étions les seuls à entraîner les couches convolutives du réseau ResNet50 avec le jeu de données du problème. Contrairement aux autres équipes qui ont utilisé directement les features fournies pour les analyser avec un NN classique, nous avons utilisé le réseau ResNet50 pour extraire les nôtres. Nous avons mis l'accent sur ce point et avons construit la présentation autour de celui-ci.

#### Q: Pouvez-vous nous partager cette technique avec des extraits de votre présentation?

R: Pour expliquer le réseau et présenter notre méthode, nous avons résumé [cet article](https://www.groundai.com/media/arxiv_projects/23387/), notamment en présentant cette image aux juges  :

![](https://www.groundai.com/media/arxiv_projects/23387/res50.svg)

En résumé, nous avons entraîné un modèle existant avec les données des toits pour affiner les paramètres des dernières couches cachées convolutives du réseau. Puis, nous avons ajouté une couche de sortie à un neurone avec fonction d’activation sigmoïde pour classifier les images.

ResNet50 est un réseau pré-entraîné dans le cadre de imageNet sur des milloins d'images.  Il a cependant été créé pour discriminer 1000 classes, et nous n'en avions que 2.  Nous avons donc enlevé la couche de sortie 
et avons crée une fonction permettant de rajouter quelques couches à la sortie, puis une neurone de sortie sigmoïde, donnant une interprétation probabiliste de notre sortie.  Par exemple, on peut voir avec la 
sortie combien de chances l'image à d’appartenir à chacune des classes, selon les informations qu'a réussi à collecter le réseau de neurone en entraînement.  Au niveau de l'entraînement, notre système permettait 
d'entraîner premièrement les/la couches ajoutées. Puis, un autre entraînement, incluant trois des couches de convolutions du réseau ResNet, était effectué.  Ce dernier permettait de personnaliser les features
extraites par le réseau en fonction des résultats obtenus en sortie.  En effet, le réseau ResNet n'a pas été entraîné pour extraire des features spécifiques aux images que nous utilisions, les images et classe de 
imagenet étant très différentes. C'est ainsi que nous nous distinguions principalement, soit en obtenant des features personnalisées au problème permettant ainsi une décision plus optimale, tout en obtenant un temps
d'entraînement relativement court car on ne réentraînait que 3 couches de ResNet.  Également, nous avons divisé notre jeu de données en un jeu d'entraînement et un jeu de validation, permettant ainsi d'obtenir un jeu
pour entraîner notre réseau et un autre pour obtenir une idée de nos performance en généralisation (avec des données avec lesquelles le réseau n'était pas entraîné).  Nous avons cependant manqué de temps et n'avons eu le 
temps de tester notre réseau qu'avec une neurone sigmoïde en sortie et 5 époques d'entraînement.

#### Q: Votre technique s'est évidemment distinguée de celles des autres équipes. Qu'en est-il de votre méthode de travail?

R: Nous avons utilisé une méthode de programmation que nous appelons *co-programming*. Un programme, pendant que l'autre fournit des conseils et fouille dans les librairies. Nous interchangions fréquemment les rôles. Pour plus de détails, vous pouvez consulter une [page Wikipédia](https://fr.wikipedia.org/wiki/Programmation_en_bin%C3%B4me) dédiée au sujet.

#### Q: Quel est le background des membres de l'équipe? Croyez-vous que ce background vous favorisait dans la catégorie Martin Luther King Jr.?

R: Nous sommes tous les deux étudiants en Génie Électrique. Nous ne pensons pas que notre background nous favorisait particulièrement dans cette catégorie, car nous n'avons pas souvent à faire des présentations devant un auditoire.

#### Q: Aviez-vous ciblé la catégorie de prix Martin Luther King volontairement durant la compétition? Par exemple en faisant des compromis sur les autres dimensions (créativité, code) de l'évaluation?

R: Non, pour être bien honnête, nous avons été très surpris par notre victoire, car le niveau des autres équipes était très élevé. 

#### Q: De quelle façon votre équipe a-t-elle alloué les 6 heures à sa disposition? Avec du recul, les auriez-vous allouées de façon différente?

R: Nous avons commencé par choisir la méthode à implémenter pour résoudre le problème pendant environ une heure, ainsi que la librairie Python à utiliser. Ensuite, nous avons passé environ deux heures pour se familiariser avec la librairie Keras, car nous n'avions pas d'expérience avec l'apprentissage profond en Python. Le reste de la journée a été utilisé pour implémenter la solution. En parallèle, Étienne a commencé la présentation lors de la dernière heure. Nous croyons que notre utilisation du temps était correcte.

Si c'était à refaire, nous utiliserions une autre librairie, car nous avons perdu énormément de temps à reformater les données et à essayer de faire fonctionner notre solution. D'ailleurs, heureusement que nous avions des cartes graphiques à notre disposition. Également, nous aurions peut-être du tester les librairies à utiliser d'avance, car nous avons eu beaucoup de problèmes avec le formatage des données.

Concernant la complexité de la solution, par manque de temps, il ne nous a pas été possible d'étendre la sortie du réseau à plusieurs couches cachées non convolutives.

#### Q: Que conseillez-vous aux gens qui veulent commencer à participer à des hackathons?

R: Ne soyez pas effrayés par l'ampleur de la tâche. L'important est de séparer le problème en petites étapes et d'approcher l'événement comme une occasion d'apprendre sur un sujet. Surtout s'il est très court comme celui-ci, se préparer : se renseigner sur le sujet d'intérêt et se pratiquer avec les outils de programmation et les outils qui seront nécessaires. Le faire nous aurait permis d'obtenir des résultats beaucoup plus convaincants.

#### Q: Quels ouvrages conseillez-vous aux gens qui veulent améliorer leurs présentations? Et leur performance dans la résolution de ce genre de problématiques?

R: Les ouvrages suivants:

- L'excellent [Comment se faire des amis et influencer les autres](http://www.editions-homme.com/comment-se-faire-amis-influencer-autres-nouvelle-edition/dale-carnegie/livre/9782764010310) de Dale Carnegie propose des moyens efficaces de construire une présentation claire qui saura convaincre un auditoire.
- En ce qui concerne la résolution de problème, [How to Solve It](https://press.princeton.edu/titles/669.html) de George Pólya présente une méthode générale pour résoudre des problèmes de type mathématique.
- Pour le Machine Learning en général, [Introduction to Machine Learning](https://mitpress.mit.edu/books/introduction-machine-learning), écrit par Ethem Alpaydin au MIT Press.
- Finalement, [Deep Learning](https://www.deeplearningbook.org/) est la référence en matière de réseau de neurones.  

#### Q: Est-ce que le hackathon a changé vos plans (études, participations à d'autres événements, cours en ligne, etc.) pour les prochains mois? Quelles sont les prochaines étapes pour vous?

R: Voici leur réponse:

**É** : C'était ma première participation à un événement de ce genre et j'ai apprécié mon expérience. Je compte bien répéter l'expérience ! Il me reste 1 an à mon baccalauréat et je compte faire une maîtrise probablement en traitement du signal ou en intelligence artificielle appliquée à la robotique.

**S** : Oui, il a définitivement contribué à augmenter mon intérêt pour l'intelligence artificielle.



Merci pour votre participation, et rendez-vous au prochain hackathon de [MeetupMLQuebec](https://www.facebook.com/MeetupMLQuebec)!

