# A useful title for examples that the user should try out for themselves
#
# Syntax
# {% tryme (Optional message here) %}
# {% highlight bash %}
# $ do stuff
# {% endhighlight %}

module Jekyll
  class TryMeTag < Liquid::Tag
    @params = nil

    def initialize(tag_name, params, tokens)
      #strip leading and trailing spaces
      @params = params.strip
      super
    end

    def render(context)
      Liquid::Template.parse("<figcaption class=\"title\">{% icon fa-terminal %} #{@params}</figcaption>").render()
    end
  end
end

Liquid::Template.register_tag('tryme', Jekyll::TryMeTag)
