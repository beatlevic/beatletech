#!/bin/bash

script="./deploy.sh"

# make sure we are in the jekyll root directory
# (where deploy.sh should be)
if [ -f $script ] ; then 
	echo "Compiling site..."
else
	echo "Please run this script from the jekyll site's root directory. Exiting..."
	exit 1
fi

# start the site over from scratch
rm -rf _site/* && \

# Generate the cloud to include before running jekyll
./_scripts/generate_cloud.py 10 8 . > ./_includes/cloud.html && \

# Run jekyll
jekyll

# Run HTML White space remover
# echo "Minifying HTML..."
# for f in $(find _site/ -name \*.html); do
#     mv $f $(echo "$f" | sed 's/html$/html.old/')
#     _scripts/strip_whitespace.pl < $f.old > $f
#     rm $f.old
# done

# CSS Minifier
# echo "Minifying CSS..."
# for f in _site/css/*.css; do
#     mv $f $f.old
#     ./_scripts/cssOptimizer.pl $f.old $f
#     rm $f.old
# done

# Use rsync to send blog to server
#rsync -avz --delete _site/ homeserver:blog/

# explicitly ping google only when 'ping' is passed as a parameter to the script
# ie, ./deploy ping

if [ $# -gt 0 ] ; then
if [ $1 = ping ] ; then
	echo "Pinging Update Services..."

	# Ping google tell them the sitemap has been updated
	wget --output-document=/dev/null http://www.google.com/webmasters/tools/ping?sitemap=http%3A%2F%2Fbeatletech.com%2Fsitemap.xml

	# and bing
	wget --output-document=/dev/null http://www.bing.com/webmaster/ping.aspx?siteMap=http://beatletech.com/sitemap.xml

	# and blog search engines
	# ./_scripts/rpcping.pl "Blog for Jason Graham" http://jason.the-graham.com/
else
	echo "Use \"$0 ping\" to ping google about an update."
fi
fi
