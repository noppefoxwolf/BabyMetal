//
//  ViewController.swift
//  BabyMetal
//
//  Created by noppefoxwolf on 07/04/2018.
//  Copyright (c) 2018 noppefoxwolf. All rights reserved.
//

import UIKit
import BabyMetal
import Photos

final class ViewController: UIViewController {
  
  lazy var camera = CameraSource()
  lazy var image = ImageSource(name: "example")
  lazy var sobelFilter = SobelFilter()
  lazy var blurFilter = BlurFilter()
  lazy var grayScaleFilter = GrayScaleFilter()
  lazy var preview = PreviewView(frame: view.bounds, device: MTLCreateSystemDefaultDevice()!)
  lazy var pipPreview = PreviewView(frame: .init(x: 20, y: 20, width: 200, height: 200), device: MTLCreateSystemDefaultDevice()!)
  lazy var recoder = VideoRecoder(filePath: NSTemporaryDirectory() + "/sample.mp4")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(preview)
    view.addSubview(pipPreview)
    
    //image >>> filter >>> preview
    //image.update()
    
    camera >>> sobelFilter >>> blurFilter >>> preview
    camera >>> pipPreview
    camera >>> sobelFilter >>> recoder
    
    camera.startRunning()
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    recoder.startWriting()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    recoder.finishWriting {
      print("done")
      let filePath = NSTemporaryDirectory() + "/sample.mp4"
      PHPhotoLibrary.shared().performChanges({
        let url = URL(fileURLWithPath: filePath)
        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
      }, completionHandler: { (saved, error) in
        print("saved", saved, error)
      })
    }
  }
}


