def splashscreen args
  args.outputs.primitives << Sprite.new((args.grid.w - 256) / 6, 1000 - args.state.counters.counter, 256, 256, "img/dragonruby.png", args.state.counters.counter + 10 < 750 ? args.state.counters.counter : 0)
  
  if args.inputs.keyboard.key_down.escape
    if $gtk.platform != "Emscripten"
      $gtk.request_quit
    end
  end
  
  if args.state.counters.counter + 10 < 750
    args.state.counters.counter += 10
  else
    if args.state.counters.counter2 + 1 < 2
      args.state.counters.counter2 += 1
      play_sound(:start, args)
    else
      if args.state.tick_count % 60 == 0
        args.state.metadata.prev_scene = args.state.metadata.scene
        args.state.metadata.scene = 1
        args.state.counters.counter2 = 0
        args.state.counters.counter = 0
      end
    end
  end
  
  args.outputs.primitives << Label.new(
    1280 - args.state.counters.counter,
    (args.grid.h + 150) / 2,
    "DragonRuby",
    48,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    255,
    255)
end

def main_menu args
  main_menu_bg args
  
  if args.state.counters.counter2 == 0
    if args.state.counters.counter < 670
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
      
      if args.state.metadata.scene_to_go == 2
        reset_game_data args
      end
      
      args.state.metadata.prev_scene = args.state.metadata.scene
      args.state.metadata.scene = args.state.metadata.scene_to_go
    end
  end

  rv = parsed_response_value(args)
  tricase = false
  
  if (!args.state.net.req.nil? && args.state.net.req.complete && args.state.net.req.http_response_code == 200) && rv.length > 0
    highscore = args.state.game_stats.highscore
    score = leaderboards_score_by_name(rv, args.state.game_stats.username, args.state.net.user_id).to_i
    tricase = highscore > score
  end
  
  show_sync_button = args.state.game_stats.highscore > 0 && args.state.game_stats.username.length > 0 && args.state.game_stats.plays > 0 && tricase

  stats_button_rec = {
    x: (args.grid.w - 118) / 7,
    y: -650 + args.state.counters.counter,
    w: 72,
    h: 72
  }
  
  leaderboards_button_rec = {
    x: (args.grid.w - 118) / 3.8,
    y: -650 + args.state.counters.counter,
    w: 72,
    h: 72
  }
  
  achievements_button_rec = {
    x: (args.grid.w - 118) / 2.6,
    y: -650 + args.state.counters.counter,
    w: 72,
    h: 72
  }
  
  play_button_rec = {
    x: (args.grid.w - 128) / 2,
    y: -670 + args.state.counters.counter,
    w: 144,
    h: 144
  }
  
  options_button_rec = {
    x: (args.grid.w - 118) / 1.5,
    y: -650 + args.state.counters.counter,
    w: 72,
    h: 72
  }
  
  themes_button_rec = {
    x: (args.grid.w - 118) / 1.12,
    y: -660 + args.state.counters.counter,
    w: 72,
    h: 72
  }
  
  guide_button_rec = {
    x: (args.grid.w - 118) / 1.28,
    y: -650 + args.state.counters.counter,
    w: 72,
    h: 72
  }
  
  quit_button_rec = {
    x: (args.grid.w - 84),
    y: (-48 + args.state.counters.counter),
    w: 72,
    h: 72
  }
  
  if show_sync_button
    sync_button_rec = {
      x: args.state.counters.counter - 665,
      y: 720 - 88,
      w: 82,
      h: 72,
    }
  end
  
  aabb_play_button = $pointer.intersect_rect?(play_button_rec)
  aabb_options_button = $pointer.intersect_rect?(options_button_rec)
  aabb_leaderboards_button = $pointer.intersect_rect?(leaderboards_button_rec)
  aabb_achivements_button = $pointer.intersect_rect?(achievements_button_rec)
  aabb_quit_button = $pointer.intersect_rect?(quit_button_rec)
  aabb_guide_button = $pointer.intersect_rect?(guide_button_rec)
  aabb_stats_button = $pointer.intersect_rect?(stats_button_rec)
  aabb_themes_button = $pointer.intersect_rect?(themes_button_rec)
    
  if show_sync_button
    aabb_sync_button = $pointer.intersect_rect?(sync_button_rec)
  end
  
  args.outputs.primitives << Label.new(
    (1505 - args.state.counters.counter * 1.88),
    680,
    "COLOLINKS!",
    62,
    "fonts/Confarreatio.ttf",
    255,
    0,
    255,
    255)
  
  draw_img(play_button_rec, "img/start_button_light.png", 0, aabb_play_button ? 26 : 255, aabb_play_button ? 193 : 255, aabb_play_button ? 221 : 255, 255)
  draw_img(options_button_rec, "img/options_white.png", 0, aabb_options_button ? 26 : 255, aabb_options_button ? 193 : 255, aabb_options_button ? 221 : 255, 255)
  draw_img(leaderboards_button_rec, "img/leaderboards.png", 0, aabb_leaderboards_button ? 26 : 255, aabb_leaderboards_button ? 193 : 255, aabb_leaderboards_button ? 221 : 255, 255)
  draw_img(stats_button_rec, "img/stats.png", 0, aabb_stats_button ? 26 : 255, aabb_stats_button ? 193 : 255, aabb_stats_button ? 221 : 255, 255)
  draw_img(achievements_button_rec, "img/trophy_white.png", 0, aabb_achivements_button ? 26 : 255, aabb_achivements_button ? 193 : 255, aabb_achivements_button ? 221 : 255, 255)
  draw_img(guide_button_rec, "img/question.png", 0, aabb_guide_button ? 26 : 255, aabb_guide_button ? 193 : 255, aabb_guide_button ? 221 : 255, 255)
  draw_img(themes_button_rec, "img/brush.png", 0, aabb_themes_button ? 26 : 255, aabb_themes_button ? 193 : 255, aabb_themes_button ? 221 : 255, 255)
  draw_img(quit_button_rec, "img/power.png", 0, aabb_quit_button ? 26 : 255, aabb_quit_button ? 193 : 255, aabb_quit_button ? 221 : 255, 255)
  
  if show_sync_button
    draw_img(sync_button_rec, "img/sync.png", 0, aabb_sync_button ? 26 : 255, aabb_sync_button ? 193 : 255, aabb_sync_button ? 221 : 255, 255)
  end
  
  if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
    if args.inputs.keyboard.key_down.enter || args.inputs.keyboard.key_down.space || args.inputs.keyboard.key_down.p || ($tapping && aabb_play_button)
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 2
      reset_game_data args
      play_sound(:button, args)
    end
    
    if show_sync_button && (args.inputs.keyboard.key_down.k || ($tapping && aabb_sync_button))
      args.state.net.waypoint_id = 0
      args.state.net.waypoint_step = 0
      args.state.net.waypoints_done = 0
      args.state.net.run_waypoints = 1
      args.state.net.req = nil
      args.state.net.latest_req = nil
          
      if args.state.net.req == args.state.net.latest_req
        leaderboards_re_request(0, args)
      end
        
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 14
      play_sound(:button, args)
    end
  
    if args.inputs.keyboard.key_down.o || ($tapping && aabb_options_button)
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 7
      play_sound(:button, args)
    end
  
    if args.inputs.keyboard.key_down.l || ($tapping && aabb_leaderboards_button)
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 5
      leaderboards_re_request(0, args)
      play_sound(:button, args)
    end
  
    if args.inputs.keyboard.key_down.s || ($tapping && aabb_stats_button)
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 12
      play_sound(:button, args)
    end
  
    if args.inputs.keyboard.key_down.a || ($tapping && aabb_achivements_button)
      args.state.counters.counter2 = 1
      args.state.counters.ach_idx = 0
      args.state.metadata.scene_to_go = 11
      play_sound(:button, args)
    end
  
    if args.inputs.keyboard.key_down.g || ($tapping && aabb_guide_button)
      args.state.counters.counter2 = 1
      args.state.counters.tutorial_idx = 0
      args.state.metadata.scene_to_go = 9
      play_sound(:button, args)
    end
  
    if args.inputs.keyboard.key_down.t || ($tapping && aabb_themes_button)
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 8
      play_sound(:button, args)
    end
  
    if args.inputs.keyboard.key_down.escape || ($tapping && aabb_quit_button)
      play_sound(:button, args)
      
      if $gtk.platform != "Emscripten"
        $gtk.request_quit
      end
    end
  end
