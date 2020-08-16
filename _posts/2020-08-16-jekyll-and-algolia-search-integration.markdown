---
layout: post
title: Jekyll and Algolia search integration
meta_description: Jekyll and Algolia search integration
meta_keywords: post, development, javascript, Jekyll, Algolia
tags: [javascript, jekyll, algolia]
category: [development]
image: jekyll-and-algolia.png
published: true
---

<img src="{{site.url}}/images/jekyll-and-algolia.png" alt="Algolia" width="98%" title="Jekyll and Algolia" style="margin-left:0px">


Recently I decided to add search functionality to my [BeatleTech](https://beatletech.com) site (indeed, the one you are visiting right now). Not because I needed my readers to filter through the overwhelming number of articles I have written here (which I have not), but simply because I thought it would be a cool feature that would bring some nice interactivity to the site and to spark my ambition to write more blog posts going forward.

In this article I will explain **why** I picked [Algolia Search](https://www.algolia.com/) and **how** it was integrated with this [Jekyll](https://jekyllrb.com/) generated static site, including some interesting improvements.

### Why Algolia Search?

While tinkering a bit with the design and layout of this site during a rainy day at a Dutch campsite, I was looking for an easy Jekyll plugin to bring search to my website. Although I have a lot of experience in working directly with [Elasticsearch](https://www.elastic.co/), I didn't want to go down a route of building and deploying everything from scratch. While certainly a nice exercise, this would definitely take too much time and maintenance down the line, which wouldn't be worth it (yet) looking at the traffic statistics. So, like I said, looking for something easy and quick to get up and running within a day.

After some Google search queries, I quickly stumbled upon some people recommending Algolia at the [Jekyll talk](https://talk.jekyllrb.com/t/how-to-add-a-search-bar/606/7) discussion board.

Digging into Algolia, I found the following compelling reasons to integrate with Algolia Search:
- **Known brand**. It turns out I was already quite familiar (and satisfied) with Algolia Search as a consumer of [Hacker News Search](https://hn.algolia.com/) which is powered by Algolia.
- **Free tier**. They recently (July 1st) introduced more [customer-friendly pricing](https://blog.algolia.com/introducing-algolias-most-customer-friendly-pricing/) with a starting free tier as long as you would show the "Search by Algolia" next to your search results. Also with reasonable pricing when I need to scale up.
- **Great documentation**. Their [Getting started](https://community.algolia.com/jekyll-algolia/getting-started.html) is clear, complete and up-to-date.
- **Open source**. [Jekykll Algolia Plugin](https://github.com/algolia/jekyll-algolia) for indexing Jekyll posts
- **UI Template**. Template with UI component using [instantsearch.js](https://community.algolia.com/instantsearch.js/)
- **Example project**. Github project [jekyll-algolia-example](https://github.com/algolia/jekyll-algolia-example)

### How to integrate Algolia and Jekyll?

To integrate with Jeyll we first need to install and run the [jekyll-algolia-plugin](https://github.com/algolia/jekyll-algolia) to push the content of our Jekyll website to our Algolia index. Secondly we need to update our HTML with templating and [Instantsearch.js](https://community.algolia.com/instantsearch.js/).

#### 1. Pushing content to your Algolia index

This is a simple three step process, as lined out in the README of the [jekyll-algolia-plugin](https://github.com/algolia/jekyll-algolia) repository. First add the jekyll-algolia gem to your Gemfile, after which you run `bundle install` to fetch all the dependencies:
{% highlight ruby linenos %}
  # Gemfile

  group :jekyll_plugins do
    gem 'jekyll-algolia', '~> 1.0'
  end
{% endhighlight %}

Next, add your `application_id`, `index_name` and `search_only_api_key` to the Jekyll `_.config.yml` file:
{% highlight yaml linenos %}
  # _.config.yaml

  algolia:
    application_id: 'your_application_id'
    index_name: 'your_indexname'
    search_only_api_key: '2b61f303d605176b556cb377d5ef3acd'
{% endhighlight %}

Finally, get your private Algolia admin key (which you can find in your Algolia dashboard) and run the following to execute the indexing:
{% highlight bash %}
$ ALGOLIA_API_KEY='your_admin_api_key' bundle exec jekyll algolia
{% endhighlight %}

#### 2. Adding instantsearch.js to the front-end

For the front-end part I followed the excellent Algolia community [tutorial](https://community.algolia.com/jekyll-algolia/blog.html). Instead of repeating all the documented steps here, I'll only highlight the relative changes I made.

The integration consists of two parts:
- A `search-hits-wrapper` div element where we load the search results. These results are located front and center under the navigation bar (pushing the rest of the content down).
- The instantsearch.js dependency, template configuration and styling. All of which is located in the `_includes/algolia.html` file, which can be viewed in full in the [source code](https://github.com/beatlevic/beatletech/blob/master/_includes/algolia.html) of this site.

I made the following 4 changes compared to the community tutorial:
- **Hide Search results by default (style="display:none") and don't fire off an empty query that returns all articles.** The default empty query returns all articles and to mitigate this I added a `searchFunction` to the instantsearch options:

{% highlight javascript linenos %}
  const search = instantsearch({
    appId: "{{ site.algolia.application_id }}",
    apiKey: "{{ site.algolia.search_only_api_key }}", // public read-only key
    indexName: "{{ site.algolia.index_name }}",
    searchFunction: function (helper) {
      var searchResults = document.getElementById("search-hits-wrapper");
      if (helper.state.query === "" && searchResults.style.display === "none") {
        return;
      }
      searchResults.style.display = helper.state.query ? "block" : "none";
      helper.search();
    },
  });
{% endhighlight %}

- **Don't fire off a query on every keystroke.** While the default of triggering a search query with every keystroke is great in terms of responsiveness, it will also help you burn quickly through your free 10k search requests. In order to trade off query responsiveness for less api requests, I added the following `queryHook` with a 500ms delay:

{% highlight javascript linenos %}
  search.addWidget(
    instantsearch.widgets.searchBox({
      container: "#search-searchbar",
      placeholder: "Search into posts...",
      poweredBy: false,
      showLoadingIndicator: true,
      queryHook(query, refine) {
        clearTimeout(timerId);
        timerId = setTimeout(() => refine(query), 500);
      },
    })
  );
{% endhighlight %}

- **Show "Search by Algolia" badge.** If you want to make use of the free plan, they ask you in exchange that you display a "Search by Algolia" logo next to your search results. You can use the Instantsearch options Boolean flag `poweredBy` or if you want more flexibility, as I did, you can find different versions of their logo [here](https://www.algolia.com/press/?section=brand-guidelines) and add it to the `search-hits-wrapper` div.

### Experience so far

I really liked the whole integration process, which was really smooth and not much work. I mean, I even went as far as to write all about it here. 🙂

One additional benefit of Algolia, which I haven't listed yet, is gaining statistics on your site's search queries with weekly email updates and an interactive dashboard. Helping you figure out what your readers and followers are looking for.

I am using the slightly older v2 of instantsearch.js, so at some point I will want to update to the latest version, which will decrease to javascript library size. Running [PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/?hl=nl) is still get a very comfortable 96/100 score, so there is no immediate need, but less is more when it comes to JS dependencies.

If my search query volume increases above the free 10k a month, then I'm happy to pay for this service. I do have one feature request for the Algolia team for the paid service, which is adding a monthly payment limit with alerting, to make sure you won't get any surprise overcharge bill.

Anyway, so far a big thumbs up for Algolia. 👍
