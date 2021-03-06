//
//  SobelFilter.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/06.
//

import MetalKit
import MetalPerformanceShaders

public class SobelFilter: Source, DestinationType {
  public override init() {
    super.init()
  }
  
  public func render(_ frame: Frame) {
    let texture = frame.texture
    let w = texture.width
    let h = texture.height
    let device = MTLCreateSystemDefaultDevice()!
    let desc: MTLTextureDescriptor = .texture2DDescriptor(pixelFormat: texture.pixelFormat,
                                                          width: w,
                                                          height: h,
                                                          mipmapped: true)
    desc.usage = [.shaderRead, .shaderWrite]
    let outputTexture = device.makeTexture(descriptor: desc)!
    let commandQueue = device.makeCommandQueue()!
    let commandBuffer = commandQueue.makeCommandBuffer()!
    let encoder = commandBuffer.makeBlitCommandEncoder()!
    encoder.copy(from: texture,
                 sourceSlice: 0,
                 sourceLevel: 0,
                 sourceOrigin: .init(x: 0, y: 0, z: 0),
                 sourceSize: .init(width: w, height: h, depth: texture.depth),
                 to: outputTexture,
                 destinationSlice: 0,
                 destinationLevel: 0,
                 destinationOrigin: .init(x: 0, y: 0, z: 0))
    encoder.endEncoding()
    
    let kernel = MPSImageSobel(device: device)
    kernel.encode(commandBuffer: commandBuffer, sourceTexture: texture, destinationTexture: outputTexture)
    
    commandBuffer.commit()
    
    let outputFrame = Frame(texture: outputTexture, frame: frame)
    targets.forEach({ $0.render(outputFrame) })
  }
}
