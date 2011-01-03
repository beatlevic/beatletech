---
layout: post
title: "BeatleTech generated with Jekyll"
meta_description: BeatleTech is generated with jekyll and the source code can be found on github.
meta_keywords: post, jekyll, ruby, html, generation, web-development, static, site, html5
category: [web-development]
---

When I started with the creation of BeatleTech.com and blog, I didn't
want to rely on Wordpress (or others) as I wanted more flexibility and
control, and I definitely didn't want to separate the blog from the main site,
i.e. linking to a blog on Posterous.

So my initial plan was to build the site in clojure, given a nice
online clojure blog example, Brian Carper's <a href="https://github.com/briancarper/cow-blog">Cow-blog</a>.
However, shortly after having started, my friend Jeff Rose introduced
me to <a href="https://github.com/mojombo/jekyll">Jekyll</a>, which is
a blog-aware, static site generator in Ruby. It allows for templating,
and uses Disqus for showing a dynamic javascript blog. Generating a static
site allowed me to copy all the html files to my Transip webhosting
server, and thereby keeping it extremely low cost. Running a clojure
site on Google App Engine could have been a good alterative, but I
liked giving Jekyll a try. It turned out to be very easy and already has tons of
examples online to check out. I also put the source code of BeatleTech
on <a href="https://github.com/beatlevic/BeatleTech">Github</a> for sharing, and hope it could be of any use for you.

So if you are looking for a way to create your website-blog and
(just like me) already paid for webhosting, which sadly only allows you to do some php
wizardry, then rest assured as Jekyll can save your day.



