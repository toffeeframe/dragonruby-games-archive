def game_stats_gui args
  hxc = dragonruby_hex2color("294253")
  
  args.outputs.primitives << Solid.new(
    (0 - args.state.counters.anmov),
    0,
    475,
    720,
    hxc.r,
    hxc.g,
    hxc.b,
    hxc.a)
  
  args.outputs.primitives << Border.new(
    (58 - args.state.counters.anmov),
    565,
    360,
    125,
    255,
    255,
    255,
    255)
  
  args.outputs.primitives << Label.new(
    (160 - args.state.counters.anmov),
    685,
    "SCORE",
    12,
    "fonts/Confarreatio.ttf",
    255,
    255,
    255,
    255)
  
  args.outputs.primitives << Line.new(
    (62 - args.state.counters.anmov),
    635,
    (412 - args.state.counters.anmov),
    635,
    255,
    255,
    255,
    255)
  
  c = args.state.settings.custom_palettes_enabled == 1 ? args.state.themes.current_palette.colors[args.state.game_stats.last_color_swiped].transform_keys(&:to_sym) : args.state.themes.current_palette[args.state.game_stats.last_color_swiped]
  chain_cond = (args.state.game_stats.color_chains > 0) ? c : { r: 255, g: 255, b: 255 }
  
  args.outputs.primitives << Label.new(
    (125 - args.state.counters.anmov),
    620,
    args.state.game_stats.score.to_s.rjust(10, "0"),
    12,
    "fonts/JetBrainsMono-Regular.ttf",
    chain_cond.r,
    chain_cond.g,
    chain_cond.b,
    255)

  args.outputs.primitives << Border.new(
    (55 - args.state.counters.anmov),
    385,
    360,
    125,
    255,
    255,
    255,
    255)
  
  args.outputs.primitives << Label.new(
    (115 - args.state.counters.anmov),
    505,
    "HIGHSCORE",
    12,
    "fonts/Confarreatio.ttf",
    255,
    255,
    255,
    255)
  
  args.outputs.primitives << Line.new(
    (60 - args.state.counters.anmov),
    455,
    (410 - args.state.counters.anmov),
    455,
    255,
    255,
    255,
    255)
  
  args.outputs.primitives << Label.new(
    (125 - args.state.counters.anmov),
    440,
    args.state.game_stats.pre_highscore.to_s.rjust(10, "0"),
    12,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    255,
    255)
  
  args.outputs.primitives << Border.new(
    (60 - args.state.counters.anmov),
    205,
    360,
    125,
    255,
    255,
    255,
    255)
  
  args.outputs.primitives << Label.new(
    (185 - args.state.counters.anmov),
    325,
    "TIME",
    12,
    "fonts/Confarreatio.ttf",
    255,
    255,
    255,
    255)
  
  args.outputs.primitives << Line.new(
    (65 - args.state.counters.anmov),
    275,
    (415 - args.state.counters.anmov),
    275,
    255,
    255,
    255,
    255)
  
  time_cond = (args.state.game_stats.time_left <= 10 && args.state.tick_count % 60 == 0) ? 0 : 255
  
  args.outputs.primitives << Label.new(
    (205 - args.state.counters.anmov),
    260,
    args.state.game_stats.time_left.to_s.rjust(3, "0"),
    12,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    time_cond,
    time_cond,
    255)
  
  args.outputs.primitives << Border.new(
    (60 - args.state.counters.anmov),
    25,
    360,
    125,
    255,
    255,
    255,
    255)
  
  args.outputs.primitives << Label.new(
    (165 - args.state.counters.anmov),
    145,
    "MOVES",
    12,
    "fonts/Confarreatio.ttf",
    255,
    255,
    255,
    255)
  
  args.outputs.primitives << Line.new(
    (65 - args.state.counters.anmov),
    95,
    (415 - args.state.counters.anmov),
    95,
    255,
    255,
    255,
    255)
  
  args.outputs.primitives << Label.new(
    (206 - args.state.counters.anmov),
    80,
    args.state.game_stats.player_moves.to_s.rjust(3, "0"),
    12,
    "fonts/JetBrainsMono-Regular.ttf",
    255,
    255,
    255,
    255)
end

def game_gui args
  pause_button_rec = {
    x: (1210 - args.state.counters.anmov),
    y: 650,
    w: 64,
    h: 64
  }
  
  aabb_pause_button = $pointer.intersect_rect?(pause_button_rec)
  game_stats_gui args
  
  args.outputs.primitives << Sprite.new(
    (1210 - args.state.counters.anmov),
    650,
    64,
    64,
    "img/pause_button_2.png")
  
  if args.inputs.keyboard.key_down.escape || args.inputs.keyboard.key_down.p || ($tapping && aabb_pause_button)
    args.state.metadata.scene = 6
    args.state.settings.game_paused = 1
    play_sound(:button, args)
  end
end
