extends Sprite
export(Vector2) var scroll_rate := Vector2(-10, -10)

func _process(delta):
  # This is what makes it scroll
  set_region_rect(Rect2(region_rect.position + scroll_rate * delta, region_rect.size))
