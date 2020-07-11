---
layout: post
title: Docker Build using remote Linux Docker host on MacOS
meta_description: Docker Build using remote Linux Docker host on MacOS
meta_keywords: post, beatletech, docker, remote
tags: [startup, docker, remote, hetzner]
category: [work]
published: true
---

### Why?
- in readiness for Apple Silicon
- Speed
- Silence

Improve build speed of docker imzges on my Macbook pro (quad-core).

Virtualization of X86_64 on Apple Silicon?

### How?

Docker Contexts

#### Docker compose
[How to deploy on remote Docker hosts with docker-compose](https://www.docker.com/blog/how-to-deploy-on-remote-docker-hosts-with-docker-compose/)


### Port forwarding

File: `.ssh/config`.

{% highlight bash linenos %}
Host beatletunnel
  HostName beatle.ai
  User coen
  ForwardAgent yes
  ServerAliveInterval 60
  ServerAliveCountMax 10
  LocalForward 5601 localhost:5601 # kibana
  LocalForward 9200 localhost:9200 # ES
  LocalForward 9300 localhost:9300 # ES
  LocalForward 27017 localhost:27017 # Mongo
{% endhighlight %}

### Autossh + Tmux

{% highlight bash %}
$ autossh beatletunnel -t "tmux -u new -As main"
{% endhighlight %}
