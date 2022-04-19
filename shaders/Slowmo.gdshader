shader_type canvas_item;

uniform float mixAmt = 0.0f;

void fragment() {
	vec4 normTex = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	vec2 wave = vec2(
		sin(TIME * 7.0f + SCREEN_UV.y * 128.0f) / 1024.0f,
		0
	);
	vec4 tex = texture(SCREEN_TEXTURE, SCREEN_UV + wave);
	
	float avg = (tex.r + tex.g + tex.b) / 3.0f;
	vec4 blueish = vec4(avg, avg, avg, 1.0f) * vec4(0.1f, 0.1f, 1.0f, 1.0f);
	
	
	COLOR = mix(normTex, mix(tex, blueish, 0.2) * 1.5f, mixAmt);
}