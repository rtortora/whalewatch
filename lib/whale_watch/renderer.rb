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
      end_point = point + render_canvas.size
      unless canvas.size.contains?(end_point)
        resize(canvas.size.max(end_point + Point[1, 0]))
      end

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

    # Resizes the canvas while keeping the configured max width in
    # mind.
    # @param size [Point] the new size.
    def resize(size)
      canvas.resize(size, max_width: @max_width)
    end

    private

    # Breaks up one string into multiple lines based on a max
    # character width.
    # @param input [String]
    # @param max_width [Fixnum]
    # @return [String]
    def word_wrap(input, max_width)
      lines = []
      input.split(/ +/).each do |word|
        if lines.last.nil? ||
           lines.last.size + word.size + 1 > max_width
          lines << [word]
        else
          lines.last << word
        end
      end
      return lines.map{|line| line.join(' ')}
    end
  end
end
