import Metal

class MetalRenderer {
    let context: MetalContext
    var computePipelineState: MTLComputePipelineState?
    var outputTexture: MTLTexture?

    init(context: MetalContext) {
        self.context = context
        setupComputePipeline()
    }

    private func setupComputePipeline() {
        let computeFunction = context.device.makeDefaultLibrary()?.makeFunction(name: "intersectionTest")
        do {
            computePipelineState = try context.device.makeComputePipelineState(function: computeFunction!)
        } catch let error {
            fatalError("Failed to create compute pipeline state: \(error)")
        }
    }
    
    func makeOutputTexture(size: CGSize) -> MTLTexture? {
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: .rgba32Float,
            width: Int(size.width),
            height: Int(size.height),
            mipmapped: false
        )
        descriptor.usage = [.shaderWrite, .shaderRead]
        return context.device.makeTexture(descriptor: descriptor)
    }
    
    func saveTextureToImage(texture: MTLTexture) {
        let bytesPerPixel = 4 * MemoryLayout<Float>.size // 16 bytes for RGBA32Float
        let bytesPerRow = texture.width * bytesPerPixel
        var data = [Float](repeating: 0, count: texture.width * texture.height * 4)
        let region = MTLRegionMake2D(0, 0, texture.width, texture.height)
        texture.getBytes(&data, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
        
        // Scale and clamp the Float values to the range [0, 255]
        let scaledData = data.map { value -> UInt8 in
            let scaled = max(0, min(255, Int(value * 255)))
            return UInt8(scaled)
        }
        
        // Use ImageSaver to save the image
        ImageSaver.saveTextureToDisk(data: scaledData, width: texture.width, height: texture.height, url: URL(fileURLWithPath: "/Users/benmoore/Desktop/output.png"))
    }
    func dispatchIntersectionTests(rays: [Ray], renderables: [Renderable]) {
        // Sort renderables into their respective arrays
        var spheres: [Sphere] = []
        for renderable in renderables {
            if let sphere = renderable as? Sphere {
                spheres.append(sphere)
            }
        }
        
        guard let computePipelineState = computePipelineState else {
            return
        }

        let commandBuffer = context.commandQueue.makeCommandBuffer()
        let computeEncoder = commandBuffer?.makeComputeCommandEncoder()
        computeEncoder?.setComputePipelineState(computePipelineState)

        // Create and set buffers for rays and scene objects
        if let raysBuffer = context.makeRayBuffer(rays: rays) {
            computeEncoder?.setBuffer(raysBuffer, offset: 0, index: 0)
        }

        if let spheresBuffer = context.makeSphereBuffer(spheres: spheres) {
            computeEncoder?.setBuffer(spheresBuffer, offset: 0, index: 1)
        }
        
        // Create output texture
        let texture = makeOutputTexture(size: CGSize(width: imageWidth, height: imageHeight))
        computeEncoder?.setTexture(texture, index: 2)

        // Determine grid size
        let gridSize = MTLSize(width: imageWidth, height: imageHeight, depth: 1)

        var threadGroupSize = computePipelineState.maxTotalThreadsPerThreadgroup
        if threadGroupSize > rays.count {
            threadGroupSize = rays.count
        }
        let threadgroupSize = MTLSize(width: threadGroupSize, height: 1, depth: 1)

        computeEncoder?.dispatchThreads(gridSize, threadsPerThreadgroup: threadgroupSize)
        
        computeEncoder?.endEncoding()
        commandBuffer?.commit()
        commandBuffer?.waitUntilCompleted()
        
        saveTextureToImage(texture: texture!)
    }
}
