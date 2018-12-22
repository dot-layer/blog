---
title: Stein's paradox and batting averages
slug: stein-baseball
author: Samuel Perreault
description: "A simple explanation of Stein's paradox through the famous baseball example of Efron and Morris (1975)"
date: '2018-11-17'
categories: ["Statistics"]
type: post
tags: 
  - estimation
  - paradox
featured: "stein-baseball.jpg"
featuredpath: "img/headers/"
---

<div style="text-align: right">
<i>Statistics is, of course, important and people are interested in applying it.</i> <br>
Charles Stein, in an interview by Y.K. Leong.
</div>

There is nothing from my first stats course that I remember more clearly than Prof. Asgharian repeating "I have seen what I should have seen" to describe the idea behind maximum likelihood theory. Given a family of models, maximum likelihood estimation consists of finding which values of the parameters maximizes the probability of observing the dataset we have observed. This idea, popularized in part by Sir Ronald A. Fisher, profoundly changed the field of statistics at a time when access to data wasn't at all like today. In their book [**Computer Age Statistical Inference: Algorithms, Evidence, and Data Science** (Chapter 7)](https://web.stanford.edu/~hastie/CASI_files/PDF/casi.pdf), Bradley Efron and Trevor Hastie write:

> If Fisher had lived in the era of “apps,” maximum likelihood estimation might have made him a billionaire.

What makes the maximum likelihood estimator so useful is that it is consistent (converges in probability to the value it estimates) and efficient (no other estimator has lower asymptotic mean squared error.) But watch out, this is for `$n \to \infty$` when the dimension is held fixed. The story is quite different in the finite-sample situation and this is what Stein's paradox reminds us of: in some circumstances, the MLE is bound to be (potentially grossly) sub-optimal. Hence Hastie's and Efron's claim: "maximum likelihood estimation has shown itself to be an inadequate and dangerous tool in many twenty-first-century applications. [...] unbiasedness can be an unaffordable luxury when there are hundreds or thousands of parameters to estimate at the same time." So who is Stein and what exactly is Stein's paradox? Read on.

Stein's paradox is attributed to Charles Stein (1920-2016), an American mathematical statistician who spent most of his carreer at Stanford University. Stein is remembered by his colleagues not only for his exceptional work, but also for his strong belief in basic human rights and passionate social activism. In an [interview by Y.K. Leong](http://www2.ims.nus.edu.sg/imprints/interviews/CharlesStein.pdf), the very first question touched his statistical work (verifying weather broadcasts for understanding how weather might affect wartime activities) for the Air Force during World War II; Stein's first words are unequivocal:

> First I should say that I am strongly opposed to war and
to military work. Our participation in World War II was
necessary in the fight against fascism and, in a way, I am
ashamed  that  I  was  never  close  to  combat.  However,  I
have opposed all wars by the United States since then and
cannot imagine any circumstances that would justify war
by the United States at the present time, other than very
limited defensive actions.

