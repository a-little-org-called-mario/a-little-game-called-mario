extends Node
class_name CatManager

var cat_nodes := []

onready var _player : Player = get_parent()

func get_cat_count():
	return cat_nodes.size()


#Returns the last cat that was added, or the player if this is the first cat. 
#This return value is used to tell a newly added cat what to follow.
func add_cat(cat_node : Node2D) -> Node2D:
	cat_nodes.append(cat_node)
	if get_cat_count() == 1:
		return _player
	else:
		return cat_nodes[-2]
	
	
func remove_cat(amount : int = 1):
	amount = min(amount, get_cat_count()) as int
	for i in amount:
		cat_nodes[-i].queue_free()
	cat_nodes.resize(cat_nodes.size() - amount)
	if get_cat_count() == 0:
		queue_free()
