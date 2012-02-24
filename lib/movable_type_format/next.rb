# Extend Enumerator
module MovableTypeFormat
  module Next
    def next_if_exists
      self.next
    rescue StopIteration
    end

    def next?
      !!self.peek
    rescue StopIteration
      false
    end
  end
end
