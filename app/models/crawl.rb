class Crawl < ActiveRecord::Base
  default_scope where(:result => 1)
  has_many :categories
  def self.max_id
    self.maximum('id')
  end
  
  def self.before_id(base_id, num_old_day)
    before_day = num_old_day.days.ago(self.find(base_id).created_at.to_date)
    self.find(:first, :conditions => ['created_at >= ?', before_day]).id
  end
end
