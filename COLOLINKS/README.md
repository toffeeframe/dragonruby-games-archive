# COLOLINKS!

This is the source code of the game COLOLINKS! which was on itch.io years ago before deletion.

The code has not been touched years ago since the release (Unless for improvements and patches) therefore
there is no guarantee that it can be built or run on newer DragonRuby GTK versions

The game should work just fine (If can be built) on desktop and mobile platforms, Web build struggles with
stuttering and performance problems so it was the only game back then I didn't make it playable on web.

## Source Code

Initially the whole game source code was all in one file during development, Later little refactoring done and the source code split into
various files with their usage although the naming of some is somehow misleading (Could've been better) or even fulfill parts that other
files should do instead...

| File | Usage |
|------|-------|
| `achievements.rb` | Achievements UI Scene (Achievements metadata is in `game.rb`) |
| `arr_utils.rb` | Utilities to deal with arrays, Used for the grid data logic within gameplay mechanism |
| `audio.rb` | Audio Management, Makes playing sounds easier |
| `background.rb` | Code for rendering backgrounds within game scenes |
| `board.rb` | Code for rendering the game board during playing |
| `common_rectangles.rb` | Functions returning rectangles used commonly within various parts of game code |
| `game.rb` | Code for setup the whole game data (Not just user data), Also includes code for gameplay loop and rendering gameplay scene |
| `game_data.rb` | Code for handling game user data (Load, Save, Reset), Also includes logic to reset state for each new gameplay |
| `gui.rb` | Rendering code for parts of the gameplay scene UIs (Rest parts of rendering code are within other files) |
| `input.rb` | Logic code for handling input within game, [drkbd](https://github.com/toffeeframe/drkbd) and [drtouch](https://github.com/toffeeframe/drtouch) where built on portions from this file |
| `leaderboards.rb` | Leaderboards code, Including code for handling user IDs and leaderboards as well as leaderboards menu rendering code |
| `main.rb` | Main Entry, Contains main loop logic and loads rest of game code upon its launching |
| `matching_logic.rb` | Logic code for matching marbles, Also includes functions for rendering clearing traces and lines connecting matches |
| `palettes.rb` | Palettes-related code, Including code for loading and usage of palettes as well as palette menu rendering code |
| `rendering_classes.rb` | Classes used for rendering shapes and sprites by game code, Since classes are fastest for rendering in DragonRuby GTK |
| `scenes.rb` | Rendering code for scenes and menus that their rendering code isn't within other files |
| `special_marbles.rb` | Logic code for special marbles that can be used within gameplay |
| `themes.rb` | Themes-related code, Including code for loading and usage of themes as well as themes menu rendering code |
| `utils.rb` | Utility functions for various things |
| `yell.rb` | Logic and rendering code to show yelling texts within gameplay |

Other folders contain fonts (`fonts`) and sounds (`sounds`) and images (`img`) used by the game, For info on their license check out `doc/3rd_party.txt`.

It worth mentioning that one of my old friends on Discord contributed with a design for one of the game themes and his name can be seen within code of
`themes.rb`, Thanking him to this day if he still remembers me.

The game was the first of DragonRuby games that did put usage of HTTP requests into practice through leaderboards, It was possible
to find bugs and problems within DragonRuby GTK that [Ryan C. Gordon (@icculus)](https://github.com/icculus) thankfully solved at that time (Bugs from problems of returning broken data
of HTTP requests results to weird sprite rendering bug on Android).

The leaderboards API is RESTFul HTTP and based on one from GitHub that not remembering which one sadly, And hosted by [mooff (@awesomecooking)](https://github.com/awfulcooking) on his site
which supposed even to host games by other developers and so on... Later the site got down so not fearing to share the whole code with even the API key since nothing could be done and leaderboards
data has been lost with the site being down.

The game also allows customization and modding for some of game visuals but this not available for web and mobile builds sadly.
