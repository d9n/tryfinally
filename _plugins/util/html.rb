# To use...
# puts "<span>This is a test</span>".strip_tags

class String
    def strip_tags;    "#{self}".gsub(/<\/?[^>]+?>/, '') end
end