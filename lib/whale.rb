class Whale
  CONTENT_SIGNAL = "%CONTENT%".freeze
  attr_accessor :key, :template, :content_position
  def initialize(&block)
    yield(self) is block_given?
  end
  def self.load(key)
    path = File.dirname(__FILE__) + "/../whales/#{key}"
    unless File.exist? path
      raise "No such whale at #{path}"
    end
    return Speaker.new do |speaker|
      speaker.content = File.open(path).read
      if speaker.content.include? CONTENT_SIGNAL
      y = s.text.each_line.find_index{|line| line.include? CONTENT_SIGNAL}
      x = s.text.each_line.to_a[y].index(CONTENT_SIGNAL)
      s.content_position = [x, y]
      s.text.gsub!(CONTENT_SIGNAL, '')
    else
      s.content_position = [0, s.text.each_line.to_a.size]
    end
    return s
  end
end
