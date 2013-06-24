class Speaker
  BUBBLE_SIGNAL = "$BUBBLE$"

  attr_accessor :key, :tags, :text, :bubble_at
  def self.load(key)
    path = File.dirname(__FILE__) + "/../speakers/#{key}.rb"
    unless File.exist? path
      raise "No such speaker at #{path}"
    end
    data = File.open(path).read
    dsl = SpeakerDefinitionDSL.new
    dsl.instance_eval(data)
    s = Speaker.new
    s.key = key
    s.tags = dsl.tags
    s.text = dsl.text
    if s.text.include? BUBBLE_SIGNAL
      y = s.text.each_line.find_index{|line| line.include? BUBBLE_SIGNAL}
      x = s.text.each_line.to_a[y].index(BUBBLE_SIGNAL)
      s.bubble_at = [x, y]
      s.text.gsub!(BUBBLE_SIGNAL, '')
    else
      s.bubble_at = [0, s.text.each_line.to_a.size]
    end
    return s
  end
  class SpeakerDefinitionDSL
    attr_accessor :tags, :text
    def tags(*list)
      self.tags = [list].flatten
    end
    alias_method :tag, :tags
    def speak(text)
      self.text = (text || "").to_s
    end
  end
end
