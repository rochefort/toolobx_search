class ProjectsController < ApplicationController
  before_filter :get_category_id, :only => [ :index, :most_popular, :show, :list ]

  def index
    search_number = 50
    @tag_cloud_title = set_title(params[:search], search_number)
    @projects = Project.search_keyword(@crawl_id, params[:search], params[:page], search_number, params[:order])

    @daily_top10_projects    = Project.top10(Crawl.before_id(@crawl_id,  1), @crawl_id)
    @weekly_top10_projects   = Project.top10(Crawl.before_id(@crawl_id,  7), @crawl_id)
    @monthly_top10_projects  = Project.top10(Crawl.before_id(@crawl_id, 30), @crawl_id)
    @top10_projects          = Project.top10(@crawl_id, @crawl_id)
  end

  def about
  end

  def list
    search_number = 50
    @projects = Project.search_keyword(@crawl_id, params[:search], params[:page], search_number, params[:order])

    respond_to do |format|
      format.html
      format.js if request.xhr?
    end
  end

  def most_popular
    @tag_cloud_title = set_title(params[:search] )
    @projects = Project.search_keyword(@crawl_id, params[:search], params[:page], 10000, params[:order])
  end

  def show
    @project = Project.find(params[:id])
    @weekly_project  = [Project.for_a_week(@project.name.capitalize, @project.project_link, @crawl_id)]
    @monthly_project = [Project.for_a_month(@project.name.capitalize, @project.project_link, @crawl_id)]
  end


  private
  def get_category_id
    @crawl_id = Crawl.max_id
  end

  def set_title(search, number = 0)
    return "tags(#{search})" if search
    number > 0 ? "Top50 Tags" : "Tags"
  end
end
