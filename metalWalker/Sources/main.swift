let sphereMaterial = Material(baseColor: SIMD3<Float>(1, 0, 0), metallic: 0.5, roughness: 0.5, emissive: SIMD3<Float>(0, 0, 0))
let sphereMaterialComponent = MaterialComponent(material: sphereMaterial)
let sphereTransform = Transform(position: SIMD3<Float>(0, 0, 0), rotation: SIMD3<Float>(0, 0, 0), scale: SIMD3<Float>(1, 1, 1))
let sphereTransformComponent = TransformComponent(transform: sphereTransform)

let sphere = Sphere(transformComponent: sphereTransformComponent, materialComponent: sphereMaterialComponent, radius: 1.0)

let camera = Camera(position: SIMD3<Float>(0, 0, 3), lookAt: SIMD3<Float>(0, 0, -1), up: SIMD3<Float>(0, 1, 0), fieldOfView: 45, aspectRatio: 1.0)


let imageWidth = 256
let imageHeight = 256
var rays: [Ray] = []

for y in 0..<imageHeight {
    for x in 0..<imageWidth {
        let ray = camera.generateRay(forPixelAt: x, y: y, imageWidth: imageWidth, imageHeight: imageHeight)
        rays.append(ray)
    }
}

let metalContext = MetalContext()
let metalRenderer = MetalRenderer(context: metalContext)
metalRenderer.dispatchIntersectionTests(rays: rays, renderables: [sphere])
