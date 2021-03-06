module MovableTypeFormat
  module Section
    class Metadata <  Base
      define_field_accessors MovableTypeFormat::Field::KEYS_FOR_METADATA

      def initialize(fields = Collection.new)
        super nil, fields
      end

      def categories
        fields.select{|f| f.key == "CATEGORY" }.map{|f| f.value}.freeze
      end
    end
  end
end
