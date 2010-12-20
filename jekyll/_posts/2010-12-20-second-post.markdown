---
layout: post
title: Second post
meta_description: This is already my second post
meta_keywords: post, welcome, beatletech, coen, stevens
category: [javascript]
---

Test text hello.


different text here...!!! hello

Is this a new paragraph?

{% highlight javascript %}

var dyna_tabs = {
    
    tabs: null,

    init: function (id) {
        var tabs = $('<div></div>').append('<div id="'+ id + '"></div>');
        $('body').append(tabs);

        var list = $('<ul></ul').append('<li><a href="#"></a></li>');
        tabs.append(list);

        tabs.tabs();

        // remove the dummy tab
        tabs.tabs('remove', 0);
        tabs.hide();

        this.tabs = tabs;
    },

    add: function (tab_id, tab_name, tab_content) {
        if (this.tabs != null) {
            if (this.tabs.css('display') == 'none') {
                this.tabs.show();
            }
            var data = $('<div id="'+tab_id+'"></div>').append(tab_content);
            this.tabs.append(data).tabs('add', '#' + tab_id, tab_name);
            this.tabs.tabs('select', '#' + tab_id);
        } else {
            alert('Tabs not initialized!');
        }
    }

};

{% endhighlight %}

<strong>Note:</strong> obviously, this code is just for demonstration purposes. The final implementation depends on what you are trying to do.  Enjoy! ^_^
