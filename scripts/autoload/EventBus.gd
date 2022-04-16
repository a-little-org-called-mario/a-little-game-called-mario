#warning-ignore-all: UNUSED_SIGNAL
extends Node

signal jumping(data)
signal coin_collected(data)
signal star_collected(data)
signal star_collected_again(data)
signal heart_changed(data)
signal shot()
signal enemy_killed(data)
signal build_block(data)
signal level_completed(data)
signal level_started(data)
signal player_died

# The "stream" key will set the background music and
# the "playing" will set whenever the music is playing
signal bgm_changed(data)

# Expects a "visible" boolean key
signal ui_visibility_changed(data)

# Scene Transitions, expects "scene" key
signal change_scene(data)

# screenshakes
signal small_screen_shake
signal medium_screen_shake
signal large_screen_shake

# pauses the game - used by PauseMenu.gd
signal game_paused(data)
# called once on game ends (or is restarted)
signal game_exit

## settings signals
signal crt_filter_toggle(data)
signal volume_changed(data)

signal enemy_hit_coin
signal enemy_hit_fireball

signal fire_flower_collected(data)
signal bus_collected(data)

signal player_spotted(spotted_by, player)

signal big_button_pressed(button_id)
