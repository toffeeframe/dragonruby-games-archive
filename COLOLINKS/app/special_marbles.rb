def line_marble(args, x, y)
  x_list = []
  ppp1 = []
  ppp2 = []
  grid_len = args.state.metadata.grid.length
  _0 = grid_len - 1
  
  grid_len.times do |i|
    if (i != y || i != x)
      px = args.state.metadata.grid[_0 - i][x]
      py = args.state.metadata.grid[y][i]
      
      if px == args.state.themes.empty_id - 2
        ppp1 << { x: x, y: _0 - i }
      elsif px == args.state.themes.empty_id - 1
        ppp2 << { x: x, y: _0 - i, c: rand_piece }
      end
    
      if py == args.state.themes.empty_id - 2
        ppp1 << { x: i, y: y }
      elsif py == args.state.themes.empty_id - 1
        ppp2 << { x: i, y: y, c: rand_piece }
      end
    end
    
    args.state.metadata.grid[_0 - i][x] = args.state.themes.empty_id
    args.state.metadata.leavepoints << { x: x, y: _0 - i }
    
    args.state.metadata.grid[y][i] = args.state.themes.empty_id
    args.state.metadata.leavepoints << { x: i, y: y }
    
    x_list << i
  end
  
  x_list = x_list.uniq
  args.state.game_stats.score += (100 * (args.state.game_stats.color_chains + 1)) * x_list.length
  
  x_list.length.times do |i|
    c = purify_col(args.state.metadata.grid, x_list[i], args)
    
    c.length.times do |k|
      args.state.metadata.grid[_0 - k][x_list[i]] = c[k]
      correct_col(x_list[i], args)
    end
  end
  
  ppp1.length.times do |i|
    if (ppp1[i].x != x || ppp1[i].y != y)
      line_marble(args, ppp1[i].x, ppp1[i].y)
    end
  end
  
  ppp2.length.times do |i|
    if (ppp2[i].x != x || ppp2[i].y != y)
      clear_tiles_with_color(args, ppp2[i].c, ppp2[i].x, ppp2[i].y)
    end
  end
  
  play_sound(:pop, args)
  
  if args.state.game_stats.time_left > 0
    args.state.game_stats.time_left += 4
  end
end

def clear_tiles_with_color(args, c, x, y)
  if args.state.game_stats.time_left > 0
    args.state.game_stats.time_left += 8
  end
  
  x_list = []
  
  args.state.metadata.grid.length.times do |i|
    args.state.metadata.grid[i].length.times do |j|
      t = args.state.metadata.grid[i][j]
      
      if t == c
        if t == args.state.themes.empty_id - 2
          line_marble(args, j, i)
        elsif t == args.state.themes.empty_id - 1
          clear_tiles_with_color(args, rand_piece, j, i)
        end
        
        args.state.metadata.leavepoints << { x: j, y: i }
        x_list << j
        args.state.metadata.grid[i][j] = args.state.themes.empty_id
      end
    end
  end
  
  args.state.metadata.grid[y][x] = args.state.themes.empty_id
  x_list << x
  x_list = x_list.uniq
  args.state.game_stats.score += (200 * (args.state.game_stats.color_chains + 1)) * x_list.length
  
  if x_list.length >= 6
    yell args
  end
  
  x_list.length.times do |i|
    col = purify_col(args.state.metadata.grid, x_list[i], args)
    
    col.length.times do |k|
      args.state.metadata.grid[(args.state.metadata.grid.length - 1) - k][x_list[i]] = col[k]
      correct_col(x_list[i], args)
    end
  end
  
  args.state.counters.anim_rect = 1
  args.state.themes.anim_rect_color = args.state.settings.custom_palettes_enabled == 1 ? args.state.themes.current_palette.colors[c - 1].transform_keys(&:to_sym) : args.state.themes.current_palette[c - 1]
  
  play_sound(:pop, args)
end

def activate_special_marbles args
  args.state.metadata.grid.length.times do |i|
    args.state.metadata.grid[i].length.times do |j|
      t = args.state.metadata.grid[i][j]
      
      if t == args.state.themes.empty_id - 1
        clear_tiles_with_color(args, rand_piece, j, i)
        play_sound(:explosion, args)
      elsif t == args.state.themes.empty_id - 2
        line_marble(args, j, i)
        play_sound(:explosion, args)
      end
    end
  end
  
  play_sound(:pop, args)
end
