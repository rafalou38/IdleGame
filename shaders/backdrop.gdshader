shader_type canvas_item;

uniform float blur_amount : hint_range(0, 5);
uniform float alpha : hint_range(0, 1);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 uv = SCREEN_UV;

    // Sample the screen with increasing blur
    vec4 color = textureLod(SCREEN_TEXTURE, uv, blur_amount);

    // Blend with black
	color.rgb = mix(color.rgb, vec3(0.0), alpha);

    // Apply alpha
    color.a = 1.0;
	
    COLOR = color;
}
