//
//  Frame.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/07.
//

import MetalKit
import CoreMedia

public class Frame {
  public var texture: MTLTexture
  public var timingInfo: CMSampleTimingInfo = CMSampleTimingInfo()
  
  init(texture: MTLTexture, sampleBuffer: CMSampleBuffer? = nil) {
    self.texture = texture
    if let sampleBuffer = sampleBuffer {
      CMSampleBufferGetSampleTimingInfo(sampleBuffer, 0, &timingInfo)
    }
  }
  
  init(texture: MTLTexture, frame: Frame) {
    self.texture = texture
    self.timingInfo = frame.timingInfo
  }
}
