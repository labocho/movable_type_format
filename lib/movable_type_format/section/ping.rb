module MovableTypeFormat
  module Section
    class Ping <  Base
      define_field_accessors MovableTypeFormat::Field::KEYS_FOR_PING

      def initialize(fields = Collection.new, body = nil)
        super "PING", fields, body
      end

      def serialize
        serialized = {}
        MovableTypeFormat::Field::KEYS_FOR_PING.each do |s|
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
