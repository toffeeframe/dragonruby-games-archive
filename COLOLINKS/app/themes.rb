def themes_subvision_idxs(i)
  t = $gtk.args.state.settings.custom_themes_enabled == 1 ? load_custom_themes : get_theme

  return [ i - 1, i, (i == t.length - 1) ? 0 : i + 1 ]
end

def load_custom_themes
  res = []
  
  if $gtk.platform != "Emscripten" && !is_mobile
    tl = $gtk.read_file("custom_themes/themes.txt")
  
    if !tl.nil?
      tl = tl.split("\n")
      
      tl.length.times do |i|
        tname = tl[i]
        
        if $gtk.read_file("custom_themes/#{tname}/metadata.json")
          o = $gtk.parse_json_file("custom_themes/#{tname}/metadata.json")
          o["img"] = "custom_themes/#{tname}/#{o["img"]}"
          res << o
        end
      end
    end
  end
  
  return res
end

def theme_fallback args
  if args.state.settings.custom_themes_enabled == 1
    t = load_custom_themes
    
    if t.length == 0 || t[args.state.counters.custom_theme_idx].nil?
      args.state.settings.custom_themes_enabled = 0
      args.state.counters.custom_theme_idx = 0
      args.state.counters.theme_idx = 0
    end
  end
end

def get_theme(i = nil)
  themes = [
    { img: "img/circle.png",                        idx: (7).map { 0 }           },
    { img: "img/default_themes/dice.png",           idx: [ 0, 1, 2, 3, 4, 5, 0 ] },
    { img: "img/default_themes/space.png",          idx: [ 0, 1, 2, 3, 4, 5, 0 ] },
    { img: "img/default_themes/candy.png",          idx: [ 0, 1, 2, 3, 4, 4, 0 ] },
    { img: "img/default_themes/tetris.png",         idx: [ 0, 1, 2, 3, 4, 5, 0 ] },
    { img: "img/default_themes/math.png",           idx: [ 0, 1, 2, 3, 4, 5, 0 ] },
    { img: "img/default_themes/roman_numbers.png",  idx: [ 0, 1, 2, 3, 4, 5, 0 ] },
    { img: "img/default_themes/magnetic_neo.png",   idx: [ 0, 1, 2, 3, 4, 5, 0 ] },
    { img: "img/default_themes/magical.png",        idx: [ 0, 1, 2, 3, 4, 5, 0 ] },
    { img: "img/default_themes/kingdom.png",        idx: [ 0, 1, 2, 3, 4, 5, 0 ] },
    { img: "img/default_themes/geometry.png",       idx: [ 0, 1, 2, 3, 4, 5, 0 ] }
  ]
  
  return i == nil ? themes : themes[i]
end

def get_theme_info(i)
  if $gtk.args.state.settings.custom_themes_enabled == 0
    return [
      { name: "Basic",         author: "Rabia Alhaffar" },
      { name: "Dice",          author: "Rabia Alhaffar" },
      { name: "Space",         author: "Rabia Alhaffar" },
      { name: "Candy",         author: "Rabia Alhaffar" },
      { name: "Tetris",        author: "Rabia Alhaffar" },
      { name: "Algebra",       author: "Rabia Alhaffar" },
      { name: "Roman Numbers", author: "Mostafa Alhdad" },
      { name: "Magnet",        author: "Rabia Alhaffar" },
      { name: "Magical",       author: "Rabia Alhaffar" },
      { name: "Kingdom",       author: "Rabia Alhaffar" },
      { name: "Geometry",      author: "Rabia Alhaffar" }
    ][i]
  else
    return load_custom_themes[i].transform_keys(&:to_sym)
  end
end

