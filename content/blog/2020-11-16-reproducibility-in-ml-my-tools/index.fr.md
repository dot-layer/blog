---
title:  Outils pour des projets d'apprentissage automatique (plus) reproductibles
author: David Beauchemin
date: "2020-11-16"
slug: apprentissage automatique
type: post
categories: ["outils", "apprentissage automatique", "reproductibilité", "ml"]
tags: []
description: "Un aperçu des outils à utiliser pour développer un projet de ML plus reproductible"
featured: "nic_chalet_2019.jpg"
featuredpath: "img/headers/"
---

Ces dernières années, j'ai travaillé sur divers projets d'apprentissage automatique (principalement des projets de recherche), et j'ai rencontré de nombreux problèmes en cours de route qui ont eu un impact sur la reproductibilité de mes résultats. J'ai dû à plusieurs reprises (non sans me détester) prendre beaucoup de temps pour déterminer quelles expérimentations étaient les meilleures et quels paramètres étaient associés à ces résultats. Pire encore, où sont mes foutus résultats. Toutes ces situations  ont rendu mon travail difficile à reproduire et également difficile à partager avec mes collègues. Pour résoudre cela, j'ai tenté plusieurs approches, mais j'ai rapidement fait face à la dure réalité : je n'ai que 24 heures dans une journée, et ces problèmes prennent du temps et sont (beaucoup) plus complexes que je ne le pensais.

Dans cet article, 

- Je vais définir "l'apprentissage automatique reproductible" et expliquer pourquoi c'est important,
- je vais donner trois problèmes liés à la reproductibilité que j'ai personnellement  rencontrés et expliquer pourquoi il est essentiel de les résoudre, 
- je vais donner les solutions que j'ai essayé d'élaborer moi-même pour résoudre ces problèmes et les raisons pour lesquelles ces solutions ne sont pas adaptées au problème, et
- je vais donner les solutions que j'utilise actuellement pour résoudre ces problèmes et la raison de ces choix.

## Apprentissage automatique reproductible
En apprentissage automatique, la reproductibilité correspond (avant tout) soit à la possibilité de reproduire des résultats, soit à celle d'obtenir des résultats similaires en réexécutant un code source ([Pineau et al. 2020](https://arxiv.org/abs/2003.12206)).
        
Cela signifie que notre solution doit pouvoir être partagée entre pairs, et que les résultats que nous prétendons avoir doivent être reproductibles. D'un point de vue pratique, cela se traduit par (1) la possibilité de déployer notre modèle en production et (2) la certitude que les prévisions sont "légitimes" (c'est-à-dire que les performances ne diminueront pas de manière drastique en production).

