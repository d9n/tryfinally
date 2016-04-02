# Syntax:
# {% filetree %}
# folder/
#   binary*
#   code.java
#   text.txt
#   subfolder/
#     asset.png
#     ...
#   closedfolder/
# {% endfiletree %}
#
# Outputs:
# <ul class="fa-ul">
#   <li>{% icon fa-li fa-folder-open-o %}folder</li>
#   <ul class="fa-ul">
#       <li>{% icon fa-li fa-file-excel-o %}binary</li>
#       <li>{% icon fa-li fa-file-code-o %}code.java</li>
#       <li>{% icon fa-li fa-file-text-o %}text.txt</li>
#       <li>{% icon fa-li fa-folder-open-o %}subfolder</li>
#       <ul class="fa-ul">
#           <li>{% icon fa-li fa-folder-o %}subfolder</li>
#           <li>{% icon fa-li fa-file-image-o %}asset.png</li>
#           <li>{% icon fa-ellipsis-h %}</li>
#       </ul>
#       <li>{% icon fa-li fa-folder-o %}closedfolder</li>
#   </ul>
# </ul>


module Jekyll
  class FiletreeTag < Liquid::Block
    ICON_CODE = "fa-file-code-o"
    ICON_IMAGE = "fa-file-image-o"
    ICON_TEXT = "fa-file-text-o"
    ICON_BINARY = "fa-file-excel-o"
    ICON_GENERIC = "fa-file-o"
    @@icon_names = {
      '.gradle' => ICON_CODE,
      '.java' => ICON_CODE,
      '.kt' => ICON_CODE,
      '.txt' => ICON_TEXT,
      '.doc' => ICON_TEXT,
      '.md' => ICON_TEXT,
      '.png' => ICON_IMAGE,
      '.jpg' => ICON_IMAGE,
      '.bmp' => ICON_IMAGE,
      '.gif' => ICON_IMAGE,
    }

    def render(context)
      page = context.environments.first["page"]

      # Prepare input string into input array
      input = super.sub(/\t/, ' ').split(/\r?\n/).reject { |s| s.empty? }
      if input.size == 0
        Log.warn(page, 'Ignoring empty filetree block')
        return ""
      end

      # Calculate and sanity check indents
      lineIndents = []
      hasChildren = []
      for line in input
        lineIndents.push(line.length - line.lstrip.length)
        hasChildren.push(false)
      end

      indentLen = 1
      for currIndent in lineIndents
        if currIndent > 0
          indentLen = currIndent
          break
        end
      end
      lineIndents.each_with_index { |currIndent, index|
        if (currIndent % indentLen != 0)
          Log.err(page, "Bad filetree indents, found #{currIndent} which is not a multiple of #{indentLen} (#{input[index].strip}). Aborting!")
          return ""
        end
      }
      lineIndents.map! { |i| i / indentLen } # e.g. indent of 4: 4, 8, 12 -> 1, 2, 3

      prevIndent = -1
      lineIndents.each_with_index { |currIndent, index|
        if (currIndent - prevIndent) > 1
          Log.err(page, "Bad filetree indents, got #{prevIndent} then #{nextIndent} (#{input[index].strip}). Aborting!")
          return ""
        end

        if (currIndent > prevIndent and index > 0)
          hasChildren[index - 1] = true
        end

        prevIndent = currIndent
      }

      # Convert input to output
      currIndent = -1
      output = StringIO.new
      output << '<div class="filetree">'
      input.each_with_index { |line, index|
        nextIndent = lineIndents[index]
        while nextIndent > currIndent
          output << '<ul class="fa-ul">'
          currIndent += 1
        end
        while nextIndent < currIndent
          output << '</ul>'
          currIndent -= 1
        end

        lineStrip = line.strip
        ext = File.extname(lineStrip.strip_tags)
        if lineStrip.end_with?('/')
          icon = hasChildren[index] ? 'fa-folder-open-o' : 'fa-folder-o'
          output << "<li>{% icon fa-li #{icon} %}#{lineStrip.chomp('/')}</li>"
        elsif lineStrip == "..."
          # Extra <br/> is necessary to prevent HTML from thinking this is a blank item
          output << "<li>{% icon fa-li fa-ellipsis-h %}<br/></li>"
        elsif !ext.empty?
          icon = @@icon_names[ext]
          if icon.nil?
            Log.warn(page, "Unknown filetype: #{lineStrip}")
            icon = ICON_GENERIC
          end
          output << "<li>{% icon fa-li #{icon} %}#{lineStrip}</li>"
        elsif lineStrip.end_with?('*')
          output << "<li>{% icon fa-li #{ICON_BINARY} %}<i>#{lineStrip.chomp('*')}</i></li>"
        else
          Log.warn(page, "Skipping unknown input: #{lineStrip}")
        end
      }

      while currIndent > -1
        output << '</ul>'
        currIndent -= 1
      end
      output << '</div>'


      template = Liquid::Template.parse(output.string)
      template.render()
    end

  end
end

Liquid::Template.register_tag('filetree', Jekyll::FiletreeTag)
