---
layout: post
title: "Minimum Viable Kubernetes for MVP ($100 per month)"
meta_description: Minimum Viable Kubernetes running on GKE for $100 per month
description: What is the minimum Kuberentes environment to deployment and run you node.js backend and frontend, while not breaking the bank
meta_keywords: post, kubernetes
tags: [kubernetes, node.js, bedrock]
category: [development]
image: tools_logos.png
image_s3: https://s3.eu-west-1.amazonaws.com/eu-west-1.beatletech.com/images/tools_logos.png
published: false
---

<img src="https://s3.eu-west-1.amazonaws.com/eu-west-1.beatletech.com/images/tools_logos.png" alt="Minimum Viable Kubernetes" width="80%" title="Minimum Viable Kubernetes"  style="margin-left:50px">

Introduction

Lots of discussion on whether or not to use K8s for startups and/or hobby projects. Too much complexity? Only relevant for bigger companies? Expensive?

Like an MVP (Minium Viable Product) for a startup, "a version of a product with just enough features to be usable by early customers who can then provide feedback for future"

### Minimum Viable Kubernetes (MVK)
What is the MVK (Minimum Viable Kubernetes), what is the minimum set of features your k8s cluster needs to provide in order to support your product (MVP). Unless you run a devops product, you like to spend most of your time on your product (not infra):
- Maintainable over time. Keep complexity as low as possible.
- enough resources to run your (node.js) Backend and frontend stack
- supporting multiple environments (staging, production)
- High availability is a nice bonus, but primarily I want fault tolerance to sleep like a prince at night.
- Last but not least, keep cost at a minimum too.

This blog: Both describe and provide templates and resources to setup you own MVK cluster with a Bedroock (Node.js + MongoDB) MVP. Plus Cost breadkdown (in GCP)


### GKE + Bedrock.io
* MaintainabilityRun a managed Cloud version. GCP GKE or AWS EKS. Why?
* add link to AWS EKS. But no free first cluster
* Environment per project ($70 cost per cluster)
* Availability (min 2 nodes), but GKE will recover failing node

[bedrock](http://bedrock.io)
[bedrock-cli](http://https://github.com/bedrockio/bedrock-cli)

{% highlight bash %}
$ curl -s https://install.bedrock.io | bash
$ bedrock create
{% endhighlight %}

`git clone git@github.com:beatlevic/bedrock.git`

---

### How-to Instructions

4 differences:
1. Namespaces: Production, Staging, Data and Infra
2. Gateways instead of Ingresses (VPC native loadbalancing)
3. config.json staging images GCR image prefix
4. Limits and resource quotas

#### Namespaces

`MONGO_URI`: `mongodb://mongo.data:27017/bedrock_production`

* environment node_pools vs namespaces

{% highlight yaml linenos %}
apiVersion: v1
kind: Namespace
metadata:
  name: production
{% endhighlight %}

{% highlight yaml linenos %}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: production # <= Added environment namespace
{% endhighlight %}

#### Gateway

{% highlight yaml linenos %}
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: external-http
  namespace: infra  # <= Gateway is deployed in infra namespace
spec:
  gatewayClassName: gke-l7-gxlb
  listeners:
    - name: http
      protocol: HTTP
      port: 80
      allowedRoutes:
        namespaces:
          from: All
  addresses:
    - type: NamedAddress
      value: external-gateway
{% endhighlight %}

{% highlight yaml linenos %}
kind: HTTPRoute
apiVersion: gateway.networking.k8s.io/v1beta1
metadata:
  name: bedrock-api
  namespace: staging
spec:
  parentRefs:
    - name: external-http
      namespace: infra # <= Gateway is deployed in infra namespace
  hostnames:
    - bedrock-api.beatlevic.dev
  rules:
    - backendRefs:
        - name: api
          port: 80

{% endhighlight %}

#### config.json

Staging [config.json](github.com:beatlevic/bedrock/deployment/environments/staging/config.json)

{% highlight json %}
{
  "gcloud": {
    "envName": "staging",
    "project": "hubristech",
    "gcrPrefix": "staging-",
    "dropDeploymentPostfix": true,
    "computeZone": "europe-west4-a",
    "kubernetes": {
      "clusterName": "cluster-1"
    },
    "label": "app"
  }
}

{% endhighlight %}

---

### Deployment

`curl http://bedrock-api.beatlevic.dev`

{% highlight json %}
{
  "environment": "staging",
  "version": "0.0.1",
  "openapiPath": "/openapi.json",
  "servedAt": "2023-03-20T09:49:51.520Z"
}
{% endhighlight %}

Open [bedrock.beatlevic.dev](https://bedrock.beatlevic.dev)

<img src="../../../images/bedrock-login.png" alt="End of first water fast" width="60%" title="Bedrock Login"  style="margin-left:150px">


### Cost breakdown

$100,- per momtn

<img src="../../../images/gcp-cost-breakdown.png" alt="Daily cost breakdown" width="100%" title="Daily cost breakdown"  style="margin-left:0px">

<img src="../../../images/gcp-cost-breakdown-sku.png" alt="Daily cost breakdown SKU" width="100%" title="Daily cost breakdown SKU"  style="margin-left:0px">

### Future work
- CICD (deploy to GKE from master)
- Hetzner MongoDB (12ms latency)
- LLM ChatGPT code generation
- Spot instances ($50 per month)

---

### Maybe?

* Folder structure of Bedrock (focus deployments). Screenshot vscode?