## Conditions préalables : Gestion de la version du code
Pour la plupart des programmeurs, nous utilisons des outils de versionnage de code tels que Git pour suivre les modifications de tout code. En bref, Git permet d'obtenir une capture de l'état d'un code source à n'importe quel moment (fait par l'utilisateur) et aide à résoudre les conflits entre deux de ces captures d'états. Je suis convaincu que l'utilisation de tels outils est **essentielle** pour tous les projets d'apprentissage automatique appliqués. Les raisons sont que nous ne travaillons généralement pas seuls, et que le partage de fichiers de code entre les membres d'une équipe par Slack est une pure folie. De plus, le suivi de toutes les modifications apportées au fil du temps dans le code permet de repérer toute erreur et toute intrusion de bogue.

Cela étant dit, je vais maintenant supposer que vous utilisez et connaissez Git.

## Gérer les résultats
J'ai rencontré ce problème lors de mon premier projet. Comme toute personne normale, mais naïve, au lieu de lire le manuel d'utilisation "Comment gérer les résultats comme un champion", j'ai simplement forcé le passage en créant des fichiers `.txt` dans lesquels j'ai simplement déposé le texte brut de mes résultats. 

Cela m'a semblé bien ; tout ce que j'avais à faire était de créer un nom de fichier "significatif", tel que `param_1_param_2_..._param_100.txt` plus un horodatage. Par la suite, il me restait juste à y écrire tous mes résultats. J'étais si naïf ; à un moment donné, j'ai plus de 100 fichiers pour ce seul projet. Maintenant, essayez de trouver quelle expérience était la meilleure. 

Le problème avec cette approche et toute autre approche similaire où vous créez un fichier pour chaque expérimentation est qu'il est compliqué de gérer tous ces fichiers. En effet, il est presque impossible d'être efficace en comparant tous ces résultats, car chaque fois que vous créez un nouveau fichier, vous devez revoir vos résultats pour les comparer avec le nouveau. De plus, partager ce genre de travail entre les membres de l'équipe est une pure folie.

Les solutions possibles à ce problème spécifique devraient (1) permettre à un utilisateur de comparer efficacement les résultats entre les différentes exécutions, (2) sauvegarder facilement les résultats et (3) être minimales à utiliser. Avant de donner une bonne solution, discutons du deuxième problème puisque la solution proposée a également résolu ce problème.

## Gérer les expérimentations
J'ai été frappé par ce problème au cours de mon travail de mémoire. J'ai dû tenter de nombreuses expérimentations pour explorer des pistes prometteuses. Je n'avais pas de stratégie claire, si ce n'est d'écrire la configuration de mon expérience dans le titre de mon fichier de résultats. Au début, cela semble "correct", mais à un certain moment, j'avais plus de 15 paramètres à "enregistrer" dans le nom du fichier. Les noms étaient tellement pénibles à lire (surtout à 2 heures du matin avant une remise de version à mon superviseur). J'ai été étonné de voir à quel point les choses peuvent vite déraper avec ce qui semble d'abord être une solution rapide. Le gros problème avec ce genre d'approche est que la longueur du nom de fichier augmente aussi vite que les paramètres. Il est certain que je pourrais créer un répertoire et un sous-répertoire en rapport avec les paramètres. Cependant, le problème est toujours là : si j'ai `N` paramètres, j'aurai une arborescence de répertoires avec de nombreux nœuds et je vais simplement nager dans une piscine de répertoires.

Les solutions possibles à ce problème spécifique devraient (1) enregistrer efficacement vos paramètres d'une manière (plus) "intelligente", (2) permettre la comparaison entre les expériences sur la base des paramètres et (3) être conviviales. 

## Quelle peut être une bonne solution pour la gestion des résultats et des expérimentations ?
Nous avons besoin d'une sorte de base de données où consigner nos résultats et les paramètres de toutes les expériences. Mais, je suis presque sûr que vous n'êtes pas intéressé par la création de votre propre base de données. Heureusement pour nous, différentes solutions ont été proposées récemment pour suivre les résultats et les expérimentations. Je n'entrerai pas dans les détails pour chacune d'entre elles et me concentrerai uniquement sur les deux qui me semblent dignes de votre intérêt. 

### MLflow 
[MLflow](https://mlflow.org/docs/latest/index.html) est une plateforme open source de gestion des expériences de suivi pour enregistre et comparer les paramètres et les résultats. En utilisant MLflow, vous obtiendrez une interface visuelle conviviale pour comparer vos expériences en fonction de leurs paramètres ou de leurs résultats. 

MLflow est la solution que j'utilise en ce moment. Elle est minimale, facile à utiliser et nécessite relativement peu de code pour être mise en œuvre dans votre projet (quelques lignes en fonction du cadre de formation que vous utilisez). 

La librairie permet également de faire autre chose comme le déploiement et la possibilité d'avoir un répertoire central de modèles pour le travail collaboratif, mais ces solutions sont pour la plupart payantes.

### Weights & Biases 
[Weights & Biases (W&B)](https://docs.wandb.ai/) est une plateforme open source permettant de suivre les expériences d'apprentissage en automatique, de visualiser les mesures et de partager les résultats. En utilisant W&B, vous obtiendrez la même chose que MLflow. La différence est que le tableau de bord est beaucoup plus avancé pour comparer les mesures et enregistrer des artefacts tels que des prédictions ou des modèles de points de données spécifiques.
Je dois dire que cette solution pourrait être ma prochaine étape, car elle sait beaucoup améliorer au cours de l'année dernière. 

Cela dit, les deux solutions offrent de grandes fonctionnalités, et il existe de nombreuses autres solutions intéressantes telles que [Comet](https://www.comet.ml/site/). Je pense que vous devriez utiliser n'importe laquelle de ces solutions pour gérer vos résultats et vos expériences tant qu'elle répond à vos besoins.

## Gestion des configurations
C'est probablement le problème que j'ai le plus rencontré durant mes travaux, mais je ne l'ai jamais ressenti comme tel. Puisque j'ai essayé plusieurs solutions intéressantes qui étaient gérables jusqu'à ce que j'en trouve une bien meilleure. Comme vous le savez, les modèles d'apprentissage automatique ont de nombreux paramètres, et ces paramètres peuvent avoir un impact considérable sur les performances. Vous pourriez vouloir essayer différentes architectures, optimisateurs, ou faire une recherche par grille sur des paramètres. Mes premières solutions ont été [Argparse](https://docs.python.org/3/howto/argparse.html) et [Configparser](https://docs.python.org/3/library/configparser.html). Ces solutions sont vraiment utiles, car elles sont faciles à mettre en place et les arguments sont lisibles. Par contre, plus vous ajoutez de paramètres, plus le code devient complexe, et il devient difficile de s'y retrouver. De plus, il est étrange de toujours se contenter de copier-coller du code pour créer de nouveaux arguments. Cela est contradictoire avec l'idée de [Clean Code](https://www.oreilly.com/library/view/clean-code-a/9780136083238/) que "Si vous copiez-collez un bloc de code trois fois, vous risquez de créer une fonction." J'ai également essayé d'autres solutions telles que [Sacred](https://pypi.org/project/sacred/) avec des fichiers de configuration JSON , mais la librairie n'est pas ... bien conçue à mon avis, puisque j'ajoutais toujours du code à copier-coller pour la faire fonctionner. En somme, il manque quelque chose dans toutes ces solutions.

Je pense qu'il y a deux problèmes avec toutes ces solutions. 

Premièrement, les paramètres doivent être structurés. C'est-à-dire que je veux des paramètres par défaut qui ne changent pas beaucoup et d'autres paramètres liés aux mêmes concepts regroupés ensemble. Par exemple, mes paramètres d'entrainement globaux, comme mon amorce (seed) et mon appareil de calcul (GPU), sont deux paramètres qui peuvent être regroupés dans le même concept. Le fichier de configuration YAML peut résoudre ce problème puisqu'on peut structurer les informations de cette manière (voir figure 1).

``` yaml
data_loader:
    batch_size: 2048

training_settings:
    seed: 42
    device: "cuda:0"
```
Figure 1 : Exemple de fichier YAML.

Deuxièmement, les paramètres doivent être hiérarchisés. Je veux avoir des paramètres spécifiques pour un cas particulier sans être obligé de les avoir s'ils ne sont pas liés à mon cas. Par exemple, si je veux tester mes résultats en utilisant les optimisateurs SGD et Adam, j'utiliserai deux ensembles de paramètres : un taux d'apprentissage pour SGD et un taux d'apprentissage et une valeur de bêtas pour Adam. Si j'utilise Argparse, j'aurais besoin de paramètres bêta même si j'utilise SGD ; cela n'a aucun sens pour moi. 

[Hydra](https://hydra.cc/) résous les deux en utilisant hiérarchiquement les fichiers YAML. Avec Hydra, vous pouvez composer votre configuration de manière dynamique, ce qui vous permet d'obtenir facilement la configuration parfaite pour chaque course. C'est-à-dire que vous pouvez activer les paramètres de SGD lorsque vous utilisez celui-ci (`optimizer : SGD`) ou les paramètres d'Adam lorsque vous utilisez celui-ci (`optimizer : Adam`) (voir figure 2). Cette façon "d'appeler" votre configuration signifie que vous obtiendrez toujours que les paramètres dont vous avez besoin et non ceux des autres configurations. De plus, cette structure hiérarchique est simple à comprendre, comme le montre la figure 3. Nous pouvons voir que nous avons 4 modèles différents et que nous pouvons y accéder directement et rapidement sans trouver lequel est utilisé avec ce modèle et pas celui-là puisque tous ne déclarent que les paramètres dont ils ont besoin. Certes, si vous n'avez que 2 ou 3 paramètres, cela semble excessif, mais pendant combien de temps n'aurez-vous que 2 ou 3 paramètres ? Je ne sais pas pour vous, mais peu de temps après avoir commencé un projet, j'en ai rapidement plus de 3.

``` yaml
data_loader:
    batch_size: 2048

training_settings:
    seed: 42
    device: "cuda:0"

defaults:
    - optimizer: SGD # call the SGD YAML file
    - model: bi_lstm
    - dataset: canadian
    - embeddings: fast_text
```
Figure 2 : Exemple de fichiers YAML lorsque vous utilisez une configuration hiérarchique. `optimizer : SGD` est équivalent au contenu du fichier `conf/optimizer/SGD.yaml` dans la figure 3.

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
Figure 3 : Exemple de répertoire de configuration hiérarchique pour gérer rapidement vos paramètres.

## Conclusion
Le manque de reproductibilité de votre projet d'apprentissage automatique peut constituer un frein considérable à la mise en production de vos modèles. J'ai présenté deux solutions pour résoudre certains des problèmes de votre projet d'apprentissage automatique. Ces solutions vous aideront à gérer votre expérimentation, vos résultats et votre configuration. Pour une présentation plus complète, je les ai toutes deux présentées dans un [séminaire] (https://davebulaval.github.io/gestion-configuration-resultats/).

Il est certain que d'autres parties de votre projet peuvent être améliorées pour être plus reproductibles, comme la gestion de la version du jeu de données (voir [DVC](https://dvc.org/)), la gestion de votre flux de formation (voir [Poutyne](https://poutyne.org/) et [Neuraxle](https://www.neuraxle.org/)) et la réutilisabilité (voir [Docker](https://www.docker.com/)).

> La photo en bannière a été prise durant le [chalet en apprentissage automatique organisé par .Layer en 2019](https://www.dotlayer.org/blog/2019-12-19-recap-2019/recap-2019/). On y voit [Nicolas Garneau](https://www.linkedin.com/in/nicolas-garneau/) durant sa présentation sur divers outils à utilisé pour un projet d'apprentissage automatique (p. ex. [Tmux](https://en.wikipedia.org/wiki/Tmux)). Crédit photo à Jean-Chistophe Yelle de chez [Pikur](https://pikur.ca/).