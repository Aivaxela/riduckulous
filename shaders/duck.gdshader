shader_type canvas_item;

uniform vec4 outline_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float threshold = 0.1;

void fragment() {
    vec2 texel_size = TEXTURE_PIXEL_SIZE; // This works in canvas_item shaders

    float alpha_center = texture(TEXTURE, UV).a;

    float alpha_up        = texture(TEXTURE, UV + vec2(0.0, -texel_size.y)).a;
    float alpha_down      = texture(TEXTURE, UV + vec2(0.0,  texel_size.y)).a;
    float alpha_left      = texture(TEXTURE, UV + vec2(-texel_size.x, 0.0)).a;
    float alpha_right     = texture(TEXTURE, UV + vec2( texel_size.x, 0.0)).a;
    float alpha_up_left   = texture(TEXTURE, UV + vec2(-texel_size.x, -texel_size.y)).a;
    float alpha_up_right  = texture(TEXTURE, UV + vec2( texel_size.x, -texel_size.y)).a;
    float alpha_down_left = texture(TEXTURE, UV + vec2(-texel_size.x,  texel_size.y)).a;
    float alpha_down_right= texture(TEXTURE, UV + vec2( texel_size.x,  texel_size.y)).a;

    bool outline = alpha_center < threshold && (
        alpha_up > threshold || alpha_down > threshold ||
        alpha_left > threshold || alpha_right > threshold ||
        alpha_up_left > threshold || alpha_up_right > threshold ||
        alpha_down_left > threshold || alpha_down_right > threshold
    );

    if (outline) {
        COLOR = outline_color;
    } else {
        COLOR = texture(TEXTURE, UV);
    }
}
