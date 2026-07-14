def palettes_subvision_idxs(i)
  t = $gtk.args.state.settings.custom_palettes_enabled == 1 ? load_custom_palettes : get_palette

  return [ i - 1, i, (i == t.length - 1) ? 0 : i + 1 ]
end

def load_custom_palettes
  res = []
  
  if $gtk.platform != "Emscripten" && !is_mobile
    pl = $gtk.parse_json_file("custom_palettes.json")
    res = pl if !pl.nil?
  end
  
  return res
end

def palette_fallback args
  if args.state.settings.custom_palettes_enabled == 1
    t = load_custom_palettes
    
    if t.length == 0 || t[args.state.counters.custom_palette_idx].nil?
      args.state.settings.custom_palettes_enabled = 0
      args.state.counters.custom_palette_idx = 0
      args.state.counters.palette_idx = 0
    end
  end
end

def get_palette(i = nil)
  palettes = [
    [
      { r: 239, g: 71,  b: 111, a: 255 },
      { r: 255, g: 209, b: 102, a: 255 },
      { r: 6,   g: 214, b: 160, a: 255 },
      { r: 17,  g: 138, b: 178, a: 255 },
      { r: 0,   g: 240, b: 0,   a: 255 },
      { r: 230, g: 130, b: 238, a: 255 },
      { r: 128, g: 128, b: 128, a: 255 }
    ],
    [
      { r: 202, g: 183, b: 230, a: 255 },
      { r: 64,  g: 124, b: 108, a: 255 },
      { r: 106, g: 159, b: 115, a: 255 },
      { r: 95,  g: 187, b: 233, a: 255 },
      { r: 98,  g: 64,  b: 150, a: 255 },
      { r: 34,  g: 24,  b: 35,  a: 255 },
      { r: 128, g: 128, b: 128, a: 255 }
    ],
    [
      { r: 174, g: 128, b: 95,  a: 255 },
      { r: 60,  g: 28,  b: 17,  a: 255 },
      { r: 202, g: 153, b: 148, a: 255 },
      { r: 234, g: 233, b: 213, a: 255 },
      { r: 186, g: 34,  b: 47,  a: 255 },
      { r: 234, g: 202, b: 191, a: 255 },
      { r: 128, g: 128, b: 128, a: 255 }
    ],
    [
      { r: 159, g: 189, b: 125, a: 255 },
      { r: 228, g: 217, b: 155, a: 255 },
      { r: 230, g: 151, b: 121, a: 255 },
      { r: 111, g: 180, b: 221, a: 255 },
      { r: 180, g: 163, b: 207, a: 255 },
      { r: 215, g: 178, b: 197, a: 255 },
      { r: 128, g: 128, b: 128, a: 255 }
    ],
    [
      { r: 90,  g: 144, b: 190, a: 255 },
      { r: 236, g: 239, b: 195, a: 255 },
      { r: 130, g: 220, b: 244, a: 255 },
      { r: 68,  g: 219, b: 204, a: 255 },
      { r: 241, g: 133, b: 183, a: 255 },
      { r: 18,  g: 61,  b: 122, a: 255 },
      { r: 128, g: 128, b: 128, a: 255 }
    ],
    [
      { r: 255, g: 178, b: 124, a: 255 },
      { r: 255, g: 186, b: 214, a: 255 },
      { r: 245, g: 239, b: 91,  a: 255 },
      { r: 159, g: 236, b: 253, a: 255 },
      { r: 196, g: 218, b: 171, a: 255 },
      { r: 207, g: 209, b: 254, a: 255 },
      { r: 128, g: 128, b: 128, a: 255 }
    ],
    [
      { r: 152, g: 129, b: 121, a: 255 },
      { r: 142, g: 164, b: 161, a: 255 },
      { r: 233, g: 149, b: 121, a: 255 },
      { r: 219, g: 172, b: 142, a: 255 },
      { r: 232, g: 209, b: 182, a: 255 },
      { r: 207, g: 208, b: 202, a: 255 },
      { r: 128, g: 128, b: 128, a: 255 }
    ],
    [
      { r: 212, g: 238, b: 239, a: 255 },
      { r: 215, g: 206, b: 214, a: 255 },
      { r: 212, g: 174, b: 197, a: 255 },
      { r: 135, g: 206, b: 196, a: 255 },
      { r: 109, g: 149, b: 177, a: 255 },
      { r: 124, g: 117, b: 158, a: 255 },
      { r: 128, g: 128, b: 128, a: 255 }
    ],
    [
      { r: 241, g: 184, b: 53,  a: 255 },
      { r: 243, g: 225, b: 99,  a: 255 },
      { r: 236, g: 231, b: 201, a: 255 },
      { r: 236, g: 231, b: 165, a: 255 },
      { r: 104, g: 114, b: 75,  a: 255 },
      { r: 213, g: 179, b: 99,  a: 255 },
      { r: 128, g: 128, b: 128, a: 255 }
    ],
    [
      { r: 214, g: 242, b: 205, a: 255 },
      { r: 146, g: 238, b: 224, a: 255 },
      { r: 102, g: 95,  b: 146, a: 255 },
      { r: 167, g: 48,  b: 147, a: 255 },
      { r: 63,  g: 19,  b: 70,  a: 255 },
      { r: 19,  g: 6,   b: 26,  a: 255 },
      { r: 128, g: 128, b: 128, a: 255 }
    ]
  ]

  return i == nil ? palettes : palettes[i]
