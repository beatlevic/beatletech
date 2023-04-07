---
layout: post
title: "Running your Startup on Kubernetes ($90 per month)"
meta_description: Minimum Viable Kubernetes running on GKE
description: Minimum Viable Kubernetes running on GKE
meta_keywords: post, kubernetes, k8s, node.js, startup, mvp, mvk
tags: [startup, kubernetes, node.js, bedrock]
category: [development]
image: tools_logos.png
image_s3: https://s3.eu-west-1.amazonaws.com/eu-west-1.beatletech.com/images/tools_logos2.jpg
published: true
---

<img src="https://s3.eu-west-1.amazonaws.com/eu-west-1.beatletech.com/images/tools_logos2.jpg" alt="Minimum Viable Kubernetes" width="80%" title="Minimum Viable Kubernetes"  style="margin-left:50px">

When you made the decision to start a Startup and begin working on your MVP (Minimum Viable Product), you at some point need to deploy and run your software somewhere to get your product in the hands of actual users. With their feedback you can iterate your product to find that precious product-market fit and become the next unicorn (or at the very least start making money instead of losing it).

While your MVP is often guaranteed to change drastically over time (even without pivots), a strong foundation will help you iterate faster and scale your product at a later stage without major rewrites. You primarily want to spend your time developing product features and squashing bugs, and not so much on devops and infrastructure (but still keep running costs to a minimum).

In this blog post I like to present what I consider a great foundation with templates to bootstrap your project, which runs on Google Cloud and Kubernetes (K8s). I know there is an ongoing discussion and heated debates about Cloud vs Dedicated servers, and why you should or shouldn't use Kubernetes for your business. Take for example [this](https://dev.37signals.com/bringing-our-apps-back-home/) recent post from 37signals, discussing their journey on and off the cloud, on and off Kubernetes. As always, it depends on your situation and your expertise, and I'm aware that I'm biased having used Google Cloud and Kubernetes a lot, but I hope that my experience and the [tools](http://github.com/bedrockio/bedrock-cli) and [resources](http://github.com/beatlevic/bedrock) that I'll share here, will help you hit the ground running and create a successful company.

#### Contents

