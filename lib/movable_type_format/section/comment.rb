module MovableTypeFormat
  module Section
    class Comment <  Base
      define_field_accessors MovableTypeFormat::Field::KEYS_FOR_COMMENT

      def initialize(fields = Collection.new, body = nil)
        super "COMMENT", fields, body
      end
    end
  end
end
