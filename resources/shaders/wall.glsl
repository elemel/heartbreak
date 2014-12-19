uniform vec2 textureSize = vec2(1.0, 1.0);
uniform vec4 shadowColor = vec4(0.0, 0.0, 0.0, 0.5);

vec4 effect(vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords) {
    vec2 texelCoords = textureCoords * textureSize;
    vec2 integral = floor(texelCoords - 0.5) + 0.5;
    vec2 fraction = texelCoords - integral;

    vec2 stepRadius = max(abs(dFdx(texelCoords)), abs(dFdy(texelCoords)));
    vec2 stepFraction = smoothstep(0.5 - stepRadius, 0.5 + stepRadius, fraction);
    vec2 stepTextureCoords = (integral + stepFraction) / textureSize;
    vec4 textureColor = Texel(texture, stepTextureCoords);

    vec2 shadowStepFraction = smoothstep(0.0, 1.0, fraction);
    vec2 shadowStepTextureCoords = (integral + shadowStepFraction) / textureSize;
    vec4 textureShadowColor = Texel(texture, shadowStepTextureCoords);

    vec4 combinedColor = textureColor * vec4(color.rgb * color.a, color.a);
    vec4 combinedShadowColor =  shadowColor * color.a * textureShadowColor.a;
    return combinedColor + (1.0 - combinedColor.a) * combinedShadowColor;
}
