require "active_model"
module MovableTypeFormat
  module Section
    class Base
      include ActiveModel::Validations
      DELIMITER = "-----\n".freeze
      NAMES_OF_SINGLE_SECTION = ["BODY", "EXTENDED BODY", "EXCERPT", "KEYWORDS"].freeze
      NAMES_OF_MULTI_SECTION = ["COMMENT", "PING"].freeze
      NAMES = (NAMES_OF_SINGLE_SECTION + NAMES_OF_MULTI_SECTION).freeze
      attr_accessor :name, :fields, :body
      validates :name, inclusion: {in: NAMES}

      def self.build_by_name(name)
        case name
        when "COMMENT"
          Comment.new
        when "PING"
          Ping.new
        when nil
          Metadata.new
        else
          new(name)
        end
      end

      def self.define_field_accessors(keys)
        keys.each do |key|
          name = key.downcase.gsub(/ /, "_")
          define_method name do
            find_or_create_field(key).value
          end
          define_method "#{name}=" do |v|
            find_or_create_field(key).value = v
          end
        end
      end

      def initialize(name = nil, fields = Collection.new, body = nil)
        fields = case fields
        when Hash
          fields.inject(Collection.new) do |col, (key, value)|
            key = key.to_s.upcase.gsub(/_/, " ")
            col << Field.new(key, value)
            col
          end
        else
          fields
        end
        @name, @fields, @body = name, fields, body
      end

      def metadata?
        @name.nil?
      end

      def name
        @name
      end

      def to_mt
        buffer = ""
        buffer << "#{name}:\n" unless metadata?
        buffer << fields.to_mt unless fields.empty?
        buffer << "#{body}\n" if body
        buffer << DELIMITER
      end

      private
      def find_or_create_field(key)
        field = fields.find{|field| field.key == key}
        unless field
          field = Field.new(key)
          fields << field
        end
        field
      end
    end
  end
end
