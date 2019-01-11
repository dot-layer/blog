---
title: "Is ethical AI possible in insurance ?"
author: Christopher Blier-Wong
date: '2018-12-07'
slug: ethical-ai-insurance
type: post
tags:
  - ethics
  - insurance
description: "A commentary on the Montréal Declaration for the 
insurance industry"
featuredpath: "img/headers/"
---

This week, the [Montreal Declaration for responsible AI development]
(https://www.montrealdeclaration-responsibleai.com/the-declaration) 
was released. The three main objectives are 

1. Develop an ethical framework for the development and deployment 
of AI;
2. Guide the digital transition so everyone beneﬁts from this 
technological revolution;
3. Open a national and international forum for discussion to 
collectively achieve equitable, inclusive, and ecologically 
sustainable AI development.

---

# What is insurance pricing ?

Insurance is based on the risk pooling principle. Since unforeseen 
events are impossible to predict and since they usually don't affect
everyone in the population at once, insurance companies may pool
risks together and minimise the variability of the collective risks. 
In other words, corresponds to the transfer of risk from the 
individual to the insurance company. 

Let $Y$ be the random variable representing total costs for a risk. 
Then, an individual may pay $E[Y]$ to an insurance company and since
the risk has been transfered, the individual has 0 variance and the 
insurance company holds $Var(Y)$ variance. 

I like to say actuaries were the first data scientists. They have 
been using statistical models (GLMs, mostly) for a while without 
much backlash, since the models are easily interpretable. The
recent raise in popularity of non-parametric statistical learning
models, like *SVMs*, *GBMs* or deep neural networks offer a much 
higher performance on prediction tasks. Howerver, the volume of data 
needed to train these models is very high and the models aren't 
easily interpretable.

# The role of segmentation in insurance pricing

What is segmentation.

Arthur Charpentier has a great series of example showing the impact
of segmentation in an insurance portfolio.

Segmentation is part of a critical process in insurance called ratemaking. This process involved the estimation of costs associated with transfer of risk. Actuaries are often assigned to the task of building adequate ratemaking process. The [Casualty Actuarial Society](https://www.casact.org/) proposed 4 principles associated with the ratemaking process:

- **Principle 1:** A rate is an estimate of the expected value of future costs. 
- **Principle 2:** A rate provides for all costs associated with the transfer of risk.
- **Principle 3:** A rate provides for the costs associated with an individual risk transfer.
- **Principle 4:** A rate is reasonable and not excessive, inadequate, or unfairly discriminatory if it is an actuarially sound estimate of the expected value of all future costs associated with an individual risk transfer. 

While studying the distribution of spatial autocorrelation in a home
insurance portfolio for a large property and casualty insurance
company Canada, I found that modeling spatial autocorrelation had 
significant improvements for the theft peril, which is inherently a
sociodemographic phenomenon. Therefore, could we say that using territorial 
segmentation for pricing the theft risk is acting in a discriminatory manner? I think it's fair to have this debate and the next section is intented to outline those gray zones that comes to my mind ...

# Key principles from de declaration affecting actuaries

The declaration outlined principles for the responsible development 
of artificial intelligence systems (AIS). In this section, I will
present the ones that I think affect insurance companies the most 
and provide a discussion. 

The Declaraion asks the reader to keep the following point in mind: 

> Although they are diverse, they must be interpreted consistently
to prevent any conflict that could prevent them from being applied. 
As a general rule, the limits of one principle’s application are 
defined by another principle’s field of application.

### Principle 4.6

> AIS should help improve risk management and foster
conditions for a society with a more equitable and mutual
distribution of individual and collective risks.

### Principle 5.2 

> The decisions made by AIS affecting a person’s life, quality of 
life, or reputation should always be justifiable in a language that 
is understood by the people who use them or who are subjected
to the consequences of their use. Justification consists in making
transparent the most important factors and parameters shaping
the decision, and should take the same form as the justification
we would demand of a human making the same kind of decision.

### Principle 5.3

> The code for algorithms, whether public or private, must always
be accessible to the relevant public authorities and stakeholders
for verification and control purposes. 

### Principle 6.1

> AIS must be designed and trained so as not to create, reinforce,
or reproduce discrimination based on — among other things —
social, sexual, ethnic, cultural, or religious differences. 

### Principle 8.3

> Before being placed on the market and whether they are
offered for charge or for free, AIS must meet strict reliability,
security, and integrity requirements and be subjected to tests
that do not put people’s lives in danger, harm their quality
of life, or negatively impact their reputation or psychological
integrity. These tests must be open to the relevant public
authorities and stakeholders. 

# Conclusion



# Sources

- https://www.montrealdeclaration-responsibleai.com/the-declaration
- https://f-origin.hypotheses.org/wp-content/blogs.dir/253/files/
2015/10/Risques-Charpentier-Denuit-Elie.pdf
- https://actuaries.asn.au/Library/Opinion/2016/BIGDATAGPWEB.pdf