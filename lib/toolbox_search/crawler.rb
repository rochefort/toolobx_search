require 'nokogiri'
require 'open-uri'

URL = 'http://ruby-toolbox.com'

module ToolboxSearch
  class Crawler
    def crawl
      @start_at = DateTime.now
      begin
        Crawl.transaction {
          @crawl = Crawl.create(:start_at => @start_at, :result => 0)
          crawl_toolbox(URL, @crawl.id)
          terminate()
        }
      rescue Exception => e
        puts e.to_s
        sendmail(e.to_s)
      end
    end

    private
    def terminate
      end_at = DateTime.now

      category_count = Category.find(:all, :conditions => {:crawl_id => @crawl.id}).count
      project_count = Project.find(:all, :conditions => {:crawl_id => @crawl.id}).count
      @crawl.update_attributes!(:end_at  => end_at,
                                :result => 1,
                                :processing_time => (end_at.to_f - @start_at.to_f),
                                :category_count => category_count,
                                :project_count => project_count)
    end

    def crawl_toolbox(url, crawl_id)
      Nokogiri::HTML(get_html(url)).css('div.category-overview').each do |elm|
        name, link = get_text_and_link(elm.css('h2 a[href]'))
        puts name
        category = Category.find_or_create_by_name(name)
        category.link = link
        category.description = elm.css('div.items').text.strip
        category.crawl_id = crawl_id

        category.project_count = crawl_projects(url + category.link, crawl_id, category.id)
        category.save!
      end
    end

    def crawl_projects(url, crawl_id, category_id)
      cnt = 0
      Nokogiri::HTML(get_html(url)).css('div.project').each do |elm|
        # header
        header = elm.css('div.project-header')
        name, link = get_text_and_link(header.css('h2 a[href]'))
        project = Project.find_or_create_by_name_and_project_link_and_category_id(
                  :name => name.downcase,
                  :project_link => link,
                  :category_id => category_id)
        puts "  #{name}"

        # header score
        h_score = header.css('.score')
        project.score         = h_score.css('h2 abbr[title]').text.strip
        project.watcher_count = h_score.css('.data abbr.watchers[title]').text.strip
        project.fork_count    = h_score.css('.data abbr.forks[title]').text.strip
        
        # description-text
        desc = elm.css('div.description-text div')
        project.description = desc.children[0].text.strip
        project.last_commit, project.commit_link = get_text_and_link(desc.css('span.last_commit a'))
        
        # project-links
        elm.css('ul.project-links a').each do |link|
          case link.text.strip
          when 'Source Code'
            project.source_link = link['href']
          when 'Website'
            project.web_link = link['href']
          when 'RDoc'
            project.rdoc_link = link['href']
          when /Wiki.*?/
            project.wiki_link = link['href']
          end
        end
        
        # project-rubygem
        gems = elm.css('div.project-rubygem')
        project.gem_name, project.gem_link = get_text_and_link(gems.css('h3 a'))

        gem_score = gems.css('table.score')
        project.gem_dl_count = gem_score.css('h3 abbr[title]').text.strip.scan(/\d.*$/).to_s
        
        gem_current = gem_score.css('.data abbr[title]')
        if gem_current.size != 0
          project.current_version  = gem_current[0].text.strip
          project.current_dl_count = gem_current[1].text.strip
        end
        
        # save project
        project.crawl_id    = crawl_id
        project.category_id = category_id
        project.save!

        # save score
        score = Score.new
        score.score            = project.score
        score.watcher_count    = project.watcher_count
        score.gem_dl_count     = project.gem_dl_count
        score.current_dl_count = project.current_dl_count
        score.crawl_id         = crawl_id
        score.project_id       = project.id
        score.save!
        
        cnt += 1
      end
      cnt
    end

    def get_text_and_link(elm)
      return nil, nil if elm.size == 0
      return elm.text.strip, elm[0]['href']
    end

    def get_html(url)
      html = ""
      retry_count = 1
      begin
        html = open(url)
      rescue Exception => e
        sleep 1
        sendmail(e.to_s)
        retry_count <= 3 ? retry : raise
      end
      html
    end

    def sendmail(body)
      to = MyConfig['crawler']['mail_to']
      from = MyConfig['crawler']['mail_from']
      subject = 'crawl error'
      ToolboxSearch::Mail.sendmail(to, from, subject, body)
    end
  end
end
