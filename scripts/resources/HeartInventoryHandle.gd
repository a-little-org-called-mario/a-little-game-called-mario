# Attach this as a scene child to your player enable coin collecion
extends BaseInventoryHandle
class_name HeartInventoryHandle


func change_hearts(delta: int) -> bool:
	delta = clamp(delta, -inventory.hearts, inventory.max_hearts - inventory.hearts)
	if delta == 0:
		return true
	inventory.hearts += delta
	EventBus.emit_signal("heart_changed", delta, inventory.hearts)
	return true


# Try to find an inventory on the node + children and change the hearts. Returns true when successful.
static func change_hearts_on(node: Node2D, heart_delta: int) -> bool:
	# operator 'is' has a bug and causes dependency cycle, use 'as' instead
	if node as HeartInventoryHandle:
		return node.change_hearts(heart_delta)

	for child in node.get_children():
		if child as HeartInventoryHandle:
			return child.change_hearts(heart_delta)
	return false
