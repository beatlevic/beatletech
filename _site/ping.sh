#!/bin/bash

echo "Pinging Update Services..."

# Ping google tell them the sitemap has been updated
wget --output-document=/dev/null http://www.google.com/webmasters/tools/ping?sitemap=http%3A%2F%2Fbeatletech.com%2Fsitemap.xml

# and bing
wget --output-document=/dev/null http://www.bing.com/webmaster/ping.aspx?siteMap=http://beatletech.com/sitemap.xml
