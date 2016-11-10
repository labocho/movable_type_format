module MovableTypeFormat
  class Collection < Array
    def to_mt
      map{|e| e.to_mt }.join
    end

    def +(another)
      self.class.new(super)
    end
  end
end
