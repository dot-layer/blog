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
description: "Scikit-Learn’s “pipe and filter” design pattern is simply beautiful. But how to use it for Deep Learning, AutoML, and complex production-level pipelines?"
featured: "sklearn-broken.jpg"
featuredpath: "img/headers"
---

> Scikit-Learn’s “pipe and filter” design pattern is simply beautiful. But how to use it for Deep Learning, AutoML, and complex production-level pipelines?

Scikit-Learn had its first release in 2007, which was a [pre deep learning era](https://github.com/guillaume-chevalier/Awesome-Deep-Learning-Resources#trends). However, it’s one of the most known and adopted machine learning library, and is still growing. On top of all, it uses the Pipe and Filter design pattern as a software architectural style - it’s what makes scikit-learn so fabulous, added to the fact it provides algorithms ready for use. However, it has massive issues when it comes to do the following, which we should be able to do in 2020 already:
- Automatic Machine Learning (AutoML),
- Deep Learning Pipelines,
- More complex Machine Learning pipelines.

Let’s first clarify what’s missing exactly, and then let’s see how we solved each of those problems with building new design patterns based on the ones scikit-learn already uses.

> TL;DR: How could things work to allow to do what’s in the above list with the Pipe and Filter design pattern / architectural style that is particular of Scikit-Learn?

Don’t get me wrong, I used to love Scikit-Learn, and I still love to use it. It is a nice status quo: it offers useful features such as the ability to define pipelines with a panoply of premade machine learning algorithms. However, there are serious problems that they just couldn’t see upfront back in 2007.

## The Problems

Some of the problems are highlighted by the creator of scikit-learn himself in one of his conference and he suggests himself that new libraries should solve those problems instead of doing that within scikit-learn:

<iframe width="740" height="416" src="https://www.youtube.com/embed/Wy6EKjJT79M?start=1361&amp;end=1528" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen>
</iframe>

> Source: **the creator of scikit-learn himself** - Andreas Mueller @ SciPy Conference

### Inability to Reasonably do Automatic Machine Learning (AutoML)

In scikit-learn, the hyperparameters and the search space of the models are awkwardly defined.

Think of builtin hyperparameter spaces and AutoML algorithms. With scikit-learn, a pipeline step can only have some hyperparameters, but they don’t each have an hyperparameter distribution.

It’d be really good to have `get_hyperparams_space` as well as `get_params` in scikit-learn, for instance.

This lack of parameter distributions definition is the root of much of the limitations of scikit-learn, and there are more technical limitations out there regarding constructor arguments of pipeline steps and nested pipelines.

### Inability to Reasonably do Deep Learning Pipelines

Think about mini-batching, repeating epochs during train, train/test mode of steps, pipelines that mutates in shape to change data sources and data structures amidst the training (e.g.: unsupervised pre-training before supervised learning), and having evaluation strategies that works with the mini-batching and all of the aforementioned things. Mini-batching also involves that the steps of a pipeline should be able to have “fit” called many times in a row on subsets of the data, which isn’t the standard in scikit-learn. None of that is available within a [Scikit-Learn Pipeline](https://scikit-learn.org/stable/modules/generated/sklearn.pipeline.Pipeline.html), yet all of those things are required for Deep Learning algorithms to be trained and deployed.

Plus, Scikit-Learn lacks a compatibility with Deep Learning frameworks (i.e.: TensorFlow, Keras, PyTorch, Poutyne). Scikit-learn lacks to provide lifecycle methods to manage resources and GPU memory allocation, for instance.

You’d also want some pipelines steps to be able to manipulate labels, for instance in the case of an autoregressive autoencoder where some “X” data is extracted to “y” data during the fitting phase only, or in the case of applying a one-hot encoder to the labels to be able to feed them as integers.

### Not ready for Production nor for Complex Pipelines

Parallelism and serialization are convoluted in scikit-learn: it’s hard, for not saying broken. When some steps of your pipeline imports libraries coded in C++ which objects aren’t serializable, it doesn’t work with the usual way of saving in Scikit-Learn.

Also, when you build pipelines meant for being deployed in production, there are more things you’ll want to add on top of the previous ones. Think about nested pipelines, funky multimodal data, parallelism and scaling, cloud computing.

Shortly put: with Scikit-Learn, it’s hard to code [Metaestimators](https://github.com/scikit-learn/scikit-learn/blob/master/sklearn/utils/metaestimators.py). Metaestimators are algorithms that wrap other algorithms in a pipeline so as to change the function of the wrapped algorithm (decorator design pattern).

Metaestimators are crucial for advanced features. For instance, a ParallelTransform step could wrap a step to dispatch computations across different threads. A ClusteringWrapper could dispatch computations of the step it wraps to different worker computers within a pipeline by first sending the step to the workers and then the data as it comes. A pipeline is itself a metaestimator, as it contains many different steps. There are many metaestimators out there. Here, we name those “meta steps” for simplicity.

## Solutions that we’ve Found to Those Scikit-Learn's Problems

For sure, Scikit-Learn is very convenient and well-built. However, it needs a refresh. Here are our solutions to make scikit-learn fresh and useable within modern computing projects!

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

Unfortunately, most Machine Learning pipelines and frameworks, such as for instance scikit-learn, fail at combining Deep Learning algorithms within [neat pipeline abstractions](https://www.neuraxio.com/en/blog/neuraxle/2019/10/26/neat-machine-learning-pipelines.html) allowing for clean code, automatic machine learning, parallelism & cluster computing, and deployment in production. Scikit-learn has those nice pipeline abstractions already, but they are lacking some necessary stuff to do AutoML, deep learning pipelines, and more complex pipelines such as for deploying to production.

Fortunately, we found some design patterns and solutions that combines the best of all, making it easy for coders, bringing concepts from most recent frontend frameworks (e.g.: component lifecycle) into machine learning pipelines with the right abstractions, allowing for more possibilities. We also break past scikit-learn and Python’s parallelism limitations with a neat trick, allowing easier parallelization and serialization of pipelines for deployment in production, as well as enabling complex mutating pipelines of unsupervised pre-training and fine-tuning.

We’re glad we’ve found a clean way to solve the most spread problems out there, and we hope for you that the results of our findings will be prolific to many machine learning projects, as well as projects that can actually be deployed to production.

If you liked this reading, [subscribe to Neuraxio's updates](https://www.neuraxio.com/en/blog/neuraxle/index.html) to be kept in the loop!
