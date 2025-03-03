shader_type canvas_item;

uniform vec2 direction = vec2(0.0, -1.0); // Default: top to bottom
uniform float height = 100.0; // Gradient height in pixels
uniform float blur_amount : hint_range(0, 5);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float offset = 0.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 pixel_size = SCREEN_PIXEL_SIZE;
    
    // Calculate position in view space
    vec2 view_pos = UV * (1.0 / pixel_size);
    
    // Calculate distance along the gradient direction
    vec2 grad_dir = normalize(direction);
    float d = dot(view_pos, grad_dir) + offset;
	
    
    // Normalize the distance based on the height
    float t = clamp(d / height, 0.0, 1.0);
    
    // Sample the screen with increasing blur based on gradient position
    vec4 color = textureLod(SCREEN_TEXTURE, uv, blur_amount * t/1.3);
    
    // Blend with black based on gradient position
    //color.rgb = mix(color.rgb, vec3(0.0), uv.y * 1.2);
	color.rgb = mix(color.rgb, vec3(0.0), t/1.3);
    
    // Apply alpha
    color.a = 1.0;
    
    COLOR = color;
}
