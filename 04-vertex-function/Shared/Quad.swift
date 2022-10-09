import MetalKit

struct Quad {
    var vertices: [Float] = [
        -1,  1,  0,
         1,  1,  0,
        -1, -1,  0,
         1, -1,  0
    ]
    var colors: [simd_float3] = [
        simd_float3(1, 0, 0),
        simd_float3(0, 1, 0),
        simd_float3(0, 0, 1),
        simd_float3(1, 1, 0)
    ]
    var indices: [UInt16] = [
      0, 3, 2,
      0, 1, 3
    ]
    
    let vertexBuffer: MTLBuffer
    let colorBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    
    init (device: MTLDevice, scale: Float = 1) {
        vertices = vertices.map {
            $0 * scale
        }
        guard let buffer = device.makeBuffer(
            bytes: &vertices,
            length: MemoryLayout<Float>.stride * vertices.count,
            options: []) else {
            fatalError("Unable to create Quad vertex buffer")
        }
        self.vertexBuffer = buffer
        
        guard let colorBuffer = device.makeBuffer(
            bytes: &colors,
            length: MemoryLayout<simd_float3>.stride * colors.count,
            options: []) else {
            fatalError("Unable to create Quad color buffer")
        }
        self.colorBuffer = colorBuffer
        
        guard let indexBuffer = device.makeBuffer(
            bytes: &indices,
            length: MemoryLayout<UInt16>.stride * indices.count, options: []) else {
            fatalError("Unable to create Quad index buffer")
        }
        self.indexBuffer = indexBuffer
    }
}

