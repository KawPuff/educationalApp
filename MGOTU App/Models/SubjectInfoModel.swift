//
//  SubjectInfoModel.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 08.03.2021.
//

import Foundation

struct Subject:Codable{
    var daynum: Int
    var timenum: Int
    var weeknum: Int
    var lparam: String
    var note: String?
    var time: String
}
