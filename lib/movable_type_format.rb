module MovableTypeFormat
  autoload :Collection, "movable_type_format/collection"
  autoload :Entry, "movable_type_format/entry"
  autoload :Field, "movable_type_format/field"
  autoload :Next, "movable_type_format/next"
  autoload :Parser, "movable_type_format/parser"
  autoload :Section, "movable_type_format/section"
  autoload :VERSION, "movable_type_format/version"

  def self.parse(string_or_io, &block)
    if block
      Parser.parse string_or_io, &block
    else
      Parser.parse string_or_io
    end
  end
end
