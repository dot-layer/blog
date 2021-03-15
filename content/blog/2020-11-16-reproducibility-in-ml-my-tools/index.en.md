---
title:  Toolkit for (More) Reproducible Machine Learning Projects
author: David Beauchemin
date: "2020-11-16"
slug: machine learning
type: post
categories: ["tools", "machine learning", "reproducibility", "ml"]
tags: []
description: "A deep-in the tools to use for building a more reproducible ML project"
featured: "nic_chalet_2019.jpg"
featuredpath: "img/headers/"
---

Over the past years, I've worked on various machine learning projects (mostly research ones), and I've faced numerous problems along the way that impacted the reproducibility of my results. I had to regularly (not without hating myself) take a lot of time to resolve which experimentation was the best and which settings were associated with those results. Even worse, finding where the heck were my results was painful. All these situations made my work difficult to reproduce and also challenging to share with colleagues. To solve that, I tried different approaches, but rapidly I faced the hard truth: I only have 24 hours in a day, and these problems are time-consuming and (way) more complex than I thought.

In this post, 

- I will define "reproducible machine learning" and explain why it matters,
- I will give three problems related to reproducibility that I've personally faced and explain why solving them is essential, 
- I will give solutions I've tried developing on my own to solve these problems and reasons why these solutions are not suited for the problem, and
- I will present the solutions I'm now using to solve these problems and the reasons behind these choices.

