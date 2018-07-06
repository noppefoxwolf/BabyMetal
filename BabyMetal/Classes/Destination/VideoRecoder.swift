//
//  VideoRecoder.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/06.
//

import UIKit
import AVFoundation

public class VideoRecoder: NSObject, DestinationType {
  private var isNeedRecord = false
  private var session: VideoRecordSession? = nil
  private let filePath: String
  
  public init(filePath: String) {
    self.filePath = filePath
    super.init()
  }
  
  public func startWriting() {
    _ = try? FileManager.default.removeItem(atPath: filePath)
    isNeedRecord = true
    session = VideoRecordSession(filePath: filePath)
  }
  
  public func finishWriting(completionHandler: @escaping (() -> Void)) {
    session?.finishWriting(completionHandler: completionHandler)
  }
  
  public func render(_ frame: Frame) {
    if isNeedRecord {
      session?.initial(presentationTime: frame.timingInfo.presentationTimeStamp,
                       width: frame.texture.width,
                       height: frame.texture.height)
      isNeedRecord = false
    }
    session?.append(frame)
  }
}
