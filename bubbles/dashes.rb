bubble do |w, h|
  pad_text 3, 1

  ch = "-"

  lines = []
  lines << ch * (w + 6)
  h.times do
    lines << ch * 2 + " " + " " * w + " " + ch * 2
  end
  lines << ch * (w + 6)
  render lines
end
