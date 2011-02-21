#!/bin/sh
#cd /srv/rails/toolbox_search/current
rails runner -e development "ToolboxSearch::Crawler.new.crawl" 
#/usr/local/bin/ruby script/runner -e production "ToolboxSearch::Crawler.new.crawl" > log/cron_crawler.log 2>&1
/usr/bin/touch tmp/restart.txt
