#warning-ignore-all: UNUSED_SIGNAL
extends Node

signal jumping(data)
signal coin_collected(data)
signal enemy_killed(data)
signal build_block(data)
signal level_completed(data)
signal level_started(data)

# pauses the game - used by PauseMenu.gd
signal game_paused(data)

## settings signals
# toggles crt filter - emitted by PauseMenu.gd and connected to Main.gd
signal crt_filter_toggle(data)
# self-explanatory - emitted by PauseMenu.gd and connected to Main.gd
signal volume_changed(data)
