//
//  InternalDestination.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/07.
//

import Foundation

protocol InternalDestinationDelegate: class {
  func frameUpdated()
}

final class InternalDestination: DestinationType {
  var lastFrame: Frame? = nil
  weak var delegate: InternalDestinationDelegate? = nil
  
  public func render(_ frame: Frame) {
    lastFrame = frame
    delegate?.frameUpdated()
  }
}
