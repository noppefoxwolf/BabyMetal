//
//  Source.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/07.
//

import UIKit

open class Source: SourceType {
  internal var targets: [DestinationType] = []
  
  public func addTarget(_ dst: DestinationType) {
    targets.append(dst)
  }
}
