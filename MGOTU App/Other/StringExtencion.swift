//
//  StringExtencion.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 04.04.2021.
//

import Foundation
extension String{
     func firstCharUppercased()->String{
        var temp = Array(self)
        let firstChar = temp.removeFirst().uppercased()
        temp.insert(contentsOf: firstChar, at: 0)
        return String(temp)
    }
}
