---
title: We Mastered the Art of Programming
author: Jean-Thomas Baillargeon
date: '2019-01-21'
slug: we-mastered-the-art-of-programming
type: post
tags:
- software engineering
- best practices
description: ""
featured: "we-mastered-the-art-of-programming-cover.jpeg"
featuredpath: "img/headers/"
---

This is probably going to sound cliché and trivial but I just realised that I learned how to use a computer before learning to use a pen. I launched my favorite game on a MS/DOS terminal a few years before writing my name on paper.

This is cliché and trivial since this holds true for many of us data scientist growing up with a computer. We found a way to download music out of napster, limewire or torrents - whatever was working at that time. We figured how to burn our friends’ game on a CD-ROM and then crack it with a fake CD KEY. We learned how to repair the family’s printer. We understood how to connect our laptop to Eduroam. We made very serious and scientific calculations for school points. We then moved to a workplace where we grasp the depth of the `vLookup`. We connected thousands of *Excel* spreadsheets together. We mastered the art of programming.

## problem solving at it's finest.

What connects the dot between is the curiosity and the satisfaction of solving a problem, a computer problem. We make things work. This is how we get points on a school assignment. This is how our boss sees us as the achiever. This is how we create pure value. Based on this, it only makes sense that the faster you solve a computer problem, the better you are.

But computer problem seldom get stashed away once solved. They come back to haunt you and require adjustments to the code so it fits the new constraints. Great, a new problem! You have to find the fastest way to hack the code. This is fun until one or two things happen: either the code you have to revise comes from a *bad* programmer or something breaks every time you alter something else. It will eventually work, but it’ll take a little longer than the previous iteration. This continues, you realise that the *bad* programmer is your past self a few month ago and you fear modifying anything since you have no faith this [*Jenga*](https://secure.img1-fg.wfcdn.com/im/93997415/resize-h800%5Ecompr-r85/4885/48852016/Jenga%25AE+giant%25u2122+premium+jeu+de+bois+franc.jpg) will hold at all.

Maybe if you took a little more time to think of how future you would feel using it, things would have been different. Maybe you would have cleaned the code. Maybe you would have explained the [magic number](https://en.wikipedia.org/wiki/Magic_number_(programming)) (why divide by 8.2?). Maybe side effects would have been commented. Well this is not important for now, because the code *works*.

But this did not apply to me. I could jump back in my code, read the witty comment I wrote and remember what `i`, `j` and `k` represented in the  matrix `X`. I make functions, so I [don't repeat myself](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself). I had a bunch of smell tests that let me know if I broke something. No really, I mastered the art of programming.

## Until one day.

I was working in a [Tech Startup](https://www.xpertsea.com/) and my team was working on a shrimp detection model. We were a few guys with different backgrounds. Everyone was a software engineers except for myself; I was an actuary holding the most statistical knowledge. We were pitted against one another to solve this shrimp detection problem. Plot twist. I was not the successful one, for reasons I was not even aware of.

It started pretty well. I quickly build a script that let me grab the data from an unstructured source and convert it to a structured format. I would then run diagnosis to find any outliers or collinearity between features. Once the data was cleaned, another script generated a regression model using a step-wise algorithm. The model would generate predictions and save them into a file. The last script was doing graph and  basic analysis. Pretty standard data science duty. The report was done deal and I could quickly deliver great results to the team.

Then we had to evaluate the evolution of the model. This analysis became a weekly affair, then a daily one. Every day, the analysis got more complicated and the dataset got bigger and weirder. We cross-sectioned the data for certain shrimp providers, shrimp age, average size of shrimp, country, quality of water — name it. We changed the images processing method, we added countless custom features, we used various metrics, we corrected the dataset, etc. This is where I hit the wall. The software engineer guy was pumping his analysis a few hours before me, every day.

## Why isn't this working ?

This called for my problem solving skills. How can I achieve faster production? By better understanding what he was doing.

First thing I saw is the pre-processing step was nightly done by a robot. The second thing I saw was his cache, where all the data were ready for treatment and intermediate values were even pre-calculated (for data grouping and other analysis). The third thing was the modeling part, where everything was so tightly bundled that he could multi-thread all different data cross-sections in one operation. The best part of all this is — all those things were done by 9 am when he arrived. Least to say that gave him plenty of time to work on his analysis.

I asked him if he could lend me a piece or two to integrate them into my scripts. As a good teammate, he obliged and provided me with a chunk of code. My pride was hurt enough that I went back to my desk alone and worked on it by myself. It was a relatively big chunk of code, so I expected a proportionate effort to plug everything and test. I opened the code and could quickly locate the line that would require modification. The music of typing was flowing into my ears — yes I had my [mechanical keyboard](http://www.wasdkeyboards.com/index.php/products/code-keyboard/code-87-key-mechanical-keyboard.html) at that time. It only took me around half an hour to do everything. I made it work without any unexpected side effects the first time I launched the script.

What a great modification done by a great programmer.

## Wait.

This is the moment the epiphany came. I was not the one have been doing a great job: my teammate was. He handed me some code that was so clean that anyone could quickly modify anything without unexpected side effect. Everything was self-explanatory, no comments lying around, no arbitrary numbers. The code had the perfect vertical and horizontal length and my solarized theme made the code look like a work of art. I experienced, what I thought at that time was, the [holy grail of good code](https://coding2fun.wordpress.com/2017/02/08/how-to-design-reliable-scalable-and-maintainable-applications/).

## Different solutions.

First of all, there were things my teammate knew that I didn't know that I didn't know. Things like data pipeline, [design patterns](https://sourcemaking.com/design_patterns) and [principles](https://en.wikipedia.org/wiki/SOLID), unit testing, [clean code](https://en.wikipedia.org/wiki/Worship), software architecture, etc. These are the normal distribution for the actuary, the $(X'X)^{-1}$ for the statistician. The ground on which everything is build. Clearly my hacking and school background never prepared me for this.

My teammate had an holistic view of the problem. I was too busy *making things work* while my teammate was busy figuring *the best way* to make it work. This subtle difference is crucial. A good solution will make something work right now. The best solution makes something work right now AND consider the future user. Even if it means taking extra time to step back and build in the right direction.

Clearly no solution could (or should) have initially planted all the seeds for the craziness that came after the first request. But my stubbornness to produce a quick solution recycling my first approach without reconsidering possible paradigm shift in the problem doomed me in the long run.

## Clean slate.

I enrolled in a software engineering certificate to build a stronger foundation. This allowed me to open a huge Pandora’s box uncovering thought-provoking and mind breaking ideas and concepts. I believe I’m a better programmer than I was and I believe I have the tools to be a better one tomorrow.

This article is the first of many in which I will share those tools I found in that Pandora's box. These articles will be half philosophical and half technical. They will be centered around good practices in software engineering, while sharing my experience coping with (really) crappy code base. Crappy code base that had been written by me, of course.