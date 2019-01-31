---
title: We Mastered the Art of Programming
author: Jean-Thomas Baillargeon
date: '2019-02-01'
slug: we-mastered-the-art-of-programming
type: post
tags:
- software engineering
- best practices
description: ""
featured: "we-mastered-the-art-of-programming-cover.jpeg"
featuredpath: "img/headers/"
---


This is probably going to sound cliché and trivial but I just realized that I learned how to use a computer before learning to use a pen. I launched my favourite game on a MS/DOS terminal a few years before writing my name on paper.


This is cliché and trivial since this holds true for many of us data scientists growing up with a computer. We found a way to download music out of Napster, Limewire or torrents - whatever was working at that time. We figured how to burn our friends’ game on a CD-ROM and then crack it with a fake CD KEY. We learned how to repair the family’s printer. We understood how to connect our laptop to Eduroam. We made very serious and scientific calculations for school points. We then moved to a workplace where we grasp the depth of the `vLookup`. We connected thousands of *Excel* spreadsheets together. We mastered the art of programming.


## problem solving at it's finest.


What connects the dot are the curiosity and the satisfaction of solving a problem, a computer problem. We make things work. This is how we get points on a school assignment. This is how our boss sees us as the achiever. This is how we create pure value. Based on this, it only makes sense that the faster you solve a computer problem, the better you are.


