//
//  VideoRecordSession.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/07.
//

import AVFoundation

internal class VideoRecordSession {
  private lazy var assetWriter: AVAssetWriter = { preconditionFailure() }()
  private lazy var videoWriterInput: AVAssetWriterInput = { preconditionFailure() }()
  private var textureCache : CVMetalTextureCache? = nil
  private let filePath: String
  private var previousPresentationTimeStamp: CMTime = kCMTimeZero
  
  internal init(filePath: String) {
    self.filePath = filePath
    let device = MTLCreateSystemDefaultDevice()!
    CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &textureCache)
  }
  
  func initial(presentationTime: CMTime, width: Int, height: Int) {
    let outputSettings = [AVVideoCodecKey : AVVideoCodecH264,
                          AVVideoWidthKey   : width,
                          AVVideoHeightKey  : height] as [String : Any]
    videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
    assetWriter = try! AVAssetWriter(outputURL: .init(fileURLWithPath: filePath), fileType: .mp4)
    assetWriter.add(videoWriterInput)
    assetWriter.startWriting()
    assetWriter.startSession(atSourceTime: presentationTime)
  }
  
  func append(_ frame: Frame) {
    guard assetWriter.status == .writing else { return }
    guard videoWriterInput.isReadyForMoreMediaData else { return }
    guard previousPresentationTimeStamp != frame.timingInfo.presentationTimeStamp else { return }
    previousPresentationTimeStamp = frame.timingInfo.presentationTimeStamp
    
    let texture = frame.texture
    
    var pixelBuffer: CVPixelBuffer? = nil
    var res = CVPixelBufferCreate(kCFAllocatorDefault, texture.width, texture.height, kCVPixelFormatType_32BGRA,
                                  [kCVPixelBufferMetalCompatibilityKey : true] as CFDictionary,
                                  &pixelBuffer)
    CVPixelBufferLockBaseAddress(pixelBuffer!, .readOnly)
    
    //MTLTexture -> ImageBuffer
    let ptr = CVPixelBufferGetBaseAddress(pixelBuffer!)
    let bytesPerPixel = 4
    let bytesPerRow = bytesPerPixel * texture.width
    let region = MTLRegionMake2D(0, 0, texture.width, texture.height)
    texture.getBytes(ptr!, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
    
    //ImageBuffer -> SampleBuffer
    var desc: CMVideoFormatDescription? = nil
    CMVideoFormatDescriptionCreateForImageBuffer(kCFAllocatorDefault, pixelBuffer!, &desc)
    
    var sampleBuffer: CMSampleBuffer? = nil
    var timing = CMSampleTimingInfo()
    timing.presentationTimeStamp = frame.timingInfo.presentationTimeStamp
    CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault,
                                       pixelBuffer!,
                                       true,
                                       nil,
                                       nil,
                                       desc!,
                                       &timing,
                                       &sampleBuffer)
    videoWriterInput.append(sampleBuffer!)
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer!, .readOnly)
  }
  
  func finishWriting(completionHandler: @escaping (() -> Void)) {
    guard assetWriter.status == .writing else { return }
    videoWriterInput.markAsFinished()
    assetWriter.finishWriting(completionHandler: completionHandler)
  }
}
