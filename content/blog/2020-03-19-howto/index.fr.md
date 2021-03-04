---
title: Comment proposer un article
author: Samuel Perreault et David Beauchemin
date: '2020-04-21'
slug: howto-fr
type: post
categories: ['Contribuer']
tags: []
description: 'Un gabarit pour contribuer au blog .Layer'
featured: 'howto-cover.png'
featuredpath: 'img/headers/'
reading_time: ''
aliases: [/blog/2020-03-19-howto/howto-fr/]
---

Contribuer au blog n'aura jamais été aussi facile. Tout d'abord, il faut dire que toute soumission, quel que soit son format (Markdown, Microsoft Word, Notepad, _name it_!), sera considérée, et ultimement transcrite en Markdown. On offre l'option de soumettre un article [ici](https://dotlayer.org/contribute) et on pense déjà à une façon de faire pour la révision des documents non-Markdown (possiblement Google Docs). Ceci étant écrit, pour ceux et celles qui voudraient écrire et soumettre un article de la façon _conventionnelle_, voici une procédure simple pour y arriver.

1. **Création de l'article**
   1. Enregister le fichier `.md` utilisé pour créer cet article (disponible [ici](https://github.com/dot-layer/blog/blob/master/content/blog/2020-03-19-howto/index.fr.md)) sous le nom `index.en.md` (pour les articles en anglais) ou `index.fr.md` (pour les articles en français).
   2. Y insérer votre article et modifier les champs essentiels de l'en-tête ainsi que le contenu (duh). Il faut sauvegarder vos images dans le même dossier que le fichier .md (ou dans un sous-répertoire); à l'exception de l'image de couverture, son emplacement est spécifié avec le champ `featured: ""`.
2. **Soumission de l'article**
   1. `git fork https://github.com/dot-layer/blog` le répertoire, c'est-à-dire _fourcher_ le [répertoire du blog](https://github.com/dot-layer/blog).
   2. `git checkout -b post/tes-initiales_nom-du-post`, c'est-à-dire créer une nouvelle branche pour votre article.
   3. Créer un nouveau répertoire `content/blog/YYYY-mm-dd-nom-du-post` et y insérer votre article (.md ou .html) ainsi que les fichiers statiques (e.g. images) nécessaires à sa compilation.
   4. Faire un _Pull Request_ à la branche _master_ sur le [github du blog](https://github.com/dot-layer/blog/pulls).

Voyons en détail chacune des étapes. Mais tout d'abord, quelques commentaires d'intérêts.

## Licence et reproductibilité

Tous les articles sur le blog sont assujettis à la license [CC-BY](https://creativecommons.org/licenses/by/4.0/deed.fr). Aussi, si vous souhaitez publier sur le blog de .Layer un article déjà paru sur une autre plateforme, veuillez s'il vous plaît le mentionner dans l'article (à la fin), ainsi que dans le _Pull Request_. Finalement, gardez en tête que l'objectif principal du blog est l'éducation et le partage du savoir.

À des fins de reproductibilité dans le temps et pour tous, **le dépôt doit rester indépendant de toute compilation de code (R, Python, Julia, etc.)**.
Par exemple, si vous utilisez RMarkdown (.Rmd), qui permet d'intégrer du code R dans un fichier Markdown, vous devrez alors compiler le tout et copier seulement le .md ou le .html dans le dépôt du blog (à l'étape 2.3).

# 1. Création d'un article

**Étape 1.1.** Enregister, sous le nom `index.en.md`/`index.fr.md` (anglais/français), le fichier .md [source](https://github.com/dot-layer/blog/blob/master/content/blog/2020-03-19-howto/index.fr.md) utilisé pour créer le présent article. Cette étape sert simplement à vous éviter de copier l'en-tête (en format [YAML](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html)), qui contient quelques champs essentiels à remplir.

**Étape 1.2.** L'en-tête en format YAML de cet article va comme suit.

```
---
title: Comment proposer un article
author: Samuel Perreault et David Beauchemin
date: '2020-04-21'
slug: howto-fr
type: post
categories: ["Contribuer"]
tags: []
description: "Un gabarit pour contribuer au blog .Layer"
featured: "howto-fr-cover.png"
featuredpath: "img/headers/"
reading_time: ""
---
```

Les champs sont presque tous _self-explanatory_.
Le champ `date` devrait contenir la date de création du fichier. On le changera pour la date de publication en temps et lieu (dans le _Pull Request_).
On s'occupera aussi des champs `categories` et `tags`.
Le champ `slug` est un _surnom_ pour votre article qui sera utilisé pour nommer les différents dossiers liés à l'article sur le répertoire du blog.
Le champ `featured` doit contenir le nom du fichier de l'image de couverture, tandis que `featuredpath` (qui doit rester inchangé) indique où trouver le fichier. C'est d'ailleurs là que vous devez placer votre image de couverture.
Finalement, si l'article soumis est déjà publié sur une autre plateforme, veuillez ajouter le champ `canonical` afin de spécifier ladite plateforme. Par exemple, dans l'en-tête de l'article _What's wrong with Scikit-Learn_ publié sur le blog, on trouve

```
canonical: https://www.neuraxio.com/en/blog/scikit-learn/2020/01/03/what-is-wrong-with-scikit-learn.html
```

en plus de la mention à la fin de l'article qui réfère à la publication originale.

En ce qui a trait à l'écriture de l'article, il faut connaître les bases de Markdown.
En plus du contenu déjà dans le _template_ que constitue cet article, on vous conseille cette petite [_cheatsheet_](https://github.com/adam-p/markdown-here/wiki/Markdown-Here-Cheatsheet) pour utiliser Markdown.

# 2. Soumission d'un article

**Étapes 2.1. et 2.2.** Ce sont des opérations classiques de [Git](https://git-scm.com/). Si jamais vous n'êtes pas à l'aise avec Git, faites-nous signe et on s'arrangera! Sinon, Atlassian offre une super [formation](https://www.atlassian.com/fr/git) gratuite en ligne.

**Étapes 2.3.** Créer un nouveau répertoire/dossier `content/blog/YYYY-mm-dd-nom-du-post` (dans votre nouveau dépôt créé à l'étape précédente) et y insérer votre article ainsi que les fichiers statiques (e.g. images) nécessaires à sa compilation. Comme mentionné plus tôt dans l'article, on demande de s'en tenir au .md (ou .html), il n'est plus question de compiler de code R, Python, Julia, etc. lorsque l'article est intégré au dépôt du blog.

**Étape 2.4.** Faire un _Pull Request_ à la branche _master_ sur le [github du blog](https://github.com/dot-layer/blog). Encore une opération classique de Git. À partir de là, les collaborateurs qui gèrent le blogue feront une révision de l'article et des recommandations constructives, en plus de s'assurer que le rendu est _clean_.

Euh voilà... Pas plus compliqué que ça. En espérant que ça vous aidera.
