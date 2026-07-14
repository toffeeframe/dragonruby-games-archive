def provide_fixed_connection args
  p1 = args.state.metadata.connections[-1]
  p2 = args.state.metadata.connections[-2]
  
  if (p1.x == p2.x && p1.y == p2.y)
    args.state.metadata.connections.pop
    return
  end
end

def disable_connections_collision args
  args.state.metadata.connections.length.times do |i|
    if duparr(args.state.metadata.connections, args.state.metadata.connections[i]) > 1
      args.state.metadata.connections = []
      args.state.counters.rot = 0
      break
    end
  end
end

def disable_wrong_color_connection args
  p0 = args.state.metadata.connections[0]
  p_color = args.state.metadata.grid[p0.y][p0.x]
  
  args.state.metadata.connections.length.times do |i|
    c = args.state.metadata.connections[i]
    cv = args.state.metadata.grid[c.y][c.x]
    
    if ((cv != p_color) &&
        (cv != args.state.themes.empty_id - 1) &&
        (cv != args.state.themes.empty_id - 2))
      args.state.metadata.connections = []
      args.state.counters.rot = 0
      break
    end
  end
end

def disable_diagonal_movement args
  if (args.state.metadata.connections.length > 1)
    last_point = args.state.metadata.connections[-1]
    prelast_point = args.state.metadata.connections[-2]
    
    if ((last_point.x - prelast_point.x) != 0 && (last_point.y - prelast_point.y) != 0)
      args.state.metadata.connections = []
      args.state.counters.rot = 0
      return
    end
  end
end

def disable_lost_connection args
  if (args.state.metadata.connections.length > 1)
    args.state.metadata.connections.length.times do |i|
      pp1 = args.state.metadata.connections[i]
      pp2 = (i < args.state.metadata.connections.length - 1) ? pp2 = args.state.metadata.connections[i + 1] : pp1

      if ((pp1.x - pp2.x).abs > 1 || (pp1.y - pp2.y).abs > 1)
        args.state.metadata.connections = []
        args.state.counters.rot = 0
        break
      end
    end
  end
end

def draw_connections args
  if args.state.metadata.connections.length > 1
    args.state.metadata.connections.length.times do |i|
      po = args.state.metadata.connections[i]
      px = x_from_board(po.x, args)
      py = y_from_board(po.y)
      r = select_rect(px, py)
      
      draw_img(r, "img/rounded_rect_stroked.png", 0, args.state.themes.line_color.r, args.state.themes.line_color.g, args.state.themes.line_color.b, args.state.metadata.connections.include?({ x: po.x, y: po.y }) ? args.state.counters.bcount : args.state.themes.line_color.a)
    end
  end
end

def clear_content args
  x_list = []
  connection_color = 0
  color_background = true
  
  if (args.state.metadata.connections.length > 1)
    args.state.game_stats.connections_lengths << args.state.metadata.connections.length
    
    args.state.metadata.connections.length.times do |i|
      args.state.metadata.leavepoints << args.state.metadata.connections.reverse[i]
    end
  
    if (args.state.metadata.connections.length >= 6)
      yell args
    end
  
    fp = args.state.metadata.connections[0]
    connection_color = args.state.metadata.grid[fp.y][fp.x] - 1
    
    if (connection_color == args.state.game_stats.last_color_swiped)
      args.state.game_stats.color_chains += 1
    else
      args.state.game_stats.color_chains_lengths << args.state.game_stats.color_chains
      args.state.game_stats.color_chains = 0
    end
    
    args.state.game_stats.last_color_swiped = connection_color
    args.state.game_stats.player_moves += 1
    args.state.game_stats.score += (50 * (args.state.game_stats.color_chains + 1)) * args.state.metadata.connections.length
    
    args.state.metadata.connections.length.times do |i|
      p = args.state.metadata.connections[i]
      t = args.state.metadata.grid[p.y][p.x]
      
      if t == args.state.themes.empty_id - 2
        color_background = false
        args.state.counters.anim_rect = 1
        args.state.themes.anim_rect_color = args.state.settings.custom_palettes_enabled == 1 ? args.state.themes.current_palette.colors[connection_color].transform_keys(&:to_sym) : args.state.themes.current_palette[connection_color]
        line_marble(args, p.x, p.y)
        play_sound(:explosion, args)
        args.state.game_stats.collected_colors[args.state.themes.empty_id - 3] += 1
      
      elsif t == args.state.themes.empty_id - 1
        color_background = false
        clear_tiles_with_color(args, connection_color + 1, p.x, p.y)
        play_sound(:explosion, args)
        args.state.game_stats.collected_colors[args.state.themes.empty_id - 2] += 1
      
      else
        args.state.game_stats.collected_colors[t - 1] += 1
      end
      
      args.state.metadata.grid[p.y][p.x] = args.state.themes.empty_id
      x_list << p.x
    end
    
    if args.state.metadata.connections.length >= 6 && args.state.metadata.connections.length < 10
      p = args.state.metadata.connections[-1]
      args.state.metadata.grid[p.y][p.x] = args.state.themes.empty_id - 2
      play_sound(:powerup, args)
    elsif args.state.metadata.connections.length >= 10
      p = args.state.metadata.connections[-1]
      args.state.metadata.grid[p.y][p.x] = args.state.themes.empty_id - 1
      play_sound(:powerup, args)
    end
    
    x_list = x_list.uniq
    
    x_list.length.times do |i|
      c = purify_col(args.state.metadata.grid, x_list[i], args)
      
      c.length.times do |k|
        args.state.metadata.grid[(args.state.metadata.grid.length - 1) - k][x_list[i]] = c[k]
        correct_col(x_list[i], args)
      end
    end
    
    if color_background
      args.state.counters.anim_rect = 1
      args.state.themes.anim_rect_color = args.state.themes.line_color
    end
    
    play_sound(:pop, args)
  end
end

def draw_leavepoints args
  if args.state.settings.effects_enabled == 1
    if (args.state.metadata.leavepoints.length > 1)
      args.state.metadata.leavepoints.length.times do |i|
        p = args.state.metadata.leavepoints[i]
        r = leavepoint_rect(p.x, p.y, args)
        
        draw_img(r, "img/coloured_circle.png", args.state.tick_count * 10)
      end
    
      if args.state.settings.game_paused == 0
        if args.state.counters.anim_time % 150 == 0
          args.state.metadata.leavepoints.pop
          args.state.counters.anim_time = 0
        end
      end
    else
      args.state.counters.anim_enabled = 0
      args.state.metadata.leavepoints = []
    end
  end
end