end

def get_palette_info(i)
  if $gtk.args.state.settings.custom_palettes_enabled == 0
    return [
      { name: "Colorful",       author: "Rabia Alhaffar" },
      { name: "Peacock",        author: "Rabia Alhaffar" },
      { name: "Cherry Blossom", author: "Rabia Alhaffar" },
      { name: "Kaleidoscope",   author: "Rabia Alhaffar" },
      { name: "Lilly",          author: "Rabia Alhaffar" },
      { name: "Pastel",         author: "Rabia Alhaffar" },
      { name: "Cozy",           author: "Rabia Alhaffar" },
      { name: "Unicorn",        author: "Rabia Alhaffar" },
      { name: "Daffodil",       author: "Rabia Alhaffar" },
      { name: "Galaxy",         author: "Rabia Alhaffar" }
    ][i]
  else
    return load_custom_palettes[i].transform_keys(&:to_sym)
  end
end

def get_palette_colors(args, i = nil)
  if i == nil
    if args.state.settings.custom_palettes_enabled == 1   
      res = []
    
      args.state.themes.current_palette.colors.length.times do |j|
        res << args.state.themes.current_palette.colors[j].transform_keys(&:to_sym)
      end
    
      return res
    else
      return args.state.themes.current_palette
    end
  else
    if args.state.settings.custom_palettes_enabled == 1   
      res = []
      t = load_custom_palettes[i]["colors"]
    
      t.length.times do |j|
        res << t[j].transform_keys(&:to_sym)
      end
    
      return res
    else
      return get_palette(i)
    end
  end
end

def draw_palette_block(i, x, y, args)
  p = nil
  
  if args.state.settings.custom_palettes_enabled == 1
    p = load_custom_palettes[i].transform_keys(&:to_sym).colors
  else
    p = get_palette(i)
  end
  
  c = p[0].transform_keys(&:to_sym)

  args.outputs.primitives << Solid.new(
    x,
    y,
    48,
    48,
    c.r,
    c.g,
    c.b,
    c.a)
  
  c = p[1].transform_keys(&:to_sym)
  
  args.outputs.primitives << Solid.new(
    x + 72,
    y,
    48,
    48,
    c.r,
    c.g,
    c.b,
    c.a)
  
  c = p[2].transform_keys(&:to_sym)
  
  args.outputs.primitives << Solid.new(
    x,
    y - 72,
    48,
    48,
    c.r,
    c.g,
    c.b,
    c.a)
  
  c = p[3].transform_keys(&:to_sym)
  
  args.outputs.primitives << Solid.new(
    x + 72,
    y - 72,
    48,
    48,
    c.r,
    c.g,
    c.b,
    c.a)
  
  c = p[4].transform_keys(&:to_sym)
  
  args.outputs.primitives << Solid.new(
    x,
    y - 144,
    48,
    48,
    c.r,
    c.g,
    c.b,
    c.a)
  
  c = p[5].transform_keys(&:to_sym)
  
  args.outputs.primitives << Solid.new(
    x + 72,
    y - 144,
    48,
    48,
    c.r,
    c.g,
    c.b,
    c.a)
