extends Node
class_name CatManager

export(PackedScene) var cat_scene = load("res://scenes/friends/Cat.tscn")
export(PackedScene) var cat_manager_scene = load("res://scenes/platformer/characters/player_components/CatManager.tscn")

var cat_nodes := []
var cat_count_key = "CatCount"

onready var _player : Player = get_parent()


func _ready():
	var num_cats = DataStore.get_data_or_null(cat_count_key)
	if num_cats:
		for i in num_cats:
			var cat = cat_scene.instance()
			get_parent().get_parent().add_child(cat)
			cat.set_player(get_parent())
			cat.global_position = get_parent().global_position
	DataStore.set_data_in_dict("PlayerStoredScenes", "CatManager", cat_manager_scene)
	

func get_cat_count():
	return cat_nodes.size()


#Returns the last cat that was added, or the player if this is the first cat. 
#This return value is used to tell a newly added cat what to follow.
func add_cat(cat_node : Node2D) -> Node2D:	
	cat_nodes.append(cat_node)
	DataStore.set_data(cat_count_key, get_cat_count())
	if get_cat_count() == 1:
		return _player
	else:
		return cat_nodes[-2]
	
	
func remove_cat(amount : int = 1):
	amount = min(amount, get_cat_count()) as int
	for i in amount:
		cat_nodes[-i].queue_free()
	cat_nodes.resize(cat_nodes.size() - amount)
	DataStore.set_data(cat_count_key, get_cat_count())
	if get_cat_count() == 0:
		DataStore.remove_data(cat_count_key)
		DataStore.remove_data_in_dict("PlayerStoredScenes", "CatManager")
		queue_free()
