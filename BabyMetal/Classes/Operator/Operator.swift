//
//  Operator.swift
//  BabyMetal
//
//  Created by Tomoya Hirano on 2018/07/05.
//

import UIKit

precedencegroup Base {
  associativity: left
  lowerThan: AdditionPrecedence
}

infix operator >>> : Base

public func >>> (lhs: SourceType, rhs: DestinationType) {
  lhs.addTarget(rhs)
}

public func >>> (lhs: SourceType, rhs: SourceType & DestinationType) -> SourceType {
  lhs.addTarget(rhs)
  return rhs
}
