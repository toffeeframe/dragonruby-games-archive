def draw_background args
  if args.state.settings.effects_enabled == 1
    if args.state.counters.anim_rect == 1
      if args.state.counters.anim_rect_y % 730 == 0
        args.state.counters.anim_rect = 0
        args.state.counters.anim_rect_y = 0
        args.state.themes.background_color = args.state.themes.anim_rect_color
      end
    
      args.state.counters.anim_rect_y += 10
    
      args.outputs.primitives << Solid.new(
        475,
        0,
        1280 - 475,
        args.state.counters.anim_rect_y,
        args.state.themes.anim_rect_color.r,
        args.state.themes.anim_rect_color.g,
        args.state.themes.anim_rect_color.b,
        args.state.themes.anim_rect_color.a)
    end
  end
end

def main_menu_bg args
  if args.state.settings.effects_enabled == 1
    t_col = get_palette_colors(args)
    
    args.state.metadata.bg_circles.length.times do |i|
      args.state.metadata.bg_circles[i].length.times do |j|
        idx = args.state.metadata.bg_circles[i][j] - 1
        
        args.outputs.primitives << SuperSprite.new(
          (args.state.themes.current_theme.idx[idx]) * 128,
          0,
          128,
          128,
          ((i * 125) + 50) - args.state.counters.bg_counter,
          (j * 125),
          100,
          100,
          args.state.themes.current_theme.img,
          0,
          t_col[idx].r,
          t_col[idx].g,
          t_col[idx].b,
          50)
      end
    end
  
    args.state.counters.bg_counter += 4
  
    if args.state.counters.bg_counter >= 140
      args.state.metadata.bg_circles << rand_line
      args.state.metadata.bg_circles = args.state.metadata.bg_circles.drop(1)
      args.state.counters.bg_counter = 0
    end
  end
end

def gameplay_bg args
  if args.state.settings.effects_enabled == 1
    args.state.metadata.gameplay_bg_circles.length.times do |i|
      args.state.metadata.gameplay_bg_circles[i].length.times do |j|
        args.outputs.primitives << SuperSprite.new(
          (args.state.themes.current_theme.idx[args.state.metadata.gameplay_bg_circles[i][j] - 1]) * 128,
          0,
          128,
          128,
          (505 + (j * 64)),
          20 + (i * 64) - args.state.counters.gameplay_bg_counter,
          48,
          48,
          args.state.themes.current_theme.img,
          args.state.tick_count * 2,
          0,
          0,
          0,
          255)
      end
    end
  
    args.state.counters.gameplay_bg_counter += 1
  
    if args.state.counters.gameplay_bg_counter % 60 == 0
      args.state.metadata.gameplay_bg_circles << (12).map { rand_piece }
      args.state.metadata.gameplay_bg_circles = args.state.metadata.gameplay_bg_circles.drop(1)
      args.state.counters.gameplay_bg_counter = 0
    end
  end
end
