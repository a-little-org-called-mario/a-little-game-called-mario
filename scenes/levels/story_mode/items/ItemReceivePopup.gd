extends AcceptDialog

onready var _item_texture_rect: TextureRect = $VBoxContainer/ItemTextureRect
onready var _item_title_label: Label = $VBoxContainer/ItemTitleLabel

func show_for(item: StoryItem):
	_item_texture_rect.texture = item.texture
	_item_title_label.text = item.name
	popup()
