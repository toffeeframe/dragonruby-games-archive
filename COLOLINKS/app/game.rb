def setup args
  args.state.metadata.mouse_bx                           ||= -1
  args.state.metadata.mouse_by                           ||= -1
  args.state.metadata.touched                            ||= 0
  args.state.metadata.touched_previously                 ||= 0
  args.state.metadata.scene                              ||= 0
  args.state.metadata.prev_scene                         ||= 0
  args.state.metadata.scene_to_go                        ||= 0
  args.state.metadata.connections                        ||= []
  args.state.metadata.leavepoints                        ||= []
  args.state.metadata.gameplay_bg_circles                ||= (12).map { (12).map { rand_piece } }
  args.state.metadata.bg_circles                         ||= (11).map { rand_line }
  args.state.metadata.kbdstr                             ||= ""
  args.state.metadata.cursor_pos                         ||= -1
  args.state.metadata.grid                               ||= (6).map { rand_line }
  
  args.state.metadata.achievements_list ||= [
    { name: "Evolved Newbie", description: "Reach a Score of 10000", condition: "(args.state.game_stats.score >= 10000)", unlocked: 0 },
    { name: "Insane Score!", description: "Reach a Score of 50000", condition: "(args.state.game_stats.score >= 50000)", unlocked: 0 },
    { name: "Chain Newbie", description: "Do 10 or more Color Chains in 1 Round", condition: "(args.state.game_stats.color_chains >= 10)", unlocked: 0 },
    { name: "Chain Apprentice", description: "Do 25 or more Color Chains in 1 Round", condition: "(args.state.game_stats.color_chains >= 25)", unlocked: 0 },
    { name: "Chain Master", description: "Do 50 or more Color Chains in 1 Round", condition: "(args.state.game_stats.color_chains >= 50)", unlocked: 0 },
    { name: "Punching Marbles", description: "Connect total of 100 Marbles in 1 Round", condition: "(args.state.game_stats.collected_colors.inject(:+) >= 100)", unlocked: 0 },
    { name: "Marble Collector", description: "Connect total of 250 Marbles in 1 Round", condition: "(args.state.game_stats.collected_colors.inject(:+) >= 250)", unlocked: 0 },
    { name: "Marble Controller", description: "Connect total of 500 Marbles in 1 Round", condition: "(args.state.game_stats.collected_colors.inject(:+) >= 500)", unlocked: 0 },
    { name: "Marbleville", description: "Connect total of 1000 Marbles in all the game", condition: "(args.state.game_stats.total_collected_colors.inject(:+) >= 1000)", unlocked: 0 },
    { name: "Marblewood", description: "Connect total of 5000 Marbles in all the game", condition: "(args.state.game_stats.total_collected_colors.inject(:+) >= 5000)", unlocked: 0 },
    { name: "Fastchain", description: "Do 25 or more Color Chains in 1 Round", condition: "(args.state.game_stats.color_chains >= 25)", unlocked: 0 },
    { name: "Chain-nado", description: "Do 50 or more Color Chains in 1 Round", condition: "(args.state.game_stats.color_chains >= 25)", unlocked: 0 },
    { name: "Surviver", description: "Stay in the Round for 5 Minutes", condition: "(args.state.game_stats.play_time >= 300)", unlocked: 0 },
    { name: "Linkmaster", description: "Link 15 or more Marbles on the Board in 1 Round", condition: "args.state.game_stats.connections_lengths.any? { |n| (15 ... 36).cover?(n) }", unlocked: 0 },
    { name: "COLOLINKS!", description: "Link 25 or more Marbles on the Board in 1 Round", condition: "args.state.game_stats.connections_lengths.any? { |n| (25 ... 36).cover?(n) }", unlocked: 0 },
  ]
  
  args.state.settings.sound_enabled                 ||= 1
  args.state.settings.music_enabled                 ||= 1
  args.state.settings.effects_enabled               ||= 1
  args.state.settings.volume                        ||= 100
  args.state.settings.fullscreen                    ||= 0
  args.state.settings.game_paused                   ||= 0
  args.state.settings.show_kbd                      ||= 0
  args.state.settings.kbdup                         ||= 0
  args.state.settings.custom_themes_enabled         ||= 0
  args.state.settings.custom_palettes_enabled       ||= 0
  args.state.settings.data_loaded                   ||= 0
  args.state.settings.game_save_loaded              ||= 0
  args.state.settings.played_game_previously        ||= 0

  args.state.net.req_state                          ||= 0
  args.state.net.req                                ||= nil
  args.state.net.latest_req                         ||= nil
  args.state.net.user_id                            ||= nil
  args.state.net.pid                                ||= ""
  args.state.net.req_timer                          ||= 0
  args.state.net.req_action                         ||= 0
  args.state.net.waypoints_done                     ||= 0
  args.state.net.waypoint_id                        ||= -1
  args.state.net.waypoint_step                      ||= -1
  args.state.net.run_waypoints                      ||= 0

  args.state.counters.theme_idx                     ||= 0
  args.state.counters.custom_theme_idx              ||= 0
  args.state.counters.custom_palette_idx            ||= 0
  args.state.counters.palette_idx                   ||= 0
  args.state.counters.ach_idx                       ||= 0
  args.state.counters.scrollbar_idx                 ||= 1
  args.state.counters.show_idx                      ||= 0
  args.state.counters.menu_anim_idx                 ||= 0
  args.state.counters.leaderboards_idx              ||= 0
  args.state.counters.counter                       ||= 0
  args.state.counters.counter2                      ||= 0
  args.state.counters.counter3                      ||= 0
  args.state.counters.counter4                      ||= 0
  args.state.counters.counter_finished              ||= 0
  args.state.counters.bg_counter                    ||= 0
  args.state.counters.tutorial_idx                  ||= 0
  args.state.counters.gameplay_bg_counter           ||= 0
  args.state.counters.kbd_idx                       ||= 0
  args.state.counters.anim_rect                     ||= 0
  args.state.counters.anim_rect_y                   ||= 0
  args.state.counters.anim_enabled                  ||= 0
  args.state.counters.anim_time                     ||= 0
  args.state.counters.anmov                         ||= 1500
  args.state.counters.rot                           ||= 0
  args.state.counters.show_timeup                   ||= 0
  args.state.counters.yell_state                    ||= 0
  args.state.counters.move_game_gui                 ||= 0
  args.state.counters.gover                         ||= 0
  args.state.counters.bcount                        ||= 255
  args.state.counters.bbcount                       ||= 255

  args.state.game_stats.plays                       ||= 0
  args.state.game_stats.score                       ||= 0
  args.state.game_stats.highscore                   ||= 0
  args.state.game_stats.pre_highscore               ||= 0
  args.state.game_stats.play_time                   ||= 0
  args.state.game_stats.total_time                  ||= 0
  args.state.game_stats.player_moves                ||= 0
  args.state.game_stats.total_moves                 ||= 0
  args.state.game_stats.color_chains_lengths        ||= []
  args.state.game_stats.best_color_chain            ||= 0
  args.state.game_stats.collected_colors            ||= (6).map { 0 }
  args.state.game_stats.total_collected_colors      ||= (6).map { 0 }
  args.state.game_stats.connections_lengths         ||= []
  args.state.game_stats.longest_connection_length   ||= 0
  args.state.game_stats.last_color_swiped           ||= -1
  args.state.game_stats.color_chains                ||= 0
  args.state.game_stats.broke_score                 ||= 0
  args.state.game_stats.time_left                   ||= 31
  args.state.game_stats.username                    ||= ""
  args.state.game_stats.old_username                ||= ""
  args.state.game_stats.achievements_unlocked       ||= []
  
  if args.state.settings.custom_themes_enabled == 0
    args.state.themes.current_theme = get_theme(args.state.counters.theme_idx)
  else
    args.state.themes.current_theme = load_custom_themes[args.state.counters.custom_theme_idx].transform_keys(&:to_sym)
  end
  
  if args.state.settings.custom_palettes_enabled == 0
    args.state.themes.current_palette = get_palette(args.state.counters.palette_idx)
  else
    args.state.themes.current_palette = load_custom_palettes[args.state.counters.custom_palette_idx].transform_keys(&:to_sym)
  end
  
  args.state.themes.empty_id                        ||= args.state.themes.current_theme.idx.length
  args.state.themes.color_grid_lines                ||= 0
  args.state.themes.anim_rect_color                 ||= { r: 0, g: 0, b: 0, a: 255 }
  args.state.themes.line_color                      ||= { r: 255, g: 255, b: 255, a: 255 }
  args.state.themes.background_color                ||= { r: 0, g: 0, b: 0, a: 255 }
