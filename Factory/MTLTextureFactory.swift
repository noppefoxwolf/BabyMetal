//
//  MTLTextureFactory.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/07.
//

import CoreVideo
import CoreMedia
import MetalKit

struct MTLTextureFactory {
  static func make(with sampleBuffer: CMSampleBuffer, textureCache: CVMetalTextureCache?) -> MTLTexture? {
    guard let textureCache = textureCache else { return nil }
    let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
    let width = CVPixelBufferGetWidthOfPlane(imageBuffer, 0)
    let height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0)
    var imageTexture: CVMetalTexture?
    let result = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                           textureCache,
                                                           imageBuffer,
                                                           nil,
                                                           .bgra8Unorm,
                                                           width,
                                                           height,
                                                           0,
                                                           &imageTexture)
    if let imageTexture = imageTexture, result == kCVReturnSuccess {
      return CVMetalTextureGetTexture(imageTexture)
    } else {
      return nil
    }
  }
}
