def shuffle_board(args)
  args.state.metadata.grid.length.times do |i|
    args.state.metadata.grid[i] = args.state.metadata.grid[i].shuffle
    col_arr = get_col(args.state.metadata.grid, i).shuffle
    
    col_arr.length.times do |j|
      args.state.metadata.grid[(args.state.metadata.grid.length - 1) - j][i] = col_arr[j]
    end
  end
  
  play_sound(:pop, args)
end

def draw_grid args
  t_col = get_palette_colors(args)

  draw_img($board, "img/rounded_rect.png")
  
  args.outputs.primitives << Border.new(
    $board.x - 1,
    $board.y,
    $board.w + 1,
    $board.h,
    0,
    0,
    0,
    255)
  
  args.state.metadata.grid.length.times do |i|
    args.state.metadata.grid[i].length.times do |j|
      if args.state.settings.effects_enabled == 1
        glow = glow_rect(j, i, args)
        draw_img(glow, "img/glow.png", 0, 0, 0, 0, args.state.metadata.connections.include?({ x: j, y: i }) ? args.state.counters.bcount : 255)
      end
      
      tile = tile_rect(j, i, args)
      idx = args.state.metadata.grid[i][j] - 1
      
      args.outputs.primitives << SuperSprite.new(
        args.state.themes.current_theme.idx[idx] * 128,
        0,
        128,
        128,
        tile.x,
        tile.y,
        tile.w,
        tile.h,
        args.state.themes.current_theme.img,
        (args.state.counters.theme_idx > 0 && args.state.metadata.connections.length > 1 && args.state.metadata.connections.include?({ x: j, y: i })) ? args.state.counters.rot : 0,
        t_col[idx].r,
        t_col[idx].g,
        t_col[idx].b,
        args.state.metadata.connections.include?({ x: j, y: i }) ? args.state.counters.bcount : t_col[idx].a)
    end
  end
end