end

def palettes_menu args
  main_menu_bg args
  
  back_button_rec = {
    x: args.state.counters.counter - 1265,
    y: 720 - 78,
    w: 64,
    h: 64,
  }

  prev_button_rec = {
    x: args.state.counters.counter - 1235,
    y: 252,
    w: 52,
    h: 52
  }

  next_button_rec = {
    x: args.state.counters.counter - 105,
    y: 252,
    w: 52,
    h: 52
  }
  
  palette_button_rec = {
    x: args.state.counters.counter - 80,
    y: 16,
    w: 64,
    h: 64
  }
  
  aabb_back_button = $pointer.intersect_rect?(back_button_rec)
  aabb_prev_button = $pointer.intersect_rect?(prev_button_rec)
  aabb_next_button = $pointer.intersect_rect?(next_button_rec)
  aabb_palette_button = $pointer.intersect_rect?(palette_button_rec)
  
  if !($gtk.platform == "Emscripten" || is_mobile)
    mode_button_rec = {
      x: args.state.counters.counter - 180,
      y: 500,
      w: 150,
      h: 50
    }
    
    aabb_mode_button = $pointer.intersect_rect?(mode_button_rec)
  end
  
  if args.state.counters.counter2 == 0
    if args.state.counters.counter < 1270
      args.state.counters.counter += 20
    else
      args.state.counters.counter_finished = 1
    end
  elsif args.state.counters.counter2 == 1
    if args.state.counters.counter > 0
      args.state.counters.counter -= 20
    else
      args.state.counters.counter = 0
      args.state.counters.counter2 = 0
      args.state.counters.counter3 = 0
      args.state.counters.counter4 = 0
      args.state.counters.counter_finished = 0
      args.state.metadata.prev_scene = args.state.metadata.scene
      args.state.metadata.scene = args.state.metadata.scene_to_go
    end
  end
  
  if args.state.tick_count % 120 == 0
    args.state.counters.counter3 = (args.state.counters.counter3 == 0) ? 1 : 0
  end
 
  args.outputs.primitives << Sprite.new(
    args.state.counters.counter - 920,
    600,
    96,
    96,
    (args.state.settings.effects_enabled == 1 && args.state.counters.counter3 == 1) ? "img/star.png" : "img/star_outlined.png",
    args.state.tick_count,
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Sprite.new(
    args.state.counters.counter - 460,
    600,
    96,
    96,
    (args.state.settings.effects_enabled == 1 && args.state.counters.counter3 == 1) ? "img/star.png" : "img/star_outlined.png",
    args.state.tick_count,
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Border.new(
    args.state.counters.counter - 750,
    170,
    220,
    220,
    255,
    0,
    200,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 795,
    args.state.counters.counter - 605,
    "PALETTES",
    22,
    "fonts/Confarreatio.ttf",
    255,
    255,
    0,
    255)
  
  draw_img(prev_button_rec, "img/triangle.png", 90, 255, 255, 0, 255)
  draw_img(next_button_rec, "img/triangle.png", 270, 255, 255, 0, 255)
  
  args.outputs.primitives << Line.new(
    16,
    args.state.counters.counter - 700,
    1280 - 16,
    args.state.counters.counter - 700,
    255,
    255,
    0,
    255)

  args.outputs.primitives << Label.new(
    40,
    args.state.counters.counter - 720,
    get_palette_info(args.state.settings.custom_palettes_enabled == 1 ? args.state.counters.custom_palette_idx : args.state.counters.palette_idx).name,
    16,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    0,
    200,
    255)
  
  args.outputs.primitives << Label.new(
    45,
    args.state.counters.counter - 778,
    "by",
    8,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    255,
    255)
  
  args.outputs.primitives << Label.new(
    95,
    args.state.counters.counter - 780,
    get_palette_info(args.state.settings.custom_palettes_enabled == 1 ? args.state.counters.custom_palette_idx : args.state.counters.palette_idx).author,
    8,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)

  draw_img(back_button_rec, "img/start_button_light.png", 180, 255, 255, 0, 255)
  draw_img(palette_button_rec, "img/brush.png", 0, 255, 255, 0, 255)
  
  custom_pal_disabled = args.state.settings.custom_palettes_enabled == 0
  custom_pal_enabled = args.state.settings.custom_palettes_enabled == 1
  
  if !($gtk.platform == "Emscripten" || is_mobile)
    draw_border(mode_button_rec, aabb_mode_button ? 26 : 255, aabb_mode_button ? 193 : 255, aabb_mode_button ? 221 : 255, 255)
  
    args.outputs.primitives << Label.new(
      custom_pal_disabled ? args.state.counters.counter - 171 : args.state.counters.counter - 155,
      542,
      custom_pal_disabled ? "Standard" : "Custom",
      6,
      "fonts/JetBrainsMono-Regular.ttf",
      aabb_mode_button ? 26 : 255,
      aabb_mode_button ? 193 : 255,
      aabb_mode_button ? 221 : 255,
      255)
  end
  
  idxs = custom_pal_enabled ? palettes_subvision_idxs(args.state.counters.custom_palette_idx) : palettes_subvision_idxs(args.state.counters.palette_idx)
  t = custom_pal_enabled ? load_custom_palettes : get_palette
  
  if t.length > 1
    idxs.length.times do |i|
      draw_palette_block(idxs[i], args.state.counters.counter - 1042 + (i * 340), 326, args)
    end
  else
    draw_palette_block(0, args.state.counters.counter - 1042 + (1 * 340), 326, args)
  end
  
  if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
    if args.inputs.keyboard.key_down.left || ($tapping && aabb_prev_button)
      if custom_pal_disabled
        pointer_dec(:counters, :palette_idx, -1, get_palette.length - 1)
      else
        pointer_dec(:counters, :custom_palette_idx, -1, load_custom_palettes.length - 1)
      end
      
      save_data args
      play_sound(:button, args)
    end
    
    if args.inputs.keyboard.key_down.right || ($tapping && aabb_next_button)
      if custom_pal_disabled
        pointer_inc(:counters, :palette_idx, get_palette.length, 0)
      else
        pointer_inc(:counters, :custom_palette_idx, load_custom_palettes.length, 0)
      end
      
      save_data args
      play_sound(:button, args)
    end
    
    if args.inputs.keyboard.key_down.escape || ($tapping && aabb_back_button)
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 1
      play_sound(:button, args)
    end
    
    if args.inputs.keyboard.key_down.space || ($tapping && aabb_palette_button)
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 8
      play_sound(:button, args)
    end
    
    if !($gtk.platform == "Emscripten" || is_mobile)
      if args.inputs.keyboard.key_down.tab || ($tapping && aabb_mode_button)
        if custom_pal_disabled
          if load_custom_palettes.length > 0
            args.state.settings.custom_palettes_enabled = 1
            args.state.counters.custom_palette_idx = 0
          end
        else
          args.state.settings.custom_palettes_enabled = 0
          args.state.counters.custom_palette_idx = 0
          args.state.counters.palette_idx = 0
        end
        
        save_data args
        play_sound(:button, args)
      end
    end
  end
end
