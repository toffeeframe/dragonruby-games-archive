def gen_game_id
  res = []
  
  25.times do |i|
    b = rand(2)
    
    if b == 0
      res << rand(10)
    elsif b == 1
      res << (65 + rand(26)).chr.to_s.downcase
    end
  end
  
  return res.join
end

def response_value(args)
  if !args.state.net.req.nil?
    if args.state.net.req.complete && args.state.net.req.http_response_code == 200
      if !args.state.net.req.response_data.nil?
        return args.state.net.req.response_data
      end
    end
  end
  return nil
end

def parsed_response_value(args)
  return $gtk.parse_json((response_value(args) || "[]").tr("\u0000", ""))
end

def new_game_id(args)
  uname = []
  
  if args.state.net.req_action == 0 && args.state.net.req_state == 1
    json = parsed_response_value(args)
    
    if json.length > 0
      json.length.times do |i|
        uname << json[i]["name"].split("@")[1]
      end
    end
    
    id = gen_game_id
    
    while uname.include?(id)
      id = gen_game_id
    end
    
    return id
  end
  
  return gen_game_id
end

def leaderboards_add_score(args, k = "a4f35e809a2646efb8cf")
  return $gtk.http_get("https://awful.cooking/_highscores/api/add/#{k}/#{args.state.game_stats.highscore}-#{args.state.game_stats.username}@#{args.state.net.user_id}")
end

def leaderboards_remove_score(args, k = "a4f35e809a2646efb8cf")
  return $gtk.http_get("https://awful.cooking/_highscores/api/delete/#{k}/#{args.state.net.pid}")
end

def leaderboards_top_scores(count, k = "a4f35e809a2646efb8cf")
  return $gtk.http_get("https://awful.cooking/_highscores/api/top/#{k}/#{count}")
end

def leaderboards_sort_scores(arr)
  return arr.sort_by { |h| h["score"].to_i }.reverse
end

def leaderboards_re_request(action = 0, args)
  args.state.net.req = nil
  args.state.net.req_state = 0
  args.state.net.req_timer = 0
  args.state.net.req_action = action
end

def leaderboards_name_exists(arr, name, id)
  res = false
  
  arr.length.times do |i|
    if arr[i]["name"] == "#{name}@#{id}"
      res = true
      break
    end
  end
  
  return res
end

def leaderboards_pid_by_name(arr, name, id)
  res = nil
  return res if !leaderboards_name_exists(arr, name, id)
  
  arr.length.times do |i|
    if arr[i]["name"] == "#{name}@#{id}"
      res = arr[i]["id"]
      break
    end
  end
  
  return res
end

def leaderboards_score_by_name(arr, name, id)
  res = nil
  return res if !leaderboards_name_exists(arr, name, id)
  
  arr.length.times do |i|
    if arr[i]["name"] == "#{name}@#{id}"
      res = arr[i]["score"]
      break
    end
  end
  
  return res
end

def update_player_score_from_leaderboards(arr, name, id, args)
  update_state = 0

  arr.length.times do |i|
    if arr[i]["name"] == "#{name}@#{id}"
      if args.state.game_stats.highscore < arr[i]["score"].to_i
        args.state.game_stats.highscore = arr[i]["score"].to_i
        update_state = 1
        break
      end
    end
  end
  
  return update_state
end

def push_play_score_to_leaderboards(args)
  args.state.net.run_waypoints = 1
  args.state.net.waypoint_id = 0
  args.state.net.waypoint_step = 0
  args.state.net.waypoints_done = 0
end

def handle_http_requests_failure args
  if args.state.net.req_action >= 0 && args.state.net.req_state == 0
    if args.state.net.run_waypoints == 1 && args.state.net.waypoint_step > -1
      if args.state.net.waypoint_id == 0 && args.state.net.req_timer > 5
        args.state.net.run_waypoints = 0
        args.state.net.waypoints_done = 1
      end
    end
  end
end

