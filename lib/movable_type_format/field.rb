require "active_model"
require "time"
require "date"
module MovableTypeFormat
  class Field
    KEYS_FOR_METADATA = [
      "AUTHOR", "TITLE", "BASENAME", "STATUS", "ALLOW", "COMMENTS", "ALLOW PINGS",
      "CONVERT BREAKS", "PRIMARY CATEGORY", "CATEGORY", "DATE", "TAGS", "NO ENTRY"
    ]
    KEYS_FOR_COMMENT = ["AUTHOR", "EMAIL", "URL", "IP", "DATE"]
    KEYS_FOR_PING = ["TITLE", "URL", "IP", "BLOG NAME", "DATE"]
    KEYS = (KEYS_FOR_METADATA + KEYS_FOR_COMMENT + KEYS_FOR_PING).uniq.freeze
    STATUS_VALUES = %w(draft publish future)
    ALLOW_COMMENTS_VALUES = %w(0 1)
    CONVERT_BREAKS_VALUES = %w(0 1 markdown markdown_with_smartypants richtext textile_2)
    DATE_REGEXP = %r{\A(\d\d)/(\d\d)/(\d\d\d\d) (\d\d):(\d\d):(\d\d)( AM| PM)?\z}
    DATE_FORMAT = "%m/%d/%Y %H:%M:%S"

    include ActiveModel::Validations
    attr_accessor :key, :value
    validates :key, presence: true
    validates :value, presence: true

    validate do
      if key
        if KEYS.include?(key) || custom_field?
          validate_value
        else
          errors.add(:key, :format)
        end
      end
    end

    def initialize(key = nil, value = nil)
      @key, @value = key, value
    end

    def value
      case key
      when "DATE"
        case @value
        when Date, Time
          @value
        else
          parse_date @value
        end
      when "TAGS"
        case @value
        when Array
          @value
        else
          parse_tags @value
        end
      else
        @value
      end
    end

    def inspect
      to_mt
    end

    def custom_field?
      key && key =~ /\ACF50_.+\z/
    end

    def to_mt
      case key
      when "DATE"
        case value
        when Date, Time
          "#{key}: #{value.strftime(DATE_FORMAT)}\n"
        else
          time = parse_date(value)
          "#{key}: #{time.strftime(DATE_FORMAT)}\n"
        end
      when "TAGS"
        case value
        when Array
          tags = value.map{|tag|
            tag = %{"#{tag}"} if tag =~ / /
            tag
          }.join(",")
          "#{key}: #{tags}\n"
        else
          "#{key}: #{value}\n"
        end
      else
        "#{key}: #{value}\n"
      end
    end

    private
    def validate_value
      return unless value
      case key
      when "STATUS"
        unless STATUS_VALUES.include?(value.downcase)
          errors.add(:value, :inclusion)
        end
      when "ALLOW COMMENTS"
        unless ALLOW_COMMENTS_VALUES.include?(value.to_s)
          errors.add(:value, :inclusion)
        end
      when "CONVERT BREAKS"
        unless CONVERT_BREAKS_VALUES.include?(value.to_s)
          errors.add(:value, :inclusion)
        end
      when "DATE"
        unless value.is_a?(Date) || value.is_a?(Time) || value =~ DATE_REGEXP
          errors.add(:value, :format)
        end
      end
    end

    def parse_date(string)
      return unless string
      string =~ DATE_REGEXP
      m, d, y, h, min, s, am_pm = $~.captures
      if am_pm == " PM"
        h = h.to_i + 12
      end
      Time.new(y.to_i, m.to_i, d.to_i, h.to_i, min.to_i, s.to_i)
    end

    def parse_tags(string)
      return unless string
      string.split(",").map{|tag|
        tag =~ /\A"(.+)"\z/ ? $1 : tag
      }
    end
  end
end
