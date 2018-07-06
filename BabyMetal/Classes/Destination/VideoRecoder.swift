//
//  VideoRecoder.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/06.
//

import UIKit
import AVFoundation

public class VideoRecoder: NSObject, DestinationType {
  private let assetWriter: AVAssetWriter!
  private let videoWriterInput: AVAssetWriterInput
  private var textureCache : CVMetalTextureCache? = nil
  
  public init(filePath: String) {
    if true {
      try! FileManager.default.removeItem(atPath: filePath)
    }
    let outputSettings = [AVVideoCodecKey : AVVideoCodecH264,
                          AVVideoWidthKey   : 480,
                          AVVideoHeightKey  : 640] as [String : Any]
    videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
    assetWriter = try! AVAssetWriter(outputURL: .init(fileURLWithPath: filePath), fileType: .mp4)
    super.init()
    assetWriter.add(videoWriterInput)
    
    let device = MTLCreateSystemDefaultDevice()!
    CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &textureCache)
  }
  
  @discardableResult
  public func startWriting() -> Bool {
    guard assetWriter.status == .unknown else { return false }
    assetWriter.startWriting()
    assetWriter.startSession(atSourceTime: kCMTimeZero)
    return true
  }
  
  public func finishWriting(completionHandler: @escaping (() -> Void)) {
    videoWriterInput.markAsFinished()
    assetWriter.finishWriting(completionHandler: completionHandler)
  }
  
  public func render(_ texture: MTLTexture) {
    guard assetWriter.status == .writing else { return }
    guard videoWriterInput.isReadyForMoreMediaData else { return }
    
    var pixelBuffer: CVPixelBuffer? = nil
    var res = kCVReturnError
    res = CVPixelBufferCreate(kCFAllocatorDefault, texture.width, texture.height, kCVPixelFormatType_32ARGB,
                              [kCVPixelBufferMetalCompatibilityKey : true, kCVPixelBufferCGBitmapContextCompatibilityKey : true, kCVPixelBufferCGImageCompatibilityKey : true] as CFDictionary,
                                  &pixelBuffer)
    
    var cvTexture: CVMetalTexture? = nil
    res = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                              textureCache!,
                                              pixelBuffer!,
                                              nil,
                                              texture.pixelFormat,
                                              CVPixelBufferGetWidth(pixelBuffer!),
                                              CVPixelBufferGetHeight(pixelBuffer!),
                                              0,
                                              &cvTexture)
    _ = pixelBuffer
    
    let t = CVMetalTextureGetTexture(cvTexture!)
    
    
//    videoWriterInput.append
  }
}
