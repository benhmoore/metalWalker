//import Metal
//import CoreGraphics
//import ImageIO
//import UniformTypeIdentifiers
//
//guard let device = MTLCreateSystemDefaultDevice() else {
//    fatalError("Metal is not supported on this device.")
//}
//
//guard let commandQueue = device.makeCommandQueue() else {
//    fatalError("Could not create a command queue.")
//}
//
//// Load default library
//guard let defaultLibrary = device.makeDefaultLibrary() else {
//    fatalError("Could not find default Metal library.")
//}
//
//guard let computeFunction = defaultLibrary.makeFunction(name: "clearScreen") else {
//    fatalError("Could not find compute function in the library")
//}
//
//// Create a compute pipeline state object
//var computePipelineState: MTLComputePipelineState!
//
//do {
//    computePipelineState = try device.makeComputePipelineState(function: computeFunction)
//} catch {
//    fatalError("Could not creat ecompute pipeline state: \(error)")
//}
//
//// - - - - - -
//// Setting up Buffers and Textures
//// - - - - - -
//
//let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba32Float, width: 800, height: 600, mipmapped: false)
//
//textureDescriptor.usage = [.shaderWrite, .shaderRead]
//
//// Create a texture from the device using the descriptor
//guard let texture = device.makeTexture(descriptor: textureDescriptor) else {
//    fatalError("Could not create texture")
//}
//
//// - - - - - -
//// Dispatching the Compute Work
//// - - - - - -
//
//guard let commandBuffer = commandQueue.makeCommandBuffer() else {
//    fatalError("Could not create command buffer.")
//}
//
//guard let computeEncoder = commandBuffer.makeComputeCommandEncoder() else {
//    fatalError("Couldd not create compute command encoder.")
//}
//
//// Set the compute pipeline state
//computeEncoder.setComputePipelineState(computePipelineState)
//
//// Set the output texture
//computeEncoder.setTexture(texture, index: 0)
//
//// Calculate the number of threadgroups
//let threadGroupSize = MTLSizeMake(8, 8, 1)
//let threadGroups = MTLSizeMake(
//    (texture.width + threadGroupSize.width - 1) / threadGroupSize.width,
//    (texture.height + threadGroupSize.height - 1) / threadGroupSize.height,
//    1
//)
//
//// Dispatch the compute work
//computeEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupSize)
//
//// End encoding and commit the command buffer
//computeEncoder.endEncoding()
//commandBuffer.commit()
//commandBuffer.waitUntilCompleted()
//
//// - - - - - -
//// Read and Save the Texture
//// - - - - - -
//
//// Create a buffer to hold the texture data
//let bytesPerPixel = 16 // Assuming RGBA32Float
//let imageByteCount = texture.width * texture.height * bytesPerPixel
//let bytesPerRow = texture.width * bytesPerPixel
//var rawData = [Float](repeating: 0, count: Int(imageByteCount / MemoryLayout<Float>.size))
//
//
//// Save image


let sphereMaterial = Material(baseColor: SIMD3<Float>(1, 0, 0), metallic: 0.5, roughness: 0.5, emissive: SIMD3<Float>(0, 0, 0))
let sphereMaterialComponent = MaterialComponent(material: sphereMaterial)
let sphereTransform = Transform(position: SIMD3<Float>(0, 0, -5), rotation: SIMD3<Float>(0, 0, 0), scale: SIMD3<Float>(1, 1, 1))
let sphereTransformComponent = TransformComponent(transform: sphereTransform)

let sphere = Sphere(transformComponent: sphereTransformComponent, materialComponent: sphereMaterialComponent, radius: 1.0)

// Define a simple ray from the origin pointing forward
let ray = Ray(origin: SIMD3<Float>(0, 0, 0), direction: SIMD3<Float>(0, 0, -1))

if let intersection = sphere.intersect(ray: ray) {
    print("Intersected at point \(intersection.position) with a distance of \(intersection.distance).")
} else {
    print("The ray didn't hit the sphere.")
}

let camera = Camera(position: SIMD3<Float>(0, 0, 0), lookAt: SIMD3<Float>(0, 0, -1), up: SIMD3<Float>(0, 1, 0), fieldOfView: 45, aspectRatio: 1.0)
let imageWidth = 800
let imageHeight = 800

//
//for y in 0..<imageHeight {
//    for x in 0..<imageWidth {
//        let ray = camera.generateRay(forPixelAt: x, y: y, imageWidth: imageWidth, imageHeight: imageHeight)
//        if let intersection = sphere.intersect(ray: ray) {
//            // Handle intersection
//        } else {
//            // no intersection
//        }
//    }
//}
