class Bubble
  attr_accessor :key, :renderer
  def initialize(key, &renderer)
    self.key, self.renderer = key, renderer
  end
  def self.exist?(key)
    return File.exist? path(key)
  end
  def self.load(key)
    raise "No such bubble at #{path(key)}" unless exist?(key)
    data = File.open(path(key)).read
    dsl = BubbleDefinitionDSL.new
    dsl.instance_eval(data)
    return Bubble.new(key, &dsl.renderer)
  end
  def render(width, height)
    dsl = BubbleImplementationDSL.new
    dsl.instance_exec(width, height, &renderer)
    return dsl
  end
  private
  def self.path(key)
    return File.dirname(__FILE__) + "/../bubbles/#{key}.rb"
  end
  class BubbleDefinitionDSL
    attr_accessor :renderer
    def bubble(&block)
      self.renderer = block
    end
  end
  class BubbleImplementationDSL
    attr_accessor :lines, :text_padding
    def initialize
      self.lines = []
    end
    def render(lines)
      self.lines = lines
    end
    def pad_text(x, y)
      self.text_padding = [x, y]
    end
  end
end