def handle_http_requests args
  if args.state.net.req_action == 0 && args.state.net.req_state == 0
    if args.state.net.req.nil?
      args.state.net.req = leaderboards_top_scores(100)
      handle_http_requests_failure args
    else
      if args.state.net.req.complete && args.state.net.req.http_response_code == 200
        if args.state.net.latest_req != args.state.net.req
          args.state.net.req_timer = 0
          args.state.net.req_state = 1
          args.state.net.latest_req = args.state.net.req
          
          if args.state.net.user_id.nil?
            args.state.net.user_id = new_game_id(args)
            save_data args
          end
          
          json_res = parsed_response_value(args)
          
          v1 = 0
          v2 = 0
          
          if !args.state.game_stats.username.nil? && args.state.game_stats.username.length > 0
            update_player_score_from_leaderboards(json_res, args.state.game_stats.username, args.state.net.user_id, args) == 0
          end
          if !args.state.game_stats.username.nil? && args.state.game_stats.old_username.length > 0
            update_player_score_from_leaderboards(json_res, args.state.game_stats.old_username, args.state.net.user_id, args) == 0
          end
          
          if args.state.net.run_waypoints == 0
            push_play_score_to_leaderboards(args)
          end
          
          if args.state.net.run_waypoints == 1
            if args.state.net.waypoint_step > -1
              if args.state.net.waypoint_id == 0
                args.state.net.waypoint_id = 1
              elsif args.state.net.waypoint_id == 3
                args.state.net.waypoint_id = 4
              end
            end
          end
        end
      else
        args.state.net.req = leaderboards_top_scores(100)
        handle_http_requests_failure args
      end
    end
  elsif args.state.net.req_action == 1 && args.state.net.req_state == 0
    if args.state.net.req.nil?
      args.state.net.req_timer += 1
      args.state.net.req = leaderboards_add_score(args)
      handle_http_requests_failure args
    else
      if args.state.net.req.complete && args.state.net.req.http_response_code == 200
        if args.state.net.latest_req != args.state.net.req
          args.state.net.req_timer = 0
          args.state.net.req_state = 1
          args.state.net.latest_req = args.state.net.req

          if args.state.net.run_waypoints == 1
            if args.state.net.waypoint_step > -1
              if args.state.net.waypoint_id == 2
                args.state.net.waypoint_id = 3
              end
            end
          end
          
        end
      else
        args.state.net.req = leaderboards_add_score(args)
        handle_http_requests_failure args
      end
    end
  elsif args.state.net.req_action == 2 && args.state.net.req_state == 0
    if args.state.net.req.nil?
      args.state.net.req = leaderboards_remove_score(args)
      handle_http_requests_failure args
    else
      if args.state.net.req.complete && args.state.net.req.http_response_code == 200
        if args.state.net.latest_req != args.state.net.req

          args.state.net.req_timer = 0
          args.state.net.req_state = 1
          args.state.net.latest_req = args.state.net.req

          if args.state.net.run_waypoints == 1
            if args.state.net.waypoint_step > -1
              if args.state.net.waypoint_id == 1
                args.state.net.waypoint_id = 2
              end
            end
          end
        end
      else
        args.state.net.req = leaderboards_remove_score(args)
        handle_http_requests_failure args
      end
    end
  end
end

def page_count(arr)
  if arr.length <= 10
    return 1
  else
    l = (arr.length / 10)
    
    if l.to_i == l
      return l
    else
      return l.to_i + 1
    end
  end
end

def page_count_arr(arr, i)
  return arr[i * 10 .. ((i * 10) + 9)]
end

def page_count_rankvals(i)
  return [i * 10, ((i * 10) + 9)]
end

def page_count_ranks(i)
  return page_count_arr((0 .. 99).to_a, i)
end

