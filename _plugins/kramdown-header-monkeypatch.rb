# By default, kramdown converts #, ##, ### to <h1>, <h2>, etc.
# This modification adds an anchor tag with a font awesome link icon,
# e.g. "## Test" -> <h2>Test <a href="#id" class="section-anchor"><span class="fa-link"></span></h2>"
# Later, a css pass should style these icons

require 'kramdown'

module Kramdown
  module Converter
    class Base
      # Like generate_id but doesn't mark as used or check collisions
      def generate_id_preview(str)
        str = ::Kramdown::Utils::Unidecoder.decode(str) if @options[:transliterated_header_ids]
        gen_id = str.gsub(/^[^a-zA-Z]+/, '')
        gen_id.tr!('^a-zA-Z0-9 -', '')
        gen_id.tr!(' ', '-')
        gen_id.downcase!
        gen_id = 'section' if gen_id.length == 0
        gen_id
      end

      def generate_id(str)
        gen_id = generate_id_preview(str)

        @used_ids ||= {}
        if @used_ids.has_key?(gen_id)
          gen_id += '-' << (@used_ids[gen_id] += 1).to_s
        else
          @used_ids[gen_id] = 0
        end
        @options[:auto_id_prefix] + gen_id
      end
    end

    class Html

      def convert_span(el, indent)
        format_as_span_html(el.type, el.attr, inner(el, indent))
      end

      alias orig_convert_header convert_header
      def convert_header(el, indent)
        id = generate_id_preview(el.options[:raw_text])
        anchor = Element.new(:a, nil, {
            'href' => '#' + id,
            'class' => 'section-anchor'
        })
        linkicon = Element.new(:span, nil, {
            'class' => 'fa fa-link'
        })
        anchor.children.push(linkicon)
        el.children.push(anchor)
        orig_convert_header(el, indent)
      end
    end
  end
end
