bubble do |width, height|
  if height == 1
    pad_text 2, 1
    render [ " " + "_" * (width + 2),
             "<" + " " * (width + 2) + ">",
             " " + "-" * (width + 2) ]
  elsif height == 2
    pad_text 2, 1
    render [ " " + "_" * (width + 2),
             "/" + " " * (width + 2) + "\\",
             "\\" + " " * (width + 2) + "/",
             " " + "-" * (width + 2) ]
  else
    pad_text 3, 1
    lines = []
    lines << "  " + "_" * (width + 1)
    lines << " /" + " " * (width + 1) + "\\"
    (height - 2).times { lines << "|" + " " * (width + 3) + "|" }
    lines << " \\" + " " * (width + 1) + "/"
    lines << "  " + "-" * (width + 1) 
    render lines
  end
end
