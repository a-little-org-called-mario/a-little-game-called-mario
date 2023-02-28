extends Node
class_name CatManager

export(PackedScene) var cat_scene = load("res://scenes/friends/Cat.tscn")
export(PackedScene) var cat_manager_scene = load("res://scenes/platformer/characters/player_components/CatManager.tscn")
export(PackedScene) var scaredy_cat_scene = load("res://scenes/friends/ScaredyCat.tscn")

export(Vector2) var min_scatter_velocity = Vector2(200, -20)
export(Vector2) var max_scatter_velocity = Vector2(300, -300)

var cat_nodes := []
var cat_count_key = "CatCount"

onready var _player : Player = get_parent()


func _ready():
	EventBus.connect("heart_changed", self, "_on_Player_heart_changed")
	
	var num_cats = DataStore.get_data_or_null(cat_count_key)
	if num_cats:
		for i in num_cats:
			var cat = cat_scene.instance()
			get_parent().get_parent().add_child(cat)
			cat.set_player(get_parent())
			cat.global_position = get_parent().global_position
	DataStore.set_data_in_dict("PlayerStoredScenes", "CatManager", cat_manager_scene)
	

func get_cat_count() -> int:
	return cat_nodes.size()
	
	
func _on_Player_heart_changed(delta, _total):
	if delta < 0:
		scatter()


#Returns the last cat that was added, or the player if this is the first cat. 
#This return value is used to tell a newly added cat what to follow.
func add_cat(cat_node : Node2D) -> Node2D:
	cat_nodes.append(cat_node)
	DataStore.set_data(cat_count_key, get_cat_count())
	if get_cat_count() == 1:
		return _player
	else:
		return cat_nodes[-2]
	
	
func remove_cat(amount : int = 1) -> void:
	amount = min(amount, get_cat_count()) as int
	for i in range(1, amount+1):
		cat_nodes[-i].queue_free()
	cat_nodes.resize(cat_nodes.size() - amount)
	DataStore.set_data(cat_count_key, get_cat_count())
	if get_cat_count() == 0:
		DataStore.remove_data(cat_count_key)
		DataStore.remove_data_in_dict("PlayerStoredScenes", "CatManager")
		queue_free()
		
		
func scatter() -> void:
	var count := get_cat_count()
	remove_cat(count)
	for i in count:
		var cat : Node2D = scaredy_cat_scene.instance()
		cat.velocity.x = rand_range(min_scatter_velocity.x, max_scatter_velocity.x)
		cat.velocity.y = rand_range(min_scatter_velocity.y, max_scatter_velocity.y)
		if randf() > 0.5: #Has an equal chance to run either left or right
			cat.velocity.x *= -1
		cat.global_position = _player.global_position
		_player.get_parent().call_deferred("add_child", cat)
	
