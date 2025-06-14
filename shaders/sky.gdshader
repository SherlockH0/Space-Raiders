shader_type sky;

uniform sampler2D skyTexture : source_color, filter_linear, hint_default_black;

void sky() {
	if (AT_CUBEMAP_PASS) {
		COLOR = vec3(0.2, 0.6, 1.0);
	} else {
		COLOR = texture(skyTexture, SKY_COORDS).rgb;
	}
}