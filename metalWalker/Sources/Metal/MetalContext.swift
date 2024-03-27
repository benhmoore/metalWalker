import Metal
import MetalKit

class MetalContext {
    var device: MTLDevice
    var commandQueue: MTLCommandQueue

    init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device")
        }
        self.device = device

        guard let commandQueue = device.makeCommandQueue() else {
            fatalError("Could not create a command queue")
        }
        self.commandQueue = commandQueue
    }

    func makeBuffer<T: ContiguousBytes>(data: [T], options: MTLResourceOptions = []) -> MTLBuffer? {
        let length = data.count * MemoryLayout<T>.stride
        return data.withUnsafeBytes { bufferPointer -> MTLBuffer? in
            return device.makeBuffer(bytes: bufferPointer.baseAddress!, length: length, options: options)
        }
    }

}
