module MovableTypeFormat
  class Entry
    DELIMITER = "--------\n".freeze
    attr_accessor :sections
    def self.build_by_sections(sections)
      entry = new
      entry.sections = sections
      entry
    end

    def sections
      @sections ||= Collection.new
    end

    Section::Base::NAMES_OF_SINGLE_SECTION.each do |section_name|
      name = section_name.downcase.gsub(/ /, "_")
      define_method name do
        find_or_create_section(section_name).body
      end
      define_method "#{name}=" do |v|
        find_or_create_section(section_name).body = v
      end
    end

    MovableTypeFormat::Field::KEYS_FOR_METADATA.each do |metadata_key|
      name = metadata_key.downcase.gsub(/ /, "_")
      define_method name do
        metadata.send(name)
      end
      define_method "#{name}=" do |v|
        metadata.send "#{name}=", v
      end
    end

    def categories
      metadata.categories
    end

    def metadata
      section = sections.find{|s| s.metadata? }
      unless section
        section = Section::Metadata.new
        sections << section
      end
      section
    end

    def metadata=(v)
      sections.delete section
      sections << v
    end

    def comments
      sections.select{|s| s.name == "COMMENT" }.freeze
    end

    def comments=(v)
      comments.each{|c| sections.delete c}
      sections += v
    end

    def pings
      sections.select{|s| s.name == "PING" }.freeze
    end

    def pings=(v)
      pings.each{|p| sections.delete p}
      sections += v
    end

    def to_mt
      sections.to_mt + DELIMITER
    end

    private
    def find_or_create_section(section_name)
      section = sections.find{|s| s.name == section_name}
      unless section
        section = Section::Base.build_by_name(section_name)
        sections << section
      end
      section
    end
  end
end
