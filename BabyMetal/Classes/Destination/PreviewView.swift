//
//  PreviewView.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/05.
//

import UIKit
import MetalKit

public class PreviewView: MTKView, DestinationType, MTKViewDelegate {
  private let commandQueue: MTLCommandQueue
  private var renderTexture: MTLTexture? = nil
  
  public override init(frame frameRect: CGRect, device: MTLDevice?) {
    commandQueue = device!.makeCommandQueue()!
    super.init(frame: frameRect, device: device)
    delegate = self
    framebufferOnly = false
    enableSetNeedsDisplay = true
  }
  
  public required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    
  }
  
  public func draw(in view: MTKView) {
    guard let texture = renderTexture else { return }
    let drawable = currentDrawable!
    colorPixelFormat = texture.pixelFormat
    drawableSize = CGSize(width: texture.width, height: texture.height)
    
    let commandBuffer = commandQueue.makeCommandBuffer()!
    let encoder = commandBuffer.makeBlitCommandEncoder()!
    let w = texture.width
    let h = texture.height
    encoder.copy(from: texture,
                 sourceSlice: 0,
                 sourceLevel: 0,
                 sourceOrigin: MTLOrigin(x: 0, y: 0, z: 0),
                 sourceSize: MTLSizeMake(w, h, texture.depth),
                 to: drawable.texture,
                 destinationSlice: 0,
                 destinationLevel: 0,
                 destinationOrigin: MTLOrigin(x: 0, y: 0, z: 0))
    encoder.endEncoding()
    
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
  
  public func render(_ texture: MTLTexture) {
    renderTexture = texture
    DispatchQueue.main.async { [weak self] in
      self?.setNeedsDisplay()
    }
  }
}
