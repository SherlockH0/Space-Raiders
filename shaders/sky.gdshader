shader_type sky;

uniform float time;
uniform vec3 star_color : source_color = vec3(1.0);
uniform float star_density = 0.002;

float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void fragment() {
    // Convert 3D direction into spherical UV coordinates
    vec3 dir = normalize(DIRECTION);
    vec2 uv = vec2(atan(dir.z, dir.x) / (2.0 * PI) + 0.5, asin(dir.y) / PI + 0.5);

    float noise = rand(uv * 1000.0 + time * 0.01);
    float star = step(1.0 - star_density, noise);
    vec3 color = mix(vec3(0.0), star_color, star);

    SKY_COLOR = color;
}
