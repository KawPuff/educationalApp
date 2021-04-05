//
//  NSLayoutConstraint Extension.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 19.03.2021.
//

import UIKit

public extension NSLayoutConstraint {
    
  func changeMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
    let newConstraint = NSLayoutConstraint(
      item: firstItem,
      attribute: firstAttribute,
      relatedBy: relation,
      toItem: secondItem,
      attribute: secondAttribute,
      multiplier: multiplier,
      constant: constant)
    newConstraint.priority = priority

    NSLayoutConstraint.deactivate([self])
    NSLayoutConstraint.activate([newConstraint])

    return newConstraint
  }

}
