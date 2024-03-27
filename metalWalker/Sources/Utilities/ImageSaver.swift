import CoreGraphics
import ImageIO
import Metal
import UniformTypeIdentifiers

class ImageSaver {
    static func saveTextureToDisk(data: [UInt8], width: Int, height: Int, url: URL) {
        // Create a CGImage from the scaled data
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitsPerComponent = 8
        let bitsPerPixel = 32
        let bytesPerRow = width * 4
        
        guard let providerRef = CGDataProvider(data: Data(bytes: data, count: data.count) as CFData) else {
            print("Failed to create CGDataProvider")
            return
        }
        
        guard let cgImage = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: bytesPerRow,
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        ) else {
            print("Failed to create CGImage")
            return
        }
        
        // Create a CGContext and draw the CGImage
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Get the image from the context and save it to disk
        guard let outputImage = context?.makeImage() else {
            print("Failed to create output image")
            return
        }
        
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else {
            print("Failed to create CGImageDestination")
            return
        }
        
        CGImageDestinationAddImage(destination, outputImage, nil)
        if !CGImageDestinationFinalize(destination) {
            print("Failed to finalize CGImageDestination")
        }
    }
}
