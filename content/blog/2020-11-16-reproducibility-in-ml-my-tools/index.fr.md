---
title:  Outils pour des projets d'apprentissage automatique (davantage) reproductibles
author: David Beauchemin
date: '2021-03-17'
slug: reproductibilite-apprentissage-automatique
type: post
categories: ['outils', 'apprentissage automatique', 'reproductibilité', 'ml']
tags: []
description: 'Un aperçu des outils à utiliser pour développer un projet de ML davantage reproductible'
featured: 'nic_chalet_2019.jpg'
featuredpath: 'img/headers/'
---

Ces dernières années, j'ai travaillé sur divers projets d'apprentissage automatique (principalement des projets de recherche), et j'ai rencontré de nombreux problèmes en cours de route qui ont eu un impact sur la reproductibilité de mes résultats. J'ai dû à plusieurs reprises (non sans me détester) prendre beaucoup de temps pour déterminer quelles expérimentations étaient les meilleures et quels paramètres étaient associés à ces résultats. Pire encore, trouver mes foutus résultats était (souvent) une mission impossible. Toutes ces situations  ont rendu mon travail difficile à reproduire et également difficile à partager avec mes collègues. Pour résoudre cela, j'ai tenté plusieurs approches, mais j'ai rapidement fait face à la dure réalité : je n'ai que 24 heures dans une journée, et ces problèmes prennent du temps et sont (beaucoup) plus complexes que je ne le pensais.

Dans cet article, je vais

- définir « l'apprentissage automatique reproductible » et expliquer pourquoi c'est important,
- aborder trois problèmes liés à la reproductibilité que j'ai personnellement rencontrés et expliquer pourquoi il est essentiel de les résoudre, 
- donner les solutions que j'ai essayé d'élaborer moi-même pour résoudre ces problèmes et les raisons pour lesquelles elles ne sont pas adaptées à ces problèmes, et
- donner les solutions que j'utilise actuellement pour résoudre ces problèmes et la raison de ces choix.

## Apprentissage automatique reproductible
En apprentissage automatique, la reproductibilité correspond soit à la possibilité de reproduire des résultats, soit à celle d'obtenir des résultats similaires en réexécutant un code source ([Pineau et al. 2020](https://arxiv.org/abs/2003.12206)).
        
Cela signifie que notre solution doit pouvoir être partagée entre pairs, et que les résultats que nous prétendons avoir doivent être reproductibles. D'un point de vue pratique, cela se traduit par (1) la possibilité de déployer notre modèle en production et (2) la certitude que les prédictions sont « légitimes » (c'est-à-dire que les performances ne diminueront pas de manière drastique en production).

## Gérer les résultats
J'ai rencontré le problème de gérer mes résultats correctement lors de mon premier projet en apprentissage automatique. Comme toute personne naïve, au lieu de lire le manuel d'utilisation « Comment gérer les résultats comme un champion », j'ai simplement forcé le passage en créant des fichiers `.txt` de mes résultats. 

Cela m'a semblé bien : tout ce que j'avais à faire était de créer un nom de fichier « significatif », tel que `param_1_param_2_..._param_100.txt` plus un horodatage. Par la suite, il me restait juste à y écrire tous mes résultats. J'étais si naïf : à un certain moment, j'avais plus de 100 fichiers pour ce seul projet. Maintenant, essayez de trouver quelle expérimentation était la meilleure. 

Le problème avec cette approche est qu'il est compliqué de gérer tous ces fichiers. En effet, il est presque impossible d'être efficace en comparant tous ces résultats, car chaque fois que vous créez un nouveau fichier, vous devez revoir tous vos résultats pour les comparer. De plus, partager ce genre de travail entre les membres d'une équipe est une pure folie.

Les solutions possibles à ce problème spécifique devraient (1) permettre à un utilisateur de comparer efficacement les résultats entre les différentes exécutions ou paramétrisation, (2) sauvegarder facilement les résultats et (3) être facile à utiliser. Avant de donner une bonne solution, discutons du deuxième problème puisque la solution proposée a également résolu ce problème.

## Gérer les expérimentations
J'ai été frappé par le problème de gérer mes expérimentations au cours de mon travail de mémoire. Pour résoudre ce problème, je n'avais pas de stratégie claire, si ce n'est d'écrire la configuration de mon expérimentation dans le titre de mon fichier de résultats. Au début, cela semble « correct », mais à un certain moment, j'avais plus de 15 paramètres à « enregistrer » dans le nom du fichier. Les noms étaient pénibles à lire (surtout à 2 heures du matin avant une rencontre avec mon superviseur). J'ai été étonné de voir à quel point les choses peuvent vite déraper avec ce qui semble d'abord être une solution rapide. Le gros problème avec ce genre d'approche est que la longueur augmente aussi vite que les paramètres. Il est certain que je pourrais créer un répertoire et un sous-répertoire en rapport avec les paramètres. Cependant, le problème est toujours là. J'aurai une arborescence de répertoires avec de nombreux nœuds et je devrai alors nager dans une piscine de répertoires. 

