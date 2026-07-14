def load_data args
  if args.state.settings.data_loaded == 0
    f = [ :metadata, :settings, :net, :counters, :game_stats, :themes ]
    d = []
    
    deafdata = $gtk.deserialize_state("data/deafdata.txt")
    if deafdata
      args.state = deafdata
    end
    
    f.length.times do |i|
      d[i] = $gtk.deserialize_state("data/#{(f[i]).to_s}.txt")
      
      if d[i]
        args.state.as_hash[f[i]] = d[i]
      end
    end
    
    if deafdata
      theme_fallback args
      palette_fallback args
      
      args.state.settings.game_save_loaded = 1
      args.state.settings.game_paused = 0
      args.state.metadata.scene = 0
      args.state.metadata.prev_scene = 0
      args.state.counters.counter = 0
      args.state.counters.counter2 = 0
      args.state.counters.counter3 = 0
      args.state.counters.counter4 = 0
      args.state.counters.counter_finished = 0
      args.state.counters.scrollbar_idx = 1
      args.state.counters.bcount = 255
      args.state.counters.bbcount = 255
      args.state.net.req_timer = 0
      args.state.net.req_state = 0
      args.state.net.req_action = 0
      args.state.net.req = nil
      args.state.net.latest_req = nil
      leaderboards_re_request(0, args)
      
      if args.state.settings.game_save_loaded == 1 && args.state.game_stats.highscore > 0 || args.state.game_stats.username != ""
        args.state.settings.played_game_previously = 1
      end
    end
    
    args.state.settings.data_loaded = 1
  end
end

def save_data args
  args.state.net.latest_req = nil
  args.state.themes.background_color = nil
  
  f = [ :metadata, :settings, :net, :counters, :game_stats, :themes ]
  d = []
  
  args.state.as_hash[:__thrash_count__].clear if args.state.as_hash[:__thrash_count__]
  
  f.length.times do |i|
    args.state.as_hash[f[i]].as_hash[:__thrash_count__].clear if args.state.as_hash[f[i]].as_hash[:__thrash_count__]
  end
  
  data0 = $gtk.serialize_state $gtk.args.state.as_hash.reject { |key, value|
    f.include?(key)
  }
  
  $gtk.write_file("data/deafdata.txt", data0)
  
  f.length.times do |i|
    d[i] = $gtk.serialize_state(args.state.as_hash[f[i]])
    $gtk.write_file("data/#{(f[i]).to_s}.txt", d[i])
  end
end

