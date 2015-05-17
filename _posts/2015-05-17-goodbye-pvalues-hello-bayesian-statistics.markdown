---
layout: post
title: Goodbye P-values, Hello Bayesian Statistics!
meta_description: Frequentism vs Bayesianism with Bayesian statistics winning
meta_keywords: post, Frequentism, Bayesianism, inferences, data analysis, statistics, p-values, OThot
tags: [OThot, statistics, bayesianism]
category: [statistics]
published: true
---

***Note: This is a repost of my original blog post at [OThot](http://www.othot.com/blog), where I work since January of 2015 as Senior Data Scientist.***

In statistics there is the old and ongoing debate of Frequentism versus Bayesianism, which has been humorously depicted in the following popular XKCD cartoon \[[1](http://www.xkcd.com/1132/)\]:

<img src="http://imgs.xkcd.com/comics/frequentists_vs_bayesians.png" alt="Frequentism vs Bayesianism" width="468" heigth="709" style="margin-left:100px">

In this cartoon we see the Frequentist statistician believing that the odds (p-value) of the
neutrino detector lying are below the (arbitrary) significance level of 0.05, saying that it is
unlikely that machine is lying, therefore concluding that the Sun must have exploded. The
Bayesianist on the other hand also takes his prior knowledge about the Sun into account and
determines that given the billions of years track record of the Sun not exploding vastly outweighs
the likelihood of the neutrino detector lying.

The use of explicit priors with Bayesianism versus implicit priors with Frequentism (yes there are
priors, but they are fixed), is one difference most statisticians know about. However there are
actually more subtle differences that carry big consequences that can sometimes lead to
contradictive conclusions between the two approaches.

The popular blogging site **"Pythonic Perambulations"** has a great series of technical posts that give
a practical introduction to Frequentism and Bayesianism \[[2](http://jakevdp.github.io/blog/2014/03/11/frequentism-and-bayesianism-a-practical-intro/)\], which are highly recommended. In this
series Jake Vanderplas explains with great clarity the differences, which are summarized as follows:

- Frequentists and Bayesians disagree about the definition of probability 
- Frequentism considers probabilities to be objective and related to frequencies of real or hypothetical events 
- Bayesianism considers probabilities to be subjective and measures degrees of knowledge or belief

As a result he explains: *"[..] frequentists consider model parameters to be fixed and data to be
random, while Bayesians consider model parameters to be random and data to be fixed."* \[[3](http://jakevdp.github.io/blog/2014/06/12/frequentism-and-bayesianism-3-confidence-credibility/)\]

This actually has far stretching consequences for the use of Frequentism in Science, where you most
often have one dataset (i.e., fixed data) for which you want to make inferences, and you are not
interested in inferences for hypothetical other datasets. Using Frequentism in science answers the
wrong question, because you want answers for your specific dataset. Therefore the use of p-values
and confidence intervals in this context are useless.

But you might ask, why then is the use of p-values the de facto standard in scientific research, if
it is fundamentally wrong? Good question. The problem is that confidence intervals are easy to
compute and often give similar results to the Bayesian approach. This doesn't change the fact that
the approach is flat out invalid, and doesn't support the conclusions made.

Recently the science community started acknowledging this fact and we are now starting to see
journals, e.g., **"Basic and Applied Social Psychology"** \[[4](http://www.tandfonline.com/doi/abs/10.1080/01973533.2015.1012991)\], where research using p-values is being
rejected. This has not gone unnoticed as both Nature, the international weekly journal of Science,
as well as Scientific American, wrote about it in depth and both proposed Bayesian statistics as a
good alternative. \[[5](http://www.nature.com/news/statistics-p-values-are-just-the-tip-of-the-iceberg-1.17412)\]\[[6](http://www.scientificamerican.com/article/scientists-perturbed-by-loss-of-stat-tools-to-sift-research-fudge-from-fact)\]

The Scientific American article adds the following about p-values, and confirms the aforementioned
hypothetical other datasets problem with Frequentism:

*"Unfortunately, p-values are also widely misunderstood, often believed to furnish more information
than they do. Many researchers have labored under the misbelief that the p-value gives the
probability that their study’s results are just pure random chance. But statisticians say the
p-value’s information is much more non-specific, and can interpreted only in the context of
hypothetical alternative scenarios: The p-value summarizes how often results at least as extreme as
those observed would show up if the study were repeated an infinite number of times when in fact
only pure random chance were at work. This means that the p-value is a statement about imaginary
data in hypothetical study replications, not a statement about actual conclusions in any given
study"* \[[6](http://www.scientificamerican.com/article/scientists-perturbed-by-loss-of-stat-tools-to-sift-research-fudge-from-fact)\]

Needless to say, but at [OThot](http://www.othot.com) we are big proponents of the Bayesian approach for statistical inferences. In a previous blog post by Mark Voortman \[[7](http://www.othot.com/what-do-searching-for-a-plane-and-a-doctors-diagnosis-have-in-common)\], we already started talking and explaining the Bayesian approach and you can safely bet to expect more of that. 

#### Sources

[1] XKCD: Frequentists vs. Bayesians [http://www.xkcd.com/1132/](http://www.xkcd.com/1132/)

[2] Frequentism and Bayesianism: A Practical Introduction
[http://jakevdp.github.io/blog/2014/03/11/frequentism-and-bayesianism-a-practical-intro/](http://jakevdp.github.io/blog/2014/03/11/frequentism-and-bayesianism-a-practical-intro/)

[3] Frequentism and Bayesianism III: Confidence, Credibility, and why Frequentism and Science do not Mix
[http://jakevdp.github.io/blog/2014/06/12/frequentism-and-bayesianism-3-confidence-credibility/](http://jakevdp.github.io/blog/2014/06/12/frequentism-and-bayesianism-3-confidence-credibility/)

[4] Journal of Basic and Applied Social Psychology [http://www.tandfonline.com/doi/abs/10.1080/01973533.2015.1012991](http://www.tandfonline.com/doi/abs/10.1080/01973533.2015.1012991)

[5] Statistics: P values are just the tip of the iceberg [http://www.nature.com/news/statistics-p-values-are-just-the-tip-of-the-iceberg-1.17412](http://www.nature.com/news/statistics-p-values-are-just-the-tip-of-the-iceberg-1.17412)

[6] Scientists Perturbed by Loss of Stat Tools to Sift Research Fudge from Fact [http://www.scientificamerican.com/article/scientists-perturbed-by-loss-of-stat-tools-to-sift-research-fudge-from-fact](http://www.scientificamerican.com/article/scientists-perturbed-by-loss-of-stat-tools-to-sift-research-fudge-from-fact)

[7] What Do Searching For a Plane and a Doctor’s Diagnosis Have in Common? [http://www.othot.com/what-do-searching-for-a-plane-and-a-doctors-diagnosis-have-in-common](http://www.othot.com/what-do-searching-for-a-plane-and-a-doctors-diagnosis-have-in-common)

