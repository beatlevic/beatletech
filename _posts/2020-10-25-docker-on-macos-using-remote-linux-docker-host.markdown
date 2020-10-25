---
layout: post
title: "Docker on macOS using remote Linux Docker host"
meta_description: Docker on macOS using remote Linux Docker host
meta_keywords: post, beatletech, docker, remote, hetzner, bedrock
tags: [docker, hetzner, bedrock]
category: [development]
image: docker_logo.png
published: false
---

<img src="{{site.url}}/images/docker_logo.png" alt="Docker" width="30%" title="Docker"  style="margin-left:250px">

As a developer I'm a big fan of Apple hardware and software ever since I got my first Macbook back in 2008. MacOS is a UNIX operating system running on X86 hardware (changing to ARM soon, but more on that later) that makes developing for Linux production servers a smooth experience utilizing the same UNIX tooling. While my development stack changed over the years and nowadays includes Docker, Kubernetes and [bedrock.io](http://bedrock.io), MacOS still continues to serve me well. It is providing these new CLI tools and templates on a stable OS with little to no issues, a nice UI with great HIDPI scaling (rocking a LG 5K monitor over [here](https://beatletech.com/setup)), and of course I've become so used to the interface that switching back to Windows or Linux Desktop would mess up my optimized workflows and habits.

