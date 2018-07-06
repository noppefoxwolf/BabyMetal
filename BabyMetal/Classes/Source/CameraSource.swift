//
//  CameraSource.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/06.
//

import UIKit
import AVFoundation
import MetalKit

public class CameraSource: SourceType, CaptureDeviceDelegate {
  private var targets: [DestinationType] = []
  private var camera = CaptureDevice()
  private var textureCache : CVMetalTextureCache? = nil
  
  public init() {
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
  
  public func addTarget(_ dst: DestinationType) {
    targets.append(dst)
  }
  
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
    let width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0)
    let height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0)
    var imageTexture: CVMetalTexture?
    let result = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                           textureCache!,
                                                           imageBuffer,
                                                           nil,
                                                           .bgra8Unorm,
                                                           width,
                                                           height,
                                                           0,
                                                           &imageTexture)
    if result == kCVReturnSuccess {
      let texture = CVMetalTextureGetTexture(imageTexture!)!
      targets.forEach({ $0.render(texture) })
    }
  }
}
