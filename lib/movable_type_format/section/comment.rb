module MovableTypeFormat
  module Section
    class Comment <  Base
      define_field_accessors MovableTypeFormat::Field::KEYS_FOR_COMMENT

      def initialize(fields = Collection.new, body = nil)
        super "COMMENT", fields, body
      end

      def serialize
        serialized = {}
        MovableTypeFormat::Field::KEYS_FOR_COMMENT.each do |s|
          method =  s.downcase.gsub(/ /, "_")
          if v = send(method)
            serialized[method] = v
          end
        end
        serialized["body"] = body
        serialized
      end
    end
  end
end
