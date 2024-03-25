#include <metal_stdlib>
using namespace metal;

kernel void clearScreen(texture2d<float, access::write> outTexture [[texture(0)]], uint2 grid [[thread_position_in_grid]])
{
    float4 color = float4(0.0, 0.4, 0.6, 1.0); // Clear image with dark blue
    outTexture.write(color, grid);
}