end

def play args
  draw_background args
  gameplay_bg args
  draw_grid args
  draw_connections args
  draw_leavepoints args
  game_gui args
  
  if args.state.counters.show_timeup <= 0 && args.state.settings.game_paused == 0
    mouse_pos_onboard args
    handle_game_logic args
    handle_game_input args
  end
  
  yell_logic args
end

def handle_game_logic args
  if args.state.game_stats.time_left == 0
    args.audio[:song] = nil
    args.state.metadata.connections = []
    args.state.metadata.leavepoints = []
    
    if args.state.counters.show_idx < 2
      args.state.counters.show_idx += 1
    end
    
    if args.state.counters.show_idx == 1
      args.state.counters.show_timeup = 1
    end
    
    if args.state.counters.move_game_gui == 1
      if args.state.tick_count % 80 == 0
        args.state.counters.move_game_gui = 2
      end
    end
  
    if args.state.counters.move_game_gui == 2
      if args.state.counters.anmov < 1500
        args.state.counters.anmov += 60
        args.state.counters.counter = 1
      else
        args.state.counters.counter = 0
        args.state.counters.counter2 = 0
        args.state.counters.counter3 = 0
        args.state.counters.counter4 = 0
        
        if args.state.game_stats.score > args.state.game_stats.highscore
          args.state.game_stats.highscore = args.state.game_stats.score
          args.state.game_stats.broke_score = 1
        end
        
        args.state.game_stats.total_collected_colors.length.times do |i|
          args.state.game_stats.total_collected_colors[i] += args.state.game_stats.collected_colors[i]
        end
        
        args.state.game_stats.plays += 1
        args.state.game_stats.total_time += args.state.game_stats.play_time
        args.state.game_stats.total_moves += args.state.game_stats.player_moves
        
        if args.state.game_stats.color_chains_lengths.max > args.state.game_stats.best_color_chain
          args.state.game_stats.best_color_chain = args.state.game_stats.color_chains_lengths.max
        end
        
        if args.state.game_stats.connections_lengths.max > args.state.game_stats.longest_connection_length
          args.state.game_stats.longest_connection_length = args.state.game_stats.connections_lengths.max
        end
        
        args.state.game_stats.achievements_unlocked.length.times do |i|
          args.state.metadata.achievements_list[args.state.game_stats.achievements_unlocked[i]].unlocked = 1
        end
        
        args.state.game_stats.color_chains_lengths = []
        args.state.game_stats.connections_lengths = []
        args.state.metadata.prev_scene = args.state.metadata.scene
        save_data args
        args.state.metadata.scene = 3
        play_sound(:lose, args)
      end
    end
  else
    if (no_moves(args))
      args.state.counters.yell_state = 7
    end
    
    if args.state.game_stats.score > args.state.game_stats.highscore && args.state.game_stats.plays > 0
      if args.state.counters.counter4 + 1 < 2
        play_sound(:scorebreak, args)
        args.state.counters.counter4 += 1
      end
    end
    
    if args.state.game_stats.score > args.state.game_stats.highscore
      args.state.game_stats.pre_highscore = args.state.game_stats.score
    end
  
    if args.state.tick_count % 60 == 0
      args.state.game_stats.play_time += 1
      args.state.game_stats.time_left -= 1
      
      if args.state.game_stats.time_left <= 10
        play_sound(:tick, args)
      end
    end
    
    if args.state.counters.anim_enabled == 1
      args.state.counters.anim_time += 50
    end
  end
  
  if args.state.counters.counter == 0
    if args.state.counters.anmov > 0
      args.state.counters.anmov -= 60
    end
  elsif args.state.counters.counter == 1
    if args.state.counters.anmov < 1500
      args.state.counters.anmov += 60
    end
  end
end