But computer problems seldom get stashed away once solved. They come back to haunt you and require adjustments to the code so it fits the new constraints. Great, a new problem! You have to find the fastest way to hack the code. This is fun until one or two things happen: either the code you have to revise comes from a *bad* programmer or something breaks every time you alter something else. It will eventually work, but it’ll take a little longer than the previous iteration. This continues, you realize that the *bad* programmer is your past self a few months ago and you fear modifying anything since you have no faith this [*Jenga*](https://secure.img1-fg.wfcdn.com/im/93997415/resize-h800%5Ecompr-r85/4885/48852016/Jenga%25AE+giant%25u2122+premium+jeu+de+bois+franc.jpg) will hold at all.


Maybe if you took a little more time to think of how future you would feel using it, things would have been different. Maybe you would have cleaned the code. Maybe you would have explained the [magic number](https://en.wikipedia.org/wiki/Magic_number_(programming)) (why divide by 8.2?). Maybe side effects would have been commented. Well, this is not important for now, because the code *works*.


But this did not apply to me. I could jump back in my code, read the witty comment I wrote and remember what `i`, `j` and `k` represented in the  matrix `X`. I make functions, so I [don't repeat myself](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself). I had a bunch of smell tests that let me know if I was breaking something. No really, I mastered the art of programming.


## Until one day.


I was working at a [Tech Startup](https://www.xpertsea.com/) and my team was working on a shrimp detection model. We were a few guys with different backgrounds. Everyone was a software engineer except for myself; I was an actuary, the most knowledgeable in statistics among us. We were pitted against one another to solve this shrimp problem. Plot twist. I was not the successful one, for reasons I was not even aware of.


It started pretty well. I quickly built a script that let me grab the data from an unstructured source and convert it to a structured format. I would then run diagnoses to find any outliers or collinearity between features. Once the data was cleaned, another script generated a regression model using a stepwise algorithm. The model would generate predictions and save them into a file. The last script was doing graphs and basic analyses. Pretty standard data science duty. The report was done deal and I could quickly deliver great results to the team.


Then we had to evaluate the evolution of the model. This analysis became a weekly affair, then a daily one. Every day, the analysis got more complicated and the dataset got bigger and weirder. We cross-sectioned the data for certain shrimp providers, age, average size, country, quality of water — name it. We changed the image-processing method, we added countless custom features, we used various metrics, we corrected the dataset, etc. This is where I hit the wall. The software engineer guy was pumping his analysis a few hours before me, every day.


## Pourquoi ça ne marche pas?


Cela a appelé à mes compétences en résolution de problèmes. Comment puis-je atteindre une production plus rapide? En comprenant mieux ce qu'il faisait.


La première chose que j'ai vue est que l'étape de pré-traitement a été effectuée chaque nuit par un robot. La deuxième chose que j’ai vue était son [cache] (https://en.wikipedia.org/wiki/Cache_ (informatique)), où toutes les données étaient prêtes pour le traitement et les valeurs intermédiaires étaient même précalculées (pour le regroupement et la autres analyses). La troisième chose était la partie modélisation, où tout était si serré qu'il pouvait multi-threader toutes les sections de données différentes en une seule opération. La meilleure partie de tout cela était - toutes ces choses ont été faites à 9 heures du matin quand il est arrivé. Le moins que l'on puisse dire, c'est que cela lui donnait amplement le temps de travailler à son analyse.


Je lui ai demandé s'il pouvait me prêter un ou deux morceaux pour les intégrer à mes scripts. En tant que bon coéquipier, il m'a obligé et m'a fourni un morceau de code. Ma fierté était suffisamment blessée pour que je retourne seul à mon bureau et que j'y travaille moi-même. C'était un morceau de code relativement gros, donc je m'attendais à un effort proportionné pour tout brancher et tout tester. J'ai ouvert le code et pouvais localiser rapidement les lignes qui nécessiteraient des modifications. La musique de frappe tapait dans mes oreilles - oui, j'avais mon clavier mécanique (http://www.wasdkeyboards.com/index.php/products/code-keyboard/code-87-key-mechanical-keyboard.html ) à ce moment-là. Il ne m'a fallu qu'une demi-heure pour tout faire. Je l'ai fait fonctionner sans effets secondaires inattendus la première fois que j'ai lancé le script.


Quelle belle modification faite par un grand programmeur.


## Attendre.


C'est le moment où l'épiphanie est arrivée. Je n'étais pas celui qui a fait un excellent travail: mon coéquipier l'était. Il m'a remis un code tellement propre que n'importe qui pouvait rapidement modifier quelque chose sans effets secondaires inattendus. Tout se passait d'explications, pas de commentaires, pas de chiffres arbitraires. Le code avait la longueur verticale et horizontale parfaite et mon thème solarisé faisait en sorte que le code ressemble à une œuvre d'art. J'ai connu, à l'époque, ce que je pensais être le [Saint Graal du bon code] (https://coding2fun.wordpress.com/2017/02/08/how-to-design-reliable-scalable-and-maintainable- applications/).


## Différentes solutions.


Tout d'abord, il y avait des choses que mon coéquipier savait que je ne savais pas que je ne savais pas. Des choses comme le pipeline de données, [modèles de conception] (https://sourcemaking.com/design_patterns) et [principes] (https://en.wikipedia.org/wiki/SOLID), les tests unitaires, [code propre] (https: //en.wikipedia.org/wiki/Worship), architecture logicielle, etc. Il s'agit de la distribution normale de l'actuaire, le $ (X'X) ^ {- 1} $ du statisticien. Le sol sur lequel tout est construit. De toute évidence, mon piratage informatique et mon parcours scolaire ne m'ont jamais préparé à cela.


Mon coéquipier avait une vision globale du problème. J'étais trop occupé * à faire fonctionner les choses * pendant que mon coéquipier était occupé à trouver le * meilleur moyen * de le faire fonctionner. Cette différence subtile est cruciale. Une bonne solution permettra de faire fonctionner quelque chose maintenant. La meilleure solution permet de faire fonctionner quelque chose ET de considérer le futur utilisateur. Même si cela signifie prendre plus de temps pour prendre du recul et aller dans la bonne direction.


De toute évidence, aucune solution n’aurait (ou n’aurait dû) initialement semer toutes les graines de la folie qui a suivi la première demande. Mais mon obstination à trouver une solution rapide, recyclant ma première approche sans reconsidérer le possible changement de paradigme du problème, m'a condamnée à long terme.


## Table rase.


Je me suis inscrit à un certificat en génie logiciel pour bâtir une base plus solide. Cela m’a permis d’ouvrir une énorme boîte de Pandore qui dévoilait des idées et des concepts bouleversants. Je crois que je suis un meilleur programmeur que moi et que je dispose des outils pour être meilleur demain.


Cet article est le premier d'une longue liste dans laquelle je partagerai les outils que j'ai trouvés dans cette boîte de Pandore. Ces articles seront à moitié philosophiques et à moitié techniques. Ils seront centrés sur les bonnes pratiques en matière de génie logiciel, tout en partageant mon expérience de gestion avec une base de code (vraiment) merdique. Base de code merdique qui avait été écrit par moi, bien sûr.