def waypoint args
  main_menu_bg args
  
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
      args.state.counters.leaderboards_idx = 0
      
      if args.state.metadata.prev_scene == 3 || args.state.metadata.prev_scene == 4
        args.state.metadata.scene_to_go = 5
      elsif args.state.metadata.prev_scene == 7
        args.state.metadata.scene_to_go = 7
      else
        args.state.metadata.scene_to_go = 1
      end
      
      args.state.metadata.prev_scene = args.state.metadata.scene
      args.state.metadata.scene = args.state.metadata.scene_to_go
    end
  end

  if args.state.net.waypoint_step == 0 && args.state.net.waypoints_done == 0
    if args.state.net.waypoint_id == 1
      if args.state.net.req_action == 0 && args.state.net.req_state == 1
        json = parsed_response_value(args)
        pid1 = leaderboards_pid_by_name(json, args.state.game_stats.old_username, args.state.net.user_id)
        pid2 = leaderboards_pid_by_name(json, args.state.game_stats.username, args.state.net.user_id)
        
        if leaderboards_name_exists(json, args.state.game_stats.username, args.state.net.user_id)
          args.state.net.pid = leaderboards_pid_by_name(json, args.state.game_stats.username, args.state.net.user_id)
        else
          args.state.net.pid = leaderboards_pid_by_name(json, args.state.game_stats.old_username, args.state.net.user_id)
        end
        
        if args.state.net.pid.nil?
          args.state.net.req_action = 2
          args.state.net.req_state = 1
          args.state.net.waypoint_id = 2
        else
          old_score = leaderboards_score_by_name(json, args.state.game_stats.old_username, args.state.net.user_id).to_i
          args.state.game_stats.highscore = [old_score, args.state.game_stats.highscore].max
          
          if old_score != args.state.game_stats.highscore
            if args.state.net.req == args.state.net.latest_req
              leaderboards_re_request(2, args)
            end
          else
            args.state.net.run_waypoints = 0
            args.state.net.waypoints_done = 1
          end
        end
      end
      
    elsif args.state.net.waypoint_id == 2
      if args.state.net.req_action == 2 && args.state.net.req_state == 1        
        if args.state.net.req == args.state.net.latest_req
          leaderboards_re_request(1, args)
        end
      end
    
    elsif args.state.net.waypoint_id == 3
      if args.state.net.req_action == 1 && args.state.net.req_state == 1
        if args.state.net.req == args.state.net.latest_req
          leaderboards_re_request(0, args)
        end
      end
    
    elsif args.state.net.waypoint_id == 4
      if args.state.net.req_action == 0 && args.state.net.req_state == 1
        args.state.net.run_waypoints = 0
        args.state.net.waypoints_done = 1
      end
    end
  end
  
  if args.state.net.waypoints_done == 0
    args.outputs.primitives << Sprite.new(
      (args.state.counters.counter - 770),
      (args.grid.h - 256) / 1.8,
      256,
      256,
      "img/coloured_circle.png",
      args.state.tick_count)
    
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 730),
      (args.grid.h - 256) / 2,
      "CONNECTING...",
      6,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      0,
      255)
  else
    if args.state.counters.counter2 == 0
      args.state.counters.counter2 = 1
    end
  end
end

