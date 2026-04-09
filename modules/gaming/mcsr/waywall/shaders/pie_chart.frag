precision highp float;

varying vec2 f_src_pos;

uniform sampler2D u_texture;

const float threshold = 0.01;
const vec3 pink = vec3(0.882, 0.271, 0.761); // #e145c2
const vec3 orange = vec3(0.914, 0.427, 0.302); // #e96d4d
const vec3 green = vec3(0.271, 0.796, 0.396); // #45cb65

const vec3 entities         = vec3(0.894, 0.275, 0.769);

const vec3 unspecified      = vec3(0.275, 0.808, 0.400);
const vec3 destroyProgress  = vec3(0.800, 0.424, 0.275);
const vec3 prepare          = vec3(0.275, 0.298, 0.275);

const vec3 blockentities    = vec3(0.925, 0.431, 0.306);

void main() {
    vec4 color = texture2D(u_texture, f_src_pos);

    bool is_pink = all(lessThan(abs(color.rgb - pink), vec3(threshold)));
    bool is_orange = all(lessThan(abs(color.rgb - orange), vec3(threshold)));
    bool is_green = all(lessThan(abs(color.rgb - green), vec3(threshold)));

    bool is_blockentities = all(lessThan(abs(color.rgb - blockentities), vec3(threshold)));
    bool is_entities = all(lessThan(abs(color.rgb - entities), vec3(threshold)));
    bool is_unspecified = all(lessThan(abs(color.rgb - unspecified), vec3(threshold)));
    bool is_destroy_progress = all(lessThan(abs(color.rgb - destroyProgress), vec3(threshold)));
    bool is_prepare = all(lessThan(abs(color.rgb - prepare), vec3(threshold)));

    if (is_pink || is_orange || is_green || is_blockentities || is_entities || is_unspecified || is_destroy_progress || is_prepare) {
        gl_FragColor = color;
    } else {
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    }
}

