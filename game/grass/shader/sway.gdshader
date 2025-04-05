shader_type canvas_item;
uniform float speed = .5;
uniform float dist = 15.0;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453123); 
}

float noise(vec2 x) {
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    vec2 a = vec2(1.0, 0.0);
    return mix(mix(hash(p + a.yy), hash(p + a.xy), f.x), mix(hash(p + a.yx), hash(p + a.xx), f.x), f.y);
}

float noisef(float x) {
	return noise(vec2(x, x));
}

void vertex() {
	VERTEX.x += dist * (2. * noisef(TIME * speed) - 1.) * (UV.y - 1.0);
}
