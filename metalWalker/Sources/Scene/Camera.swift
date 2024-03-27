import simd

class Camera {
    var position: SIMD3<Float>
    var lookAt: SIMD3<Float>
    var up: SIMD3<Float>
    var fieldOfView: Float
    var aspectRatio: Float
    
    init(position: SIMD3<Float>, lookAt: SIMD3<Float>, up: SIMD3<Float>, fieldOfView: Float, aspectRatio: Float) {
        self.position = position
        self.lookAt = lookAt
        self.up = up
        self.fieldOfView = fieldOfView
        self.aspectRatio = aspectRatio
    }

    func generateRay(forPixelAt x: Int, y: Int, imageWidth: Int, imageHeight: Int) -> Ray {
        let aspectRatio = Float(imageWidth) / Float(imageHeight)
        let pixelNDCX = (Float(x) + 0.5) / Float(imageWidth)
        let pixelNDCY = (Float(y) + 0.5) / Float(imageHeight)
        
        let pixelScreenX = (2.0 * pixelNDCX - 1.0) * aspectRatio
        let pixelScreenY = 1.0 - 2.0 * pixelNDCY
        
        let rayDirection = normalize(SIMD3<Float>(pixelScreenX, pixelScreenY, -1))
        
        return Ray(origin: position, direction: rayDirection)
    }
}

