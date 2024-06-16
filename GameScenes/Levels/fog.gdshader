shader_type canvas_item;
render_mode unshaded;

uniform float speed = 1.0;
uniform vec2 scale = vec2(1.0, 1.0);

const float MIN_STAR_COL = 0.9;

// One iteration of one at a time hashing
uint hash(uint x) 
{
    x = x + (x << uint(10));
    x = x ^ (x >>  uint(6));
    x = x + (x <<  uint(3));
    x = x ^ (x >> uint(11));
    x = x = (x << uint(15));
    return x;
}
// A hash for vector3
uint hash2(uvec2 v) 
{ 
	return hash(v.x ^ hash(v.y)); 
}
// A hash for vector3
uint hash3(uvec3 v) 
{ 
	return hash(v.x ^ hash(v.y) ^ hash(v.z)); 
}
// Builds a float from a uint
float floatConstruct(uint m) {
    const uint ieeeMantissa = uint(0x007FFFFF); //  binary32 mantissa bitmask
    const uint ieeeOne = uint(0x3F800000); //  1.0 in IEEE binary32

    m &= ieeeMantissa;                     //  Keep only mantissa bits (fractional part)
    m |= ieeeOne;                          //  Add fractional part to 1.0

    float  f = uintBitsToFloat(m);         //  Range [1:2]
    return f - 1.0;                        //  Range [0:1]
}
// Returns a random float
float rand(float seed) {
// 	return texture(randTexture, fract(vec2(seed) / 300.0)).r;
	return floatConstruct(hash(floatBitsToUint(seed)));
}
// Using the hash, converts a vec2 to a uvec2, hashes it, the returns a float
float rand2(vec2 v) 
{ 
// 	return texture(randTexture, fract(v / 300.0)).r;
	return floatConstruct(hash2(floatBitsToUint(v))); 
}
// Using the hash, converts a vec3 to a uvec3, hashes it, the returns a float
float rand3(vec3 v) {
// 	return texture(randTexture, fract(vec2(v.x + fract(v.z * 10.0), v.y + fract(v.z + 10.0)) / 300.0)).r;
	return floatConstruct(hash3(floatBitsToUint(v))); 
}

float perlinNoise(vec3 vector) 
{
	vec3 square = floor(vector);
	vec3 pos = fract(vector);
	
	vec3 pt1 = vec3(rand3(square) * 2.0 - 1.0, rand3(square + vec3(0.1)) * 2.0 - 1.0, rand3(square - vec3(0.1)) * 2.0 - 1.0);
	vec3 pt2 = vec3(rand3(square + vec3(1.0, 0.0, 0.0)) * 2.0 - 1.0, rand3(square + vec3(1.0, 0.0, 0.0) + vec3(0.1)) * 2.0 - 1.0, rand3(square + vec3(1.0, 0.0, 0.0) - vec3(0.1)) * 2.0 - 1.0);
	vec3 pt3 = vec3(rand3(square + vec3(0.0, 1.0, 0.0)) * 2.0 - 1.0, rand3(square + vec3(0.0, 1.0, 0.0) + vec3(0.1)) * 2.0 - 1.0, rand3(square + vec3(0.0, 1.0, 0.0) - vec3(0.1)) * 2.0 - 1.0);
	vec3 pt4 = vec3(rand3(square + vec3(1.0, 1.0, 0.0)) * 2.0 - 1.0, rand3(square + vec3(1.0, 1.0, 0.0) + vec3(0.1)) * 2.0 - 1.0, rand3(square + vec3(1.0, 1.0, 0.0) - vec3(0.1)) * 2.0 - 1.0);
	vec3 pt5 = vec3(rand3(square + vec3(0.0, 0.0, 1.0)) * 2.0 - 1.0, rand3(square + vec3(0.0, 0.0, 1.0) + vec3(0.1)) * 2.0 - 1.0, rand3(square + vec3(0.0, 0.0, 1.0) - vec3(0.1)) * 2.0 - 1.0);
	vec3 pt6 = vec3(rand3(square + vec3(1.0, 0.0, 1.0)) * 2.0 - 1.0, rand3(square + vec3(1.0, 0.0, 1.0) + vec3(0.1)) * 2.0 - 1.0, rand3(square + vec3(1.0, 0.0, 1.0) - vec3(0.1)) * 2.0 - 1.0);
	vec3 pt7 = vec3(rand3(square + vec3(0.0, 1.0, 1.0)) * 2.0 - 1.0, rand3(square + vec3(0.0, 1.0, 1.0) + vec3(0.1)) * 2.0 - 1.0, rand3(square + vec3(0.0, 1.0, 1.0) - vec3(0.1)) * 2.0 - 1.0);
	vec3 pt8 = vec3(rand3(square + vec3(1.0, 1.0, 1.0)) * 2.0 - 1.0, rand3(square + vec3(1.0, 1.0, 1.0) + vec3(0.1)) * 2.0 - 1.0, rand3(square + vec3(1.0, 1.0, 1.0) - vec3(0.1)) * 2.0 - 1.0);
	
	return 	0.5 + 0.5 * (
				mix(
					mix(
						mix(dot(pt1, pos - vec3(0.0, 0.0, 0.0)), dot(pt2, pos - vec3(1.0, 0.0, 0.0)), smoothstep(0.0, 1.0, pos.x)), 
						mix(dot(pt3, pos - vec3(0.0, 1.0, 0.0)), dot(pt4, pos - vec3(1.0, 1.0, 0.0)), smoothstep(0.0, 1.0, pos.x)), 
						smoothstep(0.0, 1.0, pos.y)
					), 
					mix(
						mix(dot(pt5, pos - vec3(0.0, 0.0, 1.0)), dot(pt6, pos - vec3(1.0, 0.0, 1.0)), smoothstep(0.0, 1.0, pos.x)), 
						mix(dot(pt7, pos - vec3(0.0, 1.0, 1.0)), dot(pt8, pos - vec3(1.0, 1.0, 1.0)), smoothstep(0.0, 1.0, pos.x)), 
						smoothstep(0.0, 1.0, pos.y)
					), 
					smoothstep(0.0, 1.0, pos.z)
				)
			);
}
float fbm(vec3 vector) 
{
	const int OCTAVES = 6;
	const float LACUNARITY = 1.8;
	const float GAIN = 0.5;
	
	float value = 0.0;
	float amplitude = GAIN;
	float normalizer = 0.0;
	
	for (int index = 0; index < OCTAVES; index ++)
	{
		normalizer += amplitude;
		value += amplitude * perlinNoise(vector);
		vector *= LACUNARITY;
		amplitude *= GAIN;
	}
	
	return value / normalizer;
}


void fragment() {
	// Add background nebula
	float nebula = fbm(vec3(100.0 * UV.xy / scale, 0.5 * TIME * speed));
	
	// Assign the colour to the screen
	COLOR = vec4(vec3(1.0), pow(smoothstep(0.0, 1.0, nebula), 2.0) * smoothstep(0.0, 1.0, UV.y));
	
	
}