//
//  authJsonData.swift
//  MGOTU App
//
//  Created by Дмитрий Мартьянов on 09.12.2020.
//

import Foundation

struct AuthData: Codable{
    var admin_auth: Int?
    var allowed: Int?
    var avatar: String?
    var edit_auth: Int?
    var email: String?
    var fio: String?
    var id: Int?
    var info: String?
    var pin: Int?
    var success: Bool
    var user_type: Int?
}
