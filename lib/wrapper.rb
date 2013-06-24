class Wrapper
  def self.wrap(content, max_width)
    lines = []
    cur_line = ""
    content.split(' ').each do |word|
      if cur_line.size + word.size + 1 > max_width
        lines << cur_line
        cur_line = word
      else
        cur_line += " " if cur_line.length > 0
        cur_line += word
      end
    end
    lines << cur_line
    return lines
  end
end
