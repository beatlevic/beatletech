---
layout: post
title: The post-Persgroep era
meta_description: The post-Persgroep era
meta_keywords: post, beatletech, https, setup, persgroep, startup, AI
tags: [work, development]
category: [work]
published: true
---

Last week I finished my job as Lead Data Engineer at the [Persgroep](https://persgroep.nl) in Amsterdam, where
I worked for the past year. I had a great time crafting ETL pipelines, writing Scala and Python for Spark (AWS EMR),
scheduling tasks (DAGs) with Airflow, and scaling with Redshift (Minus some boring, but important GDPR work).
But most of all I liked the (Kanban) team, which grew during my time from just 3 members to 15, and I enjoyed coaching
and helping out the new recruits, as well as providing technical support and architectural advise to other teams.

So why leave my esteemed colleagues, when everything is fine and dandy? Can Christian van Thillo really do
without me? (Better known by insiders as Christiaan van de Thillo). Well, I have this tendency to shake things up once
in a while, and I felt the need to explore new startup opportunities. So here we are, I cleared my schedule
for the next half a year, and will be diving into Strong-AI, Genomics, Crypto and Healthcare to find
interesting (and doable) business angles. First I like to explore the latest research and follow a couple of
Coursera courses, while simultaneously hack on some neural nets for crypto value predictions. In other words,
playing around until I hit something concrete and tangible. I have a couple of friends that also have
available overtime to join in on the fun. I'm also keeping an ear to the ground for any other opportunities in
these domains.

So what was the first thing I did last week with my free time? I updated my BeatleTech website, the site you
are actually reading right now! One of my TODOs was to run everything over https, now that Chrome by default
shows your website as not secure when it is served over http
([news](https://www.theverge.com/2018/2/8/16991254/chrome-not-secure-marked-http-encryption-ssl)). This was
relatively easy to fix thanks to [Let's Encrypt](https://letsencrypt.org/) and
[Certbot](https://certbot.eff.org/). As long as you know that Letsencrypt will verify your website over IPv6
if you added an AAAA DNS record, so make sure it points to the correct IPv6 address (mine wasn't :/ so I
dropped the incorrect AAAA record).

Secondly I was inspired by a Hacker News [discussion](https://news.ycombinator.com/item?id=17671490) on improving
your portfolio website, to include a section about my home office setup. I have spent many hours perfecting my
work setup, so it was only logical to also write about it. You can find it
[here](https://beatletech.com/Setup) and in the top menu.

Finally after cleaning up my HTML, upgrading Jekyll, minimizing assets and moving them to S3
([source](https://github.com/beatlevic/beatletech)), I'm concluding my stint on BeatleTech improvements with
this blog post. Next up, research and play time!

Wish me luck.

