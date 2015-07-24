module WhaleWatch
  # Stores a 'text canvas' - that is a string. Has methods for
  # treating it like a 2d character rendering.
  class TextCanvas
    # The fill character.
    FILL = " "

    # @attr body [String] The raw text string. Lines separated by '\n'.
    attr_reader :body

    # @attr initial_body [String] The initial body. Defaults to "".
    def initialize(initial_body = "")
      @body = initial_body
    end

    # @return [Array<String>] Returns the list of lines.
    def lines
      return @body.split("\n")
    end

    # @return [Point] The x, y size of the canvas, wheter x is the
    #   maximum line width and y is the number of lines.
    def size
      return Point.new(lines.map{|line| line.size}.max || 0,
                       lines.size)
    end

    # @param point [Point] the x, y to overwrite
    # @param str [String] The string to blindly overwrite.
    def overwrite(point, str)
      origin = point.y * (size.x + 1) + point.x
      @body = @body[0..origin] +
              str +
              (@body[(origin + str.size + 1)..-1] || '')
      nil
    end

    # Resizes the canvas. While increasing, spaces are used to
    # fill. While decreasing size, characters are cut off (not
    # wrapped).
    # @param size [Point] The new x, y size of the rendering.
    def resize(nsize, opt = {})
      # Enforce max width.
      if opt[:max_width] && nsize.x > opt[:max_width]
        nsize = Point.new(opt[:max_width], size.y)
      end

      new_body = ""
      (0...nsize.y).each do |y|
        (0...nsize.x).each do |x|
          if y < size.y &&
             x < size.x
            begin
              new_body += lines[y][x] || FILL
            rescue => e
              binding.pry
            end
          else
            new_body += FILL
          end
        end
        new_body += "\n"
      end
      @body = new_body
    end

    def to_s
      return @body
    end
  end
end
