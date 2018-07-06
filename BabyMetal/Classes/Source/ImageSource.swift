//
//  ImageSource.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/05.
//

import UIKit
import MetalKit

public class ImageSource: Source {
  private let texture: MTLTexture
  
  public init(name: String, scaleFactor: CGFloat = 1.0, bundle: Bundle = .main) {
    let device = MTLCreateSystemDefaultDevice()!
    let loader = MTKTextureLoader(device: device)
    texture = try! loader.newTexture(name: name,
                                     scaleFactor: scaleFactor,
                                     bundle: bundle)
  }
  
  //強制的に更新
  public func update() {
    targets.forEach({ $0.render(Frame(texture: texture)) })
  }
}
