#!/bin/sh
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
bundle_bin=/home/trsw/.gem/ruby/1.9.1/bin/bundle
log_file=log/cron_indexer.log

cd /usr/local/rails/toolbox_search/current
date "+%Y%m%d %H:%M:%S" > $log_file 2>&1
$bundle_bin exec rake RAILS_ENV=production thinking_sphinx:index >> $log_file 2>&1