One thing however that could use improvements is Docker Desktop ([for mac](https://docs.docker.com/docker-for-mac/)), to increase Docker container performance, speed up docker build times and reduce CPU usage when running "idle". The reason for being slow and performance hungry is succinctly explained in [this Stackoverflow answer](https://stackoverflow.com/questions/55951014/docker-in-macos-is-very-slow):

> Docker needs a plain Linux kernel to run. Unfortunately, Mac OS and Windows cannot provide this. Therefore, there is a client on Mac OS to run Docker. In addition to this, there is an abstraction layer between Mac OS kernel and applications (Docker containers) and the filesystems are not the same.

In other words, there is a lot of extra (hyper)virtualization and filesystem overhead going on. Of course a relative performance hit (compared to running on Linux directly) is something I could live with, but my main annoyance presents itself loudly when I'm building (and deploying) a lot of Docker images: it spins up my Macbook pro CPU fans to audible levels, something in stark contrast to the absolute silence at which my laptop runs almost everything else (I guess I'm spoiled).

While you could argue that you should not build and push Docker images to staging or production from your local development machine and just incorporate it in your CI/CD pipeline, I prefer having this manual control, which is also nicely supported by the [bedrock.io](https://bedrock.io) build and deploy commands. This point probably warrants a whole dedicated blog post, but if you are like me, and also run a lot of docker build commands locally, then you will be interested in the solution I found to my **main problem: the lack of macOS docker performance and noisy CPU fans**.

### Apple Silicon

With myself being an Apple enthusiast, you can image why I'm excited about the upcoming transition from Intel CPUs to Apple Silicon, which is planned to make its debut in their Macbook Pro and iMac lineup later this year ([Rumors](https://9to5mac.com/2020/10/09/apple-silicon-november-bloomberg/) point to a November event). So at first I thought that the answer to the lackluster Docker performance on the Mac would simply be waiting for the new ARM hardware release and buying a new Macbook Pro. However, this might not hold true as Apple Silicon will be an ARM SoC, which is a different architecture than X86_64. And X86_64 is still my deployment target for the foreseeable future. In other words, I still need to build X86 images and this will requires emulation and virtualization that [some](http://www.ml-illustrated.com/2020/06/25/ARM-Macs-virtualization-different-take.html) are expecting to have a 2x to 5x performance hit.

It is also worth noting that Craig Federighi, Apple's senior vice president of Software Engineering, said the following during an interview after the initial WWDC Apple Silicon announcement:

> "Virtualization on the new Macs won't support X86 at all" ([source](https://www.jeffgeerling.com/blog/2020/what-does-apple-silicon-mean-raspberry-pi-and-arm64))

Craig even explicitly called out Docker containers being built for ARM, and being able to run them on ARM instances in AWS, but what about building your X86 images? I know you can build for multi-arch including ARM now with docker desktop ([post](https://www.docker.com/blog/multi-arch-images/)), but what will the performance hit be for Apple Silicon?

All in all, upcoming Apple Silicon doesn't seem like an immediate win for my specific problem with Docker performance. Also, I like to skip 1st gen hardware and wait on the sidelines a bit longer before I migrate my production workflows to new hardware running on ARM.

Luckily I did find a solution that serves me right away and might also help with the transition to Apple Silicon in the future. **Docker remote to the rescue!**

### Remote Docker host Solution

Instead of beefing up my local development machine now or with upcoming Apple ARM hardware, I looked into off-loading all the Docker activities onto a remote machine, and as it turns out, it is trivially easy to setup access to a remote docker host. I kinda knew about this, back when I was using Docker Swarm and connecting to different machines, but I somehow never thought about this as a setup for my "local" docker environment.

Needless to say, but one does not setup remote access without a remote machine, so I'm assuming you have a remote Linux machine running somewhere. I personally use and recommend dedicated or cloud servers from [Hetzner](https://www.hetzner.com/), that is if you are located in Europe. I'm using the [AX51-NVMe](https://www.hetzner.com/dedicated-rootserver/ax51-nvme) Dedicated Root Server (Ryzen 7 3700X CPU, 64GB RAM, 1TB NVMe SSD), which seems comically cheap at only 59 Euros a month. Anyway, let's get rolling.

#### 1. Install Docker Engine on remote host
First, let's install Docker on your remote Linux server (I'm using the [Ubunty install instructions](https://docs.docker.com/engine/install/ubuntu/), but there you can find instructions for other distros as well):

{% highlight bash %}
 ## Update the apt package index and install packages to allow apt to use a repository over HTTPS:
 $ sudo apt-get update

 $ sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg-agent \
     software-properties-common

 ## Add Docker’s official GPG key:
 $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

 ## Use the following command to set up the stable repository
 $ sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

 ## Install docker engine
 $ sudo apt-get update
 $ sudo apt-get install docker-ce docker-ce-cli containerd.io
{% endhighlight %}

#### 2. Create Docker Context

Next up we need to access the remote Docker host and make it our default "local" engine. For this we leverage **Docker Contexts** in the following way. First we create a context that will hold the connection path (e.g. `ssh://coen@whatever.com`) to the remote docker host:

{% highlight bash %}
 $ docker context create remote ‐‐docker host=ssh://coen@whatever.com
 remote
 Successfully created context “remote”

 $ docker context ls
 NAME       TYPE    DESCRIPTION              DOCKER ENDPOINT    KUBERNETES ENDPOINT    ORCHESTRATOR
 default *  moby    Current DOCKER_HOST...   unix:///var/run/docker.sock               swarm
 remote     moby                             ssh://coen@whatever.com
{% endhighlight %}

And the final step is to make `remote` your default context:

{% highlight bash %}
 $ docker context use remote
 remote
 Current context is now “remote”
{% endhighlight %}

#### 3. Using your remote Docker host

With the previous 2 steps you are ready to start enjoying a silent local development machine when you are building docker images and an increased speed in build time! Any time you now run `docker build`, all the relevant (and changed) files that are required for the build are copied from your local computer to the remote Docker host in the background, and the `docker build` starts the build of the image on the remote host. The resulting image is also located on the remote host, which you can list with `docker images`, as all docker commands use the default `remote` context.

### Benefits

To show you an example of Docker build speed improvements, let's have a look at the following time measurements for building the `web` service component, a React SPA build with Webpack, of [bedrock](https://github.com/bedrockio/bedrock-core/tree/master/services/web) on a clean install:

{% highlight bash %}
  +---------+-------------------+--------------------+------------+---------------+
  | Context | Yarn install time | Webpack build time | Total time | Relative time |
  +---------+-------------------+--------------------+------------+---------------+
  | Local   | 75.82s            | 82.05s             | 157.87s    | 296% (~3x)    |
  +---------+-------------------+--------------------+------------+---------------+
  | Remote  | 18.19s            | 35.11s             |  53.30s    | 100% (1x)     |
  +---------+-------------------+--------------------+------------+---------------+
{% endhighlight %}

Of course a 3x improvement doesn't come as a surprise when you are basically comparing a Macbook Pro with 2 (virtual) CPUs allocated to Docker, versus an 8 core dedicated Linux machine (with hyperthreading and higher internet bandwidth) even though not everything runs multi-threaded. But it is a big improvement that you can quickly and easily get for yourself to reap the benefits, which quickly adds up over time. Not to mention the complete silence at which you gain the increased build times.

As a bonus, you can now stop running Docker Desktop entirely, and no longer see a Docker process "idling" in the background that would otherwise still be using around 20% CPU all the time (doing nothing).

Being able to build X86_64 images on a remote machine, incidentally also makes it more viable to migrate my development environment to Apple Silicon in the future, not depending on Apple ARM to build and run my X86_64 images.

Finally, of course you can also `docker run` containers on your remote host. For example running MongoDB:

{% highlight bash %}
 $ docker run --name mongo -d -p 27017:27017 -v /root/data:/data/db mongo:4.2.8
 # Note: /root/data is located on your remote machine
{% endhighlight %}

In order to access and use the running MongoDB container locally, make sure to SSH tunnel to your remote machine and forward the relevant ports. For this you can update your SSH config file: `.ssh/config`:

{% highlight bash linenos %}
Host coentunnel
  HostName whatever.com
  User coen
  ForwardAgent yes
  ServerAliveInterval 60
  ServerAliveCountMax 10
  LocalForward 27017 localhost:27017 # Mongo
{% endhighlight %}

A big word of **caution** here is to make sure you firewall your ports properly on your remote server, because Docker is known to [bypass ufw firewall rules](https://github.com/docker/for-linux/issues/690)!!!

### Downsides

Using a remote Docker host works really well for me, but there are a couple of downsides to this approach:

The first one would be "added complexity & dependency", because now you have added an extra machine to your development environment that you need to keep up-to-date and secure. Especially if you also use it to `docker run` containers for local development.

Secondly, if you use `docker-compose` for local development (often used to inject your live code changes), then you cannot map your local drive into the docker containers, as the mounted volumes will be pointing to folders on your remote machine. You can find more information about how to deploy on remote Docker hosts with docker-compose [here](https://www.docker.com/blog/how-to-deploy-on-remote-docker-hosts-with-docker-compose/).

Last but not least, remote servers are not free, so there is an additional cost involved. However, as pointed out earlier, [Hetzner](https://hetzner.com) is a very cheap server provider you can use, or you can start with any other small cloud (AWS, Google, etc) instance. I guess that most developers actually already run a Linux box somewhere (often for testing).

### Wrap up

As an Apple enthusiast, I don't see myself switch to a local Linux development computer anytime soon, but I was kind of annoyed with the lack of macOS Docker performance and noisy CPU fans when building images.

Having a hard time believing that the upcoming switch to Apple Silicon will alleviate this issue (still hope for the best, but prepare for the worst), I was happy that I found a solution by introducing a remote Docker host, which was trivially easy to setup and use with Docker Contexts. Sometimes a small change can have a big impact.

IMHO the benefits I described in this article more than make up for the downsides. Hopefully this may benefit you too, but if you have any other suggestions or improvements, then please let me know!
