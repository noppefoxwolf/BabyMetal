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
  
  lazy var source = ImageSource(name: "example")
  lazy var filter = BlurFilter()
  lazy var preview = PreviewView(frame: view.bounds, device: MTLCreateSystemDefaultDevice()!)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(preview)
    
    source >>> filter >>> preview
    
    source.update()
  }
}