def leaderboards args
  main_menu_bg args
  
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
      args.state.counters.leaderboards_idx = 0
      args.state.metadata.prev_scene = args.state.metadata.scene
      args.state.metadata.scene = args.state.metadata.scene_to_go
    end
  end
  
  if args.state.tick_count % 120 == 0
    args.state.counters.counter3 = (args.state.counters.counter3 == 0) ? 1 : 0
  end
  
  back_button_rec = {
    x: args.state.counters.counter - 1265,
    y: 720 - 78,
    w: 64,
    h: 64,
  }
  
  aabb_back_button = $pointer.intersect_rect?(back_button_rec)

  args.outputs.primitives << Sprite.new(
    args.state.counters.counter - 1020,
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
    args.state.counters.counter - 350,
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
    args.state.counters.counter - 885,
    args.state.counters.counter - 605,
    "LEADERBOARDS",
    22,
    "fonts/Confarreatio.ttf",
    255,
    255,
    0,
    255)
  
  args.outputs.primitives << Line.new(
    16,
    580,
    args.grid.w - 16,
    580,
    255,
    255,
    0,
    255)

  draw_img(back_button_rec, "img/start_button_light.png", 180, 255, 255, 0, 255)
      
  if args.state.net.req_state == 0
    args.outputs.primitives << Sprite.new(
      (args.state.counters.counter - 770),
      (args.grid.h - 256) / 2.3,
      256,
      256,
      "img/coloured_circle.png",
      args.state.tick_count)
    
    args.outputs.primitives << Label.new(
      (args.state.counters.counter - 710),
      (args.grid.h - 256) / 2.3,
      "LOADING...",
      6,
      "fonts/JetBrainsMono-Regular.ttf",
      255,
      255,
      0,
      255)
  else
    list = leaderboards_sort_scores(parsed_response_value(args))
    ranks = page_count_ranks(args.state.counters.leaderboards_idx)
    rankstamp = page_count_rankvals(args.state.counters.leaderboards_idx)
    sublist = page_count_arr(list, args.state.counters.leaderboards_idx)

    sublist.length.times do |i|
      if list[i]
        args.outputs.primitives << Label.new(
          args.state.counters.counter - 1260,
          (args.state.counters.counter - 715) + i * -50,
          "##{ranks[i] + 1}",
          8,
          "fonts/JetBrainsMono-Regular.ttf",
          255,
          255,
          0,
          255)
        
        args.outputs.primitives << Label.new(
          args.state.counters.counter - 1170,
          (args.state.counters.counter - 715) + i * -50,
          (sublist[i]["name"] == "#{args.state.game_stats.username}@#{args.state.net.user_id}" || sublist[i]["name"] == "#{args.state.game_stats.old_username}@#{args.state.net.user_id}") ? "You" : sublist[i]["name"].split("@")[0],
          8,
          "fonts/JetBrainsMono-Regular.ttf",
          255,
          (sublist[i]["name"] == "#{args.state.game_stats.username}@#{args.state.net.user_id}" || sublist[i]["name"] == "#{args.state.game_stats.old_username}@#{args.state.net.user_id}") ? 0 : 255,
          255,
          255)
      
        args.outputs.primitives << Label.new(
          args.state.counters.counter - 200,
          (args.state.counters.counter - 715) + i * -50,
          sublist[i]["score"].rjust(10, "0"),
          8,
          "fonts/JetBrainsMono-Regular.ttf",
          255,
          (sublist[i]["name"] == "#{args.state.game_stats.username}@#{args.state.net.user_id}" || sublist[i]["name"] == "#{args.state.game_stats.old_username}@#{args.state.net.user_id}") ? 0 : 255,
          255,
          255)
      end
    end
    
    if list.length > 10
      prev_button_rec = {
        x: args.state.counters.counter - 805,
        y: 16,
        w: 32,
        h: 32
      }
      
      next_button_rec = {
        x: args.state.counters.counter - 545,
        y: 16,
        w: 32,
        h: 32
      }
      
      aabb_prev_button = $pointer.intersect_rect?(prev_button_rec)
      aabb_next_button = $pointer.intersect_rect?(next_button_rec)
      
      draw_img(prev_button_rec, "img/triangle.png", 90, 255, 255, 0, 255)
      draw_img(next_button_rec, "img/triangle.png", 270, 255, 255, 0, 255)
        
      args.outputs.primitives << Label.new(
        args.state.counters.counter - 720,
        48,
        "##{rankstamp[0] + 1} - ##{rankstamp[1] + 1}",
        4,
        "fonts/JetBrainsMono-Regular.ttf",
        255,
        255,
        0,
        255)
      
      pages = page_count(list) - 1
      
      if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
        if args.inputs.keyboard.key_down.right || ($tapping && aabb_next_button)
          pointer_inc(:counters, :leaderboards_idx, pages + 1, 0)
          play_sound(:button, args)
        end
        
        if args.inputs.keyboard.key_down.left || ($tapping && aabb_prev_button)
          pointer_dec(:counters, :leaderboards_idx, -1, pages)
          play_sound(:button, args)
        end
      end
    end
  end
  
  if args.state.counters.counter2 == 0 && args.state.counters.counter_finished == 1
    if args.inputs.keyboard.key_down.escape || ($tapping && aabb_back_button)
      args.state.counters.counter2 = 1
      args.state.metadata.scene_to_go = 1
      play_sound(:button, args)
    end
  end
end
