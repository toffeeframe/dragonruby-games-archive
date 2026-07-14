def is_mobile
  return ($gtk.platform == "iOS" || $gtk.platform == "Android")
end

def touch_down(args)
  return (args.state.metadata.touched == 1)
end

def touch_press(args)
  return (args.state.metadata.touched == 1 && (args.state.metadata.touched != args.state.metadata.touched_previously))
end

def tap(args)
  return (args.inputs.mouse.click && args.inputs.mouse.button_left) || touch_press(args)
end

def pointer_rect args
  r = { w: 1, h: 1 }

  if is_mobile && args.state.metadata.touched == 1
    if !args.inputs.finger_one.nil?
      return ({ x: args.inputs.finger_one.x, y: args.inputs.finger_one.y }).merge(r)
    else
      return ({ x: -1000, y: -1000 }).merge(r)
    end
  else
    return ({ x: args.inputs.mouse.x, y: args.inputs.mouse.y }).merge(r)
  end
end

def mouse_pos_onboard args
  args.state.metadata.grid.length.times do |i|
    args.state.metadata.grid[i].length.times do |j|
      if $pointer.intersect_rect?(tile_rect(j, i, args))
        args.state.metadata.mouse_bx = j
        args.state.metadata.mouse_by = i
          
        if (args.state.themes.color_grid_lines == 1)
          if args.state.settings.custom_palettes_enabled == 1
            args.state.themes.line_color = args.state.themes.current_palette.colors[args.state.metadata.grid[i][j] - 1].transform_keys(&:to_sym)
          else
            args.state.themes.line_color = args.state.themes.current_palette[args.state.metadata.grid[i][j] - 1]
          end
        end
      end
    end
  end
end

def handle_game_input args
  #if args.inputs.mouse.click || (args.state.metadata.touched == 1 && (args.state.metadata.touched != args.state.metadata.touched_previously))
  if args.inputs.mouse.click || $tapping
    line_marble_hit = args.state.metadata.grid[args.state.metadata.mouse_by][args.state.metadata.mouse_bx] == args.state.themes.empty_id - 2
    color_marble_hit = args.state.metadata.grid[args.state.metadata.mouse_by][args.state.metadata.mouse_bx] == args.state.themes.empty_id - 1
    
    if line_marble_hit
      line_marble(args, args.state.metadata.mouse_bx, args.state.metadata.mouse_by)
      args.state.game_stats.collected_colors[args.state.themes.empty_id - 3] += 1
    elsif color_marble_hit
      clear_tiles_with_color(args, rand_piece, args.state.metadata.mouse_bx, args.state.metadata.mouse_by)
      args.state.game_stats.collected_colors[args.state.themes.empty_id - 2] += 1
    end
    
    if line_marble_hit || color_marble_hit
      args.state.game_stats.player_moves += 1
      play_sound(:explosion, args)
    end
  end
  
  if args.inputs.mouse.button_left || $tapping
    if $pointer.intersect_rect?($board)
      args.state.themes.color_grid_lines = 1
      mouse_point = { x: args.state.metadata.mouse_bx, y: args.state.metadata.mouse_by }
      
      if (duparr(args.state.metadata.connections, mouse_point) == 0)
        play_sound(:connect, args)
      end
      
      args.state.metadata.connections << mouse_point
      
      if (args.state.metadata.connections.length > 1)
        provide_fixed_connection args
        disable_wrong_color_connection args
        disable_diagonal_movement args
        disable_connections_collision args
        disable_lost_connection args
        args.state.counters.rot += 5
      end
    else
      args.state.metadata.touched = 0
      args.state.themes.color_grid_lines = 0
      args.state.themes.line_color = { r: 255, g: 255, b: 255, a: 255 }
      args.state.metadata.connections = []
      args.state.counters.rot = 0
    end
  else
    if args.state.metadata.connections.length > 1
      if args.state.counters.bcount > 0
        args.state.counters.bcount -= 35
      else
        clear_content args
        args.state.counters.anim_enabled = 1
        args.state.themes.color_grid_lines = 0
        args.state.themes.line_color = { r: 255, g: 255, b: 255, a: 255 }
        args.state.metadata.connections = []
        args.state.counters.rot = 0
        args.state.counters.bcount = 255
      end
    else
      args.state.metadata.touched = 0
      args.state.themes.color_grid_lines = 0
      args.state.themes.line_color = { r: 255, g: 255, b: 255, a: 255 }
      args.state.metadata.connections = []
      args.state.counters.rot = 0
      args.state.counters.bcount = 255
    end
  end