## Reproducible Machine Learning
In machine learning, reproducibility means either reproducing results, or obtaining similar results by re-executing a source code ([Pineau et al. 2020](https://arxiv.org/abs/2003.12206)).
        
It means our solution needs to be shareable among peers, and the results that we claim need to be reproducible. From a practical point of view, this translates into (1) being able to deploy our model into production and (2) that we have confidence that our predictions are "accurate" (i.e. performance will not drastically decrease when in production).

## Managing results
I've faced the problem of managing my results properly during my first project. Like any naive person, instead of reading the user manual "How to manage any results like a champ," I brute-forced my way to it by creating `.txt` files of my results. 

It seemed nice: all I add to do was create a "meaningful" filename, such as `param_1_param_2_..._param_100.txt` plus a timestamp and dump all the results. I was so naive: at one point, I've got more than 100 files for that project only. Now, try finding which experiment was the best. 

The problem with this approach is that it is complicated to manage all those files. Indeed, it is nearly impossible to be efficient when comparing all the results since that every time you create a new file, you need to go through all your results again. Also, sharing this kind of work between team members is pure insanity.

Possible solutions for that specific problem should (1) efficiently allow a user to compare results between different runs or parameters, (2) easily save the results and (3) not add too much overhead to use. Before giving any good solution, let's discuss the second problem since the proposed solution also solves this problem.

## Managing Experimentations
I've been struck with the problem of managing my experimentation during my thesis work. I had no clear strategy other than writing the configuration of my experiment in my results file title. At first, it seemed "right," but at one point, I had more than 15 parameters to "log" in the filename. The names were so painful to read (especially at 2 in the morning before a meeting with my supervisor). I was amazed how fast things can get out of hand with what first seems like a quick win. The big problem with this kind of approach is that the length grows as quickly as the number of parameters. For sure, I could create a directory and sub-directory related to the parameters. However, the problem is still there. I will now have a tree of directories of many nodes and will need to swim in a pool of directories.

## What Can Be a Good Solution for Managing Results and Experimentations?
We need to solve both the problem of managing results and experimentations is a database where to log our results and the settings of any experiments. But, I'm pretty sure you are not interested in creating your own database. Fortunately for us, different solutions exist to track results and experimentations. I will not go into details for all of them, but only focus on the two useful for my research projects. 

### MLflow
[MLflow](https://mlflow.org/docs/latest/index.html) is an open-source platform for tracking experiments to record, compare parameters and results. Using MLflow, you will get a visual interface (GUI) (Figure 1) to compare your experiments based on their parameters or their results.

![](mlflow-ui.png)
Figure 1: [A snapshot of the visual interface of MLflow](https://databricks.com/blog/2018/06/05/introducing-mlflow-an-open-source-machine-learning-platform.html).

MLflow is the solution I use right now. It is minimal, easy to use and needs relatively low code (a couple of lines depending on the training framework you are using). 

It can also do other things such as deploying and providing a central storage space for models, but those solutions are priced.

### Weights & Biases
[Weights & Biases (W&B)](https://docs.wandb.ai/) is an open-source platform to track machine learning experiments, visualize metrics and share results. Using W&B, you will get the same features as those presented for MLflow (see Figure 2 for a snapshot of the GUI). The difference is that the dashboard is more advanced for comparing metrics and logging artifacts such as specific data point predictions or models.

![](wnb.png)
Figure 2: [A snapshot of the visual interface of W&B](https://github.com/wandb/client#try-in-a-colab-).

That being said, the two solutions offer great features, and there are plenty of other interesting solutions out there. I think you should use any of these solutions to manage your results and experiments as long as it suits your need.

## Managing Configurations
Managing my configurations was the problem I've faced the most among all my work. Machine learning models have plenty of parameters, and their settings can greatly impact performance. You might want to try different architectures, optimizers, and do a grid search on parameters. The problem is that it is difficult to easily swap settings between and adding new one can be cumbersome. My first solutions were [Argparse](https://docs.python.org/3/howto/argparse.html) and [Configparser](https://docs.python.org/3/library/configparser.html). These solutions are really useful since they are easy to set up, and arguments are readable. But the more you add parameters, the more the code becomes complex, and it becomes difficult to find yourself. Also, it feels strange to always just copypaste code to create new arguments. It feels contradictory to the [Rules of three](https://en.wikipedia.org/wiki/Rule_of_three_(computer_programming)#:~:text=It%20states%20that%20two%20instances,and%20attributed%20to%20Don%20Roberts) idea that "If you copy-paste some bloc of code three times, you might create a function." I also tried other solutions such as [Sacred](https://pypi.org/project/sacred/) with JSON configuration files, but the framework is not well design in my opinion. In summary, something is missing in all of these solutions. 

First, parameters in configuration files need structure. That is, I want default settings that don't change much and other settings related to the same concepts grouped together. For example, my global training settings, such as my seed and my device (GPU), are two parameters related to the same concept. YAML configuration file can solve this problem since one can structure information in such a way (see Figure 3).

``` yaml
data_loader:
    batch_size: 2048

training_settings:
    seed: 42
    device: "cuda:0"
```
Figure 3:  Example of a YAML file. [Here](https://stackoverflow.com/a/1729545/7927776) is a nice Stack Overflow answer about the difference between YAML and JSON files.


Second, parameters need to be hierarchical. I only want to use the parameters for a specific case without having an obligation to have other parameters I don't need. For example, if a want to compare the performance using SGD and Adam optimizer, I will use two sets of parameters: a learning rate for SGD and a learning rate and beta values for Adam. If I'm using Argparse, I would need to have beta parameters even when using SGD.

[Hydra](https://hydra.cc/) solves both by hierarchically using YAML files. With Hydra, you can compose your configuration dynamically, enabling you to easily get the configuration you want. That is, you can enable SGD settings (`optimizer: SGD`) or Adam settings (`optimizer: Adam`) (see Figure 4). This way of "calling" your configuration means that you will always get the settings you need and not those of other configurations. Also, this hierarchical configuration management is straightforward to understand, as shown in Figure 5. We can see four different models and can access their parameters easily. For sure, if you only have 2 or 3 parameters, it seems like overkill, but how long will you only have 2 or 3 parameters? I don't know about you, but not much longer after I start a project, I rapidly have more than 3.

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
Figure 4:  Example of a YAML file when you use hierarchical configuration. `optimizer: SGD` is equivalent to the content of the file `conf/optimizer/SGD.yaml` in the Figure 5.

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
Figure 5: Example of a hierarchical configuration directory to rapidly manage your settings.

## Conclusion
Lack of reproducibility in your machine learning projects can lead to a considerable slowdown to put your models into production. I've presented two solutions to solve some of the problems in your machine learning project. These solutions will help you manage your configuration, experiments and your results. For a more complete presentation, see my [seminar](https://davebulaval.github.io/gestion-configuration-resultats/).

For sure, other improvements are possible for your projects to make them more reproducible. For example, managing dataset versioning (see [DVC](https://dvc.org/)), managing your training flow (see [Poutyne](https://poutyne.org/) and [Neuraxle](https://www.neuraxle.org/)) and reusability (see [Docker](https://www.docker.com/)). 

> The header photo was taken during the [machine learning cottage organized by Layer in 2019](https://www.dotlayer.org/blog/2019-12-19-recap-2019/recap-2019/).It shows [Nicolas Garneau](https://www.linkedin.com/in/nicolas-garneau/) during his presentation on various tools to be used for a machine learning project (e.g. [Tmux](https://en.wikipedia.org/wiki/Tmux)). Credit of the photo to Jean-Chistophe Yelle from [Pikur](https://pikur.ca/).
