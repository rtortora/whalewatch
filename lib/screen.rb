class Screen
  attr_accessor :lines
  def initialize(lines = {})
    self.lines = lines.clone
  end
  def self.build_partmap(partmap)
    number_of_parts = partmap.map{|partline| partline.size}.max
    build = []
    0.upto(number_of_parts - 1) do |part_number|
      build << Screen.parse(partmap.map{|partline| partline[part_number]})
    end
    return build
  end
  def self.parse(content)
    s = Screen.new
    s.draw(0, 0, content)
    return s
  end
  def draw(x, y, content)
    if content.is_a? Screen
      content = content.to_s
    end
    content = [content].flatten.
      map{|line| line.each_line.to_a.map{|y| y.chomp}}.flatten
    content.each_with_index do |line, yindex|
      self.lines[yindex + y] ||= {}
      line.chars.each_with_index do |ch, xindex|
        self.lines[yindex + y][xindex + x] = ch
      end
    end
  end
  def width
    lines.values.map{|line| line.keys.max}.max + 1
  end
  def height
    lines.keys.max + 1
  end
  def repeat_x!(times = 2)
    self.lines = repeat_x(times).lines
  end
  def repeat_x(times = 2)
    repeated = Screen.new
    times.times {|x| repeated.draw(x * width, 0, self)}
    return repeated
  end
  def repeat_y!(times = 2)
    self.lines = repeat_y(times).lines
  end
  def repeat_y(times = 2)
    repeated = Screen.new
    times.times {|y| repeated.draw(0, y * height, self)}
    return repeated
  end
  def to_s
    rendered_lines = []
    0.upto(lines.keys.max || 0) do |y|
      render_line = ""
      if lines[y]
        0.upto(lines[y].keys.max || 0) do |x|
          render_line += lines[y][x] || " "
        end
      end
      rendered_lines << render_line
    end
    return rendered_lines.join("\n")
  end
end