end

def input_name args
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
      args.state.counters.counter_finished = 0
      
      if args.state.counters.counter4 == 0
        args.state.game_stats.old_username = args.state.game_stats.username
        args.state.game_stats.username = args.state.metadata.kbdstr
        args.state.metadata.kbdstr = ""
        
        rv = $gtk.parse_json((response_value(args) || "[]").tr("\u0000", ""))
        tricase = false
        
        if rv.length > 0
          highscore = args.state.game_stats.highscore
          score = leaderboards_score_by_name(rv, args.state.game_stats.username, args.state.net.user_id).to_i
          tricase = highscore > score
        end
        
        if args.state.metadata.scene_to_go == 14 && args.state.game_stats.highscore > 0 && args.state.game_stats.score > 0 && tricase
          play_sound(:event, args)
          args.state.net.run_waypoints = 1
          args.state.net.waypoints_done = 0
          args.state.net.waypoint_id = 0
          args.state.net.waypoint_step = 0
          args.state.net.req = nil
          args.state.net.latest_req = nil
          leaderboards_re_request(0, args)
        else
          args.state.metadata.scene_to_go = 1
        end
        
        save_data args
      end
      
      args.state.metadata.scene = args.state.metadata.scene_to_go
    end
  end
  
  if args.state.settings.show_kbd == 1
    if args.state.counters.counter4 < 1070
      args.state.counters.counter4 += 20
    end
  elsif args.state.settings.show_kbd == 0
    if args.state.counters.counter4 > 0
      args.state.counters.counter4 -= 20
    else
      args.state.counters.counter3 = 1
    end
  end
  
  args.outputs.primitives << Label.new(
    415,
    args.state.counters.counter - 550,
    "INPUT YOUR USERNAME",
    14,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    510,
    args.state.counters.counter - 610,
    "(Max Characters: 25)",
    2,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    0,
    255)

  if args.state.metadata.kbdstr.length == 0
    args.outputs.primitives << Label.new(
      525,
      args.state.counters.counter - 720,
      "FIELD IS EMPTY!",
      4,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      0,
      0,
      255)
  elsif args.state.metadata.kbdstr == args.state.game_stats.username
    args.outputs.primitives << Label.new(
      430,
      args.state.counters.counter - 720,
      "FIELD CONTAINS SAME USERNAME!",
      4,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      0,
      0,
      255)
  end
  
  args.outputs.primitives << Border.new(
    335,
    args.state.counters.counter - 700,
    615,
    48,
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Label.new(
    340,
    args.state.counters.counter - 650,
    args.state.metadata.kbdstr,
    14,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    255,
    255)
  
  if args.state.tick_count % 1 == 0
    args.outputs.primitives << Solid.new(
      338 + (args.state.metadata.cursor_pos == -1 ? (args.state.metadata.kbdstr.length == 25 ? args.state.metadata.kbdstr.length - 1 : args.state.metadata.kbdstr.length) * 24.15 : args.state.metadata.cursor_pos * 24.15),
      args.state.counters.counter - 690,
      4,
      30,
      100,
      50,
      255,
      255)
  end
  
  if args.state.metadata.prev_scene == 7
    back_button_rec = {
      x: args.state.counters.counter - 1065,
      y: 720 - 78,
      w: 64,
      h: 64,
    }
    
    draw_img(back_button_rec, "img/start_button_light.png", 180, 255, 255, 0, 255)
  end
  
  if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
   if args.inputs.keyboard.key_down.enter
      if args.state.metadata.kbdstr.length > 0 && args.state.metadata.kbdstr != args.state.game_stats.username
        args.state.metadata.show_kbd = 0
        args.state.counters.counter3 = 0
        args.state.counters.counter2 = 1
        args.state.counters.counter4 = 0
        
        if args.state.metadata.prev_scene == 7
          args.state.metadata.scene_to_go = 7
        else
          args.state.metadata.scene_to_go = 5
        end
      end
      
      play_sound(:button, args)
    end
      
    if args.state.metadata.kbdstr.length + args.inputs.text.length <= 25 && args.inputs.text.length > 0
      banned_chars = [ "%", "?", "~", "!", "@", "#", "$", "-", "|", "\\", "/" ]
    
      if !banned_chars.include?(args.inputs.text[0])
        args.state.metadata.kbdstr = insert_text_at_pos(args.state.metadata.kbdstr, args.inputs.text[0], args.state.metadata.cursor_pos)
        play_sound(:key, args)
      end
    end
  
    if args.inputs.keyboard.key_down.left
      pointer_dec(:metadata, :cursor_pos, -2, args.state.metadata.kbdstr.length)
    end
  
    if args.inputs.keyboard.key_down.right
      pointer_inc(:metadata, :cursor_pos, args.state.metadata.kbdstr.length + 1, -1)
    end
  
    if args.inputs.keyboard.key_down.tab
      if args.state.settings.show_kbd == 0
        args.state.settings.show_kbd = 1
        args.state.counters.counter3 = 0
      else
        args.state.settings.show_kbd = 0
      end
    end
  
    if args.inputs.keyboard.key_down.space
      play_sound(:spacebar, args)
    end
  
    if args.inputs.keyboard.key_down.escape && args.state.metadata.prev_scene == 7
      args.state.settings.show_kbd = 0
      args.state.counters.counter3 = 0
      args.state.counters.counter2 = 1
      args.state.counters.counter4 = 1
      args.state.metadata.scene_to_go = 7
      play_sound(:button, args)
    end

    if args.inputs.keyboard.backspace && args.state.tick_count % 8 == 0
      if args.state.metadata.kbdstr.chop.length <= args.state.metadata.cursor_pos
        args.state.metadata.cursor_pos -= 1
      end
          
      remove_char_at_pos(args.state.metadata.kbdstr, args.state.metadata.cursor_pos)
      play_sound(:key, args)
    end
  end
  
  25.times do |i|
    r = {
      x: 342 + i * 24,
      y: 384,
      w: 23,
      h: 40
    }
          
    if ((args.inputs.mouse.button_left) || $down) && $pointer.intersect_rect?(r)
      if i < args.state.metadata.kbdstr.length
        if i != args.state.metadata.cursor_pos
          args.state.metadata.cursor_pos = i
          play_sound(:tick, args)
        end
      else
        if args.state.metadata.cursor_pos != args.state.metadata.kbdstr.length
          args.state.metadata.cursor_pos = args.state.metadata.kbdstr.length
          play_sound(:tick, args)
        end
      end
    end
  end
  
  if args.state.counters.counter3 == 0
    chars = [
      [
        [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" ],
        [ "q", "w", "e", "r", "t", "y", "u", "i", "o", "p" ],
        [ "a", "s", "d", "f", "g", "h", "j", "k", "l", ":" ],
        [ ";", "z", "x", "c", "v", "b", "n", "m", ",", "." ],
        [ "<<<", "", "", "", "", "", "", "", "", "" ]
      ],
      [
        [ "^", "&", "*", "(", ")", "_", "+", "=", "{", "}" ],
        [ "[", "]", "<", ">", "`", "'", "\"", "", "", "" ],
        [ "", "", "", "", "", "", "", "", "", "" ],
        [ "", "", "", "", "", "", "", "", "", "" ],
        [ "<<<", "", "", "", "", "", "", "", "", "" ]
        
        #[ "~", "!", "@", "#", "$", "^", "&", "*", "(", ")" ],
        #[ "-", "_", "+", "=", "{", "}", "[", "]", "|", "\\" ],
        #[ ":", "<", ">", "/", "`", "'", "\"", "", "", "" ],
        #[ "", "", "", "", "", "", "", "", "", "" ],
        #[ "<<<", "", "", "", "", "", "", "", "", "" ]
      ]
    ]
    
    space_rect = {
      x: 258,
      y: (args.state.counters.counter4 - 1078),
      w: 763,
      h: 53
    }
    
    erase_rect = {
      x: 1026,
      y: (args.state.counters.counter4 - 1078),
      w: 123,
      h: 53
    }
    
    upcase_rect = {
      x: 130,
      y: (args.state.counters.counter4 - 1078),
      w: 123,
      h: 53
    }
    
    hidekbd_rect = {
      x: 1187,
      y: (args.state.counters.counter4 - 1076),
      w: 53,
      h: 53
    }
    
    args.outputs.primitives << Solid.new(
      0,
      args.state.counters.counter4 - 1080,
      args.grid.w,
      300,
      255,
      255,
      255,
      255)

    chars[args.state.counters.kbd_idx].length.times do |i|
      chars[args.state.counters.kbd_idx][i].length.times do |j|
        t = chars[args.state.counters.kbd_idx][i][j]
        
        if t != ""
          k_rec = {
            x: (j * 128) + 2,
            y: ((args.state.counters.counter4 - 838) - (i * 60)),
            w: 123,
            h: 53
          }
      
          draw_border(k_rec, 0, 0, (args.inputs.mouse.button_left || $down) && $pointer.intersect_rect?(k_rec) ? 255 : 0, 255)
      
          args.outputs.primitives << Label.new(
            t == "<<<" ? (j * 128) + 40 : (j * 128) + 55,
            (args.state.counters.counter4 - 792) - (i * 60),
            args.state.settings.kbdup > 0 ? chars[args.state.counters.kbd_idx][i][j].upcase : chars[args.state.counters.kbd_idx][i][j],
            8,
            "fonts/JetBrainsMono-Regular.ttf",
            0,
            0,
            (args.inputs.mouse.button_left || $down) && $pointer.intersect_rect?(k_rec) ? 255 : 0,
            255)
        
          if args.state.counters.counter_finished == 1 && $tapping && $pointer.intersect_rect?(k_rec)
            if t == "<<<"
              args.state.counters.kbd_idx = (args.state.counters.kbd_idx == 0) ? 1 : 0
              play_sound(:vkbd_type, args)
            elsif $pointer.intersect_rect?(hidekbd_rect)
              args.state.settings.show_kbd = 0
              play_sound(:vkbd_type, args)
            elsif t != "" && args.state.metadata.kbdstr.length < 25
              if (args.state.settings.kbdup > 0)
                args.state.metadata.kbdstr = insert_text_at_pos(args.state.metadata.kbdstr, t.upcase, args.state.metadata.cursor_pos)
              else
                args.state.metadata.kbdstr = insert_text_at_pos(args.state.metadata.kbdstr, t, args.state.metadata.cursor_pos)
              end
              
              args.state.settings.kbdup = 0 if args.state.settings.kbdup == 1
              play_sound(:vkbd_type, args)
            end
          end
        end
      end
    end
    
    draw_border(space_rect, 0, 0, args.state.counters.counter_finished == 1 && (args.inputs.mouse.button_left || $down) && $pointer.intersect_rect?(space_rect) ? 255 : 0, 255)
 
    if args.state.counters.counter_finished == 1 && $tapping && $pointer.intersect_rect?(space_rect) && args.state.metadata.kbdstr.length < 25
      args.state.metadata.kbdstr = insert_text_at_pos(args.state.metadata.kbdstr, " ", args.state.metadata.cursor_pos)
    end
    
    draw_border(upcase_rect, 0, 0, args.state.counters.counter_finished == 1 && (args.inputs.mouse.button_left || $down) && $pointer.intersect_rect?(upcase_rect) || args.state.settings.kbdup > 0 ? 255 : 0, 255)
    
    args.outputs.primitives << Sprite.new(
      175,
      (args.state.counters.counter4 - 1073),
      32,
      42,
      "img/up_arrow.png",
      0,
      0,
      0,
      args.state.counters.counter_finished == 1 && (args.inputs.mouse.button_left || $down) && $pointer.intersect_rect?(upcase_rect) || args.state.settings.kbdup > 0 ? 255 : 0,
      255)
    
    draw_border(erase_rect, 0, 0, args.state.counters.counter_finished == 1 && (args.inputs.mouse.button_left || $down) && $pointer.intersect_rect?(erase_rect) ? 255 : 0, 255)
    
    args.outputs.primitives << Sprite.new(
      1056,
      (args.state.counters.counter4 - 1068),
      64,
      32,
      "img/eraser_icon.png",
      0,
      0,
      0,
      args.state.counters.counter_finished == 1 && (args.inputs.mouse.button_left || $down) && $pointer.intersect_rect?(erase_rect) ? 255 : 0,
      255)
    
    draw_img(hidekbd_rect, "img/start_button_light.png", 270, 0, 0, 0, 255)

    if args.state.settings.show_kbd == 1 && $tapping
      if $pointer.intersect_rect?(erase_rect)
        if args.state.metadata.kbdstr.chop.length <= args.state.metadata.cursor_pos
          args.state.metadata.cursor_pos -= 1
        end
        
        remove_char_at_pos(args.state.metadata.kbdstr, args.state.metadata.cursor_pos)
        play_sound(:vkbd_type, args)
      end
      
      if $pointer.intersect_rect?(hidekbd_rect)
        args.state.settings.show_kbd = 0
        play_sound(:vkbd_type, args)
      end
      
      if $pointer.intersect_rect?(upcase_rect)
        pointer_inc(:settings, :kbdup, 3, 0)
        play_sound(:vkbd_type, args)
      end
    end
  else
    showkbd_button_rec = {
      x: 598,
      y: (args.state.counters.counter - 1076),
      w: 64,
      h: 64
    }
    
    next_button_rec = {
      x: args.state.counters.counter + 90,
      y: (args.state.counters.counter - 1066),
      w: 84,
      h: 84
    }
    
    aabb_showkbd_button = $pointer.intersect_rect?(showkbd_button_rec)
    aabb_next_button = $pointer.intersect_rect?(next_button_rec)
    
    if args.state.metadata.prev_scene == 7
      aabb_back_button = $pointer.intersect_rect?(back_button_rec)
    end
    
    draw_img(showkbd_button_rec, "img/start_button_light.png", 90, 255, 255, 0, 255)
    
    args.outputs.primitives << Label.new(
      showkbd_button_rec.x - 60,
      showkbd_button_rec.y + 110,
      "(Show Keyboard)",
      2,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      0,
      255)
    
    draw_img(next_button_rec, "img/start_button_light.png", 0, 255, 255, 0, 255)
    
    args.outputs.primitives << Label.new(
      next_button_rec.x - 120,
      next_button_rec.y + 70,
      "NEXT",
      16,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      0,
      255)

    if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
      if ($tapping && aabb_showkbd_button)
        args.state.settings.show_kbd = 1
        args.state.counters.counter3 = 0
        play_sound(:button, args)
      end
        
      if ($tapping && aabb_back_button && args.state.metadata.prev_scene == 7)
        args.state.settings.show_kbd = 0
        args.state.counters.counter3 = 0
        args.state.counters.counter2 = 1
        args.state.counters.counter4 = 1
        args.state.metadata.scene_to_go = 7
        play_sound(:button, args)
      end
      
      if ($tapping && aabb_next_button)
        if ((args.state.metadata.kbdstr.length > 0) && (args.state.metadata.kbdstr != args.state.game_stats.username))
          args.state.settings.show_kbd = 0
          args.state.counters.counter3 = 0
          args.state.counters.counter2 = 1
          args.state.counters.counter4 = 0
            
          if args.state.metadata.prev_scene == 7
            args.state.metadata.scene_to_go = 7
          else
            args.state.metadata.scene_to_go = 14
          end
        end
        
        play_sound(:button, args)
      end
    end
  end
end
