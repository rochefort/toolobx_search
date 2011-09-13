class Project < ActiveRecord::Base
  belongs_to :crawl
  belongs_to :category
  has_many :scores
  named_scope :popular, lambda{ |crawl_id, order| {
                                :conditions => ["scores.crawl_id = ?", crawl_id],
                                :order => order, :include => [:category, :scores]}}

  named_scope :period, lambda{ |name, link, from_crawl_id, to_crawl_id| {
                                :conditions => ["projects.name = ? AND project_link = ? AND scores.crawl_id between ? AND ?",
                                                 name, link, from_crawl_id, to_crawl_id],
                                :order => "projects.name, project_link, projects.crawl_id",
                                :include => [:category, :scores], :limit => 31 }}

  def to_param
    "#{id}-#{name.gsub(/\W/, '-').downcase}"
  end

  # sphinx settings
  define_index do
    # fields
    # symbol(such as id, name or type)
    indexes :name, :as => :project_name, :sortable => true
    indexes description
    indexes category(:name), :as => :category_name, :sortable => true

    # attributes
    has score, :type => :integer
    has crawl_id, updated_at, category.name
  end

  def self.search_keyword(crawl_id, keyword, page, per_page, order_type)
    page ||= 1
    per_page ||= 30

    order = case order_type
    when "project_d" then keyword.blank?? "projects.name DESC" : "project_name DESC"
    when "project_a" then keyword.blank?? "projects.name ASC": "project_name ASC"
    when "category_d" then keyword.blank?? "categories.name DESC" : "category_name DESC"
    when "category_a" then keyword.blank?? "categories.name ASC" : "category_name ASC"
    when "score_d" then keyword.blank?? "projects.score DESC" : "score DESC"
    when "score_a" then keyword.blank?? "projects.score ASC" : "score ASC"
    else
      keyword.blank?? "projects.score DESC, projects.updated_at ASC" : "score DESC, updated_at ASC"
    end

    if keyword.blank?
      popular(crawl_id, order).paginate(:page => page, :per_page => per_page)
    else
      search(keyword, :page => page, :per_page => per_page,
                      :include => [:category, :scores],
                      :with => {:crawl_id => crawl_id},
                      :star => true,
                      :sort_mode => :extended,
                      :order => order)
    end
  end

  def self.top10(from_crawl_id, to_crawl_id)
    if from_crawl_id != to_crawl_id
      Project.find_by_sql(["SELECT t.id, t.name , t.score, t.score - f.score as diff_score, c.id category_id, c.name category_name
                            FROM ( SELECT * FROM projects WHERE crawl_id = :to_crawl_id ) t
                              LEFT OUTER JOIN ( SELECT * from projects WHERE crawl_id = :from_crawl_id ) f
                              ON t.name = f.name AND t.project_link = f.project_link
                              INNER JOIN categories c
                              ON t.category_id = c.id
                            ORDER BY diff_score DESC
                            LIMIT 10", {:from_crawl_id => from_crawl_id, :to_crawl_id => to_crawl_id}])
    else
      Project.find_by_sql(["SELECT t.id, t.name , t.score, c.id category_id, c.name category_name
                            FROM ( SELECT * FROM projects WHERE crawl_id = :crawl_id ) t
                              INNER JOIN categories c
                              ON t.category_id = c.id
                            ORDER BY score DESC
                            LIMIT 10", {:crawl_id => to_crawl_id} ])
    end
  end

  def self.for_a_week(name, link, crawl_id)
    project = period(name, link, Crawl.before_id(crawl_id, 7), crawl_id).paginate(:page => 1, :per_page => 31)
    return if project.size == 0
    
    { :name => name,
      :data => project[0].scores.map(&:score).join(','),
      :type => "weekly",
      :x_axis => project[0].scores.map { |pc| "'#{pc.created_at.strftime("%m/%d")}'" }.join(','),
      :x_all  => project[0].scores.map { |pc| "'#{pc.created_at.strftime("%m/%d")}'" } }
  end

  def self.for_a_month(name, link, crawl_id)
    project = period(name, link, Crawl.before_id(crawl_id, 30), crawl_id).paginate(:page => 1, :per_page => 31)
    return if project.size == 0

    { :name => name,
      :data => project[0].scores.map(&:score).join(','),
      :type => "monthly",
      :x_axis => project[0].scores.each_with_index.map { |pc, i| i % 7 == 0 ? "'#{pc.created_at.strftime("%m/%d")}'" : "' '"}.join(','),
      :x_all  => project[0].scores.map { |pc| "'#{pc.created_at.strftime("%m/%d")}'" } }
  end

  def self.category_projects(crawl_id, category_id, order_type)
    order_type ||= "score_d"
    order = case order_type
    when "project_d" then "name DESC"
    when "project_a" then "name ASC"
    when "score_d" then "projects.score DESC"
    when "score_a" then "projects.score ASC"
    else "updated_at ASC"
    end

    self.find(:all, :conditions => {:crawl_id => crawl_id, :category_id => category_id}, :order => order).
         paginate(:page => 1, :per_page => 10000)
  end


  def self.top10(from_crawl_id, to_crawl_id)
    if from_crawl_id != to_crawl_id
      self.find_by_sql(["SELECT p.id, p.name , t.score, t.score - f.score as diff_score, c.id category_id, c.name category_name
                            FROM ( SELECT * FROM scores WHERE crawl_id = :to_crawl_id ) t
                            LEFT OUTER JOIN ( SELECT * from scores WHERE crawl_id = :from_crawl_id ) f ON t.project_id = f.project_id
                            INNER JOIN projects p   ON t.project_id = p.id
                            INNER JOIN categories c ON p.category_id = c.id
                            ORDER BY diff_score DESC
                            LIMIT 10", {:from_crawl_id => from_crawl_id, :to_crawl_id => to_crawl_id}])
    else
      self.find_by_sql(["SELECT p.id, p.name , t.score, 0 as diff_score, c.id category_id, c.name category_name
                            FROM ( SELECT * FROM scores WHERE crawl_id = :crawl_id ) t
                            INNER JOIN projects p   ON t.project_id = p.id
                            INNER JOIN categories c ON p.category_id = c.id
                            ORDER BY score DESC
                            LIMIT 10", {:crawl_id => to_crawl_id} ])
    end
  end
end
