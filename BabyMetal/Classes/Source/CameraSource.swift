//
//  CameraSource.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/06.
//

import UIKit
import AVFoundation
import MetalKit

public class CameraSource: Source, CaptureDeviceDelegate {
  private var camera = CaptureDevice()
  private var textureCache : CVMetalTextureCache? = nil
  
  public override init() {
    super.init()
    camera.delegate = self
    
    let device = MTLCreateSystemDefaultDevice()!
    CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &textureCache)
  }
  
  public func startRunning() {
    camera.startRunning()
  }
  
  public func stopRunning() {
    camera.stopRunning()
  }
  
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let texture = MTLTextureFactory.make(with: sampleBuffer, textureCache: textureCache) else { return }
    targets.forEach({ $0.render(Frame(texture: texture, sampleBuffer: sampleBuffer)) })
  }
}
