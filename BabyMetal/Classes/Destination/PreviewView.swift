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
    print("drawableSizeWillChange")
  }
  
  public func draw(in view: MTKView) {
    guard let texture = renderTexture else { return }
    let drawable = currentDrawable!
    colorPixelFormat = texture.pixelFormat
    
    let textureRatio = CGFloat(texture.height) / CGFloat(texture.width)
    let drawableRatio = CGFloat(drawable.texture.height) / CGFloat(drawable.texture.width)
    let isTextureTinThanDrawable = textureRatio > drawableRatio
    
    if isTextureTinThanDrawable {
      let ratio: CGFloat = min(CGFloat(texture.width) / CGFloat(drawable.texture.width), 1.0)
      drawableSize = CGSize(width: drawable.texture.width, height: drawable.texture.height).applying(.init(scaleX: ratio, y: ratio))
    } else {
      let ratio: CGFloat = min(CGFloat(texture.height) / CGFloat(drawable.texture.height), 1.0)
      drawableSize = CGSize(width: drawable.texture.width, height: drawable.texture.height).applying(.init(scaleX: ratio, y: ratio))
    }
    
    let commandBuffer = commandQueue.makeCommandBuffer()!
    let encoder = commandBuffer.makeBlitCommandEncoder()!
    let w = drawableSize.width
    let h = drawableSize.height
    let x = (texture.width - Int(drawableSize.width)) / 2
    let y = (texture.height - Int(drawableSize.height)) / 2
    
    encoder.copy(from: texture,
                 sourceSlice: 0,
                 sourceLevel: 0,
                 sourceOrigin: .init(x: x, y: y, z: 0),
                 sourceSize: .init(width: Int(w), height: Int(h), depth: texture.depth),
                 to: drawable.texture,
                 destinationSlice: 0,
                 destinationLevel: 0,
                 destinationOrigin: .init(x: 0, y: 0, z: 0))
    encoder.endEncoding()
    
    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
  
  public func render(_ frame: Frame) {
    renderTexture = frame.texture
    DispatchQueue.main.async { [weak self] in
      self?.setNeedsDisplay()
    }
  }
}
