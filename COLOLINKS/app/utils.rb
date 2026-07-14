def pointer_inc(k1, k2, v1, v2)
  if $gtk.args.state.as_hash[k1].as_hash[k2] + 1 < v1
    $gtk.args.state.as_hash[k1].as_hash[k2] += 1
  else
    $gtk.args.state.as_hash[k1].as_hash[k2] = v2
  end
end

def pointer_dec(k1, k2, v1, v2)
  if $gtk.args.state.as_hash[k1].as_hash[k2] - 1 > v1
    $gtk.args.state.as_hash[k1].as_hash[k2] -= 1
  else
    $gtk.args.state.as_hash[k1].as_hash[k2] = v2
  end
end

def insert_text_at_pos(txt, txt2, pos = -1)
  if (pos == -1 || pos == txt.length)
    return txt.concat(txt2)
  else
    return txt.insert(pos, txt2)
  end
end

def remove_char_at_pos(txt, pos = -1)
  if (pos == -1 || pos == txt.length)
    return txt.chop!
  else
    return txt.slice!(pos)
  end
end

def rand_piece
  return rand(4) + 1
end

def rand_line
  return (6).map { rand_piece }
end

def secs_to_str(s = 0, f = 0)
  secs         = s
  mins         = 0
  mins_to_secs = 0
  hrs          = 0
  hrs_to_secs  = 0
  days         = 0
  days_to_secs = 0
  
  if secs > 43200
    days = secs.div(43200)
    days_to_secs = days * 43200
    secs -= days_to_secs
  end
  
  if secs > 3600
    hrs = secs.div(3600)
    hrs_to_secs = hrs * 3600
    secs -= hrs_to_secs
  end

  if secs > 60
    mins = secs.div(60)
    mins_to_secs = mins * 60
    secs -= mins_to_secs
  end
  
  if secs == 60
    secs = 0
    mins += 1
  end
  
  if mins == 60
    mins = 0
    hrs += 1
  end
  
  if hrs == 24
    hrs = 0
    days += 1
  end
  
  if f == 0
    return "#{days || 0}d #{hrs || 0}h #{mins || 0}m #{secs || 0}s"
  elsif f == 1
    return ((days || 0).to_s.rjust(2, "0")) + ":" + ((hrs || 0).to_s.rjust(2, "0")) + ":" + ((mins || 0).to_s.rjust(2, "0")) + ":" + ((secs || 0).to_s.rjust(2, "0"))
  end
end

def dragonruby_hex2color(h)
  color_r = h[0 .. 1].to_i(16)
  color_g = h[2 .. 3].to_i(16)
  color_b = h[4 .. 5].to_i(16)
  
  return { r: color_r, g: color_g, b: color_b, a: 255 }
end
