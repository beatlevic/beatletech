---
layout: post
title: "Completed 4 Coursera courses"
meta_description: Four Cousera courses I have completed recently
meta_keywords: post, courses, learning, machine learning, bioinformatics, algorithms, education
tags: [learning, Coursera, education]
category: [education]
published: true
---

In the past couple of months I managed to complete 4 online courses on
[Coursera](http://coursera.com), which is an education platform that partners with top universities
to offer free [MOOCs](http://en.wikipedia.org/wiki/Massive_open_online_course) (Massive open online
courses). In this post I like to present you my experiences with these courses and my plans for any
future courses.

The reason for me to start following online courses has to do with what I already pointed out in my
previous blog post "[My System to Win Big](http://beatletech.com/2015/02/03/my-system-to-win-big)". I want to
keep on improving myself and acquire more knowledge in domains of my interest. Part of it is
revisiting knowledge I'm "supposed" to know to gain an even better understanding, and the other part
is exploring new uncharted territories. I also wanted to follow courses where I would have to
practice and hone my programming skills.

But why follow online courses with a rigid schedule and deadlines if you can simply study books or solve some tough problems on
[Project Euler](https://projecteuler.net/) at your own pace? Well, for me as it turns out, having a fixed
course schedule releases me of the burden of planning and serves as a nice stick to finish on time,
which made it easier to get into the habit of spending evening hours on education. This way I didn't
have to spend my will-power every time to get started, and now that I have grown this study habit and
with it the discipline to follow through, I'm in a much better position to also study at my own pace.

The courses for which I have received statements of accomplishment are in chronological order:

- [Machine Learning](https://www.coursera.org/course/ml)
- [Algorithms: Design and Analysis, Part 1](https://www.coursera.org/course/algo)
- [Bioinformatics Algorithms, Part 1](https://www.coursera.org/course/bioinformatics)
- [Learning How to Learn](https://www.coursera.org/course/learning)

In the subsequent sections I will describe each course in more detail.

### Courses
#### Machine Learning

**Overview:** *Stanford University // June-September 2014 // 12 weeks of study // 6 hours per week // [Coursera link](https://www.coursera.org/course/ml)*  
**Difficulty:** *Easy*

Half a year ago at [Bottlenose](http://bottlenose.com) I was shifting more from a Software Architect
role to a Data Scientist role, and therefore spending more time on Machine Learning problems. So I
thought it was valuable to refresh my knowledge in this particular domain. Besides reading up on
some study books I decided to enroll in the Stanford Machine Learning course, which presented a nice
overview with some basic programming exercises. Topics included (as listed on the Coursera page):

- Supervised learning (parametric/non-parametric algorithms, support vector machines, kernels,
neural networks).
- Unsupervised learning (clustering, dimensionality reduction, recommender systems, deep learning). 
- Best practices in Machine Learning (bias/variance theory; innovation process in machine learning and AI)

Given that I was already very familiar with these topics, combined with an excellent presentation by
the instructor [Andrew Ng](https://www.coursera.org/instructor/andrewng), it may not be a surprise that I found the
course easy to follow and the programming exercises not hard to implement with only the (frequent)
annoyances of coding in Matlab. 

It felt good to revisit all the topics in the course, which presented me once again the wide variety
of Machine Learning approaches and techniques. Perhaps in hindsight other specialized courses on
Machine Learning on a more graduate level would have been more worthwhile. However, I don't regret
my time spent on this course as it never hurts to go back to the basics once in a while.
Additionally, as this was my first online course, it was a great way to get started with Coursera
and familiarize myself with this new educational format. And after finding out that it
worked really well for me, I instantly signed up for a lot of other (more specialized) courses.

#### Algorithms: Design and Analysis, Part 1

**Overview:** *Stanford University // October-December 2014 // 6 weeks of study // 7 hours per week
// [Coursera link](https://www.coursera.org/course/algo)*  
**Difficulty:** *Medium*

After finishing the Machine Learning exercises in Matlab I wanted my next Coursera course to entail
a "real" and more interesting programming language, and at the time I was already reading up on two
other programming languages that I liked to put into practice, which were
[Julia](http://julialang.org/) and [Rust](http://www.rust-lang.org/).

I was already aware of the "Algorithms: Design and Analysis" class, which two of my friends already
completed and recommended, thereby making it interesting candidate. Having finished a similar
course (in Java) during my study at Delft University I thought this course would be a walk in the park and a
good playground for testing the waters with Julia and Rust. At the same time I was starting with the
"Bioinformatics Algorithms" class, which also focussed on implementing algorithms, but in the domain of biology
(more on Bioinformatics later). Both courses I started with Julia.

I can honestly say that I really like the Julia language, which was born out of its creators wish to
have a programming language that is:

> *... open source, with a liberal license. We want the speed of C with the
  dynamism of Ruby. We want a language that’s homoiconic, with true macros like Lisp, but with
  obvious, familiar mathematical notation like Matlab. We want something as usable for general
  programming as Python, as easy for statistics as R, as natural for string processing as Perl, as
  powerful for linear algebra as Matlab, as good at gluing programs together as the shell. Something
  that is dirt simple to learn, yet keeps the most serious hackers happy. We want it interactive and
  we want it compiled.  
  (Blog:  [Why we created Julia](http://julialang.org/blog/2012/02/why-we-created-julia/))*

The first week's programming assignment, a counting algorithm piggy backing on merge-sort, I also
implemented in Rust after finishing the Julia version. The Rust implementation was a painful
delivery, which was mostly me fighting the compiler and having a hard time finding clues on the web
due to a lot of breaking changes in Rust's development towards the 1.0 release version. Add to that
the resulting performance being slower than my Julia implementation, and I quickly decided to leave
Rust alone or at least until the language would be more stable (1.0 alpha was released Jan 2015).

While I was getting the hang of Julia, I also started exploring possibilities to introduce the
language at Bottlenose, but found the language too immature just yet (at version 0.3), especially
compared with Python and its vast amount of available (scientific) packages. While it would have
been interesting to complete the entire course in Julia, I deemed it more valuable to switch to
Python along the way and perhaps to revisit Julia again in a couple of years from now.

Let me now turn to the actual course contents after this (quite long)
Julia-Rust-experience-intermezzo. When I mentioned that I believed this course to be an easy ride, I
was actually quite mistaken. The lectures had a lot of technical and mathematical depth, and the
quizes were often very challenging. You simply cannot fly through this course without a good
understanding of the introduced concepts, which are luckily very well presented by the course
instructor [Tim Roughgarden](https://www.coursera.org/instructor/~214). All in all I can highly
recommend this course for both expert and aspiring computer scientists for learning (or revisiting) several
fundamental principles of algorithm design, and I'm looking forward in participating in Part 2 of
this course later this year.

#### Bioinformatics Algorithms, Part 1

**Overview:** *UC San Diego // October 2014 - Feb 2015 // 10 weeks of study // 10 hours per week //
[Coursera link](https://www.coursera.org/course/bioinformatics)*  
**Difficulty:** *Medium/Hard*

I always had a particular interest in genetics and biology in general, and if you combine this with
my interest in algorithms and Data Science, you can see why I had Bioinformatics high on
my wish list to dive into. Along came "Bioinformatics Algorithms" on Coursera and I could no longer resist
signing up and was eager to get started. The syllabus consists of chapters of
the interactive text book ["Bioinformatics Algorithms: an Active Learning Approach"](http://bioinformaticsalgorithms.com/):

- Where in the Genome Does DNA Replication Begin? (Algorithmic Warmup)
- How Do We Sequence Antibiotics? (Brute Force Algorithms)
- Which DNA Patterns Act As Cellular Clocks? (Randomized Algorithms)
- How Do We Assemble Genomes? (Graph Algorithms)
- How Do We Compare Biological Sequences? (Dynamic Programming Algorithms)
- Are There Fragile Regions in the Human Genome? (Combinatorial Algorithms)

In a way this was the "Algorithms: Design and Analysis" course all over again applied to the
biological domain. The practical applications of the algoritms really made this course stand out for
me, and made all algorithms more tangible. The interactive book accompanied by the online
lectures had great production value and introduced concepts and terminology very well.

The programming assignements throughout the book were the real meat of the course, and it is where
you will spend most (90%) of your time. Where most excerises were not too hard, there was still a
big chunk of problems that were very challenging. Sometimes due to the automated solution checker
that would be a bit too strict in the solutions it would accept (and no feedback on why you are
wrong), but mostly it were simply hard problems to solve. Once you went through the chapter and
finished all the exercises, the corresponding quiz was easy to do.

To get a statement of accomplishment you needed to score 70%, which is definitely doable. I went the
extra mile and focussed on scoring above 85% for an accomplishment with distinction, which meant no
hiding from the difficult parts. In the end I was very proud that I achieved my statement of
accomplishment with distinction.

I'm looking forward to part 2 of the course, which will start this month.

#### Learning How to Learn

**Overview:** *UC San Diego // January 2015 // 4 weeks of study // 2 hours per week // [Coursera link](https://www.coursera.org/course/learning)*  
**Difficulty:** *Very easy*

Really getting the hang of following online courses, wanted to make sure that what I learned would
not be in vain, i.e. ephemeral and quickly forgotten when moving onto other topics of interest.




### What's next?

In 2015 I want to at least take the following courses, of which the first two are continuations of
two courses I already completed:

- [Algorithms: Design and Analysis, Part 2](https://www.coursera.org/course/algo2)
- [Bioinformatics Algorithms, Part 2](https://www.coursera.org/course/bioinformatics2)
- [Probabilistic Graphical Models](https://www.coursera.org/course/pgm)

Additionally I'm looking forward to follow more courses specialized in the field of bioinformatics
(e.g. genetics, bio-medicine, evolution, neuroscience) and Data Science (mining datasets, pattern
discovery, advanced statistics)

Also want to finish Linear and Integer Programming, which I only completed 2/7 weeks and dropped due
to time constraints of other overlapping courses.

### Tips

Not too many courses at once

Find some friends => Study group => flow dock (ptegelaar, ncrombach)