def reset_data args
  args.state.metadata.connections                   = []
  args.state.metadata.leavepoints                   = []
  args.state.metadata.gameplay_bg_circles           = (12).map { (12).map { rand_piece } }
  args.state.metadata.bg_circles                    = (11).map { rand_line }
  args.state.metadata.kbdstr                        = ""
  args.state.metadata.grid                          = (6).map { rand_line }
  args.state.metadata.cursor_pos                    = -1

  args.state.settings.game_paused                   = 0
  args.state.settings.show_kbd                      = 0
  args.state.settings.kbdup                         = 0
  
  args.state.net.req_state                          = 0
  args.state.net.req                                = nil
  args.state.net.latest_req                         = nil
  args.state.net.user_id                            = nil
  args.state.net.pid                                = ""
  args.state.net.req_timer                          = 0
  args.state.net.req_action                         = 0
  args.state.net.waypoints_done                     = 0
  args.state.net.waypoint_id                        = -1
  args.state.net.waypoint_step                      = -1
  args.state.net.run_waypoints                      = 0
  
  args.state.counters.theme_idx                     = 0
  args.state.counters.custom_theme_idx              = 0
  args.state.counters.palette_idx                   = 0
  args.state.counters.ach_idx                       = 0
  args.state.counters.scrollbar_idx                 = 1
  args.state.counters.show_idx                      = 0
  args.state.counters.menu_anim_idx                 = 0
  args.state.counters.leaderboards_idx              = 0
  args.state.counters.counter3                      = 0
  args.state.counters.counter4                      = 0
  args.state.counters.bg_counter                    = 0
  args.state.counters.tutorial_idx                  = 0
  args.state.counters.gameplay_bg_counter           = 0
  args.state.counters.kbd_idx                       = 0
  args.state.counters.anim_rect                     = 0
  args.state.counters.anim_rect_y                   = 0
  args.state.counters.anim_enabled                  = 0
  args.state.counters.anim_time                     = 0
  args.state.counters.anmov                         = 1500
  args.state.counters.rot                           = 0
  args.state.counters.show_timeup                   = 0
  args.state.counters.yell_state                    = 0
  args.state.counters.move_game_gui                 = 0
  args.state.counters.bcount                        = 255
  args.state.counters.bbcount                       = 255
  
  args.state.game_stats.plays                       = 0
  args.state.game_stats.score                       = 0
  args.state.game_stats.highscore                   = 0
  args.state.game_stats.pre_highscore               = 0
  args.state.game_stats.play_time                   = 0
  args.state.game_stats.total_time                  = 0
  args.state.game_stats.player_moves                = 0
  args.state.game_stats.total_moves                 = 0
  args.state.game_stats.color_chains_lengths        = []
  args.state.game_stats.best_color_chain            = 0
  args.state.game_stats.collected_colors            = (6).map { 0 }
  args.state.game_stats.total_collected_colors      = (6).map { 0 }
  args.state.game_stats.connections_lengths         = []
  args.state.game_stats.longest_connection_length   = 0
  args.state.game_stats.last_color_swiped           = -1
  args.state.game_stats.color_chains                = 0
  args.state.game_stats.broke_score                 = 0
  args.state.game_stats.time_left                   = 31
  args.state.game_stats.username                    = ""
  args.state.game_stats.old_username                = ""
  args.state.game_stats.achievements_unlocked       = []

  args.state.themes.color_grid_lines                = 0
  args.state.themes.anim_rect_color                 = { r: 0, g: 0, b: 0, a: 255 }
  args.state.themes.line_color                      = { r: 255, g: 255, b: 255, a: 255 }
  args.state.themes.background_color                = { r: 0, g: 0, b: 0, a: 255 }
  
  args.state.metadata.achievements_list.length.times do |i|
    args.state.metadata.achievements_list[i].unlocked = 0
  end
  
  save_data args
  args.state.counters.gover = 1
end

def reset_game_data args
  args.state.metadata.connections                   = []
  args.state.metadata.leavepoints                   = []
  args.state.metadata.grid                          = (6).map { rand_line }

  args.state.settings.game_paused                   = 0
  
  args.state.counters.gameplay_bg_counter           = 0
  args.state.counters.anim_rect                     = 0
  args.state.counters.anim_rect_y                   = 0
  args.state.counters.anim_enabled                  = 0
  args.state.counters.anim_time                     = 0
  args.state.counters.anmov                         = 1500
  args.state.counters.rot                           = 0
  args.state.counters.show_timeup                   = 0
  args.state.counters.show_idx                      = 0
  args.state.counters.yell_state                    = 0
  args.state.counters.move_game_gui                 = 0
  args.state.counters.bcount                        = 255
  
  args.state.game_stats.pre_highscore               = args.state.game_stats.highscore
  args.state.game_stats.score                       = 0
  args.state.game_stats.play_time                   = 0
  args.state.game_stats.player_moves                = 0
  args.state.game_stats.color_chains_lengths        = []
  args.state.game_stats.collected_colors            = (6).map { 0 }
  args.state.game_stats.connections_lengths         = []
  args.state.game_stats.last_color_swiped           = -1
  args.state.game_stats.color_chains                = 0
  args.state.game_stats.broke_score                 = 0
  args.state.game_stats.time_left                   = 31
  args.state.game_stats.achievements_unlocked       = []

  args.state.themes.color_grid_lines                = 0
  args.state.themes.anim_rect_color                 = { r: 0, g: 0, b: 0, a: 255 }
  args.state.themes.line_color                      = { r: 255, g: 255, b: 255, a: 255 }
  args.state.themes.background_color                = { r: 0, g: 0, b: 0, a: 255 }
end