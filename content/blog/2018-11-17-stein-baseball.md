---
title: Stein's paradox and batting averages
slug: stein-baseball
author: Samuel Perreault
description: "A simple explanation of Stein's paradox throught the famous baseball example of Efron and Morris (1975)"
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

Like Bradley Efron and Trevor Hastie, I think it's fair to say that maximum likelihood estimation (MLE) can arguably be considered as one the twentieth century’s most influential pieces of applied mathematics.  In their book **Computer Age Statistical Inference: Algorithms, Evidence, and Data Science** (Chapter 7), they write:

> If Fisher had lived in the era of “apps,” maximum likelihood estimation might have made him a billionaire.

The magic of maximum likelihood theory is that it provides (asymptotically, as `$n \to \infty$`) unbiased estimators attaining the Cramér-Rao bound. In other words, the MLE converges towards the most precise value one could hope. However, the story is quite different in the finite-sample situation and this is what Stein's paradox reminds us of: in some circumstance, the MLE is bound to be (potentially grossly) sub-optimal. Hence Hastie's and Efron's claim: "maximum likelihood estimation has shown itself to be an inadequate and dangerous tool in many twenty-first-century applications. [...] unbiasedness can be an unaffordable luxury when there are hundreds or thousands of parameters to estimate at the same time." So who is Stein and what exactly is Stein's paradox? Read on.

Stein's paradox is attributed to Charles Stein (1920-2016), an American mathematical statistician who spent most of his carreer at Stanford University. His work is exceptional yes, but Stein is also remembered by his colleagues for his strong belief in basic human rights and passionate social activism. In an ![interview](http://www2.ims.nus.edu.sg/imprints/interviews/CharlesStein.pdf) by Y.K. Leong, the first question he is asked concerns his statistical work (verifying weather broadcasts for understanding how weather might affect wartime activities) for the Air Force during World War II; Stein's first words are unequivocal:

> First I should say that I am strongly opposed to war and
to military work. Our participation in World War II was
necessary in the fight against fascism and, in a way, I am
ashamed  that  I  was  never  close  to  combat.  However,  I
have opposed all wars by the United States since then and
cannot imagine any circumstances that would justify war
by the United States at the present time, other than very
limited defensive actions.

