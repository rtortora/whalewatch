module WhaleWatch
  # Represents a 2d point in cartesian space.
  class Point
    # @attr x [Fixnum] The x coordinate.
    attr_reader :x

    # @attr y [Fixnum] The y coordinate.
    attr_reader :y

    # @return [Point] Returns a new point with x, y coordinates 0, 0.
    def self.origin
      return Point.new(0, 0)
    end

    # @param x [Fixnum] The x coordinate.
    # @param y [Fixnum] The y coordinate.
    def initialize(x, y)
      @x = x
      @y = y
    end

    def to_s
      return "<#{x}, #{y}>"
    end

    def inspect
      return to_s
    end
  end
end