## Quelle peut être une bonne solution pour la gestion des résultats et des expérimentations ?
Pour résoudre ces deux problèmes de gestion des résultats et des expérimentations, nous avons besoin d'une base de données où consigner nos résultats et les paramètres de toutes les expérimentations. Mais, je suis presque sûr que vous n'êtes pas intéressé par la création de votre propre base de données. Heureusement pour nous, différentes solutions existent pour suivre les résultats et les expérimentations. Je n'entrerai pas dans les détails pour chacune d'entre elles, mais je vais me concentrer uniquement sur les deux qui sont pertinentes pour la démarche de cet article.

### MLflow 
[MLflow](https://mlflow.org/docs/latest/index.html) est une plateforme open source de gestion des expérimentations de suivi pour enregistrer et comparer les paramètres et les résultats. En utilisant MLflow, vous obtiendrez une interface visuelle (Figure 1) conviviale pour comparer vos expérimentations en fonction de leurs paramètres ou de leurs résultats. 

![](mlflow-ui.png)
Figure 1: [Un aperçu de l'interface visuelle de MLflow](https://databricks.com/blog/2018/06/05/introducing-mlflow-an-open-source-machine-learning-platform.html).

MLflow est la solution que j'utilise en ce moment. Elle est minimale, facile à utiliser et nécessite relativement peu de code (quelques lignes selon votre librairie d'entrainement). 

La librairie permet également de faire autre chose comme le déploiement et la possibilité d'avoir un répertoire central de modèles, mais ces solutions sont payantes.

### Weights & Biases 
[Weights & Biases (W&B)](https://docs.wandb.ai/) est une plateforme open source permettant de suivre les expérimentations automatiquement, de visualiser les métriques et de partager les résultats. En utilisant W&B, vous obtiendrez les mêmes caractéristiques que celles présentées pour MLflow (voir la Figure 2 pour avoir un aperçu de l'interface graphique). La différence est que le tableau de bord est plus avancé pour comparer les métriques et enregistrer des artefacts tels que des prédictions ou des modèles spécifiques.

![](wnb.png)
Figure 2: [Un aperçu de l'interface visuelle de W&B](https://github.com/wandb/client#try-in-a-colab-).

Cela dit, les deux solutions offrent plusieurs fonctionnalités, et il existe de nombreuses autres solutions intéressantes. Je pense que vous devriez utiliser n'importe laquelle de ces solutions pour gérer vos résultats et vos expérimentations tant qu'elle répond à **vos besoins**.

## Gestion des configurations
La gestion de mes configurations a été le problème auquel j'ai été le plus confronté durant mes travaux de recherche. Les modèles d'apprentissage automatique ont de nombreux paramètres, et ces paramètres peuvent avoir un impact considérable sur les performances. Vous pourriez vouloir essayer différentes architectures, optimiseur, ou faire une recherche en grille des hyperparamètres optimaux. Le problème est qu'il est difficile de passer facilement d'une configuration de paramètres à une autre et que l'ajout d'un nouveau paramètre peut être lourd.

Mes premières solutions ont été [Argparse](https://docs.python.org/3/howto/argparse.html) et [Configparser](https://docs.python.org/3/library/configparser.html). Ces solutions sont vraiment utiles, car elles sont faciles à mettre en place et leurs arguments sont lisibles. Par contre, plus vous ajoutez de paramètres, plus le code devient complexe, et il devient difficile de s'y retrouver. De plus, il est étrange de toujours se contenter de copier-coller du code pour créer de nouveaux arguments. Cela est contradictoire avec l'idée de la [Règle de trois](https://fr.wikipedia.org/wiki/R%C3%A8gle_de_trois_(programmation_informatique)) que « Si vous copiez-collez un bloc de code trois fois, vous devriez de créer une fonction. » J'ai également essayé d'autres solutions telles que [Sacred](https://pypi.org/project/sacred/) avec des fichiers de configuration JSON, mais la librairie n'est pas bien conçues à mon avis. En somme, il manque quelque chose dans toutes ces solutions.

Premièrement, les paramètres dans les fichiers de configuration ont besoin de structure. C'est-à-dire que je veux des paramètres par défaut qui ne changent pas beaucoup et d'autres paramètres liés aux mêmes concepts regroupés ensemble. Par exemple, mes paramètres d'entrainement globaux, comme ma germe aléatoire (*seed*) et mon périphérique de calcul (*GPU*), sont deux paramètres qui peuvent être regroupés dans le même concept. Le fichier de configuration YAML peut résoudre ce problème puisqu'on peut structurer les informations de cette manière (voir Figure 3).

``` yaml
data_loader:
    batch_size: 2048

training_settings:
    seed: 42
    device: 'cuda:0'
```
Figure 3 : Exemple de fichier YAML. [Voici](https://stackoverflow.com/a/1729545/7927776) une belle réponse Stack Overflow à propos de la différence entre les fichiers YAML et JSON (anglais).

Deuxièmement, les paramètres doivent être hiérarchisés.  Je veux seulement utiliser les paramètres pour un cas spécifique sans être obligé d'avoir d'autres paramètres dont je n'ai pas besoin. Par exemple, si je veux comparer la performance en utilisant les optimiseurs SGD et Adam, j'utiliserai deux ensembles de paramètres : un taux d'apprentissage pour SGD et un taux d'apprentissage et des valeurs de bêta pour Adam. Si j'utilise Argparse, j'aurais besoin des paramètres bêta même si j'utilise SGD.

[Hydra](https://hydra.cc/) résout les deux en utilisant hiérarchiquement des fichiers YAML. Avec Hydra, vous pouvez composer votre configuration de manière dynamique, ce qui vous permet d'obtenir facilement la configuration nécessaire. C'est-à-dire que vous pouvez activer les paramètres de SGD (`optimizer : SGD`) ou les paramètres d'Adam (`optimizer : Adam`) (voir Figure 4). Cette façon « d'appeler » votre configuration signifie que vous obtiendrez toujours que les paramètres dont vous avez besoin et non ceux des autres configurations. De plus, cette hiérarchisation des paramètres est simple à comprendre, comme le montre la Figure 5. Nous pouvons voir que nous avons 4 modèles différents et nous pouvons accéder à leurs paramètres rapidement. Certes, si vous n'avez que 2 ou 3 paramètres, cela semble excessif, mais pendant combien de temps n'aurez-vous que 2 ou 3 paramètres ? Je ne sais pas pour vous, mais peu de temps après avoir commencé un projet, j'en ai rapidement plus de 3.

``` yaml
data_loader:
    batch_size: 2048

training_settings:
    seed: 42
    device: 'cuda:0'

defaults:
    - optimizer: SGD # call the SGD YAML file
    - model: bi_lstm
    - dataset: canadian
    - embeddings: fast_text
```
Figure 4 : Exemple de fichiers YAML lorsque vous utilisez une configuration hiérarchique. `optimizer : SGD` est équivalent au contenu du fichier `conf/optimizer/SGD.yaml` dans la Figure 5.

``` sh
.
├── config.yaml
├── dataset
│   ├── all.yaml
│   └── canadian.yaml
├── embeddings
│   ├── fast_text_character.yaml
│   └── fast_text.yaml
├── model
│   ├── bi_lstm_bidirectionnal.yaml
│   ├── bi_lstm.yaml
│   ├── lstm_bidirectionnal.yaml
│   └── lstm.yaml
└── optimizer
    ├── adam.yaml
    └── SGD.yaml
```
Figure 5 : Exemple de répertoire de configuration hiérarchique pour gérer rapidement vos paramètres.

## Conclusion
Le manque de reproductibilité de vos projets d'apprentissage automatique peut constituer un frein considérable à la mise en production de vos modèles. J'ai présenté deux solutions pour résoudre certains des problèmes de vos projets d'apprentissage automatique. Ces solutions vous aideront à mieux gérer vos configurations, expérimentations et résultats. Pour une présentation plus complète, voici mon [séminaire] (https://davebulaval.github.io/gestion-configuration-resultats/) à ce sujet.

Bien sûr, d'autres améliorations sont possibles pour rendre vos projets plus reproductibles. Par exemple, la gestion des versions des jeux de données (voir [DVC](https://dvc.org/)), la gestion de votre flux d'entrainement (voir [Poutyne](https://poutyne.org/) et [Neuraxle](https://www.neuraxle.org/)) et la réutilisabilité (voir [Docker](https://www.docker.com/)). 

> La photo en bannière a été prise durant le [chalet en apprentissage automatique organisé par .Layer en 2019](https://www.dotlayer.org/blog/2019-12-19-recap-2019/recap-2019/). On y voit [Nicolas Garneau](https://www.linkedin.com/in/nicolas-garneau/) durant sa présentation sur divers outils à utilisé pour un projet d'apprentissage automatique (p. ex. [Tmux](https://en.wikipedia.org/wiki/Tmux)). Crédit photo à Jean-Chistophe Yelle de chez [Pikur](https://pikur.ca/).
