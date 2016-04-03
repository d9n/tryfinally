# From https://gist.github.com/jonsuh/2a88c7799461623d9d82
# because Jekyll's default URL encode messes up spaces. Spaces! I mean, that's like url encode 101...

require 'liquid'
require 'uri'

# Percent encoding for URI conforming to RFC 3986.
# Ref: http://tools.ietf.org/html/rfc3986#page-12
module URLEncode
  def url_encode(url)
    return URI.escape(url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end
end

Liquid::Template.register_filter(URLEncode)