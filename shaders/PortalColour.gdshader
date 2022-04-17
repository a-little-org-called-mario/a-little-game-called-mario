shader_type canvas_item;

uniform vec4 colour : hint_color;

void fragment() {
	vec4 sprite = texture(TEXTURE, UV);
	
	// Get the average colour. Makes grayscale.
	float avg = (sprite.r + sprite.g + sprite.b) / 3.0f;
	
	// Take the average colour (Grayscale colour) and myltiply it by colour and multiply it by 2 to make brighter.
	COLOR = vec4(avg, avg, avg, sprite.a) * colour * 2.0f;
}