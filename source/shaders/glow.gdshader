shader_type canvas_item;

uniform float bloomRadius = 0.1;
uniform float bloomThreshold = 0.5;
uniform float bloomIntensity = 0.1;

uniform vec3 bg_color = vec3(0.302, 0.302, 0.302);
uniform float bg_epsilon = 0.01;

float bgMask(vec3 rgb) {
    // 0.0 if it's background, 1.0 otherwise
    return (distance(rgb, bg_color) <= bg_epsilon) ? 0.0 : 1.0;
}

vec3 GetBloomPixel(sampler2D tex, vec2 uv, vec2 texPixelSize) {
    vec2 uv2 = floor(uv / texPixelSize) * texPixelSize;
    uv2 += texPixelSize * 0.001;

    vec3 c0 = texture(tex, uv2).rgb;
    vec3 c1 = texture(tex, uv2 + vec2(texPixelSize.x, 0.0)).rgb;
    vec3 c2 = texture(tex, uv2 + vec2(0.0, texPixelSize.y)).rgb;
    vec3 c3 = texture(tex, uv2 + vec2(texPixelSize.x, texPixelSize.y)).rgb;

    // Ignore background before thresholding
    c0 *= bgMask(c0); c1 *= bgMask(c1); c2 *= bgMask(c2); c3 *= bgMask(c3);

    vec3 tl = max(c0 - bloomThreshold, 0.0);
    vec3 tr = max(c1 - bloomThreshold, 0.0);
    vec3 bl = max(c2 - bloomThreshold, 0.0);
    vec3 br = max(c3 - bloomThreshold, 0.0);

    vec2 f = fract( uv / texPixelSize );

    vec3 tA = mix(tl, tr, f.x);
    vec3 tB = mix(bl, br, f.x);
    return mix(tA, tB, f.y);
}

vec3 GetBloom(sampler2D tex, vec2 uv, vec2 texPixelSize) {
    vec3 bloom = vec3(0.0);
    vec2 off = vec2(1) * texPixelSize * bloomRadius;

    bloom += GetBloomPixel(tex, uv + off * vec2(-1, -1), texPixelSize * bloomRadius) * 0.292893;
    bloom += GetBloomPixel(tex, uv + off * vec2(-1,  0), texPixelSize * bloomRadius) * 0.5;
    bloom += GetBloomPixel(tex, uv + off * vec2(-1,  1), texPixelSize * bloomRadius) * 0.292893;
    bloom += GetBloomPixel(tex, uv + off * vec2( 0, -1), texPixelSize * bloomRadius) * 0.5;
    bloom += GetBloomPixel(tex, uv + off * vec2( 0,  0), texPixelSize * bloomRadius) * 1.0;
    bloom += GetBloomPixel(tex, uv + off * vec2( 0,  1), texPixelSize * bloomRadius) * 0.5;
    bloom += GetBloomPixel(tex, uv + off * vec2( 1, -1), texPixelSize * bloomRadius) * 0.292893;
    bloom += GetBloomPixel(tex, uv + off * vec2( 1,  0), texPixelSize * bloomRadius) * 0.5;
    bloom += GetBloomPixel(tex, uv + off * vec2( 1,  1), texPixelSize * bloomRadius) * 0.292893;

    bloom /= 4.171573;
    return bloom;
}

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    vec3 bloom = GetBloom(TEXTURE, UV, TEXTURE_PIXEL_SIZE);

    // Add bloom
    col.rgb += bloom * bloomIntensity;
    COLOR = col;
}
