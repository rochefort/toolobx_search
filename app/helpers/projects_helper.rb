# coding: utf-8
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

  def sort_link(type)
    #diff "#{type}_d" == params[:order]

    link = type + link_to('▼', {:search => params[:search], :order => "#{type}_a"}, active_sort("#{type}_a")) +
                  link_to('▲', {:search => params[:search], :order => "#{type}_d"}, active_sort("#{type}_d"))
    link.html_safe
  end

  # sort未選択時は、score_aをactiveとする
  def active_sort(sort_type)
    # project一覧初期表示用
    return { :class => 'active_sort' } if params[:order].blank? and sort_type == "score_d"
    # categories一覧初期表示用
    return { :class => 'active_sort' } if params[:controller] == "categories" and params[:order].blank? and sort_type == "category_d"
    # sort選択時は、クエリパラメータと比較
    if sort_type == params[:order]
      { :class => 'active_sort' }
    else
      { :class => nil }
    end
  end
end
