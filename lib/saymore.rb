class Saymore
  DEFAULT_MAX_WIDTH = 42.freeze
  def self.go!(whale_key, content, opts = {})
    max_width = opts[:width] || opts[:max_width] || DEFAULT_MAX_WIDTH
    wrapped_text = Wrapper.wrap(content, max_width)
    whale = Whale.load(whale_key)
    sc = Screen.new
    sc.draw 0, 0, whale.template
    sc.draw *speaker.content_position, wrapped_text
    return sc.to_s
  end
end
