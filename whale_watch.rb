module WhaleWatch
  SIG = "%MOUTH%".freeze
  MAX_WIDTH = 42.freeze

  # see a whale talk
  def self.whale_says(whale_name, content)
    whale = find_a_whale(whale_name)
    speaking = perspective(wwrap(content||"", MAX_WIDTH), mouth_at(whale))
    return silkscreen hide_mouth(whale), speaking
  end

  # load a whale file
  def self.find_a_whale(name = nil)
    name ||= 'whale'
    path = File.dirname(__FILE__) + "/whales/#{name}"
    raise "No whale at #{path}" unless File.exist? path
    return File.open(path).read
  end

  # get [x, y] of where %MOUTH% is
  def self.mouth_at(whale)
    return whale.count("\n") unless whale.include? SIG
    lines = whale.each_line.to_a
    y = lines.find_index{|l|l.include?(SIG)}
    return [lines[y].index(SIG), y]
  end

  # remove %MOUTH% signal from whale
  def self.hide_mouth(whale)
    return whale.gsub(SIG, " " * SIG.size)
  end
  
  # word wraps a string
  def self.wwrap(text, width)
    lines, cur = [], ""
    text.split.each do |w|
      if cur.size + w.size + 1 > width
        lines << cur if cur.size > 0
        cur = w
      else
        cur += " " if cur.size > 0
        cur += w
      end
    end
    lines << cur if cur.size > 0
    return lines.join("\n")
  end

  # resist urge to monkey patch
  def self.glines(str)
    return str.each_line.to_a.map{|x| x.chomp}
  end

  # moves a text block by [x, y] via adding spaces
  def self.perspective(text, pos)
    return "\n" * pos[1] + glines(text).map{|l| " " * pos[0] + l}.join("\n")
  end

  # overlays parts onto a single string
  def self.silkscreen(*parts)
    printing = ""
    max_x = parts.map{|p| glines(p).map{|l| l.size}.max}.max
    max_y = parts.map{|p| p.count("\n")}.max
    0.upto(max_y) do |y|
      0.upto(max_x) do |x|
        ch = ' '
        parts.each do |part|
          con = (glines(part)[y] || "").chars.to_a[x]
          ch = con unless con.nil? || con == ' '
        end
        printing += ch
      end
      printing += "\n"
    end
    return printing
  end
end
