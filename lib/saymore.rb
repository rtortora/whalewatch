class Saymore
  MAX_WIDTH = 42
  def self.go!(speaker_key, bubble_key, content, opts = {})
    max_width = opts[:width] || opts[:max_width] || MAX_WIDTH
    wrapped_text = Wrapper.wrap(content, max_width)
    speaker = Speaker.load(speaker_key)
    bubble = Bubble.load(bubble_key)
    bubble_rendering = bubble.
      render(wrapped_text.map{|line| line.length}.max, wrapped_text.size)
    sc = Screen.new
    sc.draw 0, 0, speaker.text
    sc.draw *speaker.bubble_at, bubble_rendering.lines
    sc.draw(speaker.bubble_at[0] + bubble_rendering.text_padding[0],
            speaker.bubble_at[1] + bubble_rendering.text_padding[1],
            wrapped_text)
    return sc.to_s
  end
end
