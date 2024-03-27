#include <metal_stdlib>
using namespace metal;

kernel void clearScreen(texture2d<float, access::write> outTexture [[texture(0)]], uint2 grid [[thread_position_in_grid]])
{
    float4 color = float4(0.0, 0.4, 0.6, 1.0); // Clear image with dark blue
    outTexture.write(color, grid);
}

struct Ray {
    float3 origin;
    float3 direction;
};

struct Sphere {
    float3 center;
    float radius;
};

struct Intersection {
    float3 position;
    float3 normal;
    float t;
};

kernel void intersectionTest(
    device Ray* rays [[ buffer(0) ]],
    device Sphere* spheres [[ buffer(1) ]],
    texture2d<float, access::write> outTexture [[texture(2)]],
    uint2 gid [[thread_position_in_grid]])
{
    Ray ray = rays[gid.y * outTexture.get_width() + gid.x];
    Sphere sphere = spheres[0]; // Just use the first sphere to start
    float4 color = float4(0.0, 0.0, 1.0, 1.0); // Default blue
    
    float3 oc = ray.origin - sphere.center;
    float a = dot(ray.direction, ray.direction);
    float b = 2.0 * dot(oc, ray.direction);
    float c = dot(oc, oc) - sphere.radius * sphere.radius;
    float discriminant = b * b - 4 * a * c;

    if (discriminant > 0) {
        float t = (-b - sqrt(discriminant)) / (2.0 * a);
        if (t > 0) {
            // Hit the sphere, change color to red
            color = float4(1.0, 0.0, 0.0, 1.0);
        }
    }

    outTexture.write(color, gid);
}
