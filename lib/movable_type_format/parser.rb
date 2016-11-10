module MovableTypeFormat
  # parser = MovableTypeFormat::Parser.new(File.read("export.txt"))
  # parser.parse do |entry|
  #   # process for each entry
  # end
  # parser.rewind
  # parser.parse.to_a
  class Parser
    def self.parse(string_or_io, &block)
      if block
        Parser.new(string_or_io).parse(&block)
      else
        Parser.new(string_or_io).parse
      end
    end

    def initialize(string_or_io)
      @lines = string_or_io.each_line
      @lines.extend Next
    end

    def parse
      return enum_for :parse unless block_given?
      while @lines.next?
        yield parse_entry(@lines)
      end
    end

    def rewind
      @lines.rewind
    end

    private
    def parse_entry(lines)
      sections = Collection.new
      current_field = nil

      while lines.next?
        case lines.peek
        when Entry::DELIMITER
          lines.next
          break
        when "\n" # ignore empty line between entries or sections
          lines.next
        else
          sections << parse_section(lines)
        end
      end

      Entry.build_by_sections sections
    end

    def parse_section(lines)
      section = Section::Metadata.new
      context = :head # :fields, :body

      while line = lines.next_if_exists
        case line
        when /^([A-Z0-9 ]+):$/
          # section name or single line field
          key = $1
          case context
          when :head
            section = Section::Base.build_by_name key
            context = :fields
          else
            section.fields << Field.new(key)
          end
        when /^([A-Z0-9 ]+): (.*)$/
          # single line field or body
          key, value = $~.captures
          case context
          when :head, :fields
            section.fields << Field.new(key, value)
            context = :fields
          else
            section.body ||= ""
            section.body << line
            context = :body
          end
        when Section::Base::DELIMITER
          # end of section
          section.body.chomp! if section.body
          return section
        else
          section.body ||= ""
          section.body << line
          context = :body
        end
      end
      raise "Section delimiter not found!"
    end
  end
end
