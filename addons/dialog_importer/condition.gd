extends Resource

"""
A condition used inside dialogs.
"""

# The condition is only true if this is the exact occurence
# this dialog is shown.
export var only_at_occurence: int
# The condition is only true if the player has this item.
export var required_item: String
# A custom method that is called to check if the method is true.
export var custom: String
export var inverted: bool


func _init(data := {}) -> void:
	only_at_occurence = data.get("occurence", 0)
	required_item = data.get("has_item", "")
	custom = data.get("custom", "")
	inverted = data.get("inverted", false)
