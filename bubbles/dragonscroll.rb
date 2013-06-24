bubble do |w, h|
  top = [
         ["     ", " ", "               /   \\              ", "    "],
         [" _   ", " ", "       )      ((   ))     (        ", "    "],
         ["(@)  ", " ", "      /|\\      ))_((     /|\\     ", "    "],
         ["|-|\\", " ", "     / | \\    (/\\|/\\)   / | \\  ", " (@)"],
         ["| | -", "-", "----/--|-voV---\\'|'/--Vov-|--\\------", "-|-|"],
         ["|-|  ", " ", "         '^'   (o o)  '^'          ", " | |"],
         ["| |  ", " ", "               '\\Y/'              ", " |-|"]
        ]
  mid = [
         ["|-|  ", " | |"],
         ["| |  ", " |-|"]
        ]
  bot = [
         ["|_|", "_",   "___________________________________", "__| |"],
         ["(@)", " ", "l   /\\ /         ( (       \\ /\\   l", "`\\|-|"],
         ["   ", " ", "l /   V           \\ \\       V   \\ l", "  (@)"],
         ["   ", " ", "l/                _) )_          \\I", "     "],
         ["   ", " ", "                  '\\ /'            ", "     "],
         ["   ", " ", "                    `              ", "     "]
        ]
  tl, tt, tm, tr = Screen.build_partmap(top)
  ml, mr = Screen.build_partmap(mid)
  bl, bt, bm, br = Screen.build_partmap(bot)
  filler_width_top = tl.width + tm.width + tr.width
  filler_width_bot = bl.width + bm.width + br.width

  orig = [w, h].clone
  w = [w, filler_width_top, filler_width_bot].max +
    [tl.width, bl.width].max + [tr.width, br.width].max
  half_nonfill_width_top = ((w - filler_width_top) / 2).round
  half_nonfill_width_bot = ((w - filler_width_bot) / 2).round

  canvas = Screen.new
  canvas.draw(0, 0, tl)
  canvas.draw(tl.width, 0, tt.repeat_x(half_nonfill_width_top))
  canvas.draw(tl.width + half_nonfill_width_top, 0, tm)
  canvas.draw(tl.width + half_nonfill_width_top + tm.width, 0,
              tt.repeat_x(half_nonfill_width_top))
  canvas.draw(tl.width + half_nonfill_width_top * 2 + tm.width, 0, tr)

  fill = Screen.new
  fill.draw(0, 0, ml)
  fill.draw(ml.width, 0, " " * (w - ml.width - mr.width))
  fill.draw(w - mr.width, 0, mr)
  fill.repeat_y!(((h + 0.5) / ml.height).round + 1)
  canvas.draw(0, tl.height, fill)

  bot_at = canvas.height
  canvas.draw(0, bot_at, bl)
  canvas.draw(bl.width, bot_at, bt.repeat_x(half_nonfill_width_bot))
  canvas.draw(bl.width + half_nonfill_width_bot, bot_at, bm)
  canvas.draw(bl.width + half_nonfill_width_bot + bm.width, bot_at,
              bt.repeat_x(half_nonfill_width_bot))
  canvas.draw(bl.width + half_nonfill_width_bot * 2 + bm.width, bot_at, br)

  pad_text 5, 8
  render canvas
end