end

def lose args
  main_menu_bg args
  t_col = get_palette_colors(args)
  
  next_button_rec = {
    x: args.state.counters.counter - 125,
    y: 32,
    w: 84,
    h: 84
  }
  
  aabb_next_button = $pointer.intersect_rect?(next_button_rec)
  
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
      
      args.state.metadata.achievements_list.length.times do |i|
        if args.state.metadata.achievements_list[i].unlocked == 0
          if eval(args.state.metadata.achievements_list[i].condition)
            args.state.metadata.achievements_list[i].unlocked = 1
            args.state.game_stats.achievements_unlocked << i
          end
        end
      end
      
      args.state.game_stats.achievements_unlocked = args.state.game_stats.achievements_unlocked.uniq
      args.state.metadata.prev_scene = args.state.metadata.scene
      
      if args.state.game_stats.achievements_unlocked.length > 0
        args.state.metadata.scene = 4
        play_sound(:event2, args)
      else
        if args.state.game_stats.username.length == 0
          args.state.settings.show_kbd = 1
          args.state.counters.kbd_idx = 0
          args.state.settings.kbdup = 0
          args.state.metadata.kbdstr = ""
          args.state.metadata.scene = 13
        else
          rv = $gtk.parse_json((response_value(args) || "[]").tr("\u0000", ""))
          tricase = false
          
          if rv.length > 0
            highscore = args.state.game_stats.highscore
            score = leaderboards_score_by_name(rv, args.state.game_stats.username, args.state.net.user_id).to_i
            tricase = highscore > score
          end
        
          if args.state.game_stats.score > 0 && tricase
            play_sound(:event, args)
            args.state.net.run_waypoints = 1
            args.state.net.waypoints_done = 0
            args.state.net.waypoint_id = 0
            args.state.net.waypoint_step = 0
            args.state.net.req = nil
            args.state.net.latest_req = nil
            
            if args.state.net.req == args.state.net.latest_req
              leaderboards_re_request(0, args)
            end
            
            args.state.metadata.prev_scene = args.state.metadata.scene
            args.state.metadata.scene = 14
          else
            args.state.metadata.prev_scene = args.state.metadata.scene
            args.state.metadata.scene = 1
          end
        end
      end
    end
  end
  
  if args.state.tick_count % 120 == 0
    args.state.counters.counter3 = (args.state.counters.counter3 == 0) ? 1 : 0
  end
  
  args.outputs.primitives << Sprite.new(
    args.state.counters.counter - 990,
    595,
    96,
    96,
    (args.state.settings.effects_enabled == 1 && args.state.counters.counter3 == 1) ? "img/star.png" : "img/star_outlined.png",
    args.state.tick_count,
    255,
    255,
    0,
    255)
    
  args.outputs.primitives << Sprite.new(
    args.state.counters.counter - 390,
    595,
    96,
    96,
    (args.state.settings.effects_enabled == 1 && args.state.counters.counter3 == 1) ? "img/star.png" : "img/star_outlined.png",
    args.state.tick_count,
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 860,
    args.state.counters.counter - 610,
    "GAME OVER",
    28,
    "fonts/Confarreatio.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Line.new(
    16,
    args.state.counters.counter - 740,
    1280 - 16,
    args.state.counters.counter - 740,
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 1250,
    args.state.counters.counter - 745,
    "SCORE",
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 235,
    args.state.counters.counter - 745,
    args.state.game_stats.score.to_s.rjust(10, "0"),
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 1250,
    args.state.counters.counter - 790,
    "HIGHSCORE",
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 235,
    args.state.counters.counter - 790,
    args.state.game_stats.highscore.to_s.rjust(10, "0"),
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  if args.state.game_stats.broke_score == 1
    args.outputs.primitives << Border.new(
      args.state.counters.counter - 340,
      args.state.counters.counter - 785,
      75,
      35,
      255,
      0,
      0,
      255)
      
    args.outputs.primitives << Label.new(
      args.state.counters.counter - 328,
      args.state.counters.counter - 750,
      "NEW",
      6,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      0,
      0,
      255)
    
    args.outputs.primitives << Border.new(
      args.state.counters.counter - 340,
      args.state.counters.counter - 830,
      75,
      35,
      255,
      0,
      0,
      255)
    
    args.outputs.primitives << Label.new(
      args.state.counters.counter - 328,
      args.state.counters.counter - 795,
      "NEW",
      6,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      0,
      0,
      255)
  end
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 1250,
    args.state.counters.counter - 832,
    "MOVES",
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 235,
    args.state.counters.counter - 832,
    args.state.game_stats.player_moves,
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)

  args.outputs.primitives << Label.new(
    args.state.counters.counter - 1250,
    args.state.counters.counter - 875,
    "TIME",
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 235,
    args.state.counters.counter - 875,
    secs_to_str(args.state.game_stats.play_time, 1),
    8,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Line.new(
    16,
    args.state.counters.counter - 920,
    1280 - 16,
    args.state.counters.counter - 920,
    255,
    255,
    0,
    255)

  args.outputs.primitives << Border.new(
    32,
    args.state.counters.counter - 1120,
    args.grid.w - 64,
    150,
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Line.new(
    48,
    args.state.counters.counter - 1010,
    1280 - 48,
    args.state.counters.counter - 1010,
    255,
    255,
    0,
    255)
  
  5.times do |i|
    args.outputs.primitives << Line.new(
      (200 * (i + 1) + 32),
      args.state.counters.counter - 980,
      (200 * (i + 1) + 32),
      args.state.counters.counter - 1110,
      255,
      255,
      0,
      255)
  end
  
  args.state.game_stats.collected_colors.length.times do |i|
    args.outputs.primitives << Label.new(
      (200 * (i + 1) - 110),
      args.state.counters.counter - 970,
      args.state.game_stats.collected_colors[i].to_s.rjust(4, "0"),
      10,
      "fonts/JetBrainsMono-Regular.ttf",
      t_col[i].r,
      t_col[i].g,
      t_col[i].b,
      t_col[i].a)
    
    args.outputs.primitives << SuperSprite.new(
      args.state.themes.current_theme.idx[i] * 128,
      0,
      128,
      128,
      (200 * (i + 1) - 104),
      args.state.counters.counter - 1102,
      72,
      72,
      args.state.themes.current_theme.img,
      0,
      t_col[i].r,
      t_col[i].g,
      t_col[i].b,
      t_col[i].a)
  end

  args.outputs.primitives << Label.new(
    args.state.counters.counter - 240,
    100,
    "NEXT",
    14,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  draw_img(next_button_rec, "img/start_button_light.png", 0, 255, 255, 0, 255)
  
  if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
    if args.inputs.keyboard.key_down.enter || args.inputs.keyboard.key_down.space || ($tapping && aabb_next_button)
      args.state.counters.counter2 = 1
      play_sound(:button, args)
    end
  end
end

def stats args
  main_menu_bg args
  t_col = get_palette_colors(args)
  
  back_button_rec = {
    x: args.state.counters.counter - 865,
    y: 720 - 78,
    w: 64,
    h: 64,
  }
  
  aabb_back_button = $pointer.intersect_rect?(back_button_rec)
  
  if args.state.counters.counter2 == 0
    if args.state.counters.counter < 870
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
    args.state.counters.counter - 500,
    595,
    96,
    96,
    (args.state.settings.effects_enabled == 1 && args.state.counters.counter3 == 1) ? "img/star.png" : "img/star_outlined.png",
    args.state.tick_count,
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Sprite.new(
    args.state.counters.counter - 80,
    595,
    96,
    96,
    (args.state.settings.effects_enabled == 1 && args.state.counters.counter3 == 1) ? "img/star.png" : "img/star_outlined.png",
    args.state.tick_count,
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 360,
    args.state.counters.counter - 210,
    "STATS",
    30,
    "fonts/Confarreatio.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Line.new(
    16,
    args.state.counters.counter - 320,
    1280 - 16,
    args.state.counters.counter - 320,
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 850,
    args.state.counters.counter - 325,
    "HIGHSCORE",
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter + 170,
    args.state.counters.counter - 325,
    args.state.game_stats.highscore.to_s.rjust(10, "0"),
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 850,
    args.state.counters.counter - 375,
    "TOTAL TIME PLAYED",
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter + 170,
    args.state.counters.counter - 375,
    secs_to_str(args.state.game_stats.total_time, 1),
    8,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 850,
    args.state.counters.counter - 425,
    "TIMES PLAYED",
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter + 170,
    args.state.counters.counter - 425,
    args.state.game_stats.plays,
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 850,
    args.state.counters.counter - 475,
    "BEST COLOR CHAIN",
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter + 170,
    args.state.counters.counter - 475,
    args.state.game_stats.best_color_chain,
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 850,
    args.state.counters.counter - 525,
    "LONGEST CONNECTION LENGTH",
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter + 170,
    args.state.counters.counter - 525,
    args.state.game_stats.longest_connection_length,
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)

  args.outputs.primitives << Label.new(
    args.state.counters.counter - 850,
    args.state.counters.counter - 575,
    "TOTAL MOVES",
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter + 170,
    args.state.counters.counter - 575,
    args.state.game_stats.total_moves,
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 850,
    args.state.counters.counter - 625,
    "MOST CONNECTED COLOR",
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  ii = 0
  
  args.state.game_stats.total_collected_colors.length.times do |i|
    if args.state.game_stats.total_collected_colors.max == args.state.game_stats.total_collected_colors[i]
      ii = i
      break
    end
  end
  
  args.outputs.primitives << SuperSprite.new(
    args.state.themes.current_theme.idx[ii] * 128,
    0,
    128,
    128,
    args.state.counters.counter + 166,
    args.state.counters.counter - 665,
    32,
    32,
    args.state.themes.current_theme.img,
    0,
    t_col[ii].r,
    t_col[ii].g,
    t_col[ii].b,
    t_col[ii].a)

  args.outputs.primitives << Line.new(
    16,
    args.state.counters.counter - 675,
    1280 - 16,
    args.state.counters.counter - 675,
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Border.new(
    32,
    args.state.counters.counter - 855,
    args.grid.w - 64,
    150,
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Line.new(
    48,
    args.state.counters.counter - 750,
    1280 - 48,
    args.state.counters.counter - 750,
    255,
    255,
    0,
    255)
  
  5.times do |i|
    args.outputs.primitives << Line.new(
      (200 * (i + 1) + 32),
      args.state.counters.counter - 715,
      (200 * (i + 1) + 32),
      args.state.counters.counter - 845,
      255,
      255,
      0,
      255)
  end
  
  args.state.game_stats.total_collected_colors.length.times do |i|
    args.outputs.primitives << Label.new(
      (200 * (i + 1) - 110),
      args.state.counters.counter - 710,
      args.state.game_stats.total_collected_colors[i].to_s.rjust(4, "0"),
      10,
      "fonts/JetBrainsMono-Regular.ttf",
      t_col[i].r,
      t_col[i].g,
      t_col[i].b,
      t_col[i].a)
    
    args.outputs.primitives << SuperSprite.new(
      args.state.themes.current_theme.idx[i] * 128,
      0,
      128,
      128,
      (200 * (i + 1) - 104),
      args.state.counters.counter - 840,
      72,
      72,
      args.state.themes.current_theme.img,
      0,
      t_col[i].r,
      t_col[i].g,
      t_col[i].b,
      t_col[i].a)
  end
  
  draw_img(back_button_rec, "img/start_button_light.png", 180, 255, 255, 0, 255)
  
  if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
    if args.inputs.keyboard.key_down.escape || args.inputs.keyboard.key_down.enter || args.inputs.keyboard.key_down.space || ($tapping && aabb_back_button)
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 1
      play_sound(:button, args)
    end
  end
end

def pause args
  draw_background args
  game_stats_gui args
  draw_grid args
  draw_connections args
  draw_leavepoints args
  
  restart_button_rec = {
    x: 240,
    y: (args.state.counters.counter - 350),
    w: 72,
    h: 72
  }
  
  home_button_rec = {
    x: 400,
    y: (args.state.counters.counter - 350),
    w: 72,
    h: 72
  }
  
  resume_button_rec = {
    x: 560,
    y: (args.state.counters.counter - 390),
    w: 164,
    h: 164
  }
  
  options_button_rec = {
    x: 810,
    y: (args.state.counters.counter - 350),
    w: 72,
    h: 72
  }
  
  quit_button_rec = {
    x: 970,
    y: (args.state.counters.counter - 350),
    w: 72,
    h: 72
  }
  
  aabb_resume_button = $pointer.intersect_rect?(resume_button_rec)
  aabb_restart_button = $pointer.intersect_rect?(restart_button_rec)
  aabb_home_button = $pointer.intersect_rect?(home_button_rec)
  aabb_options_button = $pointer.intersect_rect?(options_button_rec)
  aabb_quit_button = $pointer.intersect_rect?(quit_button_rec)
  
  args.outputs.primitives << Solid.new(
    0,
    0,
    1280,
    720,
    0,
    0,
    0,
    240)
  
  if args.state.counters.counter2 == 0
    if args.state.counters.counter < 670
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
  
  draw_img(restart_button_rec, "img/restart.png", 0, aabb_restart_button ? 26 : 255, aabb_restart_button ? 193 : 255, aabb_restart_button ? 221 : 255, 255)
  draw_img(home_button_rec, "img/home.png", 0, aabb_home_button ? 26 : 255, aabb_home_button ? 193 : 255, aabb_home_button ? 221 : 255, 255)
  draw_img(resume_button_rec, "img/start_button_light.png", 0, aabb_resume_button ? 26 : 255, aabb_resume_button ? 193 : 255, aabb_resume_button ? 221 : 255, 255)
  draw_img(options_button_rec, "img/options_white.png", 0, aabb_options_button ? 26 : 255, aabb_options_button ? 193 : 255, aabb_options_button ? 221 : 255, 255)
  draw_img(quit_button_rec, "img/power.png", 0, aabb_quit_button ? 26 : 255, aabb_quit_button ? 193 : 255, aabb_quit_button ? 221 : 255, 255)

  if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
    if args.inputs.keyboard.key_down.r || ($tapping && aabb_restart_button)
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 2
      reset_game_data args
      play_sound(:button, args)
    end
    
    if args.inputs.keyboard.key_down.h || ($tapping && aabb_home_button)
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 1
      reset_game_data args
      play_sound(:button, args)
    end
    
    if args.inputs.keyboard.key_down.escape || args.inputs.keyboard.key_down.enter || args.inputs.keyboard.key_down.space || ($tapping && aabb_resume_button)
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 2
      args.state.settings.game_paused = 0
      play_sound(:button, args)
    end
    
    if args.inputs.keyboard.key_down.o || ($tapping && aabb_options_button)
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 7
      args.state.settings.game_paused = 1
      play_sound(:button, args)
    end
    
    if args.inputs.keyboard.key_down.q || ($tapping && aabb_quit_button)
      play_sound(:button, args)
      
      if $gtk.platform != "Emscripten"
        $gtk.request_quit
      end
    end
  end
end

def options args
  main_menu_bg args
  
  back_button_rec = {
    x: (args.state.counters.counter - 684),
    y: 16,
    w: 84,
    h: 84
  }
  
  sound_button_rec = {
    x: (args.state.counters.counter - 400),
    y: 400,
    w: 112,
    h: 64
  }
  
  music_button_rec = {
    x: (args.state.counters.counter + 430),
    y: 400,
    w: 112,
    h: 64
  }
  
  fullscreen_button_rec = {
    x: (args.state.counters.counter + 430),
    y: 300,
    w: 112,
    h: 64
  }
  
  effects_button_rec = {
    x: (args.state.counters.counter - 400),
    y: 300,
    w: 112,
    h: 64
  }
  
  cleardata_button_rec = {
    x: (args.state.counters.counter - 280),
    y: 100,
    w: 400,
    h: 50
  }
  
  set_username_button_rec = {
    x: (args.state.counters.counter - 280),
    y: 180,
    w: 400,
    h: 50
  }
  
  credits_button_rec = {
    x: (args.state.counters.counter + 480),
    y: 16,
    w: 84,
    h: 84
  }
  
  aabb_sound_button = $pointer.intersect_rect?(sound_button_rec)
  aabb_music_button = $pointer.intersect_rect?(music_button_rec)
  aabb_effects_button = $pointer.intersect_rect?(effects_button_rec)
  aabb_fullscreen_button = $pointer.intersect_rect?(fullscreen_button_rec)
  aabb_cleardata_button = $pointer.intersect_rect?(cleardata_button_rec)
  aabb_set_username_button = $pointer.intersect_rect?(set_username_button_rec)
  aabb_credits_button = $pointer.intersect_rect?(credits_button_rec)
  aabb_back_button = $pointer.intersect_rect?(back_button_rec)
  
  args.outputs.primitives << Label.new(
    (1620 - args.state.counters.counter * 1.85),
    680,
    "OPTIONS",
    64,
    "fonts/Confarreatio.ttf",
    255,
    0,
    255,
    255)
  
  if args.state.counters.counter2 == 0
    if args.state.counters.counter < 700
      args.state.counters.counter += 20
    else
      args.state.counters.counter_finished = 1
    end
  elsif args.state.counters.counter2 == 1
    if args.state.counters.counter > -800
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
  
  draw_img(sound_button_rec, "img/switch.png", args.state.settings.sound_enabled == 1 ? 180 : 0, 26, 193, 221, 255)
  
  args.outputs.primitives << Label.new(
    (args.state.counters.counter - 660),
    460,
    "Sound",
    20,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    255,
    255)
  
  draw_img(effects_button_rec, "img/switch.png", args.state.settings.effects_enabled == 1 ? 180 : 0, 26, 193, 221, 255)
  
  args.outputs.primitives << Label.new(
    (args.state.counters.counter - 660),
    360,
    "Effects",
    20,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    255,
    255)
  
  draw_img(music_button_rec, "img/switch.png", args.state.settings.music_enabled == 1 ? 180 : 0, 26, 193, 221, 255)
  
  args.outputs.primitives << Label.new(
    (args.state.counters.counter + 70),
    460,
    "Music",
    20,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    255,
    255)
    
  if !is_mobile
    draw_img(fullscreen_button_rec, "img/switch.png", args.state.settings.fullscreen == 1 ? 180 : 0, 26, 193, 221, 255)
    
    args.outputs.primitives << Label.new(
      (args.state.counters.counter + 70),
      360,
      "Fullscreen",
      20,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      255,
      255)
  end
  
  if args.state.settings.game_paused == 0
    cond_clear = aabb_cleardata_button ? 0 : 255
  end
  
  cond_username = aabb_set_username_button ? 128 : 255
  draw_border(set_username_button_rec, cond_username, cond_username, cond_username, 255)
  
  args.outputs.primitives << Label.new(
    set_username_button_rec.x + 80,
    set_username_button_rec.y + 45,
    "Set Username",
    10,
    "fonts/JetBrainsMono-Regular.ttf",
    cond_username,
    cond_username,
    cond_username,
    255)
  
  if args.state.settings.game_paused == 0
    draw_border(cleardata_button_rec, 255, cond_clear, cond_clear, 255)

    args.outputs.primitives << Label.new(
      cleardata_button_rec.x + 100,
      cleardata_button_rec.y + 45,
      "Clear Data",
      10,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      cond_clear,
      cond_clear,
      255)
  end
  
  args.outputs.primitives << Label.new(
    back_button_rec.x + 110,
    back_button_rec.y + 65,
    "Back",
    12,
    "fonts/JetBrainsMono-Regular.ttf",
    aabb_back_button ? 26 : 255,
    aabb_back_button ? 193 : 255,
    aabb_back_button ? 221 : 255,
    255)
  
  draw_img(back_button_rec, "img/start_button_light.png", 180, aabb_back_button ? 26 : 255, aabb_back_button ? 193 : 255, aabb_back_button ? 221 : 255, 255)
  
  args.outputs.primitives << Label.new(
    credits_button_rec.x - 180,
    credits_button_rec.y + 65,
    "Credits",
    12,
    "fonts/JetBrainsMono-Regular.ttf",
    aabb_credits_button ? 26 : 255,
    aabb_credits_button ? 193 : 255,
    aabb_credits_button ? 221 : 255,
    255)
  
  draw_img(credits_button_rec, "img/start_button_light.png", 0, aabb_credits_button ? 26 : 255, aabb_credits_button ? 193 : 255, aabb_credits_button ? 221 : 255, 255)
  
  args.outputs.primitives << Label.new(
    (1290 - args.state.counters.counter * 1.83),
    680,
    "VERSION: v0.1.5",
    2,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 690,
    710,
    "USERNAME: #{args.state.game_stats.username.length == 0 ? "NONE" : args.state.game_stats.username}",
    2,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
    
  args.outputs.primitives << Label.new(
    435,
    args.state.counters.counter - 625,
    "ID: #{args.state.net.user_id || ((25).map {"X"}).join}",
    2,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  if args.state.counters.gover == 1
    if args.state.tick_count % 120 != 0
      args.outputs.primitives << Solid.new(
        2,
        692,
        190,
        30,
        0,
        0,
        0,
        255)
        
      args.outputs.primitives << Label.new(
        2,
        720,
        "DATA CLEARED!",
        4,
        "fonts/JetBrainsMono-Regular.ttf",
        255,
        0,
        0,
        255)
    else
      args.state.counters.gover = 0
    end
  end

  if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
    if args.inputs.keyboard.key_down.escape || ($tapping && aabb_back_button)
      if args.state.settings.game_paused == 1
        args.state.metadata.scene_to_go = 6
        args.state.counters.counter2 = 1
      elsif args.state.settings.game_paused == 0
        args.state.metadata.scene_to_go = 1
        args.state.counters.counter2 = 1
      end
      
      play_sound(:button, args)
    end
    
    if args.inputs.keyboard.key_down.c || ($tapping && aabb_credits_button)
      args.state.metadata.scene_to_go = 10
      args.state.counters.counter2 = 1
      play_sound(:button, args)
    end
    
    if (args.inputs.keyboard.key_down.f || ($tapping && aabb_fullscreen_button)) && !is_mobile
      args.state.settings.fullscreen = (args.state.settings.fullscreen == 1) ? 0 : 1
      $gtk.set_window_fullscreen (args.state.settings.fullscreen == 1)
      save_data args
      play_sound(:button, args)
    end
    
    if args.inputs.keyboard.key_down.s || ($tapping && aabb_sound_button)
      args.state.settings.sound_enabled = (args.state.settings.sound_enabled == 1) ? 0 : 1
      save_data args
      play_sound(:button, args)
    end
    
    if args.inputs.keyboard.key_down.m || ($tapping && aabb_music_button)
      args.state.settings.music_enabled = (args.state.settings.music_enabled == 1) ? 0 : 1
      save_data args
      play_sound(:button, args)
    end
    
    if args.inputs.keyboard.key_down.e || ($tapping && aabb_effects_button)
      args.state.settings.effects_enabled = (args.state.settings.effects_enabled == 1) ? 0 : 1
      save_data args
      play_sound(:button, args)
    end
    
    if args.inputs.keyboard.key_down.u || ($tapping && aabb_set_username_button)
      if is_mobile
        args.state.settings.show_kbd = 1
      end
      
      args.state.counters.kbd_idx = 0
      args.state.settings.kbdup = 0
      args.state.metadata.kbdstr = ""
      args.state.metadata.scene_to_go = 13
      args.state.counters.counter2 = 1
      play_sound(:button, args)
    end
    
    if ($tapping && aabb_cleardata_button && args.state.settings.game_paused == 0)
      play_sound(:button, args)
      reset_data args
    end
  end
end

def how_to_play args
  main_menu_bg args

  if args.state.counters.counter2 == 0
    if args.state.counters.counter < 1070
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
      args.state.counters.tutorial_idx = 0
    end
  end
  
  if args.state.tick_count % 120 == 0
    args.state.counters.counter3 = (args.state.counters.counter3 == 0) ? 1 : 0
  end
  
  back_button_rec = {
    x: args.state.counters.counter - 1065,
    y: 720 - 78,
    w: 64,
    h: 64,
  }
  
  aabb_back_button = $pointer.intersect_rect?(back_button_rec)
  
  args.outputs.primitives << Sprite.new(
    args.state.counters.counter - 800,
    605,
    96,
    96,
    (args.state.settings.effects_enabled == 1 && args.state.counters.counter3 == 1) ? "img/star.png" : "img/star_outlined.png",
    args.state.tick_count,
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Sprite.new(
    args.state.counters.counter - 145,
    605,
    96,
    96,
    (args.state.settings.effects_enabled == 1 && args.state.counters.counter3 == 1) ? "img/star.png" : "img/star_outlined.png",
    args.state.tick_count,
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    args.state.counters.counter - 655,
    args.state.counters.counter - 400,
    "HOW TO PLAY",
    24,
    "fonts/Confarreatio.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Line.new(
    16,
    args.state.counters.counter - 495,
    args.grid.w - 16,
    args.state.counters.counter - 495,
    255,
    255,
    0,
    255)
  
  pa = args.state.settings.custom_palettes_enabled == 1 ? args.state.themes.current_palette["colors"] : args.state.themes.current_palette

  if args.state.counters.tutorial_idx == 0
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 865),
      480,
      "CONNECT 2 OR MORE MARBLES OF SAME TYPE TO CLEAR!",
      8,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      0,
      255)
    
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 860),
      180,
      "TO CUT THE CONNECTION MOVE BACK TO PREVIOUS CONNECTED MARBLE",
      4,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      0,
      255)
    
    4.times do |i|
      co = pa[i].transform_keys(&:to_sym)
      t = args.state.themes.current_theme.transform_keys(&:to_sym)
      
      args.outputs.primitives << SuperSprite.new(
        t.idx[i] * 128,
        0,
        128,
        128,
        (args.state.counters.counter - 675) + (i * 128),
        300,
        96,
        96,
        t.img,
        0,
        co.r,
        co.g,
        co.b,
        co.a)
    end
    
  elsif args.state.counters.tutorial_idx == 1
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 1044),
      480,
      "CONNECT MARBLES OF SAME COLOR MULTIPLE TIMES IN ROW TO RAISE COLOR CHAIN!",
      6,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      0,
      255)
    
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 890),
      180,
      "(YOU GET [50 X COLOR CHAINS] POINTS FOR EACH MARBLE CONNECTED)",
      4,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      0,
      255)
    
    4.times do |i|
      co = pa[i].transform_keys(&:to_sym)
      t = args.state.themes.current_theme.transform_keys(&:to_sym)
      
      args.outputs.primitives << SuperSprite.new(
        t.idx[i] * 128,
        0,
        128,
        128,
        (args.state.counters.counter - 675) + (i * 128),
        300,
        96,
        96,
        t.img,
        0,
        co.r,
        co.g,
        co.b,
        co.a)
    end
    
  elsif args.state.counters.tutorial_idx == 2
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 824),
      480,
      "CONNECT 6 - 9 MARBLES TO GET A LINE MARBLE!",
      8,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      0,
      255)
    
    co = pa[4].transform_keys(&:to_sym)
    t = args.state.themes.current_theme.transform_keys(&:to_sym)
    
    args.outputs.primitives << SuperSprite.new(
      t.idx[4] * 128,
      0,
      128,
      128,
      (args.state.counters.counter - 745) + (2 * 128),
      280,
      96,
      96,
      t.img,
      0,
      co.r,
      co.g,
      co.b,
      co.a)
    
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 950),
      200,
      "CLICK/CONNECT IT WITH MARBLES TO CLEAR COLUMN AND ROW THIS MARBLE IS ON!",
      4,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      0,
      255)
    
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 1015),
      140,
      "(YOU GET [100 X COLOR CHAINS] POINTS FOR EACH MARBLE CLEARED IN COLUMNS AND ROWS + EXTRA TIME OF 4 SECONDS)",
      0,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      255,
      255)
    
  elsif args.state.counters.tutorial_idx == 3
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 824),
      480,
      "CONNECT +10 MARBLES TO GET A COLOR MARBLE!",
      8,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      0,
      255)
    
    co = pa[5].transform_keys(&:to_sym)
    t = args.state.themes.current_theme.transform_keys(&:to_sym)
    
    args.outputs.primitives << SuperSprite.new(
      t.idx[5] * 128,
      0,
      128,
      128,
      (args.state.counters.counter - 745) + (2 * 128),
      280,
      96,
      96,
      t.img,
      0,
      co.r,
      co.g,
      co.b,
      co.a)
    
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 1030),
      200,
      "CLICK/CONNECT IT WITH MARBLES TO CLEAR MARBLES WITH COLOR THIS MARBLE CONNECTED TO",
      4,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      0,
      255)
    
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 905),
      140,
      "(YOU GET [200 X COLOR CHAINS] POINTS FOR EACH MARBLE CLEARED + EXTRA TIME OF 8 SECONDS)",
      0,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      255,
      255)
      
  elsif args.state.counters.tutorial_idx == 4
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 1022),
      400,
      "YOU HAVE TIME LIMIT IN THE ROUND AND ROUND FINISHES WHEN TIME IS OUT...",
      6,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      0,
      255)
    
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 622),
      280,
      "SO SEE YA IN NEXT ROUND! :D",
      4,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      0,
      255)
  end
  
  draw_img(back_button_rec, "img/start_button_light.png", 180, 255, 255, 0,  255)
  
  prev_button_rec = {
    x: args.state.counters.counter - 575,
    y: 16,
    w: 32,
    h: 32
  }
      
  next_button_rec = {
    x: args.state.counters.counter - 315,
    y: 16,
    w: 32,
    h: 32
  }
      
  if !is_mobile || (is_mobile && !args.inputs.finger_one.nil?)
    aabb_prev_button = $pointer.intersect_rect?(prev_button_rec)
    aabb_next_button = $pointer.intersect_rect?(next_button_rec)
  end
  
  draw_img(prev_button_rec, "img/triangle.png", 90, 255, 255, 0, 255)
  draw_img(next_button_rec, "img/triangle.png", 270, 255, 255, 0, 255)

  args.outputs.primitives << Label.new(
    next_button_rec.x - 130,
    next_button_rec.y + 35,
    args.state.counters.tutorial_idx + 1,
    8,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
    if args.inputs.keyboard.key_down.right || ($tapping && aabb_next_button)
      pointer_inc(:counters, :tutorial_idx, 5, 0)
      play_sound(:button, args)
    end
    
    if args.inputs.keyboard.key_down.left || ($tapping && aabb_prev_button)
      pointer_dec(:counters, :tutorial_idx, -1, 4)
      play_sound(:button, args)
    end
    
    if args.inputs.keyboard.key_down.escape || ($tapping && aabb_back_button)
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 1
      play_sound(:button, args)
    end
  end
end

def credits args
  main_menu_bg args
  
  back_button_rec = {
    x: (args.state.counters.counter - 664),
    y: 16,
    w: 84,
    h: 84
  }
  
  dragonruby_icon_rec = {
    x: (1840 - args.state.counters.counter * 1.88),
    y: 60,
    w: 164,
    h: 164
  }
  
  author_name_rec = {
    x: (1800 - args.state.counters.counter * 1.88),
    y: 350,
    w: 255,
    h: 25
  }

  itchio_rec = {
    x: (args.state.counters.counter + 420),
    y: (args.state.counters.counter - 666),
    w: 64,
    h: 64
  }
  
  paypal_rec = {
    x: (args.state.counters.counter + 514),
    y: (args.state.counters.counter - 666),
    w: 64,
    h: 64
  }

  aabb_back_button = $pointer.intersect_rect?(back_button_rec)
  aabb_dragonruby_icon = $pointer.intersect_rect?(dragonruby_icon_rec)
  aabb_author_name = $pointer.intersect_rect?(author_name_rec)
  aabb_itchio_button = $pointer.intersect_rect?(itchio_rec)
  aabb_paypal_button = $pointer.intersect_rect?(paypal_rec)

  if args.state.counters.counter2 == 0
    if args.state.counters.counter < 670
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
  
  args.outputs.primitives << Label.new(
    (1505 - args.state.counters.counter * 1.88),
    680,
    "COLOLINKS!",
    62,
    "fonts/Confarreatio.ttf",
    255,
    0,
    255,
    255)
  
  args.outputs.primitives << Label.new(
    (1770 - args.state.counters.counter * 1.88),
    460,
    "Created By",
    22,
    "fonts/JetBrainsMono-Regular.ttf",
    0,
    0,
    180,
    255)
  
  args.outputs.primitives << Label.new(
    (1796 - args.state.counters.counter * 1.88),
    380,
    "Rabia Alhaffar",
    8,
    "fonts/JetBrainsMono-Regular.ttf",
    aabb_author_name ? 0 : 255,
    aabb_author_name ? 200 : 255,
    255,
    255)
    
  args.outputs.primitives << Label.new(
    (1770 - args.state.counters.counter * 1.88),
    280,
    "Powered By",
    22,
    "fonts/JetBrainsMono-Regular.ttf",
    180,
    0,
    0,
    255)
  
  args.outputs.primitives << Sprite.new(
    (1840 - args.state.counters.counter * 1.88),
    60,
    164,
    164,
    "img/dragonruby.png")
  
  args.outputs.primitives << Label.new(
    back_button_rec.x + 110,
    back_button_rec.y + 65,
    "Back",
    12,
    "fonts/JetBrainsMono-Regular.ttf",
    aabb_back_button ? 26 : 255,
    aabb_back_button ? 193 : 255,
    aabb_back_button ? 221 : 255,
    255)
 
  draw_img(paypal_rec, "img/paypal.png", 0, aabb_paypal_button ? 26 : 255, aabb_paypal_button ? 193 : 255, aabb_paypal_button ? 221 : 255, 255)
  draw_img(itchio_rec, "img/itchio-logo-textless-white.png", 0, aabb_itchio_button ? 26 : 255, aabb_itchio_button ? 193 : 255, aabb_itchio_button ? 221 : 255, 255)
  draw_img(back_button_rec, "img/start_button_light.png", 180, aabb_back_button ? 26 : 255, aabb_back_button ? 193 : 255, aabb_back_button ? 221 : 255, 255)
  
  if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
    if args.inputs.keyboard.key_down.escape || ($tapping && aabb_back_button)
      args.state.metadata.scene_to_go = 7
      args.state.counters.counter2 = 1
      play_sound(:button, args)
    end
    
    if ($tapping && aabb_dragonruby_icon)
      $gtk.openurl "https://dragonruby.org/toolkit/game"
      play_sound(:button, args)
    end
    
    if ($tapping && aabb_author_name)
      $gtk.openurl "https://github.com/Rabios"
      play_sound(:button, args)
    end
    
    if ($tapping && aabb_itchio_button)
      $gtk.openurl "https://rabios.itch.io"
      play_sound(:button, args)
    end
    
    if ($tapping && aabb_paypal_button)
      $gtk.openurl "https://www.paypal.com/paypalme/Mohamadamf"
      play_sound(:button, args)
    end
  end
end