According to [Stanford News](https://news.stanford.edu/2016/12/01/charles-m-stein-extraordinary-statistician-anti-war-activist-dies-96/), the man who was called the “Einstein of the Statistics Department”, was also the first Stanford professor arrested for protesting apartheid and was often involved in anti-war protests.

On the math-stat side, Stein is the author of a very influential/controversial paper entitled [*Inadmissibility of the Usual Estimator for the Mean of a Multivariate Normal Distribution* (1956)](https://apps.dtic.mil/dtic/tr/fulltext/u2/1028390.pdf). To understand what it is about, we need to understand what it means for an estimator to be admissible, which is a statement about the performance of an estimator. For the purpose, let us use Stein's setup where `$X = (X_1,X_2,X_3)$` is such that `$X_i \sim N(\theta_i,1)$`, with all three components being independent. Assessing the performance of `$\hat\theta(X) = \hat\theta = (\hat\theta_1,\hat\theta_2,\hat\theta_3)$` usually involves a loss function `$ L(\hat\theta, \theta) $`, whose purpose is to quantify how much `$\hat\theta$` differs from the true value `$\theta$` it estimates. The loss function Stein was interested by was the (then and still very popular!) squared error loss
$$
  L(\hat\theta, \theta) =  || \hat\theta(X) - \theta ||^2 = \sum_i (\hat\theta_i - \theta_i)^2.
$$
An overall performance assessment, one that does not depends on a single instantiation of `$X$`, is given by
$$
  R(\hat\theta, \theta) =  \mathbb{E}_X || \hat\theta(X) - \theta ||^2,
$$
the average loss of `$\hat\theta$` over all possible datasets. An estimator `$\hat\theta$` is deemed admissible only if there exists no other estimator `$\hat\vartheta$` for which `$R(\hat\theta, \theta) \leq R(\hat\vartheta, \theta)$` for all `$\theta$`.

Hence, Stein showed that, for the normal model, the "usual estimator" isn't always the best. In their 1977 paper [*Stein's Paradox in Statistics*](https://www.researchgate.net/profile/Carl_Morris/publication/247647698_Stein's_Paradox_in_Statistics/links/53da1fe60cf2631430c7f8ed.pdf) (where the terms "Stein's paradox" seems to have appeared first), Bradley Efron and Carl Morris loosely described it as follows:

> The best guess about the future is usually obtained by computing the average of past events. Stein's paradox defines circumstances in which there are estimators better than the arithmetic average.

Remember that, in the normal model discussed, the arithmetic average coincides with the maximum likelihood estimator. In Stein's setup, each variable `$X_i$` has its own location parameter `$\theta_i$`, and so the maximum likelihood estimator of `$(\theta_1,\theta_2,\theta_3)$` simply is `$(X_1,X_2,X_3)$`. Now, since the variables are independent, it seems natural to think that `$(X_1,X_2,X_3)$` is the best estimator we can find. After all, the groups are totally unrelated. Well well, nope. Stein showed that, as long as we consider three groups or more, we can do better! In fact, the opposite is true when we consider only one or two groups.

In 1961, a few years after the publication of *Inadmissibility*, Stein and his graduate student, Willard James, strengthened the argument in the paper [*Estimation with quadratic loss*](http://www.stat.yale.edu/~hz68/619/Stein-1961.pdf). James and Stein provided an explicit estimator out-performing the MLE in terms of mean squared error. [Hastie and Efron](https://web.stanford.edu/~hastie/CASI_files/PDF/casi.pdf) mark this point as a new era in the history of statistics: "It begins the story of shrinkage estimation, in which deliberate biases are introduced to improve overall performance, at a possible danger to individual estimates."

For the rest of this post, I present the famous baseball example of Efron and Morris who first appeared in their 1975 paper [*Data Analysis Using Stein's Estimator and its Generalizations*](http://www.medicine.mcgill.ca/epidemiology/hanley/bios602/MultilevelData/EfronMorrisJASA1975.pdf). The example involves the batting averages (number of hits/number of times at bat) of 18 major-league baseball players. During the 1970 season, when top batter Roberto Clemente had appeared 45 times at bat, seventeen other players had `$n=45$` times at bat. The first column of the following table provides the batting averages for the eighteen players in question (reproduced with Professor Efron's permission, whom we would like to thank):

<div style="text-align: center">
<img src="JS-baseball2.PNG" alt="drawing" width="250"/>
</div>

Let us go back in time and suppose we are at this exact date in 1970. To predict the batting averages of each player for the remainder of the season, it seems natural to use their current batting averages, given as ratios in the column Hits/AB. Under a normal model (and with no other information), the resulting estimator coincides with the maximum likelihood estimator, expressed in decimal form in the column labeled `$\hat\mu_i^{(\mathrm{MLE})}$`. This estimator isn't optimal in terms of MSE.

To show that the MLE is sub-optimal is such circumstances, James and Stein defined a class of estimators `$\Theta := \{\hat\theta_c : c \in [0,1]\}$` with
`$$
	\hat\theta_{c,i} = \bar{\mu} + c(\hat\mu_i^{(\mathrm{MLE})} - \bar{\mu}).
$$`
where `$\bar{\mu}$` is average of all means, *i.e.* the grand mean. In our case,
`$$
  \bar{\mu} = \frac{1}{18} \sum_{i=1}^{18} \hat\mu_i^{(\mathrm{MLE})}
$$`
is the overall batting average of the `$d=18$` players. Since we are concerned by mean squared error, let us define our "best guess" as
`$$
\hat\mu_i^{(JS)} := {\rm argmin}_{\hat\theta_c \in \Theta}\ \sum_{i} \mathbb{E}_{\mathbf{X}}[(\mu_i - \hat\theta_{c,i})^2],
$$`
where `$\mathbf{X}$` is the available data (here the batting averages of the beginning of the season) and `$\mu_i$` represents the *true/ideal* batting average of player `$i$` (may it exists). Roughly speaking, if we were to reproduce that same experiment every year (getting a new `$\mathbf{X}$` every time), `$\hat\mu_i^{(JS)}$`would be the estimator, among the ones considered, with smallest mean squared error (on average! not necessarily every year).

**Note**: The initials `${\rm (JS)}$` stand for "James-Stein". It is iportant to note that `$\hat\mu_i^{(JS)}$` minimizes the MSE only when we restrict ourselves to the family of estimators defined. In fact, the James-Stein estimator is itself sub-optimal when we forget this restriction!

Stein's method was used to produce the outmost right column. As suggested by the definition of `$\hat\mu_i^{(JS)}$`, it consists of shrinking the individual batting average of each player towards their grand average: in Efron's and Morris' words,

> if a player's hitting record is better than the grand average,  then it must be reduced; if he is not hitting as well as the grand average, then his hitting record must be increased.

The parameter `$c$` is used to move `$\hat\mu_i^{(\mathrm{JS})}$` between `$\hat\mu_i^{(\mathrm{MLE})}$` and the grand mean `$\bar\mu$`. If `$c=1$`, we end up with `$\hat\mu_i^{(\mathrm{JS})} = \hat\mu_i^{(\mathrm{MLE})}$` and no shrinkage is applied. So `$c=1$` corresponds to the arithmetic mean, which is the same as the MLE in this case. Stein's Theorem states that if `$c$` minimizes the mean squared error, then it must be the case that `$c<1$` and so it cannot be the arithmetic mean: `$\hat\mu_i^{(\mathrm{MLE})} \neq \hat\mu_i^{(\mathrm{MLE})}$`.

The particular value of `$c$` obtained with the formulas of James and Stein is `$c=.212$`, and since in our example the grand average is `$\bar\mu = .265$` we get
`$$
	\hat\mu_i^{(\mathrm{JS})} = .265 + (.212)(\hat\mu_i^{(\mathrm{MLE})} - .265)
$$`
Efron and Morris, in their [1975 paper](http://www.medicine.mcgill.ca/epidemiology/hanley/bios602/MultilevelData/EfronMorrisJASA1975.pdf), provide a very intuitive illustration of the effect of shrinkage in this particular example.

<div style="text-align: center">
<img src="JS-baseball3.PNG" alt="drawing" width="400"/>
</div>

As we can see, everyone is pulled by the grand average of batting averages. Coming back to 2018, let us look at what actually happened during the remainder of the 1970 season. The table's bold column provides the batting averages computed for the rest of the season. Let us say that those, which were often computed on more than 200 (new) times at bat, are good approximations of the *true/ideal* batting averages. It turns out that, for 16 of the 18 players, `$\hat\mu_i^{(\mathrm{JS})}$` actually does a better job than `$\hat\mu_i^{(\mathrm{MLE})}$` at predicting `$\mu_i$`, and a better job in terms of total squared error as well (see the table).

It can seem puzzling that, to estimate Clemente's batting average (the highest), using Alvis's batting average (the lowest) should help. According to our formulas, if Alvis' batting average `$\hat\mu_{\mathrm{Alvis}}^{(\mathrm{MLE})}$` was different, then our guess `$\hat\mu_{\mathrm{Clemente}}^{(\mathrm{JS})}$` for Clemente would be different as well (because `$\bar\mu$` would be different).

It becomes more intuitive when you realize that the value of `$c$` in our formula for `$\hat\mu_{i}^{(\mathrm{JS})}$` implicitly depends on `$n$`, the number of observations available to us. As `$n$` increases, the optimal value of `$c$` gets closer to `$1$`, and so less shrinkage is applied. Stein's Theorem states that `$c<1$` no matter what; yet, `$\hat\mu_{i}^{(\mathrm{MLE})}$` and `$\hat\mu_{i}^{(\mathrm{JS})}$` might be extremely similar. 

This last property of the James-Stein estimator is similar to that of bayesian estimators, which relies more and more on the data (and less on the prior distribution) as the number of observations increases. Indeed, Efron and Morris identified Stein's method, designed under a strictly frequentist regime, as an empirical Bayes rule (inference procedures where the prior is estimated from the data as well, instead of being set by the user). For more details on Stein's Paradox and its relation to empirical Bayes methods, I recommend you read the book [**Computer Age Statistical Inference: Algorithms, Evidence, and Data Science**](https://web.stanford.edu/~hastie/CASI_files/PDF/casi.pdf) by Efron and Hastie, which provides a nice historical perspective of modern methods used by statisticians and a gentle introduction to the *connections and disagreements* relating and opposing the two main statistical theories: frequentism and bayesianism.