def draw_theme_block(i, x, y, args)
  t_idx = args.state.settings.custom_themes_enabled == 1 ? load_custom_themes[i]["idx"] : get_theme[i].idx
  t_img = args.state.settings.custom_themes_enabled == 1 ? load_custom_themes[i]["img"] : get_theme[i].img
  t_col = get_palette_colors(args)
  
  args.outputs.primitives << SuperSprite.new(
    t_idx[0] * 128,
    0,
    128,
    128,
    x,
    y,
    64,
    64,
    t_img,
    0,
    t_col[0].r,
    t_col[0].g,
    t_col[0].b,
    t_col[0].a)
  
  args.outputs.primitives << SuperSprite.new(
    t_idx[1] * 128,
    0,
    128,
    128,
    x + 112,
    y,
    64,
    64,
    t_img,
    0,
    t_col[1].r,
    t_col[1].g,
    t_col[1].b,
    t_col[1].a)
  
  args.outputs.primitives << SuperSprite.new(
    t_idx[2] * 128,
    0,
    128,
    128,
    x,
    y - 112,
    64,
    64,
    t_img,
    0,
    t_col[2].r,
    t_col[2].g,
    t_col[2].b,
    t_col[2].a)
  
  args.outputs.primitives << SuperSprite.new(
    t_idx[3] * 128,
    0,
    128,
    128,
    x + 112,
    y - 112,
    64,
    64,
    t_img,
    0,
    t_col[3].r,
    t_col[3].g,
    t_col[3].b,
    t_col[3].a)

  if args.state.counters.counter3 == 0
    args.outputs.primitives << SuperSprite.new(
      t_idx[4] * 128,
      0,
      128,
      128,
      x + 56,
      y - 56,
      64,
      64,
      t_img,
      0,
      t_col[4].r,
      t_col[4].g,
      t_col[4].b,
      t_col[4].a)
  else
    args.outputs.primitives << SuperSprite.new(
      t_idx[5] * 128,
      0,
      128,
      128,
      x + 56,
      y - 56,
      64,
      64,
      t_img,
      0,
      t_col[5].r,
      t_col[5].g,
      t_col[5].b,
      t_col[5].a)
  end
end

def themes_menu args
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
    598,
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
    598,
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
    args.state.counters.counter - 780,
    args.state.counters.counter - 608,
    "THEMES",
    28,
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
    get_theme_info(args.state.settings.custom_themes_enabled == 1 ? args.state.counters.custom_theme_idx : args.state.counters.theme_idx).name,
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
    get_theme_info(args.state.settings.custom_themes_enabled == 1 ? args.state.counters.custom_theme_idx : args.state.counters.theme_idx).author,
    8,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  draw_img(back_button_rec, "img/start_button_light.png", 180, 255, 255, 0, 255)
  draw_img(palette_button_rec, "img/bucket.png", 0, 255, 255, 0, 255)
  
  if !($gtk.platform == "Emscripten" || is_mobile)
    draw_border(mode_button_rec, aabb_mode_button ? 26 : 255, aabb_mode_button ? 193 : 255, aabb_mode_button ? 221 : 255, 255)
  
    args.outputs.primitives << Label.new(
      args.state.settings.custom_themes_enabled == 0 ? args.state.counters.counter - 171 : args.state.counters.counter - 155,
      542,
      args.state.settings.custom_themes_enabled == 0 ? "Standard" : "Custom",
      6,
      "fonts/JetBrainsMono-Regular.ttf",
      aabb_mode_button ? 26 : 255,
      aabb_mode_button ? 193 : 255,
      aabb_mode_button ? 221 : 255,
      255)
  end
  
  idxs = args.state.settings.custom_themes_enabled == 1 ? themes_subvision_idxs(args.state.counters.custom_theme_idx) : themes_subvision_idxs(args.state.counters.theme_idx)
  t = args.state.settings.custom_themes_enabled == 1 ? load_custom_themes : get_theme
  
  if t.length > 1
    idxs.length.times do |i|
      draw_theme_block(idxs[i], args.state.counters.counter - 1070 + (i * 340), 300, args)
    end
  else
    draw_theme_block(0, args.state.counters.counter - 1070 + (1 * 340), 300, args)
  end
  
  if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
    if args.inputs.keyboard.key_down.left || ($tapping && aabb_prev_button)
      if args.state.settings.custom_themes_enabled == 0
        pointer_dec(:counters, :theme_idx, -1, get_theme.length - 1)
      else
        pointer_dec(:counters, :custom_theme_idx, -1, load_custom_themes.length - 1)
      end
      
      save_data args
      play_sound(:button, args)
    end
    
    if args.inputs.keyboard.key_down.right || ($tapping && aabb_next_button)
      if args.state.settings.custom_themes_enabled == 0
        pointer_inc(:counters, :theme_idx, get_theme.length, 0)
      else
        pointer_inc(:counters, :custom_theme_idx, load_custom_themes.length, 0)
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
      args.state.metadata.scene_to_go = 15
      play_sound(:button, args)
    end
    
    if !($gtk.platform == "Emscripten" || is_mobile)
      if args.inputs.keyboard.key_down.tab || ($tapping && aabb_mode_button)
        if args.state.settings.custom_themes_enabled == 0
          if load_custom_themes.length > 0
            args.state.settings.custom_themes_enabled = 1
            args.state.counters.custom_theme_idx = 0
          end
        else
          args.state.settings.custom_themes_enabled = 0
          args.state.counters.custom_theme_idx = 0
          args.state.counters.theme_idx = 0
        end
        
        save_data args
        play_sound(:button, args)
      end
    end
  end
end
