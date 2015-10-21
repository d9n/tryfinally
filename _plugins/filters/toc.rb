# A filter which runs over html, searching for h2 tags, which it converts into a bullet list of
# links.

# To use, feed {{content }} into this filter
# <div class="my-toc-class">
# {{ content | toc }}
# </div>
# <div class="my-content-class">
# {{ content }}
# </div>

# Generates results that look like
# <ul>
#    <li><a href="...">Link to section 1</a></li>
#    <li><a href="...">Link to section 2</a></li>
# </ul>
#
# So wrap in a css div and style as you wish!

module Jekyll
  module TocFilter
    def toc(input)
        headers = input.scan(/<h2.+<\/h2>/)
        nameIds = []
        for header in headers
            match = /<h2 id="\S+">(.+)<a href="(\S+)".*/.match(header)
            if match
                nameIds.push(match.captures)
            end
        end

        if nameIds.empty?
            return '(Missing TOC, please add h2 sections in your content)'
        end

        output = '<ul>'
        for nameId in nameIds
            output << "<li><a href=\"#{nameId[1]}\">#{nameId[0]}</a></li>"
        end
        output << '</ul>'
    end
  end
end

Liquid::Template.register_filter(Jekyll::TocFilter)
