module MovableTypeFormat
  module Section
    class Ping <  Base
      define_field_accessors MovableTypeFormat::Field::KEYS_FOR_PING

      def initialize(fields = Collection.new, body = nil)
        super "PING", fields, body
      end
    end
  end
end