- [Minimum Viable Kubernetes (MVK)](#minimum-viable-kubernetes-mvk)
- [Google Kubernetes Engine (GKE)](#google-kubernetes-engine-gke)
- [Project Template (Bedrock.io)](#project-template-bedrockio)
  - [Namespaces](#namespaces)
  - [Gateway and HTTPRoutes](#gateway-and-httproutes)
  - [Environment Configuration](#environment-configuration)
- [Deployment](#deployment)
  - [Bootstrap your Project](#bootstrap-your-project)
  - [GKE Workloads](#gke-workloads)
  - [Cloudflare DNS](#cloudflare-dns)
  - [Bedrock Dashboard](#bedrock-dashboard)
- [Cost breakdown](#cost-breakdown)
- [Resources](#resources)

---

### Minimum Viable Kubernetes (MVK)

I'm assuming here that you have heard of k8s and that you know that it is an open-source orchestration tool for containerized applications, originally developed at Google. In case you need an introduction or a refresher, I would refer you to their excellent [documentation](https://kubernetes.io/docs/home/).

Like the minimum set of features you define for your MVP, I like to start defining the minimum set of features you should expect to get from your k8s cluster, in other words, your Minimum Viable Kubernetes (MVK):
- **Flexibility**: Run any containerized (Docker) application or database. If your startup requires a high level of customization, then Kubernetes is great.
- **Scalability**: Scaling your application up and down based on CPU-usage. If your startup expects to grow rapidly, you can easily horizontally scale your load.
- **Load balancing**: Load-balance across pods and services
- **Self-healing and Auto-recovery**: High availability is a nice bonus, but one of my main goals in life is to sleep at night, so we want self-healing and restart containers and nodes that fail.
- **Easy deployment**: K8s comes with a great command line interface (CLI) to manage deployments, but I'll later introduce a great CLI wrapper ([Bedrock-CLI](#bedrockio)) that also helps in building (Docker) and provisioning (Terraform) your infrastructure and applications.
- **Future proofing**: Kubernetes has become the de facto standard for container orchestration.
- **Maintainable over time**: Yes, you can install and run Kubernetes everywhere, but k8s is quite complex with many running components (control plane nodes, compute nodes, scheduler, proxy networking, load balancers, kubelets, etc). Unless you have a dedicated team of devops people (which you don't, and if you have, congrats on securing your Series A investment!), I would stay away from installing and managing k8s on dedicated servers and instead choose a Cloud managed solution. This supports auto-upgrading to newer versions and making sure you run with the latest security fixes. In the next section I'll discuss why Google Cloud's GKE is the best option.
- **Low cost**: We always like to keep costs at a minimum too (traded off against gained features). Running in the Cloud is often synonymous with spending big bucks, but I'll show you that a production ready cluster can be had for $90 a month (or even $50 if you cheap out on compute resources).
- **Supporting multiple environments**: Last but not least, we like to support different environments (e.g, staging and production). Of course you can spin up a separate k8s cluster for each environment, but we already have **low cost** as a minimum feature, so I'll show you later how you can manage multiple environments with `Namespaces` and `Gateway` load balancers in a single cluster.

So now that we have defined our MVK, where running in the Cloud is a must, let's see why the Google Cloud managed solution (GKE) is the way to go.

---

### Google Kubernetes Engine (GKE)

Google Cloud Platform (GCP) offers a managed k8s solution which is called `Google Kubernetes Engine` (GKE). As noted earlier, Google is the birthplace of Kubernetes and they have over 15 years of experience running massive workloads. However, that doesn't mean Google is the only Cloud provider with a managed solution. Amazon Web Services (AWS) and Microsoft Azure both introduced managed clusters, as well as Digital Ocean and a long tail of other providers, adding to the immense growth and popularity of Kubernetes in the industry, overtaking other container orchestration tools like [Mesos](https://mesos.apache.org/) and [Docker Swarm](https://docs.docker.com/engine/swarm/), and being a cloud-agnostic alternative to their own vendor lock-in services like AWS ECS for example. A push in Hybrid-cloud and Multi-cloud environments further fueled the need for k8s, allowing you to run the same container everywhere.

I don't have much experience with Microsoft's AKS (Azure Kubernetes Service) or any with Digital Ocean's managed Kubernetes, but I have extensively used both EKS (AWS) and GKE (GCP). I know that choosing a Cloud provider often comes down to your personal preference and sticking to what you already know and have used before. When it comes to managed k8s however, I believe GKE is the clear winner for three main reasons:

1. **Usability**: The AWS UI console for EKS is nowhere near as clean as GKE. Giving users access to your cluster is painful and logging out of the box is terrible. GKE also has better support and flawless version upgrades. All in all AWS EKS gives me the feeling that they try to push you to use ECS instead. Comparing EKS and ECS is a whole topic on its own, but some limitations of ECS are:
  - You can only mount EFS volumes, which are not to be used to run stateful applications like databases. While EKS actually has EBS support.
  - No configMaps.
  - No init containers
  - No post-start or pre-stop hooks
  - AWS vendor lock-in
2. **Competitive Advantage**: GKE has features that are not available on other platforms, such as GKE Autopilot, which is a fully managed Kubernetes experience that eliminates the need for cluster management tasks such as node maintenance and upgrades. GCP has a strong focus on containerization which is evident in its portfolio of container-related services, including Cloud Run, Cloud Build, and Anthos. GCP also offers a range of integrated tools for monitoring, logging, and managing Kubernetes clusters, making it easier to manage and maintain Kubernetes workloads.
3. **Price**: While both GKE and EKS have a management fee of $0.10 per cluster per hour (~$72 per month), your first cluster in GKE is free of management charge. This is also the reason why we will create multiple environments in one GKE cluster, to avoid this fee (and additional node compute resources). GCP offers sustained use discounts, which can lead to significant cost savings for long-running workloads.

So for starters I would recommend GKE over EKS. GCP's pricing and integrated tools make it a more attractive option. If you were somehow determined to run on AWS, then I would still recommend running k8s over ECS, and migrate to GKE later ;) Both cloud providers also come with the additional benefit of getting access to a massive suite of other managed cloud services you can easily integrate with, like BigQuery, PubSub, VertexAI, and [many](https://cloud.google.com/terms/services) more. And before you start spending your own money on these services, don't forget to apply for [free credits](https://cloud.google.com/free) or in case you secured some funding, you might be eligible for the [startups cloud program](https://cloud.google.com/startup), which can cover up to $100,000 USD in Google Cloud credits in your first year.

One feature I like to highlight, which you get out of the box in the Cloud, but takes some effort  to setup yourself when running your own dedicated solution, are automated backups of your persistent (database) disks. You can provision your cluster (as we will see later) with a disk policy attached to your persistent volumes that runs (hourly) incremental snapshots. So from the get go you are safeguarded against data corruption, storage failures and coding/human mistakes like dropping the wrong collection (or for maximum damage the entire database).

Before diving into the tools to setup your own GKE cluster, I briefly like to mention one other alternative platform that is often used to build MVPs and that is the Platform as a Service (PaaS): [Heroku](https://www.heroku.com/platform). While it is super easy to get started with Heroku and get up and running quickly, you will also quickly ramp up the costs when you need more compute resources (and there no longer is a free tier). You can create your own estimates [here](https://www.heroku.com/pricing), but I ended up with an estimate that is at least 5 times higher for the same resources in Google Cloud. Besides the cost argument, I believe it is worth your time to learn k8s and GKE (even if you are a complete beginner) and not completely abstract away your infrastructure and limiting your flexibility and scalability in the future.

Next up, I'll provide a project template to setup you own GKE cluster with Bedroock.io (Terraform + Node.js + MongoDB).

---

### Project Template (Bedrock.io)

For creating your MVP and running it on GKE I like to introduce [Bedrock.io](http://bedrock.io), a platform template which was open-sourced over two years ago. Disclaimer, I'm one of the contributors, and it is the result of iterating over a decade on projects and platforms. This makes Bedrock a battle-tested collection of components, automation and patterns that allow you to rapidly build modern software solutions, tying together Node.js, MongoDB & React.

I would say Bedrock is ideally suited for startups and a strong foundation to build on. On the bedrock.io website you can find a great post on how to [deploy a production ready Kubernetes Node+React platform in under 15 minutes](https://blog.bedrock.io/deploying-a-production-ready-kubernetes-node-react-platform-in-under-15-minutes/). I will recapture some of those steps here, but also introduce some changes (that we are still planning to land in Bedrock). For your convenience I also included the Bedrock `From 0 to production` video (by [Dominiek](https://github.com/dominiek)) below, which is slightly outdated (from 2 years ago) but still nicely captures all the steps involved:

<iframe src="https://player.vimeo.com/video/443474352?h=0dc02d544a" width="100%" height="540" frameborder="0" allow="fullscreen; picture-in-picture" allowfullscreen></iframe>

All you need to get started is getting the [bedrock-cli](github.com/bedrockio/bedrock-cli) and creating your own bedrock project as follows:


```bash
$ curl -s https://install.bedrock.io | bash
$ bedrock create
```

Your bedrock project will be a Mono Repo that includes the following parts:

- [`deployment/`](https://github.com/beatlevic/bedrock/tree/master/deployment) - K8s (GKE) & Terraform deployment automation and playbooks.
- [`services/api`]((https://github.com/beatlevic/bedrock/tree/master/services/api)) - A Node.js API, enabled with authentication middleware, OpenAPI, Mongoose ORM and other best practices.
- [`services/web`](https://github.com/beatlevic/bedrock/tree/master/services/web) - A React Single Page App (SPA) that can interact with that API. Includes React Router, authentication screens, placeholder, API portal, dashboard and a repository of components and helper functions.
- Documentation for all aspects of your new platform (Github markdown)
- CI system. If besides Continuous Integration (CI) you also want to enable Continuous Deployment (CD), then you can extend the default Github actions with a [GKE deploy workflow](https://docs.github.com/en/actions/deployment/deploying-to-your-cloud-provider/deploying-to-google-kubernetes-engine#creating-the-workflow).

Currently the Bedrock template is designed to setup a separate GCP project (and hence separate GKE cluster) for each environment (e.g, staging and production). This is great to isolate the environments from each other, but for our startup we like to start with only one cluster to keep the costs down (and avoid the cluster management fee, remember that your first GKE cluster is free of the $0.10 an hour charge). In the next sections I'll walk you through the following changes you have to make in order to support multiple environments on one cluster:

1. **Namespaces**: Production, Staging, Data and Infra namespaces with limits and resource quotas.
2. **Gateway**: Using a Gateway with HTTP routes instead of Ingresses with VPC native loadbalancing.
3. **Environment configuration**: Updating the `config.json` for each environment, including the GCR image prefix and cluster details.

We plan to add a `Startup` starting template to Bedrock itself too (as an option during the CLI project creation), but until then, I created an example project ([repo](github.com/beatlevic/bedrock)) for you as a reference. You can checkout the project running the following, and replacing all mentions of project name `beatlevic` across the repo with your the name of your own created GCP project:

```bash
$ git clone https://github.com/beatlevic/bedrock.git
```

Or you `bedrock create` a new project and make the following changes yourself.

#### Namespaces

Kubernetes namespaces are a way to logically partition a Kubernetes cluster into multiple virtual clusters. Each namespace provides a separate scope for the resources in the cluster, including pods, services, and other objects. Namespaces can be used for a variety of purposes, such as:

- **Resource isolation**: Namespaces can be used to isolate resources between different teams or projects. In our case we will use separate namespaces for each environment, but also for shared `data` and `infra` namespaces.
- **Access control**: Namespaces can be used to control access to resources in the cluster. For example, you can use namespaces to restrict access to certain pods or services based on user or role.
- **Resource quotas**: Namespaces can be used to set resource quotas for the resources in the cluster. This can help prevent one team or project from monopolizing resources in the cluster.
- **Multitenancy**: Namespaces can be used to support multitenancy in the cluster. For example, you can create a separate namespace for each tenant or customer, which can be very important for a SaaS startup.

Kubernetes includes a default namespace that is used if no other namespace is specified. You can create additional namespaces using the Kubernetes API or the command line interface. In the bedrock k8s template you will four [templates](https://github.com/beatlevic/bedrock/tree/master/deployment/environments/production/namespaces) that will be created when you bootstrap the cluster. Resources in K8s are defined in YAML files, like for example the following definition for the [production](https://github.com/beatlevic/bedrock/blob/master/deployment/environments/production/namespaces/production.yml) namespace:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: production
```

To make sure all the production resources are running in the production namespace, you need to specify the namespace for each resource in the `metadata.namespace` field. For example the [API](https://github.com/beatlevic/bedrock/blob/master/deployment/environments/production/services/api-deployment.yml) deployment for production starts with the following:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: production # <= Added environment namespace
## ...
```

We can now also share a single Database (MongoDB) deployment between environments (each with their own database, i.e., bedrock_staging and bedrock_production) by running a Mongo deployment and Mongo service in the `data` namespace. We can then access the Mongo service from other namespaces (staging and production) by appending `.data` as a suffix to the service name. So the [MONGO_URI](https://github.com/beatlevic/bedrock/blob/master/deployment/environments/production/services/api-deployment.yml#L31) in the api-deployment environment variables becomes: `mongodb://mongo.data:27017/bedrock_production`.


Finally the `infra` namespace will contain infrastructure resources, i.e., `Gateway` and `HTTPRoutes`, for load balancing and making our services accessible to the public internet.

#### Gateway and HTTPRoutes

Default Bedrock uses [GKE Ingresses](https://cloud.google.com/kubernetes-engine/docs/concepts/ingress) for routing HTTP(S) traffic to applications running in a cluster. We can create separate ingresses for each environment, but each Ingress comes with its own load balancer that we have to pay for ($20 a month). However running a single Ingress will not work, because by default an Ingress does not have cross-namespace support. Luckily we can nowadays use a Gateway instead, which evolves the Ingress resource and does have cross-namespace support (and other improvements that I won't go into detail here).

To use a Kubernetes Gateway, we first need to define the `Gateway` object in our Kubernetes configuration. You can then define an `HTTPRoute` object to specify how incoming traffic should be routed to your services.

The [Gateway resource](https://github.com/beatlevic/bedrock/blob/master/deployment/environments/production/gateways/gateway.yml) is defined as follows (in the `infra` namespace):

```yaml
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: external-http
  namespace: infra  # <= Gateway is deployed in infra namespace
spec:
  gatewayClassName: gke-l7-gxlb # <= Global external HTTP(S) load balancer
  listeners:
    - name: http
      protocol: HTTP
      port: 80
      allowedRoutes:
        namespaces:
          from: All
  addresses:
    - type: NamedAddress
      value: external-gateway # <= Name of GCP global external IP address, defined with Terraform
```

Then within each namespace you create HTTPRoutes that bind to the Gateway to route traffic from, and define which Services to route to, and rules that define what traffic the HTTPRoute matches. Take for example the following [bedrock-api HTTPRoute](https://github.com/beatlevic/bedrock/blob/master/deployment/environments/production/gateways/bedrock-api-route-staging.yml) that routes traffic from `bedrock-api.beatlevic.dev` to the api service in the staging namespace:

```yaml
kind: HTTPRoute
apiVersion: gateway.networking.k8s.io/v1beta1
metadata:
  name: bedrock-api
  namespace: staging # <= HTTPRoute and api are deployed in the staging namespace
spec:
  parentRefs:
    - name: external-http
      namespace: infra # <= Gateway is deployed in the infra namespace
  hostnames:
    - bedrock-api.beatlevic.dev
  rules:
    - backendRefs:
        - name: api
          port: 80
```

#### Environment Configuration

One final (small) change we need to make is to the environment configuration of the staging environment. Each environment has its own `config.json` file to specify the GCP project and GKE cluster name. We just need to use the same values here as we do in the config for production, with only one additional variable that is setting the `gcrPrefix` to `staging-`. The reason for this is when we build and deploy a service using the bedrock cli (`bedrock cloud deploy production api`), it by default pushes to the Google Container Registry (GCR) and defines the specific registry for the service as follows: `gcr.io/<PROJECT>/<REPO>-services-<SERVICE>`, e.g., `gcr.io/beatlevic/bedrock-services-api` for the API service. We like to build separate images for production and staging, so the `gcrPrefix` adds an additional prefix to the registry name, e.g., `gcr.io/beatlevic/staging-bedrock-services-api` for the API staging docker image.

Staging [config.json](github.com:beatlevic/bedrock/deployment/environments/staging/config.json):

```json
{
  "gcloud": {
    "envName": "staging",
    "project": "beatlevic",
    "gcrPrefix": "staging-",
    "dropDeploymentPostfix": true,
    "computeZone": "europe-west4-a",
    "kubernetes": {
      "clusterName": "cluster-1"
    },
    "label": "app"
  }
}
```

---

### Deployment

#### Bootstrap your Project

Bootstrapping your project only requires you to follow 3 steps:

1. Create your own GCP project. Or you can use an existing one. In our example we use project `beatlevic`.
2. Clone and modify the [example repo](github.com/beatlevic/bedrock) to your liking, or start with creating a bedrock project on the command line with `bedrock create`, and adding the namespace, gateway and environment configuration changes.
3. Provision and bootstrap your cluster, services and other resources with one single command:

```bash
$ bedrock cloud bootstrap production <gcloud-project-name>
```

#### GKE Workloads

When the bootstrap command runs successfully and you also deployed the staging services (`bedrock cloud deploy staging`), you should be seeing the following workloads in the gcloud console (or run `kubectl get pods`):

<img src="https://s3.eu-west-1.amazonaws.com/eu-west-1.beatletech.com/images/bedrock-workloads.png" alt="Bedrock GKE workloads" width="80%" title="Bedrock GKE workloads"  style="margin-left:20px">

You can see three services (api, api-cli and web) for each environment and mongo (and mongo-backup for daily MongoDB dumps to bucket storage) in the data namespace.

#### Cloudflare DNS

We prefer to use Cloudflare DNS to proxy traffic from your domain to the Gateway IP. You can get your Gateway global IP by checking:

```bash
$ gcloud compute addresses list
NAME              ADDRESS/RANGE   TYPE      PURPOSE  NETWORK  REGION  SUBNET  STATUS
external-gateway  34.110.231.132  EXTERNAL                                    IN_USE
```

Then next, you enter the IP for each of the (sub) domains that you have, which need to be the same hostnames that use in your HTTPRoutes. So in my case, for the `beatlevic.dev` domain:

<img src="https://s3.eu-west-1.amazonaws.com/eu-west-1.beatletech.com/images/cloudflare.png" alt="Cloudflare DNS" width="100%" title="Cloudflare DNS"  style="margin-left:0px">

You can check if the api is running successfully by requesting or opening the api endpoint in your browser:

```bash
$ curl http://bedrock-api.beatlevic.dev
{
  "environment": "staging",
  "version": "0.0.1",
  "openapiPath": "/openapi.json",
  "servedAt": "2023-03-20T09:49:51.520Z"
}
```

#### Bedrock Dashboard

With everything running you can now check the web service (dashboard) by opening [bedrock.beatlevic.dev](https://bedrock.beatlevic.dev). There you should be greeted with a login/signup form.

<img src="https://s3.eu-west-1.amazonaws.com/eu-west-1.beatletech.com/images/bedrock-login.png" alt="Bedrock login screen" width="60%" title="Bedrock Login"  style="margin-left:150px">

---

You can login with the user/password combination as defined in the [api-cli](https://github.com/beatlevic/bedrock/blob/master/deployment/environments/production/services/api-cli-deployment.yml#L33) deployment (Note: I changed the credentials for my own deployment), which sets up fixtures (including users) on its first run.

<img src="https://s3.eu-west-1.amazonaws.com/eu-west-1.beatletech.com/images/bedrock-logged-in.png" alt="Bedrock products screen" width="100%" title="Bedrock Products"  style="margin-left:0px">

The bedrock [blog post](https://blog.bedrock.io/deploying-a-production-ready-kubernetes-node-react-platform-in-under-15-minutes/) goes a bit deeper into how you can make UI and API changes, and how you run things locally. However, it doesn't yet include the generator and scaffolding features (both for code and documentation) that we introduced over time, which is due for another blog post.

---

### Cost breakdown

Finally I'll conclude with the cost breakdown of running a single production ready GKE cluster for multiple environments. The production [config.json](https://github.com/beatlevic/bedrock/blob/master/deployment/environments/production/config.json) defines the cluster size and machine type that will be passed into the Terraform templates to provision your GKE cluster. I opted for machine type `n2d-standard-2`, which provides 2 CPUs and 8 GB of RAM, and costs $54,- monthly in the europ-west region including a sustained usage discount. It's not only the compute resource your have to pay for, but also the load balancers, traffic, reserved IPs and storage. GCP billing reports provide a great and detailed overview of your costs, so let's have a look at the past 30 days:

<img src="https://s3.eu-west-1.amazonaws.com/eu-west-1.beatletech.com/images/cost-breakdown.png" alt="Daily cost breakdown for the past 30 days" width="100%" title="Daily cost breakdown for the past 30 days"  style="margin-left:0px">

As you can see the total is E82,64 which translates to approximately **$90,- a month**.

You could even bring this number down by using half the compute resources and selecting for example machine type `n1-standard-1`, reducing the costs with $28,-, bring the total down to $62,-. If that initially works for you, then you can always increase the resources later (and the cluster will already add more nodes when you start requesting more resources), but I prefer to start with nodes that have a bit more memory as we are also running a (shared) MongoDb instance. Running in the European region is also slightly more expensive than in the US, so you can save a couple of percentages there.

You might be tempted to run on spot instances, which are are even cheaper, but those are only for batch jobs and fault-tolerant workloads, and you want some guarantees that your production system is available. It can however be viable to expand with node pools running on spot instances if you require more batchable compute resources over time.

But there you have it. Running your Startup MVP on Kubernetes for $90 per month, a solid foundation, ready to scale and take over the world!

---

### Resources

1. Bedrock CLI: [github.com/bedrockio/bedrock-cli](http://github.com/bedrockio/bedrock-cli)
2. Project template: [github.com/beatlevic/bedrock](http://github.com/beatlevic/bedrock)