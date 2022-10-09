import MetalKit

// swiftlint:disable implicitly_unwrapped_optional

class Renderer: NSObject {
  static var device: MTLDevice!
  static var commandQueue: MTLCommandQueue!
  static var library: MTLLibrary!
  var pipelineState: MTLRenderPipelineState!

  lazy var model: Model = {
    Model(device: Renderer.device, name: "train.usd")
  }()

  var timer: Float = 0
  var uniforms = Uniforms()

  init(metalView: MTKView) {
    guard
      let device = MTLCreateSystemDefaultDevice(),
      let commandQueue = device.makeCommandQueue() else {
        fatalError("GPU not available")
    }
    Renderer.device = device
    Renderer.commandQueue = commandQueue
    metalView.device = device

    // create the shader function library
    let library = device.makeDefaultLibrary()
    Self.library = library
    let vertexFunction = library?.makeFunction(name: "vertex_main")
    let fragmentFunction =
      library?.makeFunction(name: "fragment_main")

    // create the pipeline state
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertexFunction
    pipelineDescriptor.fragmentFunction = fragmentFunction
    pipelineDescriptor.colorAttachments[0].pixelFormat =
      metalView.colorPixelFormat
    pipelineDescriptor.vertexDescriptor =
      MTLVertexDescriptor.defaultLayout
    do {
      pipelineState =
        try device.makeRenderPipelineState(
          descriptor: pipelineDescriptor)
    } catch let error {
      fatalError(error.localizedDescription)
    }

    super.init()
    metalView.clearColor = MTLClearColor(
      red: 1.0,
      green: 1.0,
      blue: 0.9,
      alpha: 1.0)
    metalView.delegate = self
    
    let translation = float4x4(translation: [0.5, -0.4, 0])
    let rotation = float4x4(rotation: [0, 0, Float(45).degreesToRadians])
    uniforms.modelMatrix = translation * rotation
    
    uniforms.viewMatrix = float4x4(translation: [0, 0, -3]).inverse
    
    mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)
  }
}

extension Renderer: MTKViewDelegate {
  func mtkView(
    _ view: MTKView,
    drawableSizeWillChange size: CGSize
  ) {
    let aspect = Float(view.bounds.width) / Float(view.bounds.height)
    let projectionMatrix = float4x4(projectionFov: Float(45).degreesToRadians, near: 0.1, far: 10, aspect: aspect)
    uniforms.projectionMatrix = projectionMatrix
  }

  func draw(in view: MTKView) {
    guard
      let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
      let descriptor = view.currentRenderPassDescriptor,
      let renderEncoder =
        commandBuffer.makeRenderCommandEncoder(
          descriptor: descriptor) else {
        return
    }

    renderEncoder.setRenderPipelineState(pipelineState)
    renderEncoder.setTriangleFillMode(.lines)

    timer += 0.005
    let translationMatrix = float4x4(translation: [0, -0.6, 0])
    let rotationMatrix = float4x4(rotationY: sin(timer))
    uniforms.modelMatrix = translationMatrix * rotationMatrix
    renderEncoder.setVertexBytes(
      &uniforms,
      length: MemoryLayout<Uniforms>.stride,
      index: 11
    )
    model.render(encoder: renderEncoder)

    renderEncoder.endEncoding()
    guard let drawable = view.currentDrawable else {
      return
    }
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}
