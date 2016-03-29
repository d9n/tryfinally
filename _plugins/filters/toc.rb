# A filter which runs over html, searching for h2 tags, which it converts into a bullet list of
# links.

# To use, feed {{content }} into this filter
# <div class="my-toc-class">
# {{ content | toc }}
# </div>
# <div class="my-content-class">
# {{ content }}
# </div>

# HTML content that looks like this...
# <h2>Section 1</h2>
# <h2>Section 2</h2>
#
# Generates results that look like
# <ul>
#    <li><a href="...">Section 1</a></li>
#    <li><a href="...">Section 2</a></li>
# </ul>
#
# So wrap in a css div and style as you wish!

module Jekyll
  module TocFilter
    def toc(input)
        headers = input.scan(/<h\d.+<\/h\d>/)
        headerRegex = /<h([23]) .*id="\S+".*>(.+)<a href="(\S+)".*/

        matches = headers.map { |h| headerRegex.match(h) }
        matches.compact!

        # If any h3 section comes before h2 sections drop them for being out of order
        matches = matches.drop_while { |m| m[1] == '3' }

        if matches.empty?
            return '(Missing TOC, please add h2/h3 sections in your content)'
        end

        output = '<ul>'
        lastDepth = 0;
        for match in matches
            if match[1] == '3' and lastDepth == 0
                output << '<ul>'
                lastDepth = 1
            elsif match[1] == '2' and lastDepth == 1
                output << '</ul>'
                lastDepth = 0
            end

            output << "<li><a href=\"#{match[3]}\">#{match[2]}</a></li>"
        end
        output << '</ul>'
    end
  end
end

Liquid::Template.register_filter(Jekyll::TocFilter)