According to ![Stanford News](https://news.stanford.edu/2016/12/01/charles-m-stein-extraordinary-statistician-anti-war-activist-dies-96/), the man who was called the “Einstein of the Statistics Department”, was also the first Stanford professor arrested for protesting apartheid and was often involved in anti-war protests.

On the math-stat side, Stein is the author of a very influential/controversial paper entitled *Inadmissibility of the Usual Estimator for the Mean of a Multivariate Normal Distribution* (1956). Bradley Efron and Carl Morris, who were strong supporters of Stein's idea, pinned the term Stein's paradox in their 1977 paper *Stein's Paradox in Statistics*. In it, they give a pretty intuitive description of the paradox to which we will go back:

> The best guess about the future is usually obtained by computing the average of past events. Stein's paradox defines circumstances in which there are estimators better than the arithmetic average.

A few years after Stein's original paper, the point was reinforced by himself and his graduate student, Willard James, when they publised *Estimation with quadratic loss* in 1961. There, they construct an estimator better than the arithmetic average *aka* the MLE. Hastie and Efron mark this point as the beginning of something: "It begins the story of shrinkage estimation, in which deliberate biases are introduced to improve overall performance, at a possible danger to individual estimates." Suprisingly, Stein's example takes place in a dimension as low as three.

For the rest of the post, I present the famous baseball example of Efron and Morris involving the batting averages (number of hits/number of times at bat) of 18 major-league baseball players. During the 1970 season, when top batter Roberto Clemente had appeared 45 times at bat, seventeen other players had 45 times at bat. The first column of the following table provides the batting averages for the eighteen players in question (reproduced with Professor Efron's permission, whom we would like to thank):

<div style="text-align: center">
<img src="JS-baseball2.PNG" alt="drawing" width="250"/>
</div>

Say we were at this exact time in 1970 when each of these players had 45 *at bats* and we wanted to predict the batting averages of each player for the remainder of the season. Without any more information, it seems natural to think that our best guess would have been their (then) present batting averages (the arithmetic averages given in the first column). Under a normal model, This is what the maximum likelihood estimation method would tell us. The second column provides the MLE for each player: this is just the first column expressed in decimal form. Let us define our "best guess" as the guess with smallest mean squared error, that is,

`$$
\mu_i^{(JS)} := {\rm argmin}_{\theta}\ \mathbb{E}_{\mathbf{X}}[(\mu_i - \theta)^2]
$$`

where `$\mathbf{X}$` is the available data (here the batting averages of the beginning of the season). Such loss function isn't crazy at all: we want `$\mu_i^{\rm (JS)}$` to be a formula of the past (`$\mathbf{X}$`) that would produce the best result (on average) if we were to reproduce that same experience every year (getting a new `$\mathbf{X}$` every time). In the above formula, `$\mu_i$` represents the *true/ideal* batting average of player `$i$` (may it exists), so we want our estimator to be close to it with high probability.

**Note**: The initials `${\rm (JS)}$` stand for "James-Stein".

What's nice about begin in 2018 is that we know what actually happened during the rest of the 1970 season. The bold column in the previous table provides the batting averages computed for the rest of the season. Let us say that those, which were often computed on more than 200 (new) times at bat, are good approximations of the *true/ideal* batting averages. Stein's method was used to produce the outmost right column. It consists of shrinking the individual batting average of each player towards their grand average: as Efron and Morris write,

> if a player's hitting record is better than the grand average,  then it must be reduced; if he is not hitting as well as the grand average, then his hitting record must be increased.

To do so, let `$\bar\mu = \sum_{i=1}^{18} \mu_i^{(\mathrm{MLE})}/18$` be the grand mean. One way to define a shrinkage estimator is
`$$
	\hat\mu_i^{(\mathrm{JS})} = \bar{\mu} + c(\hat\mu_i^{(\mathrm{MLE})} - \bar{\mu}),
$$`
where `$c$` is a constant we need to learn/estimate. The *shrinking process* towards the grand average is clear from the formulation of `$\hat\mu_i^{(\mathrm{JS})}$`, as we can use `$c$` to move `$\hat\mu_i^{(\mathrm{JS})}$` between `$\hat\mu_i^{(\mathrm{MLE})}$` and the grand mean `$\bar\mu$`. If `$c=1$`, we end up with `$\hat\mu_i^{(\mathrm{JS})} = \hat\mu_i^{(\mathrm{MLE})}$` and no shrinkage is applied. So `$c=1$` corresponds to the arithmetic mean. Stein's Theorem states that if `$c$` is such that `$\hat\mu_i^{(\mathrm{JS})}$` minimizes the mean squared error, then it must be the case that `$c<1$` and so it cannot be the arithmetic mean `$\hat\mu_i^{(\mathrm{MLE})}$`. 

The particular value of `$c$` obtained with the formulas of James and Stein is `$c=.212$`, and since in our example the grand average is `$\bar\mu = .265$` we get
`$$
	\hat\mu_i^{(\mathrm{JS})} = .265 + (.212)(\hat\mu_i^{(\mathrm{MLE})} - .265)
$$`
Efron and Morri, in their 1975 paper, provide a very intuitive illustration of the effect of shrinkage in this particular example.

<div style="text-align: center">
<img src="JS-baseball3.PNG" alt="drawing" width="400"/>
</div>

As we can see, everyone is pulled by the grand average of batting averages. It turns out that, for 16 of the 18 players, `$\hat\mu_i^{(\mathrm{JS})}$` actually does a better job than `$\hat\mu_i^{(\mathrm{MLE})}$` at predicting `$\mu_i$`, and a better job in terms of total squared error as well (see the table).

It can seem puzzling that, to estimate Clemente's batting average (the highest), using Alvis's batting average (the lowest) should help. According to our formulas, if Alvis' batting average `$\hat\mu_{\mathrm{Alvis}}^{(\mathrm{MLE})}$` was different, then our guess `$\hat\mu_{\mathrm{Clemente}}^{(\mathrm{JS})}$` for Clemente would be different as well (because `$\bar\mu$` would be different).

It becomes more intuitive when you realize that the value of `$c$` in our formula for `$\hat\mu_{i}^{(\mathrm{JS})}$` implicitly depends on `$n$`, the number of observations available to us. As `$n$` increases, the optimal value of `$c$` gets closer to `$1$`, and so less shrinkage is applied. Stein's Theorem states that `$c<1$` no matter what; yet, `$\hat\mu_{i}^{(\mathrm{MLE})}$` and `$\hat\mu_{i}^{(\mathrm{JS})}$` might be extremely similar. 

This last property of the James-Stein estimator is similar to that of bayesian estimators, which relies more and more on the data (and less on the prior distribution) as the number of observations increases. Indeed, Efron and Morris identified Stein's method, designed under a strictly frequentist regime, as an empirical Bayes rule (inference procedures where the prior is estimated from the data as well, instead of being set by the user). For more details on Stein's Paradox and its relation to empirical Bayes methods, I recommend the book *Computer Age Statistical Inference: Algorithms, Evidence, and Data Science* by Efron and Hastie, which provides a nice historical perspective of modern methods used by statisticians and a gentle introduction to the *connections and disagreements* relating and opposing the two main statistical theories: frequentism and bayesianism.
