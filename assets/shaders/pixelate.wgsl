#import bevy_core_pipeline::fullscreen_vertex_shader::FullscreenVertexOutput

@group(0) @binding(0) var screen_texture: texture_2d<f32>;
@group(0) @binding(1) var texture_sampler: sampler;
struct PostProcessSettings {
    intensity: f32,
    #ifdef SIXTEEN_BYTE_ALIGNMENT
        _webgl2_padding: vec3<f32> // WebGL2 structs must be 16 byte aligned.
    #endif
}
@group(0) @binding(2) var<uniform> settings: PostProcessSettings;

@fragment
fn fragment(in: FullscreenVertexOutput) -> @location(0) vec4<f32> {
    // Pixelate effect size
    let pixelate_size = 178.0;

    // Calculate the size of each cell
    let cell_size = 1.0 / pixelate_size;

    // Calculate the position of the current cell
    let cell_position = floor(in.uv * pixelate_size) / pixelate_size;

    // Calculate the center of the current cell
    let cell_center = cell_position + cell_size / 2.0;

    // Sample the color from the center of the cell
    let color = textureSample(screen_texture, texture_sampler, cell_center);

    return color;
}