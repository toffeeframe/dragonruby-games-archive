requires = [
  "game_data.rb", "achievements.rb", "arr_utils.rb", "audio.rb",
  "background.rb", "board.rb", "common_rectangles.rb", "game.rb",
  "gui.rb", "input.rb", "leaderboards.rb", "matching_logic.rb",
  "palettes.rb", "rendering_classes.rb", "scenes.rb", "special_marbles.rb",
  "themes.rb", "utils.rb", "yell.rb"
]

requires.length.times do |i|
  require("app/#{requires[i]}")
end

def tick args
  setup args
  load_data args
  
  if args.state.tick_count % 60 == 0
    if args.state.net.req_state == 0
      handle_http_requests args
      args.state.net.req_timer += 1
    end
  end
  
  if !is_mobile
    $gtk.set_window_fullscreen(args.state.settings.fullscreen == 1)
  end
  
  if is_mobile
    args.state.metadata.touched_previously = args.state.metadata.touched
    args.state.metadata.touched = !args.inputs.finger_one.nil? ? 1 : 0
  end
  
  if args.state.metadata.scene == 2
    args.outputs.background_color = args.state.themes.background_color.map { |k, v| v }
  else
    args.outputs.background_color = [ 0, 0, 0, 255 ]
  end
  
  $pointer  = pointer_rect(args)
  $board    = board_rect(args)
  $tapping  = tap(args)
  $down     = touch_down(args)
  
  if args.state.metadata.scene == 0
    splashscreen args
  elsif args.state.metadata.scene == 1
    main_menu args
  elsif args.state.metadata.scene == 2
    play args
  elsif args.state.metadata.scene == 3
    lose args
  elsif args.state.metadata.scene == 4
    new_achievements args
  elsif args.state.metadata.scene == 5
    leaderboards args
  elsif args.state.metadata.scene == 6
    pause args
  elsif args.state.metadata.scene == 7
    options args
  elsif args.state.metadata.scene == 8
    themes_menu args
  elsif args.state.metadata.scene == 9
    how_to_play args
  elsif args.state.metadata.scene == 10
    credits args
  elsif args.state.metadata.scene == 11
    achievements args
  elsif args.state.metadata.scene == 12
    stats args
  elsif args.state.metadata.scene == 13
    input_name args
  elsif args.state.metadata.scene == 14
    waypoint args
  elsif args.state.metadata.scene == 15
    palettes_menu args
  end
  
  if ((args.state.metadata.scene == 2 || ([ 6, 7, 10, 13 ].include?(args.state.metadata.scene) && args.state.settings.game_paused == 1)) && args.state.settings.music_enabled == 1 && args.state.game_stats.time_left > 0)
    play_sound(:song, args)
    args.audio[:song].gain = 1.0 if args.audio[:song]
  else
    args.audio[:song].gain = 0.0 if args.audio[:song]
  end
end
