//SHADER ORIGINALY CREADED BY \"TimothyLottes\" FROM SHADERTOY
//PORTED AND MODIFYED TO GODOT BY AHOPNESS (@ahopness)
//LICENSE : CC0
//COMATIBLE WITH : GLES2, GLES3, WEBGL
//SHADERTOY LINK : https://www.shadertoy.com/view/MsjXzh

// PUBLIC DOMAIN CRT STYLED SCAN-LINE SHADER
//
//   by Timothy Lottes
//
// This is more along the style of a really good CGA arcade monitor.
// With RGB inputs instead of NTSC.
// The shadow mask example has the mask rotated 90 degrees for less chromatic aberration.
//
// Left it unoptimized to show the theory behind the algorithm.
//
// It is an example what I personally would want as a display option for pixel art games.
// Please take and use, change, or whatever.

shader_type canvas_item;

// Emulated input resolution.
uniform vec2 res;

// Mask type
//  0 = Very compressed TV style shadow mask
//  1 = Stretched VGA style shadow mask (same as prior shaders)
//  2 = VGA style shadow mask 
uniform int mask_type :hint_range(0, 2) = 0;

// Bloom Type
//  0 = Normalized exposure
//  1 = Aditive bloom
//  2 = No Bloom
uniform int bloom_type :hint_range(0, 2) = 0;

// Hardness of scanline.
//  -8.0 = soft
// -16.0 = medium
uniform float hardScan :hint_range(-12.0, -1.0) = -8.0;

// Hardness of pixels in scanline.
// -2.0 = soft
// -4.0 = hard
uniform float hardPix :hint_range(-4.0, 0.0) = -2.0;

// Hardness of short vertical bloom.
//  -1.0 = wide to the point of clipping (bad)
//  -1.5 = wide
//  -4.0 = not very wide at all
uniform float hardBloomScan :hint_range(-4.0, 0.0) = -2.0;

// Hardness of short horizontal bloom.
//  -0.5 = wide to the point of clipping (bad)
//  -1.0 = wide
//  -2.0 = not very wide at all
uniform float hardBloomPix :hint_range(-2.0, 0.0) = -1.5;

// Amount of small bloom effect.
//  1.0/1.0 = only bloom
//  1.0/16.0 = what I think is a good amount of small bloom
//  0.0     = no bloom
uniform float bloomAmount :hint_range(1.0, 16.0) = 16.0;

// Display warp.
// 0.0 = none
// 1.0/8.0 = extreme
uniform vec2 warp = vec2(64.0, 24.0); 

// Amount of shadow mask.
uniform float maskDark  :hint_range(0.0, 1.0) = 0.5;
uniform float maskLight :hint_range(1.0, 2.0) = 1.5;

//------------------------------------------------------------------------

// sRGB to Linear.
// Assuing using sRGB typed textures this should not be needed.
float ToLinear1(float c){ return(c <= 0.04045) ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4); }
vec3 ToLinear(vec3 c){ return vec3(ToLinear1(c.r), ToLinear1(c.g), ToLinear1(c.b)); }

// Linear to sRGB.
// Assuing using sRGB typed textures this should not be needed.
float ToSrgb1(float c){ return(c < 0.0031308?c * 12.92 : 1.055 * pow(c, 0.41666) - 0.055); }
vec3 ToSrgb(vec3 c){ return vec3(ToSrgb1(c.r), ToSrgb1(c.g), ToSrgb1(c.b)); }

// Nearest emulated sample given floating point position and texel offset.
// Also zero's off screen.
vec3 Fetch(vec2 pos, vec2 off, sampler2D iChannel0){
	pos = floor(pos * res + off) / res;
	
	if(max(abs(pos.x - 0.5), abs(pos.y - 0.5)) > 0.5){
		return vec3(0.0, 0.0, 0.0);
	}
	
	return ToLinear(texture(iChannel0 , pos.xy , -16.0).rgb);
}

