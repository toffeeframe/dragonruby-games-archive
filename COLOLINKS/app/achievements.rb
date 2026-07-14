def new_achievements_page_count(arr)
  return (arr.length < 4) ? 1 : (arr.length / 4).ceil
end

def new_achievements_page_sublist(arr, i)
  return (arr.length <= 4) ? arr : arr[(i * 4) .. (((i + 1) * 4) - 1)]
end

def new_achievements args
  main_menu_bg args
  
  next_button_rec = {
    x: args.state.counters.counter + 120,
    y: 720 - 78,
    w: 64,
    h: 64,
  }
  
  aabb_next_button = $pointer.intersect_rect?(next_button_rec)
  
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
      
      if args.state.game_stats.username.length == 0
        if is_mobile
          args.state.settings.show_kbd = 1
        end
          
        args.state.metadata.cursor_pos = -1
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
          args.state.net.waypoint_id = 0
          args.state.net.waypoints_done = 0
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
  
  if args.state.tick_count % 120 == 0
    args.state.counters.counter3 = (args.state.counters.counter3 == 0) ? 1 : 0
  end
  
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
    args.state.counters.counter - 665,
    args.state.counters.counter - 415,
    "NEW ACHIEVEMENTS",
    14,
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
  
  if (args.state.game_stats.achievements_unlocked.length > 4)
    up_button_rect = {
      x: args.grid.w - 42,
      y: args.state.counters.counter - 542,
      w: 32,
      h: 32
    }
    
    down_button_rect = {
      x: args.grid.w - 42,
      y: args.state.counters.counter - 1072,
      w: 32,
      h: 32
    }
    
    draw_img(up_button_rect, "img/triangle.png", 0, 255, 255, 0, 255)
    draw_img(down_button_rect, "img/triangle.png", 180, 255, 255, 0, 255)

    aabb_up = $pointer.intersect_rect?(up_button_rect)
    aabb_down = $pointer.intersect_rect?(down_button_rect)
    
    if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
      if args.inputs.keyboard.key_down.up || ($tapping && aabb_up)
        pointer_dec(:counters, :ach_idx, -1, new_achievements_page_count(args.state.game_stats.achievements_unlocked) - 1)
        play_sound(:button, args)
      end
      
      if args.inputs.keyboard.key_down.down || ($tapping && aabb_down)
        pointer_inc(:counters, :ach_idx, new_achievements_page_count(args.state.game_stats.achievements_unlocked), 0)
        play_sound(:button, args)
      end
    end
  end
    
  subach = new_achievements_page_sublist(args.state.game_stats.achievements_unlocked, args.state.counters.ach_idx)
  
  subach.length.times do |i|
    subx = subach[i]
    
    c = args.state.metadata.achievements_list[subach[i]].unlocked == 1 ? ({
      r: 255, g: 255, b: 0, a: 255
    }) : ({
      r: 255, g: 255, b: 255, a: 255
    })
    
    args.outputs.primitives << Sprite.new(
      (args.state.counters.counter - 1016),
      450 - (i * 128),
      84,
      84,
      args.state.metadata.achievements_list[subx].unlocked == 1 ? "img/trophy.png" : "img/trophy_white.png")
    
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 884),
      530 - (i * 128),
      args.state.metadata.achievements_list[subx].name,
      10,
      "fonts/JetBrainsMono-Regular.ttf",
      c.r,
      c.g,
      c.b,
      c.a)
    
    args.outputs.primitives << Line.new(
      (args.state.counters.counter - 884),
      490 - (i * 128),
      1200,
      490 - (i * 128),
      c.r,
      c.g,
      c.b,
      c.a)
    
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 884),
      480 - (i * 128),
      args.state.metadata.achievements_list[subx].description,
      4,
      "fonts/JetBrainsMono-Regular.ttf",
      c.r,
      c.g,
      c.b,
      c.a) 
  end
  
  draw_img(next_button_rec, "img/start_button_light.png", 0, 255, 255, 0, 255)
    
  if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
    if args.inputs.keyboard.key_down.enter || args.inputs.keyboard.key_down.space || ($tapping && aabb_next_button)
      args.state.counters.counter2 = 1
      play_sound(:button, args)
    end
  end
end

