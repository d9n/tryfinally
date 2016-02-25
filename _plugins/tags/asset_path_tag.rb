# Copied from: https://github.com/samrayner/jekyll-asset-path-plugin

# The MIT License (MIT)
#
# Copyright (c) 2013 Sam Rayner
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

# Title: Asset path tag for Jekyll
# Author: Sam Rayner http://samrayner.com
# Description: Output a relative URL for assets based on the post or page
#
# Syntax {% asset_path [filename] %}
#
# Examples:
# {% asset_path kitten.png %} on post 2013-01-01-post-title
# {% asset_path pirate.mov %} on page page-title
#
# Output:
# /assets/posts/post-title/kitten.png
# /assets/page-title/pirate.mov
#
# Looping example using a variable for the pathname:
#
# File _data/image.csv contains:
#   file
#   image_one.png
#   image_two.png
#
# {% for image in site.data.images %}{% asset_path {{ image.file }} %}{% endfor %} on post 2015-03-21-post-title
#
# Output:
# /assets/posts/post-title/image_one.png
# /assets/posts/post-title/image_two.png
#

module Jekyll
  class AssetPathTag < Liquid::Tag
    @markup = nil

    def initialize(tag_name, markup, tokens)
      #strip leading and trailing spaces
      @markup = markup.strip
      super
    end

    def render(context)
      if @markup.empty?
        return "Error processing input, expected syntax: {% asset_path [filename] %}"
      end

      #render the markup
      rawFilename = Liquid::Template.parse(@markup).render context

      #strip leading and trailing quotes
      filename = rawFilename.gsub(/^("|')|("|')$/, '')

      path = ""
      page = context.environments.first["page"]

      #if a post
      if page["id"]
        #check for Jekyll version
        if Jekyll::VERSION < '3.0.0'
          #loop through posts to find match and get slug
          context.registers[:site].posts.each do |post|
            if post.id == page["id"]
              path = "posts/#{post.slug}"
            end
          end
        else
        #loop through posts to find match and get slug, method calls for Jekyll 3
          context.registers[:site].posts.docs.each do |post|
            if post.id == page["id"]
              path = "posts/#{post.data['slug']}"
            end
          end
        end
      else
        path = page["url"]
      end

      #strip filename
      path = File.dirname(path) if path =~ /\.\w+$/

      #fix double slashes
      "#{context.registers[:site].config['baseurl']}/assets/#{path}/#{filename}".gsub(/\/{2,}/, '/')
    end
  end
end

Liquid::Template.register_tag('asset_path', Jekyll::AssetPathTag)