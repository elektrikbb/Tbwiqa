shader_type canvas_item;

uniform float edge_blur_amount : hint_range(0.0, 1.0, 0.01);
uniform vec3 color : source_color;

// Blinking control
uniform float blink_speed : hint_range(0.0, 10.0, 0.01) = 6.0;

// Eye opening: amount at fully-open
uniform float open_amount : hint_range(0.0, 1.0, 0.01) = 1.0;

// Closing limit: how far it can close (0 = fully closed)
uniform float close_limit : hint_range(0.0, 1.0, 0.01) = 0.;

void fragment() {
    float blur = edge_blur_amount * 0.5;

    // blink waveform:
    // - when "open": value ~ 1
    // - when "closed": value ~ 0
    float wave = (sin(TIME * blink_speed) * 0.5 + 0.5);

    // Map to open/closed range, then clamp.
    // Fully open = open_amount
    // Fully closed = close_limit
    float v0 = mix(close_limit, open_amount, wave);
    float v = v0 + edge_blur_amount * v0;

    float d1 = (2.0 * v * pow(UV.x - 0.5, 2.0) - v/2.0 + 0.5) - (UV.y + v/(2.0));
    float d2 = -(-2.0 * v * pow(UV.x - 0.5, 2.0) + v/2.0 + 0.5) + (UV.y - v/(2.0));
    float d = max(d1, d2);

    vec4 base = COLOR;
    if (d > -blur) {
        COLOR = mix(base, vec4(color, (-d - blur) / -blur), 0.8);
    } else {
        COLOR = base;
    }
}
