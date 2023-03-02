#Provides a place for other scripts to store data across levels
#If the player restarts the level, the stored data resets to what it was
#when the level was started, unless it was set with survive_level_restart == true
extends Node


var data : Dictionary = {}
var data_on_level_start : Dictionary = {} #Used to reset stored data if the player restarts the level
var data_on_respawn : Dictionary = {} #Reset data on player death


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("level_started", self, "_on_level_started")
	EventBus.connect("restart_level", self, "_on_restart_level")
	EventBus.connect("player_died", self, "_on_player_died")
	
	
func _on_level_started(_name):
	data_on_level_start = data.duplicate(true)
	
	
func _on_restart_level():
	data = data_on_level_start.duplicate(true)
	

func _on_player_died():
	data = data_on_respawn.duplicate(true)
	data_on_level_start = data.duplicate(true)


func set_data(key, value, survive_level_restart = false, survive_respawn = false):
	data[key] = value
	if survive_level_restart:
		data_on_level_start[key] = value
	if survive_respawn:
		data_on_respawn[key] = value
	

func get_data_or_null(key):
	if data.has(key):
		return data[key]
	else:
		return null
		
		
func remove_data(key, survive_level_restart = false, survive_respawn = false):
	data.erase(key)
	if survive_level_restart:
		data_on_level_start.erase(key)
	if survive_respawn:
		data_on_respawn.erase(key)
	
	
func set_data_in_dict(key, inner_key, value, survive_level_restart = false, survive_respawn = false):
	var dict = get_data_or_null(key)
	if !dict:
		set_data(key, {})
		dict = {}
	assert(dict is Dictionary)
	dict[inner_key] = value
	set_data(key, dict, survive_level_restart, survive_respawn)
	
	
func get_data_in_dict(key, inner_key):
	return data[key][inner_key]
	
	
func remove_data_in_dict(key, inner_key, survive_level_restart = false, survive_respawn = false):
	var dict = get_data_or_null(key)
	if !dict:
		push_error("DataStore.data[%s] does not exist." % key)
	else:
		assert(dict is Dictionary)
		dict.erase(inner_key)
		set_data(key, dict, survive_level_restart, survive_respawn)

