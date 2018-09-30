---
title: Our day at OTTHAC18
author: dot-hockey #Philippe Blouin-Leclerc; Antoine Buteau; Stéphane Caron; Samuel Perreault
date: '2018-09-16'
slug: our-day-at-otthac18
type: post
tags:
  - hockey analytics
description: ""
featured: "otthac18-cover.png"
featuredpath: "img/headers/"
---

For any die-hard hockey fan, September 13th will be remembered as the day Erik Karlsson was traded by the Sens to the Sharks, and not without controversy, as it seems Ottawa got less for Karlsson than they gave to acquire Duchesne earlier this year. It turns out that the 4th Annual Ottawa International Hockey Analytics Conference (OTTHAC18), again held at Carleton University, was scheduled on the following weekend (September 14th and 15th, 2018). We couldn't get there for the workshop and activities of Friday, but made the trip on Saturday to get a glimpse of what is going on in the hockey analytics community and, of course, hear what the folks in Ottawa thought about the most recent trade activity in the NHL. The day was packed with presentations, interviews and panels. Notable speakers and attendees were, among others, Rob Vollman (author of the book *Stat Shot*), Micah Blake McCurdy (hockeyviz.com) and Elias Collette (consultant for the Ottawa Senators). You can see the full schedule by following this [link](http://statsportsconsulting.com/main/wp-content/uploads/OTTHAC18Schedule_0907.pdf). Here are the highlights of our day (in no particular order).


## What if Oscar Klefbom didn't get injured?

Tyrel Stokes' (McGill University) presentation, entitled *Estimating the Causal Effect of Injury on Performance* focused on the question: What would the world look like if someone wouldn't have gotten injured? And then what happens when someone gets injured? His prime example was Oscar Klefbom, who missed 52 games during the 2015-2016 season. Klefbom is a great example because he got injured during his second season in the NHL, here's why this is interesting. If you compare Klefbom's stats from before and after his injury, it seems clear that he got better. The injury made him better? Of course not. Any serious analysis needs to take into account that Klefbom got older, stronger, more confident, and so on. The real question is: how did the injury changed his progression? The conclusions are that injuries do indeed have a large short-term effect, but a small long-term effect. I will spare you the details about how these conclusions are reached, but the idea is that the progression of players is modeled using a random walk (with potential jumps).

Speaking of *what ifs*, what if Lemieux didn't get injured? Tyrel doesn't answer that question, but has lots to say about the comparison between Lemieux and Gretzky. If you're interested, check out his blog [Stats by Stokes](https://statsbystokes.wordpress.com).


## The rise of artificial intelligence

It's hard to have a conversation about AI in hockey (and sports in general) without mentionning the Montreal-based company SPORTLOGiQ. Well, now everytime someone will mention SPORTLOGiQ to us, we'll think about Campbell Weaver, who's building his own player tracking algorithm. Using *deep convolution neural networks* (with Keras), Campbell's objective is to track players' movements on the ice, so that others can compute more insightful stats and patterns: record time spent in each zone, analyze a player's tendencies on the ice, investigate the positioning at the time of goals for/against, assess the effectiveness of specific plays such as PP entries... I think you see the point. He's gotten quite far for someone saying he's just trying to learn. To his own admission, his algorithm wasn't exactly on point yet, but there's no doubt that the potential is there.

Campbell's now beginning a master's degree in artificial intelligence, so there's no guarantee that he will find the time to advance his project as much as he would like in the next year or so, but check out his github repo https://github.com/ccweaver1/bsi_vision to see how the project is evolving.


## Speaking of SPORTLOGiQ...

