//
//  ImageCapture.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/07.
//

import UIKit

public class ImageCapture: DestinationType {
  private var completions: ((UIImage) -> Void)? = nil
  private var isNeedCaptureNextFrame = false
  
  public init() {}
  
  //TODO: glitch output UIImage :(
  public func snapshot(completions: @escaping ((UIImage) -> Void)) {
    self.completions = completions
    isNeedCaptureNextFrame = true
  }
  
  public func render(_ frame: Frame) {
    if isNeedCaptureNextFrame {
      isNeedCaptureNextFrame = false
      let texture = frame.texture
      
      var pixelBuffer: CVPixelBuffer? = nil
      var res = CVPixelBufferCreate(kCFAllocatorDefault, texture.width, texture.height, kCVPixelFormatType_32BGRA,
                                    [kCVPixelBufferCGBitmapContextCompatibilityKey : true] as CFDictionary,
                                    &pixelBuffer)
      CVPixelBufferLockBaseAddress(pixelBuffer!, .readOnly)
      
      //MTLTexture -> ImageBuffer
      let ptr = CVPixelBufferGetBaseAddress(pixelBuffer!)
      let bytesPerPixel = 4
      let bytesPerRow = bytesPerPixel * texture.width
      let region = MTLRegionMake2D(0, 0, texture.width, texture.height)
      texture.getBytes(ptr!, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
      
      let ciImage = CIImage(cvImageBuffer: pixelBuffer!)
      let ciContext = CIContext(options: nil)
      let rect = CGRect(x: 0, y: 0,
                        width: CVPixelBufferGetWidth(pixelBuffer!),
                        height: CVPixelBufferGetHeight(pixelBuffer!))
      let cgImage = ciContext.createCGImage(ciImage, from: rect)!
      let uiImage = UIImage(cgImage: cgImage)
      
      CVPixelBufferUnlockBaseAddress(pixelBuffer!, .readOnly)
      
      completions?(uiImage)
    }
  }
}