// Distance in emulated pixels to nearest texel.
vec2 Dist(vec2 pos){ 
	pos = pos * res; 
	return - ((pos - floor(pos)) - vec2(0.5));
}
    
// 1D Gaussian.
float Gaus(float pos, float scale){ return exp2(scale * pos * pos); }

// 3-tap Gaussian filter along horz line.
vec3 Horz3(vec2 pos, float off, sampler2D iChannel0){
	vec3 b = Fetch(pos, vec2(-1.0, off), iChannel0);
	vec3 c = Fetch(pos, vec2( 0.0, off), iChannel0);
	vec3 d = Fetch(pos, vec2( 1.0, off), iChannel0);
	float dst = Dist(pos).x;
	
	// Convert distance to weight.
	float scale = hardPix;
	float wb = Gaus(dst - 1.0, scale);
	float wc = Gaus(dst + 0.0, scale);
	float wd = Gaus(dst + 1.0, scale);
	
	// Return filtered sample.
	return (b * wb + c * wc + d * wd) / (wb + wc + wd);
}
// 5-tap Gaussian filter along horz line.
vec3 Horz5(vec2 pos, float off, sampler2D iChannel0){
	vec3 a = Fetch(pos, vec2(-2.0, off), iChannel0);
	vec3 b = Fetch(pos, vec2(-1.0, off), iChannel0);
	vec3 c = Fetch(pos, vec2( 0.0, off), iChannel0);
	vec3 d = Fetch(pos, vec2( 1.0, off), iChannel0);
	vec3 e = Fetch(pos, vec2( 2.0, off), iChannel0);
	float dst = Dist(pos).x;
	
	// Convert distance to weight.
	float scale = hardPix;
	float wa = Gaus(dst - 2.0, scale);
	float wb = Gaus(dst - 1.0, scale);
	float wc = Gaus(dst + 0.0, scale);
	float wd = Gaus(dst + 1.0, scale);
	float we = Gaus(dst + 2.0, scale);
	
	// Return filtered sample.
	return (a * wa + b * wb + c * wc + d * wd + e * we) / (wa + wb + wc + wd + we);
}
// 7-tap Gaussian filter along horz line.
vec3 Horz7(vec2 pos, float off, sampler2D iChannel0){
	vec3 a = Fetch(pos, vec2(-3.0, off), iChannel0);
	vec3 b = Fetch(pos, vec2(-2.0, off), iChannel0);
	vec3 c = Fetch(pos, vec2( 1.0, off), iChannel0);
	vec3 d = Fetch(pos, vec2( 0.0, off), iChannel0);
	vec3 e = Fetch(pos, vec2( 1.0, off), iChannel0);
	vec3 f = Fetch(pos, vec2( 2.0, off), iChannel0);
	vec3 g = Fetch(pos, vec2( 3.0, off), iChannel0);
	float dst = Dist(pos).x;
	
	// Convert distance to weight.
	float scale = hardBloomPix;
	float wa = Gaus(dst - 3.0, scale);
	float wb = Gaus(dst - 2.0, scale);
	float wc = Gaus(dst - 1.0, scale);
	float wd = Gaus(dst + 0.0, scale);
	float we = Gaus(dst + 1.0, scale);
	float wf = Gaus(dst + 2.0, scale);
	float wg = Gaus(dst + 3.0, scale);
	
	// Return filtered sample.
	return (a * wa + b * wb + c * wc + d * wd + e * we + f * wf + g * wg) / (wa + wb + wc + wd + we + wf + wg);
}

// Return scanline weight.
float Scan(vec2 pos, float off){
	float dst = Dist(pos).y;
	
	return Gaus(dst + off, hardScan);
}

// Return scanline weight for bloom.
float BloomScan(vec2 pos, float off){
	float dst = Dist(pos).y;
	
	return Gaus(dst + off, hardBloomScan);
}

