import Metal

struct Ray {
    var origin: SIMD3<Float>
    var direction: SIMD3<Float>
}

extension MetalContext {
    func makeRayBuffer(rays: [Ray]) -> MTLBuffer? {
        return device.makeBuffer(bytes: rays, length: rays.count * MemoryLayout<Ray>.stride, options: [])
    }
}
