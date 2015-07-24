module WhaleWatch
  # Represents an ASCII picture with an x, y position where text can
  # be overlaid.
  class AsciiTextArt
    # If this string appears in a file loaded in an {AsciiTextArt}
    # object, the start of that string is taken to be the x, y text
    # position.
    TEXT_SIGNAL = '%TEXT%'

    # @attr art [TextCanvas] The actual ASCII art.
    attr_reader :art

    # @attr text_point [Point] The x, y position where text can be
    # overlaid.
    attr_reader :text_point

    # @param art [TextCanvas] The ASCII string itself.
    # @param text_point [Point, nil] The x, y position where text can
    #   be overlaid. If nil, defaults to the bottom of the ASCII art.
    def initialize(art, text_point = nil)
      @art = art
      @text_point = text_point || Point.new(0, @art.lines.size)
    end

    # Loads ASCII art from the provided file path. The text x, y
    # position is set to the starting position of the text '%TEXT%' if
    # it is present in the file, otherwise it is set to the bottom of
    # the art.
    def self.from_file(path)
      return from_content(File.read(path))
    end

    # Loads ASCII art from the provided string. The text x, y
    # position is set to the starting position of the text '%TEXT%' if
    # it is present in the file, otherwise it is set to the bottom of
    # the art.
    def self.from_content(content)
      text_point = find_text_signal(content)
      if text_point
        content.gsub!(TEXT_SIGNAL, ' ' * TEXT_SIGNAL.size)
        return AsciiTextArt.new(TextCanvas.new(content), text_point)
      else
        return AsciiTextArt.new(TextCanvas.new(content))
      end
    end

    # Given an ASCII art body, find the x, y point at which the text
    # '%TEXT%' appears, or return nil.
    # @param content [String]
    # @return [Point, nil]
    def self.find_text_signal(content)
      if content.include?(TEXT_SIGNAL)
        lines = content.each_line.map(&:chomp)
        y = lines.index { |line| line.include?(TEXT_SIGNAL) }
        x = lines[y].index(TEXT_SIGNAL)
        return Point[x, y]
      else
        return nil
      end
    end
  end
end
