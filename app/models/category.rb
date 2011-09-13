class Category < ActiveRecord::Base
  belongs_to :crawl
  has_many :projects, :order => 'score DESC'

  scope :popular, lambda{ |crawl_id, order| {
                              :conditions => { :crawl_id => crawl_id},
                                               :order => order,
                                               :include  => :projects } }

  def to_param
    "#{id}-#{name.gsub(/\W/, '-').downcase}"
  end

  def self.find_all(crawl_id, order_type)
    order = case order_type
    when "category_d" then "name DESC"
    when "category_a" then "name ASC"
    when "project_cnt_d" then "project_count DESC"
    when "project_cnt_a" then "project_count ASC"
    else "updated_at ASC"
    end

    Category.popular(crawl_id, order)
  end

end
