---
layout: post
title: Jekyll and Algolia search integration
meta_description: Jekyll and Algolia search integration
meta_keywords: post, development, javascript, Jekyll, Algolia
tags: [Development, Javascript, Jekyll, Algolia]
category: [Development]
published: true
---

Hacker news is powered by Algolia
Great documentation
Easy integration with Jekyll site

Planning on writting blog post more often => tweaking BeatleTech.com (checking with Google lighthouse)

Cleanup

### Why add search?

### Why Algolia?

### What is Algolia?


Which install instructions? => [jekyll-algolia](https://github.com/algolia/jekyll-algolia)

What we ask in exchange is that you display a "Search by Algolia" logo next to your search results.
InstantSearch libraries have a simple boolean option to toggle that on an off. If you want more flexibility

4 changes:
- Hide Search results on each page
- Don't fire off empty query that returns all articles
- Don't fire off a query on every keystroke
- Show "Search by Algolia" batch


{% highlight javascript linenos %}
  const search = instantsearch({
    appId: "{{ site.algolia.application_id }}",
    apiKey: "{{ site.algolia.search_only_api_key }}",
    indexName: "{{ site.algolia.index_name }}",
    searchFunction: function (helper) {
      var searchResults = document.getElementById("search-hits-wrapper");
      if (helper.state.query === "") {
        searchResults.style.display = "none";
        return;
      }
      helper.search();
      searchResults.style.display = "block";
    },
  });
{% endhighlight %}


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