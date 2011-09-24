# -*- coding: UTF-8 -*-
module ProjectsHelper

  def tag_cloud(tags)
    return if tags.empty?
    return if tags.size == 1

    level = 24

    min_score, max_score = tags.map{ |x| x.score }.minmax.map{ |e| Math.sqrt(e) }
    # max_score =  Math.sqrt(tags.max_by(&:score).score)
    # min_score =  Math.sqrt(tags.min_by(&:score).score)
    level_range = (max_score - min_score) / level

    tags.each do |tag|
      tag_score = Math.sqrt(tag.score)
      index = (tag_score - min_score).div(level_range)
      yield tag, index
    end
  end

  def sort_link(column)
    mark  = get_sort_mark(column)
    query = {:search => params[:search], :order => get_sort_order(column, mark)}
    opt   = mark.present?? {:class => 'active_sort'} : {}
    link_to("#{column}#{mark}", projects_list_path(query), opt)
  end

  private
  def get_sort_order(column, mark)
    return "#{column}_a" if mark.blank?
    mark == MARK_DESC ? "#{column}_a" : "#{column}_d"
  end

  def get_sort_mark(column)
    if first_search?
      return MARK_ASC  if category_default_column?(column)
      return MARK_DESC if project_default_column?(column)
      return ''
    end

    if sortable_column?(column)
      params[:order][-2, 2] == '_d' ? MARK_DESC : MARK_ASC
    else
      ''
    end
  end

  def first_search?
    params[:order].blank?
  end

  def category_default_column?(column)
    params[:controller] == 'categories' and column == 'category'
  end
  
  def project_default_column?(column)
    column == 'score'
  end

  def sortable_column?(column)
    column == params[:order][0..-3]
  end
end
