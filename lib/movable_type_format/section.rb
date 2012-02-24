require "active_model"
module MovableTypeFormat
  class Section
    include ActiveModel::Validations
    DELIMITER = "-----\n".freeze
    NAMES = ["BODY", "EXTENDED BODY", "EXCERPT", "KEYWORDS", "COMMENT"]
    attr_accessor :name, :fields, :body
    validates :name, inclusion: {in: NAMES}

    def initialize(name = nil, fields = Collection.new, body = nil)
      @name, @fields, @body = name, fields, body
    end

    def metadata?
      @name.nil?
    end

    def name
      @name || "[METADATA]"
    end

    def inspect
      to_mt
    end

    def to_mt
      buffer = ""
      buffer << "#{name}:\n" unless metadata?
      buffer << fields.to_mt unless fields.empty?
      buffer << body if body
      buffer << DELIMITER
    end
  end
end
