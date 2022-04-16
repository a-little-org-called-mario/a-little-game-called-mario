extends Control

var _items := []

onready var _item_texture_rect: TextureRect = $VBoxContainer/ItemTextureRect
onready var _item_list: ItemList = $VBoxContainer/ItemList
onready var _rich_text_label: RichTextLabel = $VBoxContainer/RichTextLabel
onready var _item_name_label: Label = $VBoxContainer/ItemNameLabel

func give(item):
	_items.append(item)
	_item_list.add_item(item.name, item.texture)
	_item_list.set_item_metadata(_item_list.get_item_count() - 1, item)


func take(item: StoryItem):
	_item_list.remove_item(_items.find(item))
	_items.erase(item)


func has(item: StoryItem) -> bool:
	return item in _items


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("toggle_inventory"):
		visible = not visible


func _on_ItemList_item_selected(index: int) -> void:
	var item: StoryItem = _item_list.get_item_metadata(index)
	_rich_text_label.text = item.description
	_item_name_label.text = item.name
	_item_texture_rect.texture = item.texture
