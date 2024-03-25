import simd

struct Camera {
    var position: SIMD3<Float>
    var lookAt: SIMD3<Float>
    var up: SIMD3<Float>
    var fieldOfView: Float
    var aspectRatio: Float

    func generateRay(forPixelAt x: Int, y: Int, imageWidth: Int, imageHeight: Int) -> Ray {
        let theta = fieldOfView * .pi / 180
        let halfHeight = tan(theta / 2)
        let halfWidth = aspectRatio * halfHeight
        
        let w = normalize(position - lookAt)
        let u = normalize(cross(up, w))
        let v = cross(w, u)
        
        let pixelWidth = 2.0 * halfWidth / Float(imageWidth)
        let pixelHeight = 2.0 * halfHeight / Float(imageHeight)

        let pixelX = (Float(x) + 0.5) * pixelWidth - halfWidth
        let pixelY = (Float(y) + 0.5) * pixelHeight - halfHeight

        let direction = normalize(pixelX * u - pixelY * v - w)
        return Ray(origin: position, direction: direction)
    }
}
