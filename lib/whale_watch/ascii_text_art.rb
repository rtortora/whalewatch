module WhaleWatch
  # Represents an ASCII picture with an x, y position where text can
  # be overlaid.
  class AsciiTextArt
    # If this string appears in a file loaded in an {AsciiTextArt}
    # object, the start of that string is taken to be the x, y text
    # position.
    TEXT_SIGNAL = "%TEXT%"

    # @attr art [TextCanvas] The actual ASCII art.
    attr_reader :art

    # @attr text_point [Point] The x, y position where text can be
    # overlaid.
    attr_reader :text_point

    # @param art [TextCanvas] The ASCII string itself.
    # @param text_point [Point] The x, y position where text can be overlaid.
    def initialize(art, text_point)
      @art = art
      @text_point = text_point
    end

    # Loads ASCII art from the provided file path. The text x, y
    # position is set to the starting position of the xt '%TEXT%' if
    # it is present in the file, otherwise it is set to the bottom of
    # the art.
    def self.from_file(path)
      lines = File.read(path).each_line.to_a.map(&:chomp)
      if lines.any?{|line| line.include?(TEXT_SIGNAL)}
        y = lines.index{|line| line.include?(TEXT_SIGNAL)}
        x = lines[y].index(TEXT_SIGNAL)
        art = lines.join("\n")
              .gsub(TEXT_SIGNAL,
                    " " * TEXT_SIGNAL.size)
        return AsciiTextArt.new(TextCanvas.new(art),
                                Point.new(x, y))
      else
        art = lines.join("\n")
        return AsciiTextArt.new(TextCanvas.new(art),
                                Point.new(0, lines.size))
      end
    end
  end
end
