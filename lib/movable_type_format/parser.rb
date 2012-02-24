module MovableTypeFormat
  module Parser
    module_function
    def parse_file(file)
    end

    def parse(string)
      lines = string.lines
      lines.extend Next

      entries = Collection.new

      while lines.next?
        entries << parse_entry(lines)
      end

      entries
    end

    def parse_entry(lines)
      sections = Collection.new
      current_field = nil

      while lines.next?
        case lines.peek
        when "--------\n"
          lines.next
          break
        else
          sections << parse_section(lines)
        end
      end

      Entry.build_by_sections sections
    end

    def parse_section(lines)
      section = Section.new
      context = :head # :fields, :body

      while line = lines.next_if_exists
        case line
        when /^([A-Z0-9 ]+):$/
          # section name or single line field
          key = $1
          case context
          when :head
            section.name = key
            context = :fields
          else
            section.fields << Field.new(key)
          end
        when /^([A-Z0-9 ]+): (.+)$/
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
        when "-----\n"
          # end of section
          return section
        else
          section.body ||= ""
          section.body << line
          context = :body
        end
      end
      section
    end
  end
end
