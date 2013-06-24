class 
  def self.parse(content)
    lines = content.each_line.map{|line| line.chomp}

    sig_x = lead_to_signal(lines[0])
    sig_y = lead_to_signal(lines.map{|line| line[0]})
    lines = lines[1..-1].map{|line| line[2..-1]}
    
    construct = {
      topleft: chop(lines, sig_x, sig_y, 0, 1, 0, 1),
      topfill: chop(lines, sig_x, sig_y, 1, 1,
    }
  end

  private
  def self.chop(lines, sig_x, sig_y, from_x, to_x, from_y, to_y)
    
  end
  def self.lead_to_signal(lead)
    markers = lead.each_with_index.map{|ch, i|
      if ch == ' '
        nil
      else
        i
      end
    }.compact
  end
end
