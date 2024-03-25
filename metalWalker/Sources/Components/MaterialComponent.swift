class MaterialComponent {
    var material: Material
    
    init(material: Material) {
        self.material = material
    }
    
    func setBaseColor(_ color: SIMD3<Float>) {
        material.baseColor = color
    }
}
