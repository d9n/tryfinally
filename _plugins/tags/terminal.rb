# A useful block for examples that the user should try out for themselves in a terminal shell
# This will automatically highlight the contents as if it were a bash script
#
# Syntax
# {% terminal (Optional message here) %}
# $ do stuff
# {% endhighlight %}

module Jekyll
  class TerminalTag < Liquid::Block
    @params = nil

    def initialize(tag_name, params, tokens)
      super
      #strip leading and trailing spaces
      @params = params.strip
      super
    end

    def render(context)
      Liquid::Template.parse("<figcaption class=\"title\">{% icon fa-terminal %} #{@params}</figcaption><div class=\"terminal\">{% highlight bash %}#{super}{% endhighlight %}</div>").render(context)
    end
  end
end

Liquid::Template.register_tag('terminal', Jekyll::TerminalTag)
