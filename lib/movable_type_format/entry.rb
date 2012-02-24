module MovableTypeFormat
  class Entry
    DELIMITER = "--------\n".freeze
    attr_accessor :sections
    def self.build_by_sections(sections)
      entry = new
      entry.sections = sections
      entry
    end

    def inspect
      to_mt
    end

    def to_mt
      sections.to_mt + DELIMITER
    end
  end
end
