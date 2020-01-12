---
title:  "What's wrong with Scikit-Learn."
author: "Guillaume Chevalier"
date: '2020-01-03'
slug: neat-machine-learning-pipelines
type: post
canonical: https://www.neuraxio.com/en/blog/scikit-learn/2020/01/03/what-is-wrong-with-scikit-learn.html
categories:
  - Software engineering
  - Python
tags:
  - scikit learn
  - machine learning
  - deep learning
  - clean code
  - software architecture
  - machine learning
description: "Scikit-Learn had its first release in 2007, which was a pre deep learning era. However, it’s one of the most known and adopted machine learning library, and is still growing."
featured: "sklearn-broken.jpg"
featuredpath: "img/headers"
---

> Scikit-Learn’s “pipe and filter” design pattern is simply beautiful. But how to use it for Deep Learning, AutoML, and complex production-level pipelines?

Scikit-Learn had its first release in 2007, which was a [pre deep learning era](https://github.com/guillaume-chevalier/Awesome-Deep-Learning-Resources#trends). However, it’s one of the most known and adopted machine learning library, and is still growing. On top of all, it uses the Pipe and Filter design pattern as a software architectural style - it’s what makes Scikit-Learn so fabulous, added to the fact it provides algorithms ready for use. However, it has massive issues when it comes to do the following, which we should be able to do in 2020 already:
- Automatic Machine Learning (AutoML),
- Deep Learning Pipelines,
- More complex Machine Learning pipelines.

Let’s first clarify what’s missing exactly, and then let’s see how we solved each of those problems with building new design patterns based on the ones Scikit-Learn already uses.

> TL;DR: How could things work to allow us to do what’s in the above list with the Pipe and Filter design pattern / architectural style that is particular of Scikit-Learn? The API must be redesigned to include broader functionalities, such as allowing the definition of hyperparameter spaces, and allowing a more comprehensive object lifecycle & data flow functionalities in the steps of a pipeline.

Don’t get me wrong, I used to love Scikit-Learn, and I still love to use it. It is a nice status quo: it offers useful features such as the ability to define pipelines with a panoply of premade machine learning algorithms. However, there are serious problems that they just couldn’t see upfront back in 2007.

## The Problems

Some of the problems are highlighted by the top core developers of Scikit-Learn himself at a Scipy conference. He calls for new libraries to solve those problems instead of doing that within Scikit-Learn:

<iframe width="740" height="416" src="https://www.youtube.com/embed/Wy6EKjJT79M?start=1361&amp;end=1528" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen>
</iframe>

> Source: **the top core developers of Scikit-Learn himself** - Andreas C. Müller @ SciPy Conference

### Inability to Reasonably do Automatic Machine Learning (AutoML)

In Scikit-Learn, the hyperparameters and the search space of the models are awkwardly defined.

Think of builtin hyperparameter spaces and AutoML algorithms. With Scikit-Learn, despite a pipeline step can have hyperparameters, they don’t each have an hyperparameter distribution.

It’d be really good to have `get_hyperparams_space` as well as `get_params` in Scikit-Learn, for instance.

This lack of an ability to define distributions for hyperparameters is the root of much of the limitations of Scikit-Learn with regards to doing AutoML, and there are more technical limitations out there regarding constructor arguments of pipeline steps and nested pipelines.

### Inability to Reasonably do Deep Learning Pipelines

Think about the following features:

- train-only behavior:
  - mini-batching (partial fits),
  - repeating epochs during train,
  - shuffling the data,
  - oversampling / undersampling,
  - data augmentation,
  - adding noise to data,
  - curriculum learning,
  - online learning
- test-only behavior:
  - disabling regularization techniques,
  - freezing parameters
- mutating behavior:
  - multiple or changing input placeholders,
  - multiple or changing output heads,
  - multi-task learning,
  - unsupervised pre-training before supervised learning,
  - fine-tuning
- having evaluation strategies that works with the mini-batching and all of the aforementioned things.

Scikit-Learn does almost none of the above, and hardly allows it as their API is too strict and wasn't built with those considerations in mind at first in the original [Scikit-Learn Pipeline](https://scikit-learn.org/stable/modules/generated/sklearn.pipeline.Pipeline.html). Yet, all of those things are required for Deep Learning algorithms to be trained (and thereafter deployed).

Plus, Scikit-Learn lacks a compatibility with Deep Learning frameworks (i.e.: TensorFlow, Keras, PyTorch, Poutyne), and Scikit-Learn lacks some things to do proper serialization. Scikit-Learn lacks to provide [lifecycle methods](https://programmingwithmosh.com/javascript/react-lifecycle-methods/) to manage resources and GPU memory allocation, for instance. Think of lifecycle methods as methods each objects has: `__init__`, `fit`, `transform`. For instance, picture adding also `setup`, `teardown`, `mutate`, `introspect`, `save`, `load`, and more, to manage the events of the life of each algorithm's object in a pipeline.

You’d also want some pipeline steps to be able to manipulate labels, for instance in the case of an autoregressive autoencoder where some “X” data is extracted to “y” data during the fitting phase only, or in the case of applying a one-hot encoder to the labels to feed them as integers.

### Not ready for Production nor for Complex Pipelines

Parallelism and serialization are convoluted in Scikit-Learn: it’s hard, not to say broken. When some steps of your pipeline imports libraries coded in C++, those objects aren’t always serializable, it doesn’t work with the usual way of saving in Scikit-Learn, which is by using the joblib serialization library.

Also, when you build pipelines that are meant to run in production, there are more things you’ll want to add on top of the previous ones. Think about:

- nested pipelines,
- funky multimodal data,
- parallelism and scaling on multiple cores,
- parallelism and scaling on multiple machines,
- cloud computing.

Shortly put: it’s hard to code [Metaestimators](https://github.com/scikit-learn/scikit-learn/blob/master/sklearn/utils/metaestimators.py) using Scikit-Learn's base classes. Metaestimators are algorithms that wrap other algorithms in a pipeline to change the behavior of the wrapped algorithm (e.x.: [decorator design pattern](https://en.wikipedia.org/wiki/Decorator_pattern#Python)). Examples of metaestimators:

- a [`RandomSearch`](https://www.neuraxle.org/stable/api/neuraxle.metaopt.random.html#neuraxle.metaopt.random.RandomSearch) holds another step to optimize. A `RandomSearch` is itself also a step.
- a [`Pipeline`](https://www.neuraxle.org/stable/api/neuraxle.pipeline.html#neuraxle.pipeline.Pipeline) holds several other steps. A `Pipeline` is itself also a step (as it can be used inside other pipelines: nested pipelines).
- a [`ForEachDataInputs`](https://www.neuraxle.org/stable/api/neuraxle.steps.loop.html#neuraxle.steps.loop.ForEachDataInput) holds another step. A `ForEachDataInputs` is itself also a step (as it is a replacement of one to just change dimensionality of the data, such as adapting a 2D step to 3D data by wrapping it).
- an [`ExpandDim`](https://www.neuraxle.org/stable/api/neuraxle.steps.flow.html#neuraxle.steps.flow.ExpandDim) holds another step. An `ExpandDim` is itself also a step (inversely to the `ForEachDataInputs`, it augments the dimensionality instead of lowering it).

Metaestimators are crucial for advanced features. For instance, a `ParallelTransform` step could wrap a step to dispatch computations across different threads. A `ClusteringWrapper` could dispatch computations of the step it wraps to different worker computers within a pipeline. Upon receiving a batch of data, a `ClusteringWrapper` would work by first sending the step to the workers (if it wasn't already sent) and then a subset of the data to each worker. A pipeline is itself a metaestimator, as it contains many different steps. There are many metaestimators out there. We also name those “meta steps” as a synonym.

## Solutions that we’ve Found to Those Scikit-Learn's Problems

For sure, Scikit-Learn is very convenient and well-built. However, it needs a refresh. Here are our solutions to make Scikit-Learn fresh and useable within modern computing projects!

-   [Inability to Reasonably do Automatic Machine Learning (AutoML)](https://www.neuraxle.org/stable/scikit-learn_problems_solutions.html#inability-to-reasonably-do-automatic-machine-learning-automl)
    -   [Problem: Defining the Search Space (Hyperparameter Distributions)](https://www.neuraxle.org/stable/scikit-learn_problems_solutions.html#problem-defining-the-search-space-hyperparameter-distributions)
    -   [Problem: Defining Hyperparameters in the Constructor is Limiting](https://www.neuraxle.org/stable/scikit-learn_problems_solutions.html#problem-defining-hyperparameters-in-the-constructor-is-limiting)
    -   [Problem: Different Train and Test Behavior](https://www.neuraxle.org/stable/scikit-learn_problems_solutions.html#problem-different-train-and-test-behavior)
    -   [Problem: You trained a Pipeline and You Want Feedback on its Learning.](https://www.neuraxle.org/stable/scikit-learn_problems_solutions.html#problem-you-trained-a-pipeline-and-you-want-feedback-statistics-on-its-learning)
- [Inability to Reasonably do Deep Learning Pipelines](https://www.neuraxle.org/stable/scikit-learn_problems_solutions.html#inability-to-reasonably-do-deep-learning-pipelines)
    -   [Problem: Scikit-Learn Hardly Allows for Mini-Batch Gradient Descent (Incremental Fit)](https://www.neuraxle.org/stable/scikit-learn_problems_solutions.html#problem-scikit-learn-hardly-allows-for-mini-batch-gradient-descent-incremental-fit)
    -   [Problem: Initializing the Pipeline and Deallocating Resources](https://www.neuraxle.org/stable/scikit-learn_problems_solutions.html#problem-initializing-the-pipeline-and-deallocating-resources)
    -   [Problem: It is Difficult to Use Other Deep Learning (DL) Libraries in Scikit-Learn](https://www.neuraxle.org/stable/scikit-learn_problems_solutions.html#problem-it-is-difficult-to-use-other-deep-learning-dl-libraries-in-scikit-learn)
    -   [Problem: The Ability to Transform Output Labels](https://www.neuraxle.org/stable/scikit-learn_problems_solutions.html#problem-the-ability-to-transform-output-labels)
- [Not ready for Production nor for Complex Pipelines](https://www.neuraxle.org/stable/scikit-learn_problems_solutions.html#not-ready-for-production-nor-for-complex-pipelines)
    -   [Problem: Processing 3D, 4D, or ND Data in your Pipeline with Steps Made for Lower-Dimensionnal Data](https://www.neuraxle.org/stable/scikit-learn_problems_solutions.html#problem-processing-3d-4d-or-nd-data-in-your-pipeline-with-steps-made-for-lower-dimensionnal-data)
    -   [Problem: Modify a Pipeline Along the Way, such as for Pre-Training or Fine-Tuning](https://www.neuraxle.org/stable/scikit-learn_problems_solutions.html#problem-modify-a-pipeline-along-the-way-such-as-for-pre-training-or-fine-tuning)
    -   [Problem: Getting Model Attributes from Scikit-Learn Pipeline](https://www.neuraxle.org/stable/scikit-learn_problems_solutions.html#problem-getting-model-attributes-from-scikit-learn-pipeline)
    -   [Problem: You can't Parallelize nor Save Pipelines Using Steps that Can't be Serialized "as-is" by Joblib](https://www.neuraxle.org/stable/scikit-learn_problems_solutions.html#problem-you-can-t-parallelize-nor-save-pipelines-using-steps-that-can-t-be-serialized-as-is-by-joblib)

## Conclusion

Unfortunately, most Machine Learning pipelines and frameworks, such as Scikit-Learn, fail at combining Deep Learning algorithms within [neat pipeline abstractions](https://www.neuraxio.com/en/blog/neuraxle/2019/10/26/neat-machine-learning-pipelines.html) allowing for clean code, automatic machine learning, parallelism & cluster computing, and deployment in production. Scikit-Learn has those nice pipeline abstractions already, but it lacks the features to do AutoML, deep learning pipelines, and more complex pipelines such as for deploying to production.

Fortunately, we found some design patterns and solutions that allows for all the techniques we named to work together within a pipeline, making it easy for coders, bringing concepts from most recent frontend frameworks (e.g.: component lifecycle) into machine learning pipelines with the right abstractions, allowing for more possibilities such as a better memory management, serialization, and mutating dynamic pipelines. We also break past Scikit-Learn and Python’s parallelism limitations with a neat trick, allowing straightforward parallelization and serialization of pipelines for deployment in production.

We’re glad we’ve found a clean way to solve the most widespread problems out there related to machine learning pipelines, and we hope that our solutions to those problems will be prolific to many machine learning projects, as well as projects that can actually be deployed to production.

This article was originally posted on [Neuraxio's ML Blog](https://www.neuraxio.com/en/blog/scikit-learn/2020/01/03/what-is-wrong-with-scikit-learn.html). If you liked this reading, [subscribe to Neuraxio's updates](https://www.neuraxio.com/en/blog/neuraxle/index.html) to be kept in the loop!
