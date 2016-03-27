# This Jekyll site supports the concept of "series", a grouped, ordered list of pages.
# A series is defined by _data/series.yml, which looks for corresponding files in
# /series/(series)/(page)/
#
# This generator updates both the pages that are part of a series to point to its owning
# series, as well as the site, which gets a global list of all series. In this way,
# a Jekyll page can use liquid to access these values, e.g.
#
# site.series:
# ------------
# {% for s in site.data.series %}
#   {{ s.title }}
#   <ul>
#   {% for p in s.pages %}
#      <li>{{ p.title }}</li>
#   {% endfor %}
#   </ul>
# {% endfor %}
#
# page.series:
# ------------
# {% for p in page.series.pages %}
#    ...
# {% endfor %}
#
# A page in a series may have next and previous pages added
# {% if page.next != null %} ...

module Jekyll

  # class CategoryPage < Page
  #   def initialize(site, base, dir, category)
  #     @site = site
  #     @base = base
  #     @dir = dir
  #     @name = 'index.html'

  #     self.process(@name)
  #     self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
  #     self.data['category'] = category

  #     category_title_prefix = site.config['category_title_prefix'] || 'Category: '
  #     self.data['title'] = "#{category_title_prefix}#{category}"
  #   end
  # end

  class String
    def red;            "\e[31m#{self}\e[0m" end
  end

  class SeriesDataGenerator < Generator
    safe true

    def generate(site)
      if not site.data.key? 'series'
        return
      end

      series_data = site.data['series']
      page_map = Hash.new
      site.pages.each_entry do |page|
        page_map[page.url] = page
      end

      site.data['series'] = []
      series_data.each_entry do |series_curr|
        series = Hash.new
        pages = []
        series['title'] = series_curr['title']
        series['summary'] = series_curr['summary']
        series['pages'] = pages

        prev_page = nil

        series_curr['page_ids'].each_entry do |page_id|
          page_url = "/series/#{series_curr['id']}/#{page_id}/"
          target_page = page_map[page_url]

          if target_page.nil?
            puts "series.yml references non-existing page: #{page_url}".red
            next
          end

          target_page.data['series'] = series
          if not prev_page.nil?
            prev_page.data['next'] = target_page
            target_page.data['prev'] = prev_page
          end

          prev_page = target_page
          pages << target_page
        end

        site.data['series'] << series
      end
    end
  end
end