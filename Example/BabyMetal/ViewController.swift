//
//  ViewController.swift
//  BabyMetal
//
//  Created by noppefoxwolf on 07/04/2018.
//  Copyright (c) 2018 noppefoxwolf. All rights reserved.
//

import UIKit
import BabyMetal

final class ViewController: UIViewController {
  
  lazy var camera = CameraSource()
  lazy var source = ImageSource(name: "example")
  lazy var sobelFilter = SobelFilter()
  lazy var blurFilter = BlurFilter()
  lazy var grayScaleFilter = GrayScaleFilter()
  lazy var preview = PreviewView(frame: view.bounds, device: MTLCreateSystemDefaultDevice()!)
  lazy var pipPreview = PreviewView(frame: .init(x: 20, y: 20, width: 200, height: 200), device: MTLCreateSystemDefaultDevice()!)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(preview)
    view.addSubview(pipPreview)
    
    //source >>> filter >>> preview
    //source.update()
    
//    camera >>> sobelFilter >>> blurFilter >>> preview
//    camera >>> pipPreview
//    camera >>> preview
    
    camera >>> grayScaleFilter >>> preview
    camera.startRunning()
    
  }
}


