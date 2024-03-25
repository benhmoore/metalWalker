struct TransformComponent {
    var transform: Transform
    
    init(transform: Transform) {
        self.transform = transform
    }
    
    mutating func translate(by vector: SIMD3<Float>) {
    }
    
    mutating func rotate(by vector: SIMD3<Float>) {
    }
    
    mutating func scale(by factor: SIMD3<Float>) {
    }
    
}
