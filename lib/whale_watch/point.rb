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

    # Convenience constructor.
    def self.[](x, y)
      return Point.new(x, y)
    end

    # Returns a point equal to this one but with the X capped at some
    # value. If nil is passed, returns self.
    # @param max_x [Fixnum, nil]
    # @return [Point]
    def cap_x(max_x)
      return Point[[x, max_x].min, y] if max_x
      return self
    end

    # Gets the max x and y components between the two points.
    # @param other [Point]
    # @return [Point]
    def max(other)
      return Point[[x, other.x].max, [y, other.y].max]
    end

    # Determines if this point is larger on both x and y than the
    # provided point.
    # @param other [Point]
    # @return [true, false]
    def contains?(other)
      return x >= other.x && y >= other.y
    end

    # Takes another point, adds the two together.
    # @param other [Point]
    # @return [Point]
    def +(other)
      return Point[x + other.x, y + other.y]
    end

    def to_s
      return "<#{x}, #{y}>"
    end

    def inspect
      return to_s
    end
  end
end
