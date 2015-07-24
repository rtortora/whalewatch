module WhaleWatch
  # Creates an off-screen canvas that can be rendered onto, resized,
  # print to the screen, etc.
  class Renderer
    # @attr canvas [TextCanvas] The canvas being rendered to.
    attr_reader :canvas

    # @attr max_width [Fixnum, nil] The maximum width allowed by
    # automatic renderer resizing.
    attr_reader :max_width

    # @param opt [Hash{Symbol=>Object}] Options.
    # @option opt :max_width [Fixnum, nil] Maximum width allowed by
    #   automatic renderer resizing. Defaults to nil.
    def initialize(opt = {})
      @canvas = TextCanvas.new
      @max_width = opt[:max_width]
    end

    # Gets the current rendered canvas.
    def to_s
      return canvas.to_s
    end

    # Renders a canvas onto the canvas at a given point.
    # @param render_canvas [String] A canvas to render.
    # @param point [Point] The point to render at. Defaults to origin
    #   (0, 0).
    def render_canvas(render_canvas, point = nil)
      point ||= Point.origin
      sizeup(point + render_canvas.size + Point[1, 0])
      render_canvas.lines.each_with_index do |line, y|
        canvas.overwrite(point + Point[0, y], line)
      end
    end

    # Renders text onto the canvas at a given point.
    # @param text [String] The text to display.
    # @param point [Point] The point at which to render the text.
    # @param opt [Hash{Symbol=>Object}] Options hash.
    # @option opt :word_wrap [Fixnum,nil] The maximum number of characters
    #   to print (relative to the starting point) before wrapping a
    #   word. If nil, doens't word wrap. Defaults to the max_width -
    #   starting point.
    def render_text(text, point = nil, opt = {})
      point ||= Point.origin

      if @max_width && !opt.key?(:word_wrap)
        opt[:word_wrap] = @max_width - point.x
      end

      if opt[:word_wrap]
        tc = TextCanvas.new(word_wrap(text, opt[:word_wrap]).join("\n"))
        render_canvas(tc, point)
      else
        render_canvas(TextCanvas.new(text), point)
      end
    end

    # Sizes the canvas up to the provided point. Only ever increases
    # the size of the canvas, doesn't decrease on either x or y.
    # @param size [Point] the new minimum size.
    def sizeup(size)
      return nil if canvas.size.contains?(size)
      canvas.resize(canvas.size.max(size), max_width: @max_width)
    end

    private

    # Breaks up one string into multiple lines based on a max
    # character width.
    # @param input [String]
    # @param max_width [Fixnum]
    # @return [String]
    def word_wrap(input, max_width)
      # List of lines, where each line is a list of words.
      lines = [[]]

      # Add words to the last line until it would go over the max
      # width, in which case start a new line.
      input.split(/ +/).each do |word|
        if (lines + [word]).join(' ').size < max_width
          lines.last << word
        else
          lines << [word]
        end
      end

      # We're done, just turn the lists of words into actual lines.
      return lines.map{|l| l.join(' ')}
    end
  end
end
