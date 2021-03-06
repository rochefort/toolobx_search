#!/bin/sh
export PATH=/usr/local/bin/:$PATH
bundle_bin=/home/trsw/.gem/ruby/1.9.1/bin/bundle
log_file=log/cron_crawler.log

cd /usr/local/rails/toolbox_search/current
date "+%Y%m%d %H:%M:%S" > $log_file 2>&1
$bundle_bin exec rails runner -e production "ToolboxSearch::Crawler.new.crawl" >> $log_file 2>&1
/bin/touch tmp/restart.txt
