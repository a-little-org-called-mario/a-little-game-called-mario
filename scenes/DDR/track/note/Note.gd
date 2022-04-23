extends Sprite

var target_pos
var target_tick

var init_pos
var init_tick

func set_tick(tick):
	var weight = (tick - init_tick) / float(target_tick - init_tick)
	position.y = lerp(init_pos, target_pos, weight)
	if weight > 1:
		get_parent().disconnect("set_tick", self, "set_tick")
		queue_free()
