# Tags for various notes, particularly goals, tips, and warnings,
# converting them into html. Each note includes a message, icon, and
# (optional) header. In order so that you can further style the
# note's look and feel, the container itself and each compoent are
# tagged with a class:
#
# xxx, xxx-icon, xxx-header, and xxx-message
#
# (where xxx is "tip", "goal", or "warn")

# Examples:
#    {% goal %} The purpose of this lesson...{% endgoal %}
#    {% warn Memory Warning %} The following program is resource heavy. {% endwarn %}
#    {% tip Contact us %} If you have any questions, our email is... {% endtip %}

module Jekyll

  class NoteBlock < Liquid::Block
    # Format with {type: ..., fa_id: ..., header: ..., message: ...}
    @@note_with_header = [
      "<table class=\"%{type}\">",
        "<tr>",
          "<td><span class=\"fa %{fa_id} %{type}-icon\"></span></td>",
          "<td>",
            "<table>",
              "<tr><td><span class=\"%{type}-header\">%{header}</span></td></tr>",
              "<tr><td><span class=\"%{type}-message\">%{message}</span></td></tr>",
            "</table>",
          "</td>",
        "</tr>",
      "</table>"
    ].join("");

    # Format with {type: ..., fa_id: ..., message: ...}
    # @@note = [
    #   "<div class=\"%{type}\">",
    #     "<span class=\"fa %{fa_id} %{type}-icon\"></span>",
    #     "<span class=\"%{type}-message\">%{message}</span>",
    #   "</div>"
    # ].join("");

    @@note = [
      "<table class=\"%{type}\">",
        "<tr>",
          "<td><span class=\"fa %{fa_id} %{type}-icon\"></span></td>",
          "<td><span class=\"%{type}-message\">%{message}</span></td>",
        "</tr>",
      "</table>"
    ].join("");

    def initialize(tag_name, markup, tokens, type, fa_id)
      @type = type
      @header = markup.strip()
      @fa_id = if @header.empty?
        fa_id
      else
        "#{fa_id} fa-2x"
      end

      super(tag_name, markup, tokens)
    end

    def render(context)

      args = {
        type: @type, fa_id: @fa_id, header: @header, message: super
      }

      if @header.empty?
        @@note % args
      else
        @@note_with_header % args
      end
    end
  end

  class GoalBlock < NoteBlock
    def initialize(tag_name, markup, tokens)
      super(tag_name, markup, tokens, :goal, 'fa-hand-o-right')
    end
  end

  class TipBlock < NoteBlock
    def initialize(tag_name, markup, tokens)
      super(tag_name, markup, tokens, :tip, 'fa-star')
    end
  end

  class WarnBlock < NoteBlock
    def initialize(tag_name, markup, tokens)
      super(tag_name, markup, tokens, :warn, 'fa-warning')
    end
  end
end

Liquid::Template.register_tag('goal', Jekyll::GoalBlock)
Liquid::Template.register_tag('tip', Jekyll::TipBlock)
Liquid::Template.register_tag('warn', Jekyll::WarnBlock)
