import simd

extension float4x4 {
    static func translationMatrix(_ translation: SIMD3<Float>) -> float4x4 {
        var matrix = float4x4(1) // Identity matrix
        matrix.columns.3 = SIMD4<Float>(translation, 1)
        return matrix
    }
}
