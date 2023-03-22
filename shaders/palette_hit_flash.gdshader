shader_type canvas_item;

uniform vec4 flash_color: hint_color = vec4(1.0);
uniform float flash_modifier: hint_range(0.0, 1.0) = 0;

uniform sampler2D palette;
//GLES2 does not have textureSize(), sad
uniform int palette_width;

void fragment() {
	//order of operations
	vec4 buffer = texture(TEXTURE, UV);
	vec4 color = texture(palette, vec2((buffer.r*255.0)/float(palette_width), 0.0));
	color.a = buffer.a;
	color.rgb = mix(color.rgb, flash_color.rgb, flash_modifier);
	COLOR = color;
}