def achievements args
  main_menu_bg args
  
  back_button_rec = {
    x: args.state.counters.counter - 1065,
    y: 720 - 78,
    w: 64,
    h: 64,
  }
  
  aabb_back_button = $pointer.intersect_rect?(back_button_rec)
  
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
    end
  end
  
  if args.state.tick_count % 120 == 0
    args.state.counters.counter3 = (args.state.counters.counter3 == 0) ? 1 : 0
  end
  
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
    args.state.counters.counter - 680,
    args.state.counters.counter - 400,
    "ACHIEVEMENTS",
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

  if (args.state.metadata.achievements_list.length > 4)
    up_button_rect = {
      x: args.grid.w - 42,
      y: args.state.counters.counter - 542,
      w: 32,
      h: 32
    }
    
    down_button_rect = {
      x: args.grid.w - 42,
      y: args.state.counters.counter - 1072,
      w: 32,
      h: 32
    }
    
    aabb_up = $pointer.intersect_rect?(up_button_rect)
    aabb_down = $pointer.intersect_rect?(down_button_rect)
    
    draw_img(up_button_rect, "img/triangle.png", 0, 255, 255, 0, 255)
  
    args.outputs.primitives << Border.new(
      args.grid.w - 31,
      args.state.counters.counter - 1032,
      10,
      480,
      255,
      255,
      0,
      255)
  
    draw_img(down_button_rect, "img/triangle.png", 180, 255, 255, 0, 255)
      
    args.outputs.primitives << Sprite.new(
      args.grid.w - 42,
      ((args.state.counters.counter - ((600 + (args.state.counters.scrollbar_idx - 1) * (380 / 10))))).floor,
      32,
      32,
      "img/circle.png",
      180,
      255,
      255,
      0,
      255)
    
    12.times do |i|
      if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1 && (args.inputs.mouse.button_left || $down) && $pointer.intersect_rect?({
        x: args.grid.w - 42,
        y: ((args.state.counters.counter - ((550 + (i + 1) * (380 / 10))))).floor,
        w: 32,
        h: 32})
          if i + 1 != args.state.counters.scrollbar_idx
            args.state.counters.scrollbar_idx = i + 1
            play_sound(:button, args)
          end
       end
    end
    
    if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
      if args.inputs.keyboard.key_down.up || ($tapping && aabb_up)
        pointer_dec(:counters, :scrollbar_idx, 0, args.state.metadata.achievements_list.length - 3)
        play_sound(:button, args)
      end
      
      if args.inputs.keyboard.key_down.down || ($tapping && aabb_down)
        pointer_inc(:counters, :scrollbar_idx, args.state.metadata.achievements_list.length - 2, 1)
        play_sound(:button, args)
      end
    end
  end
  
  subach = args.state.metadata.achievements_list[(args.state.counters.scrollbar_idx - 1)..args.state.counters.scrollbar_idx + 2]
  
  subach.length.times do |i|
    subx = subach[i]
    
    c = subx.unlocked == 1 ? ({
      r: 255,
      g: 255,
      b: 0,
      a: 255
    }) : ({
      r: 255,
      g: 255,
      b: 255,
      a: 255
    })
    
    args.outputs.primitives << Sprite.new(
      (args.state.counters.counter - 1016),
      450 - (i * 128),
      84,
      84,
      subx.unlocked == 1 ? "img/trophy.png" : "img/trophy_white.png")
    
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 884),
      530 - (i * 128),
      subx.name,
      10,
      "fonts/JetBrainsMono-Regular.ttf",
      c.r,
      c.g,
      c.b,
      c.a)
    
    args.outputs.primitives << Line.new(
      (args.state.counters.counter - 884),
      490 - (i * 128),
      1200,
      490 - (i * 128),
      c.r,
      c.g,
      c.b,
      c.a)
    
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 884),
      480 - (i * 128),
      subx.description,
      4,
      "fonts/JetBrainsMono-Regular.ttf",
      c.r,
      c.g,
      c.b,
      c.a)
  end
  
  draw_img(back_button_rec, "img/start_button_light.png", 180, 255, 255, 0, 255)

  if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
    if args.inputs.keyboard.key_down.escape || ($tapping && aabb_back_button)
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 1
      play_sound(:button, args)
    end
  end
end
