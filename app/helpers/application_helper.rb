# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def url_name(name)
    "-#{name.gsub(/\W/, '-').downcase}"
  end
end
