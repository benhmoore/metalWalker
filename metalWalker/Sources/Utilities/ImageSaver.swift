import CoreGraphics
import ImageIO
import Metal
import UniformTypeIdentifiers

class ImageSaver {
    static func saveTextureToDisk(texture: MTLTexture, url: URL) {
        
        let bytesPerPixel = 16 // RGBA32Float
        let imageByteCount = texture.width * texture.height * bytesPerPixel
        let bytesPerRow = texture.width * bytesPerPixel
        var rawData = [Float](repeating: 0, count: Int(imageByteCount / MemoryLayout<Float>.size))
        
        // Get the texture data
        texture.getBytes(&rawData, bytesPerRow: bytesPerRow, from: MTLRegionMake2D(0, 0, texture.width, texture.height), mipmapLevel: 0)

        // Convert the floating-point data to RGB8
        var rgbData = [UInt8](repeating: 0, count: texture.width * texture.height * 3)
        for i in 0..<(texture.width * texture.height) {
            let red = UInt8(rawData[i * 4] * 255)
            let green = UInt8(rawData[i * 4 + 1] * 255)
            let blue = UInt8(rawData[i * 4 + 2] * 255)
            rgbData[i * 3] = red
            rgbData[i * 3 + 1] = green
            rgbData[i * 3 + 2] = blue
        }

        // Create a color space and bitmap info
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        // Create a data provider from the RGB data
        guard let dataProvider = CGDataProvider(data: Data(bytes: rgbData, count: rgbData.count) as CFData) else {
            fatalError("Could not create data provider")
        }

        // Create a CGImage using the data provider
        guard let cgImage = CGImage(width: texture.width, height: texture.height, bitsPerComponent: 8, bitsPerPixel: 24, bytesPerRow: texture.width * 3, space: colorSpace, bitmapInfo: bitmapInfo, provider: dataProvider, decode: nil, shouldInterpolate: false, intent: .defaultIntent) else {
            fatalError("Could not create CGImage")
        }
        
        if let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) {
            // Add the image to the destination
            CGImageDestinationAddImage(destination, cgImage, nil)
            
            // Finalize the destination
            if !CGImageDestinationFinalize(destination) {
                print("Failed to write image to \(url)")
            }
        }


    }
}
