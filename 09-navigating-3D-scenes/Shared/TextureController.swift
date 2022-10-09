import MetalKit

enum TextureController {
  static var textures: [String: MTLTexture] = [:]

  static func texture(filename: String) -> MTLTexture? {
    if let texture = textures[filename] {
      return texture
    }
    let texture = try? loadTexture(filename: filename)
    if texture != nil {
      textures[filename] = texture
    }
    return texture
  }

  static func loadTexture(filename: String) throws -> MTLTexture? {
    // 1
    let textureLoader = MTKTextureLoader(device: Renderer.device)

    if let texture = try? textureLoader.newTexture(
      name: filename,
      scaleFactor: 1.0,
      bundle: Bundle.main,
      options: nil) {
      print("loaded texture: \(filename)")
      return texture
    }

    // 2
    let textureLoaderOptions: [MTKTextureLoader.Option: Any] = [
      .origin: MTKTextureLoader.Origin.bottomLeft,
      .SRGB: false,
      .generateMipmaps: NSNumber(value: true)
    ]
    // 3
    let fileExtension =
      URL(fileURLWithPath: filename).pathExtension.isEmpty ?
        "png" : nil
    // 4
    guard let url = Bundle.main.url(
      forResource: filename,
      withExtension: fileExtension)
      else {
        print("Failed to load \(filename)")
        return nil
    }
    let texture = try textureLoader.newTexture(
      URL: url,
      options: textureLoaderOptions)
    print("loaded texture: \(url.lastPathComponent)")
    return texture
  }
}
