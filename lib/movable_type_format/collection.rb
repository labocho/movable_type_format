module MovableTypeFormat
  class Collection < Array
    def inspect
      to_mt
    end

    def to_mt
      map{|e| e.to_mt}.join
    end
  end
end
