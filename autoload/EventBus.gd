#warning-ignore-all: UNUSED_SIGNAL
extends Node

signal jumping(data)
signal coin_collected(data)
signal heart_changed(data)
signal enemy_killed(data)
signal build_block(data)
signal level_completed(data)
signal level_started(data)

# called once on game start
signal initial_startup()

# Scene Transitions, expects "scene" key
signal change_scene(data)

# pauses the game - used by PauseMenu.gd
signal game_paused(data)

## settings signals
# toggles crt filter - emitted by PauseMenu.gd and connected to Main.gd
signal crt_filter_toggle(data)
# self-explanatory - emitted by PauseMenu.gd and connected to Main.gd
signal volume_changed(data)

signal enemy_hit_coin
signal enemy_hit_fireball

signal fire_flower_collected(data)
signal bus_collected(data)
