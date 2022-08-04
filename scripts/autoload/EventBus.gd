#warning-ignore-all: UNUSED_SIGNAL
extends Node

# Player
signal build_block(data)
signal heart_changed(delta, total)
signal jumping()
signal player_died()
signal shot()

# Inventory
signal bus_collected(data)
signal coin_collected(data)
signal fire_flower_collected(data)
signal fire_flower_refilled(amount)
signal fire_flower_changed(new_value)
signal star_collected(starname, again)

# Enemies
signal enemy_hit_coin()
signal enemy_hit_fireball()
signal enemy_killed()
signal player_attacked(enemy)
signal player_spotted(spotted_by, player)

# Levels
signal level_completed(data)
signal level_started(name)
signal level_changed(to)
signal level_exited()
signal hub_entered()
signal restart_level()

# Audio
# The "stream" key will set the background music and the "playing" will set whenever the music is playing
signal bgm_changed(data)

# UI
# Expects a "visible" boolean key
signal ui_visibility_changed(visible)
signal game_paused(pause_state)

# Scenes
# Expects a "scene" key
signal change_scene(data)
signal game_exit()

# Screenshakes
signal large_screen_shake()
signal medium_screen_shake()
signal small_screen_shake()

# Camera follow
signal cameraF_candidate_spawned()
signal cameraF_update_current_camera()
signal cameraF_reset_camera()
signal cameraF_set_following()
signal cameraF_move_camera_to(x, y)
signal cameraF_change_candidate(step_int)

# Camera limits
signal cameraL_enter_set_area(id)

# Settings
signal crt_filter_toggle(data)
signal volume_changed(data)

# Environmental
signal big_button_pressed(button_id)
signal show_all_portals()

# Notes
signal note_added(name, desc, sprite, spriteScale)
signal notes_opened()
signal notes_closed()
signal notes_updated()
