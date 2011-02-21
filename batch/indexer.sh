#!/bin/sh
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
cd /srv/rails/toolbox_search/current
/usr/local/bin/rake RAILS_ENV=production thinking_sphinx:index > log/cron_indexer.log 2>&1