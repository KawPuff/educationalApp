//
//  LoaderView.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 06.03.2021.
//

import UIKit
@IBDesignable
class LoaderView: UIView {

  @IBInspectable var cornerRadius: CGFloat = 10{
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius>0
        }
    }

}
