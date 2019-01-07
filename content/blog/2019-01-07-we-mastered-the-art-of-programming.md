---
title: We Mastered the Art of Programming
author: Jean-Thomas Baillargeon
date: '2019-01-07'
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

## problem solving at it's finest

What is connecting the dot between all this, is the curiosity and the satisfaction of solving a problem, be it a computer problem. We make things work. This is how we get points on a school assignment. This is how our boss sees us as the achiever. This is how we create pure value. Based on this, it only makes sense that the faster you solve a computer problem, the better you are.

But no computer problem get stashed away once solved. They come back to haunt you and require adjusting the code so it fits the new constraints. Great a new problem! You have to find the fastest way to hack the code. This is fun until one or two things happen: the code you have to modify comes from a *bad* programmer or something breaks every time you modify something else. It will eventually work, but it’ll take a little longer than the previous iteration. This continues, you realise that the *bad* programmer is your past self from a few month ago and you fear modifying anything in the code since you have no faith this *Jenga* will hold at all.

Maybe if you took a little more time to think of how future you would feel using it things would have been different. Maybe you would have cleaned the code. Maybe you would have explicated the magic number (why divide by 8.2?). Maybe some side effects would have been commented. Well this is not important for now, because the code *works*.

But this did not apply to me. I could jump back in my code, read the witty comment I wrote and remember what dimension of the matrix `X` were represented by variable `i`, `j` and `k`. I had a bunch of smell tests that could let me know if I broke something. No really, I mastered the art of programming.

## Until one day.

I was working in a Tech Startup and my team was working on a shrimp detection model. We were a few guys with different backgrounds. Everyone were software engineers except for myself - I was an actuary with most statistical knowledge. We were pitted against one another to figure how to solve this problem. Plot twist. I was not the one achieving - and for reasons i was not even aware of.

It started pretty well. I quickly build a script that let me grab the data from an unstructured source and convert it to a structured format. I would then run some diagnosis to see any outliers or collinearity between features. Once the data was cleaned, another script generated a regression model using a step-wise algorithm. The model would be used to generate some predictions and save them into a file. The last script was doing some graph and some basic analysis. Pretty standard data science duty. The report was done deal and could quickly deliver some great results to the team.

This started as a one time analysis. Then we had to evaluate the evolution of the model. This became a weekly affair then daily one. The analysis were more complicated and the dataset got bigger and weirder. We cross-sectioned the data for certain shrimp providers, shrimp age, average size of shrimp, quality of water etc. The analysis were more complicated to perform and to present to the team. This is where I hit the wall. The software engineer guy was pumping his analysis a few hours before me, every day.

## Why isn't this working ?

This called for my problem solving skills. How can I achieve faster production? By better understanding what he was doing.

First thing I saw is the pre-processing step was nightly done by a robot. The second thing I saw was his cache, where all the data was ready for treatment and even intermediate values were calculated (for data grouping and other analysis). The third thing was the modeling part, where everything was so tightly bundled that he could multi-thread all different data cross-sections in one operation. The best part of all this - is all those things were done by 9 am when he arrived. Least to say that gave him plenty of time to work on his analysis.

I asked him if he could lend me a piece or two, so I can integrate them into my script. As a good teammate, he obliged and provided me with a chunk of code. My pride was hurt enough that I went back to my desk and worked on it by myself. It was a relatively big chunk of code, so I expected a proportionate effort to plug everything and test. I opened the code and could quickly locate the line that would require modification. The music of typing was flowing into my ears - yes I had my mechanical keyboard at that time. It took me around half an hour to do everything. I made it work without any unexpected side effects the first time I launched the script.

What a great modification done by a great programmer.

## Wait.

This is the moment the epiphany came. I was not the one doing a great job: my teammate was. He handed me some code that was so clean that anyone could modify anything, without unintended side effect in a very short period. It was some code he intended using for himself - not a curated version of some rushed out scripts. I experienced the holy grail of good code. I could not have achieved something this great, or nothing I’ve taught myself over the year could have helped me - but my teammate could.

That moment I realised that there were a lot of stuff I didn’t know that I didn’t know. As someone purely rational would do to overcome this lack of knowledge, I enrolled in a software engineering certificate. This allowed me to open a huge Pandora’s box that sprung a lot of ideas and concepts that were thought-provoking and mind breaking. I believe I’m a better programmer than I was and I believe I have the tools to be a better one tomorrow.

This articles is the first of many that will allow me to share those tools I found in that Pandora's box. These articles will be half philosophical and half technical. They will be centered around good practices in software engineering while sharing some of my experience coping with (really) crappy code base. Crappy code base that have been written by me, obviously.