// Allow nearest three lines to effect pixel.
vec3 Tri(vec2 pos, sampler2D iChannel0){
	vec3 a = Horz3(pos,-1.0, iChannel0);
	vec3 b = Horz5(pos, 0.0, iChannel0);
	vec3 c = Horz3(pos, 1.0, iChannel0);
	
	float wa = Scan(pos,-1.0);
	float wb = Scan(pos, 0.0);
	float wc = Scan(pos, 1.0);
	
	return a * wa + b * wb + c * wc;
}

// Small bloom.
vec3 Bloom(vec2 pos, sampler2D iChannel0){
	vec3 a = Horz5(pos,-2.0, iChannel0);
	vec3 b = Horz7(pos,-1.0, iChannel0);
	vec3 c = Horz7(pos, 0.0, iChannel0);
	vec3 d = Horz7(pos, 1.0, iChannel0);
	vec3 e = Horz5(pos, 2.0, iChannel0);
	
	float wa = BloomScan(pos,-2.0);
	float wb = BloomScan(pos,-1.0);
	float wc = BloomScan(pos, 0.0);
	float wd = BloomScan(pos, 1.0);
	float we = BloomScan(pos, 2.0);
	
	return a * wa + b * wb + c * wc + d * wd + e * we;
}

// Distortion of scanlines, and end of screen alpha.
vec2 Warp(vec2 pos){
	pos = pos * 2.0 - 1.0;    
	pos *= vec2(1.0 + (pos.y * pos.y) * 1.0 / warp.x, 1.0 + (pos.x * pos.x) * 1.0/ warp.y);
	
	return pos * 0.5+0.5;
}

vec3 Mask(vec2 pos){
	if (mask_type == 0){
		float line = maskLight;
		float odd = 0.0;
		
		if(fract(pos.x / 6.0) < 0.5) odd = 1.0;
		if(fract((pos.y + odd) / 2.0) < 0.5) line = maskDark;  
		pos.x = fract(pos.x / 3.0);
		
		vec3 mask = vec3(maskDark, maskDark, maskDark);
		if(pos.x < 0.333)mask.r = maskLight;
		else if(pos.x < 0.666)mask.g = maskLight;
		else mask.b = maskLight;
		
		mask *= line;
		return mask;
	}else if (mask_type == 1){
		pos.x += pos.y * 3.0;
		
		vec3 mask = vec3(maskDark, maskDark, maskDark);
		pos.x = fract(pos.x / 6.0);
		if(pos.x < 0.333)mask.r = maskLight;
		else if(pos.x < 0.666)mask.g = maskLight;
		else mask.b = maskLight;
		
		return mask;
	}else if (mask_type == 2){
		pos.xy = floor(pos.xy * vec2(1.0, 0.5));
		pos.x += pos.y * 3.0;
		
		vec3 mask = vec3(maskDark, maskDark, maskDark);
		pos.x = fract(pos.x / 6.0);
		if(pos.x < 0.333)mask.r = maskLight;
		else if(pos.x < 0.666)mask.g = maskLight;
		else mask.b = maskLight;
	
		return mask;
	}
  }    

// Draw dividing bars.
float Bar(float pos, float bar){ pos -= bar; return pos * pos < 4.0 ? 0.0 : 1.0; }

// Entry.
void fragment(){
	vec2 coord = UV*res;
	vec2 pos = Warp(coord.xy / (1.0 / TEXTURE_PIXEL_SIZE).xy);
	
	COLOR.rgb = Tri(pos, TEXTURE) * Mask(coord.xy);
	if (bloom_type == 0){ 
		COLOR.rgb = mix(COLOR.rgb,Bloom(pos, TEXTURE), 1.0 / bloomAmount);    
	}else if (bloom_type == 1){
		COLOR.rgb += Bloom(pos, TEXTURE) * 1.0 / bloomAmount;    
	} 
	
	COLOR.a = 1.0;  
	COLOR.rgb = ToSrgb(COLOR.rgb);
}