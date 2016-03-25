# Forked from: https://github.com/samrayner/jekyll-asset-path-plugin

# The MIT License (MIT)
#
# Copyright (c) 2013 Sam Rayner, David Herman
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Syntax {% asset (filename) %}
#
# Examples:
# # In a post in /articles/learn-java/intro.md
# {% asset class-diagram.png %}
#
# Output:
# base-url/assets/articles/learn-java/intro/class-diagram.png
#

module Jekyll
  class AssetTag < Liquid::Tag
    @params = nil

    def initialize(tag_name, params, tokens)
      #strip leading and trailing spaces
      @params = params.strip
      super
    end

    def render(context)
      args = @params.split()
      if args.length != 1
        return "Error processing input, expected syntax: {% asset (filename) %}"
      end

      filename = args[0]
      page = context.environments.first["page"]
      path = page["url"]

      #strip trailing extension if any
      path = path.sub(/\.\w+$/, '')

      #return full path, fixing any double slashes
      "#{context.registers[:site].config['baseurl']}/assets/#{path}/#{filename}".gsub(/\/{2,}/, '/')
    end
  end
end

Liquid::Template.register_tag('asset', Jekyll::AssetTag)
