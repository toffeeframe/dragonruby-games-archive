def yell args
  if args.state.counters.yell_state == 0 && args.state.counters.show_timeup == 0
    args.state.counters.bbcount = 255
    args.state.counters.yell_state = rand(6) + 1
  end
end

def yell_logic args
  if args.state.settings.game_paused == 0
    if args.state.counters.show_timeup == 1
      if args.state.tick_count % 15 == 0
        play_sound(:tick, args)
        args.state.counters.counter3 += 1
      end
      
      if args.state.counters.counter3 >= ("GAME OVER!").length
        if args.state.counters.bbcount > 0
          args.state.counters.bbcount -= 25
        else
          activate_special_marbles args
          args.state.counters.show_timeup = 0
          args.state.counters.counter3 = 0
          args.state.counters.move_game_gui = 1
        end
      end
      
      args.outputs.primitives << Label.new(
        10,
        455,
        ("GAME OVER!")[0..args.state.counters.counter3],
        97,
        "fonts/Confarreatio.ttf",
        0,
        0,
        0,
        args.state.counters.counter3 >= ("GAME OVER!").length ? args.state.counters.bbcount : 150)
        
      args.outputs.primitives << Label.new(
        20,
        450,
        ("GAME OVER!")[0..args.state.counters.counter3],
        96,
        "fonts/Confarreatio.ttf",
        255,
        0,
        255,
        args.state.counters.counter3 >= ("GAME OVER!").length ? args.state.counters.bbcount : 255)
    end
  
    if args.state.counters.yell_state == 1
      if args.state.tick_count % 10 == 0
        play_sound(:tick, args)
        args.state.counters.counter3 += 1
      end
      
      if args.state.counters.counter3 >= ("GOOD JOB!").length
        if args.state.counters.bbcount > 0
          args.state.counters.bbcount -= 25
        else
          args.state.counters.yell_state = 0
          args.state.counters.counter3 = 0
        end
      end
      
      args.outputs.primitives << Label.new(
        80,
        455,
        ("GOOD JOB!")[0..args.state.counters.counter3],
        97,
        "fonts/Confarreatio.ttf",
        0,
        0,
        0,
        args.state.counters.counter3 >= ("GOOD JOB!").length ? args.state.counters.bbcount : 150)
      
      args.outputs.primitives << Label.new(
        90,
        450,
        ("GOOD JOB!")[0..args.state.counters.counter3],
        96,
        "fonts/Confarreatio.ttf",
        255,
        0,
        255,
        args.state.counters.counter3 >= ("GOOD JOB!").length ? args.state.counters.bbcount : 255)
    end
  
    if args.state.counters.yell_state == 2
      if args.state.tick_count % 10 == 0
        play_sound(:tick, args)
        args.state.counters.counter3 += 1
      end
      
      if args.state.counters.counter3 >= ("AMAZING!").length
        if args.state.counters.bbcount > 0
          args.state.counters.bbcount -= 25
        else
          args.state.counters.yell_state = 0
          args.state.counters.counter3 = 0
        end
      end
      
      args.outputs.primitives << Label.new(
        130,
        455,
        ("AMAZING!")[0..args.state.counters.counter3],
        96,
        "fonts/Confarreatio.ttf",
        0,
        0,
        0,
        args.state.counters.counter3 >= ("AMAZING!").length ? args.state.counters.bbcount : 150)
      
      args.outputs.primitives << Label.new(
        140,
        450,
        ("AMAZING!")[0..args.state.counters.counter3],
        96,
        "fonts/Confarreatio.ttf",
        255,
        0,
        255,
        args.state.counters.counter3 >= ("AMAZING!").length ? args.state.counters.bbcount : 255)
    end
  
    if args.state.counters.yell_state == 3
      if args.state.tick_count % 10 == 0
        play_sound(:tick, args)
        args.state.counters.counter3 += 1
      end
      
      if args.state.counters.counter3 >= ("NICE!").length
        if args.state.counters.bbcount > 0
          args.state.counters.bbcount -= 25
        else
          args.state.counters.yell_state = 0
          args.state.counters.counter3 = 0
        end
      end
      
      args.outputs.primitives << Label.new(
        370,
        455,
        ("NICE!")[0..args.state.counters.counter3],
        96,
        "fonts/Confarreatio.ttf",
        0,
        0,
        0,
        args.state.counters.counter3 >= ("NICE!").length ? args.state.counters.bbcount : 150)
        
      args.outputs.primitives << Label.new(
        380,
        450,
        ("NICE!")[0..args.state.counters.counter3],
        96,
        "fonts/Confarreatio.ttf",
        255,
        0,
        255,
        args.state.counters.counter3 >= ("NICE!").length ? args.state.counters.bbcount : 255)
    end
  
    if args.state.counters.yell_state == 4
      if args.state.tick_count % 10 == 0
        play_sound(:tick, args)
        args.state.counters.counter3 += 1
      end
      
      if args.state.counters.counter3 >= ("SASSY!").length
        if args.state.counters.bbcount > 0
          args.state.counters.bbcount -= 25
        else
          args.state.counters.yell_state = 0
          args.state.counters.counter3 = 0
        end
      end
      
      args.outputs.primitives << Label.new(
        270,
        455,
        ("SASSY!")[0..args.state.counters.counter3],
        97,
        "fonts/Confarreatio.ttf",
        0,
        0,
        0,
        args.state.counters.counter3 >= ("SASSY!").length ? args.state.counters.bbcount : 150)
        
      args.outputs.primitives << Label.new(
        280,
        450,
        ("SASSY!")[0..args.state.counters.counter3],
        96,
        "fonts/Confarreatio.ttf",
        255,
        0,
        255,
        args.state.counters.counter3 >= ("SASSY!").length ? args.state.counters.bbcount : 255)
    end
  
    if args.state.counters.yell_state == 5
      if args.state.tick_count % 10 == 0
        play_sound(:tick, args)
        args.state.counters.counter3 += 1
      end
      
      if args.state.counters.counter3 >= ("WOW!!!").length
        if args.state.counters.bbcount > 0
          args.state.counters.bbcount -= 25
        else
          args.state.counters.yell_state = 0
          args.state.counters.counter3 = 0
        end
      end
      
      args.outputs.primitives << Label.new(
        230,
        455,
        ("WOW!!!")[0..args.state.counters.counter3],
        96,
        "fonts/Confarreatio.ttf",
        0,
        0,
        0,
        args.state.counters.counter3 >= ("WOW!!!").length ? args.state.counters.bbcount : 150)
        
      args.outputs.primitives << Label.new(
        240,
        450,
        ("WOW!!!")[0..args.state.counters.counter3],
        96,
        "fonts/Confarreatio.ttf",
        255,
        0,
        255,
        args.state.counters.counter3 >= ("WOW!!!").length ? args.state.counters.bbcount : 255)
    end
    
    if args.state.counters.yell_state == 6
      if args.state.tick_count % 10 == 0
        play_sound(:tick, args)
        args.state.counters.counter3 += 1
      end
      
      if args.state.counters.counter3 >= ("WONDERFUL!").length
        if args.state.counters.bbcount > 0
          args.state.counters.bbcount -= 25
        else
          args.state.counters.yell_state = 0
          args.state.counters.counter3 = 0
        end
      end
      
      args.outputs.primitives << Label.new(
        110,
        455,
        ("WONDERFUL!")[0..args.state.counters.counter3],
        73,
        "fonts/Confarreatio.ttf",
        0,
        0,
        0,
        args.state.counters.counter3 >= ("WONDERFUL!").length ? args.state.counters.bbcount : 150)
        
      args.outputs.primitives << Label.new(
        120,
        450,
        ("WONDERFUL!")[0..args.state.counters.counter3],
        72,
        "fonts/Confarreatio.ttf",
        255,
        0,
        255,
        args.state.counters.counter3 >= ("WONDERFUL!").length ? args.state.counters.bbcount : 255)
    end
    
    if args.state.counters.yell_state == 7
      if args.state.tick_count % 10 == 0
        play_sound(:tick, args)
        args.state.counters.counter3 += 1
      end
      
      if args.state.counters.counter3 >= ("SHUFFLING...").length
        if args.state.counters.bbcount > 0
          args.state.counters.bbcount -= 25
        else
          shuffle_board args
          args.state.counters.yell_state = 0
          args.state.counters.counter3 = 0
        end
      end
      
      args.outputs.primitives << Label.new(
        130,
        455,
        ("SHUFFLING...")[0..args.state.counters.counter3],
        73,
        "fonts/Confarreatio.ttf",
        0,
        0,
        0,
        args.state.counters.counter3 >= ("SHUFFLING...").length ? args.state.counters.bbcount : 150)
        
      args.outputs.primitives << Label.new(
        140,
        450,
        ("SHUFFLING...")[0..args.state.counters.counter3],
        72,
        "fonts/Confarreatio.ttf",
        255,
        0,
        255,
        args.state.counters.counter3 >= ("SHUFFLING...").length ? args.state.counters.bbcount : 255)
    end
  end
end
