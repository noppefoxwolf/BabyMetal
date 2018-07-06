//
//  MTLPixelFormat+Extensions.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/07.
//

import MetalKit
import CoreVideo

extension MTLPixelFormat {
  var cvPixelFormat: OSType {
    return kCVPixelFormatType_32BGRA
  }
}