There was (at least) one representative from SPORTLOGiQ, David Yu, who presented a very nice poster entitled *Analysis of team level pace of play in hockey using spatio-temporal data*. I don't think I can explain what this is about better the the poster itself so here it is:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">To wrap things up, here&#39;s my full poster for those interested and/or following at home. Curious what the broader <a href="https://twitter.com/hashtag/hockey?src=hash&amp;ref_src=twsrc%5Etfw">#hockey</a> <a href="https://twitter.com/hashtag/analytics?src=hash&amp;ref_src=twsrc%5Etfw">#analytics</a> community thinks of this work. <a href="https://twitter.com/hashtag/OTTHAC18?src=hash&amp;ref_src=twsrc%5Etfw">#OTTHAC18</a> 🏒🥅 <a href="https://twitter.com/SPORTLOGiQ?ref_src=twsrc%5Etfw">@SPORTLOGiQ</a> <a href="https://t.co/Bs24woHPZJ">pic.twitter.com/Bs24woHPZJ</a></p>&mdash; D. David Yu (@yuorme) <a href="https://twitter.com/yuorme/status/1041381948344557568?ref_src=twsrc%5Etfw">September 16, 2018</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Yu's poster. (I will send him an email to ask if we can show his poster here).


## Hockey in space?


One thing I will remember from Devan Becker (University of Western Ontario) presentation called *Hockey in Space: Characterizing team-wise differences in shot locations with spatial point processes* is the fact that there is more and more data available from NHL APIs. By using shots taken locations, we saw the differences from where the NHL teams are mainly shooting on the ice. The speaker also showed us a nice [application](https://dbecker.shinyapps.io/LGCP_Results/) he built using the cool R package [Shiny](https://shiny.rstudio.com/).

Using that web application, we can have a quick idea of where the shots are coming for a specific, but also what is the variance for each spot densities. One may think that kind of viz could be very useful to get some quick insights about other teams strategies, weaknesses, etc .. Interesting ! :clap: :clap:

## How fairly compare Malkin and McDavid?

It's no secret, we are in the age of data. In fact, we collect and treat more and more data everywhere. Now that we have access to more data, basic statistics in hockey such as shots, goals or assists could now be view treated in different contexts. The idea of adding more context around data is really exciting and it was nearly the main idea I kept from Micah Black McCurdy talk. The subject of his talk [Isolating Individual Skater Impact on Team Shot Quantity and Quality](http://hockeyviz.com/static/pdf/otthac18.pdf) talks for itself: we want to isolate the contribution of a player in a given team.

To illustrate the idea, imagine you wanna compare Evegni Malkin and Connor McDavid. Broadly speaking, the former had 1.21 pts/games in the last 2 NHL seasons while the latter had 1.27. Not a large difference actually ... but what about the teammates both players had? What about the opposition both have faced? When we take into account all the different contexts around those two players, maybe the difference become much larger? In his work, Micah proposed different contexts such as :

- teammates: playing with good players or not?
- competition (opposing players): playing against good players or not?
- score impact: playing in a team that always trail or not?
- zone impact: playing most of his time in offensive or defensive zones?

I'll avoid the technical details about his method, but you can find some details by following the link (above) to the presentation. I also stringly encourage you to take a glimpse at his results, really interresting to see which players look good and which look bad in each context described earlier. You may even be surprised to see that Sidney Crosby is not the best 5v5 net top performer in the league ... :anguished: :anguished: :anguished: 

## Final word

Of course, this was just a small part of what happened on Saturday, and we're sorry we couldn't summarize it all because most of it was pretty interesting. Omitted (but still worthy!) presentations treated the questions of how to best qualify the pace of play (Tim Swartz); how to identify exceptional players (Yejia Liu, Simon Fraser University); concussions and dementia (Lili Hazrati, The Hospital for Sick Children); and the hot hand theory in hockey (Likang Ding). There were also multiple panels/interviews with hockey experts. This is where the Karlsson saga popped all the time. Panelists/experts that identified themselves as Sens fans appeared quite disappointed (to say the least), but most of them seemed to agree on one thing: it's time for a rebuilding phase in Ottawa: invest in young players and show patience. The only problem is that Ottawa gave away their first-round pick for the 2019 draft in the Duchesne trade (to Colorado). Chances are that Joe Sakic was smiling when he heard about the Karlsson trade...




