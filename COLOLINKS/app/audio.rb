def play_sound(key, args)
  audio = {
    :connect    => "audio/376968__elmasmalo1__bubble-pop.ogg",
    :pop        => "audio/439186__javapimp__pop-5.ogg",
    :start      => "audio/341695__projectsu012__coins-1.ogg",
    :scorebreak => "audio/514160__edwardszakal__score-beep.ogg",
    :explosion  => "audio/435413__v-ktor__explosion12.ogg",
    :powerup    => "audio/368651__jofae__game-powerup.ogg",
    :button     => "audio/39562__the-bizniss__mouse-click.ogg",
    :lose       => "audio/346425__soneproject__ecofuture3.ogg",
    :event      => "audio/366102__original-sound__confirmation-upward.ogg",
    :event2     => "audio/242855__plasterbrain__friend-request.ogg",
    :tick       => "audio/110314__mrown1__tick.ogg",
    :key        => "audio/180974__ueffects__a-key.ogg",
    :vkbd_type  => "audio/54406__korgms2000b__metronome-click.ogg",
    :spacebar   => "audio/421582__uberbosser__spacebarkey.ogg",
    :song       => "audio/337146__erokia__timelift-rhodes-piano.ogg"
  }
  
  pkey = (key != :song) ? args.state.settings.sound_enabled : args.state.settings.music_enabled
  
  if pkey == 1
    args.audio[key] ||= {
      input: audio[key],
      x: 0.0,
      y: 0.0,
      z: 0.0,
      gain: args.state.settings.volume / 100,
      pitch: 1.0,
      paused: false,
      looping: false
    }
  end
end
