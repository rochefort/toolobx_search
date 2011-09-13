class CategoriesController < ApplicationController
  before_filter :get_category_id

  def index
    @categories = Category.find_all(@crawl_id, params[:order])
  end

  def show
    @category = Category.find(params[:id], :include => :projects)
    @tag_cloud_title = "#{@category.name} Tags"

    # 上位10件のみチャートデータを取得
    @weekly_category_projects = @category.projects[0...10].map { |project|
      Project.for_a_week(project.name.capitalize, project.project_link, @crawl_id)
    }.compact

    @monthly_category_projects = @category.projects[0...10].map { |project|
      Project.for_a_month(project.name.capitalize, project.project_link, @crawl_id)
    }.compact

    @projects = Project.category_projects(@crawl_id, params[:id], params[:order])
  end

  private
  def get_category_id
    @crawl_id = Crawl.max_id
  end
end
