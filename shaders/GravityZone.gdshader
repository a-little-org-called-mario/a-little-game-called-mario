shader_type canvas_item;

uniform float speed = 0.8;
uniform float direction = 1.0;

void fragment()
{
	float dir = -direction;
	vec2 uv = UV + vec2(0, TIME * dir * speed);
	if (dir > 0.0)
		uv = 1.0 - uv;
	COLOR = texture(TEXTURE, 1.0 - uv);
}