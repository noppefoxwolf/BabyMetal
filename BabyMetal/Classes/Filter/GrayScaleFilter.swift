//
//  GrayScaleFilter.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/06.
//

import MetalKit
import MetalPerformanceShaders

public class GrayScaleFilter: Source, DestinationType {
  private var pipelineState: MTLRenderPipelineState? = nil
  
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
    desc.usage = [.renderTarget]
    let outputTexture = device.makeTexture(descriptor: desc)!
    let commandQueue = device.makeCommandQueue()!
    let commandBuffer = commandQueue.makeCommandBuffer()!

    let vertexData: [Float] = [-1,-1,0,1,
                               1,-1,0,1,
                               -1,1,0,1,
                               1,1,0,1]
    let size = vertexData.count * MemoryLayout<Float>.size
    let vertexBuffer = device.makeBuffer(bytes: vertexData, length: size)

    let texCoordinateData: [Float] = [0,1,
                                      1,1,
                                      0,0,
                                      1,0]
    let texCoordinateDataSize = texCoordinateData.count * MemoryLayout<Float>.size
    let texCoordBuffer = device.makeBuffer(bytes: texCoordinateData, length: texCoordinateDataSize)

    let pipelineState = self.pipelineState ?? makeRenderPipelineState(device: device, texture: texture, vertexFunctionName: "vertexShader", fragmentFunctionName: "grayscale_fragmentShader")
    self.pipelineState = pipelineState //cache pipelineState
    
    let renderDesc = MTLRenderPassDescriptor.init()
    renderDesc.colorAttachments[0].texture = outputTexture
    
    let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderDesc)!
    renderEncoder.setRenderPipelineState(pipelineState)
    renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    renderEncoder.setVertexBuffer(texCoordBuffer, offset: 0, index: 1)
    renderEncoder.setFragmentTexture(texture, index: 0)
    renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
    renderEncoder.endEncoding()
    
    commandBuffer.commit()
    
    let outputFrame = Frame(texture: outputTexture, frame: frame)
    targets.forEach({ $0.render(outputFrame) })
  }
  
  private func makeRenderPipelineState(device: MTLDevice, texture: MTLTexture, vertexFunctionName: String, fragmentFunctionName: String) -> MTLRenderPipelineState {
    let library = try! device.makeDefaultLibrary(bundle: Bundle(for: type(of: self)))
    
    let pipelineDesc = MTLRenderPipelineDescriptor()
    pipelineDesc.vertexFunction = library.makeFunction(name: vertexFunctionName)
    pipelineDesc.fragmentFunction = library.makeFunction(name: fragmentFunctionName)
    pipelineDesc.colorAttachments[0].pixelFormat = texture.pixelFormat
    
    return try! device.makeRenderPipelineState(descriptor: pipelineDesc)
  }
}
