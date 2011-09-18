# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run ToolboxSearch::Application

# if ENV['RAILS_RELATIVE_URL_ROOT']
#   map ENV['RAILS_RELATIVE_URL_ROOT'] do
#     run ToolboxSearch::Application
#   end
# else
#   run ToolboxSearch::Application
# end
