# Syntax {% warn your text here %}
#
# If we are targeting a release build, this tag will print out a warning message

module Jekyll
  class WarnTag < Liquid::Tag
    @params = nil

    def initialize(tag_name, params, tokens)
      #strip leading and trailing spaces
      @params = params.strip
      super
    end

    def render(context)
      if ENV["JEKYLL_ENV"] != "production"
        return
      end

      page = context.environments.first["page"]
      Log.warn(page, @params)
    end
  end
end

Liquid::Template.register_tag('warn', Jekyll::WarnTag)
