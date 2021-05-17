//
//  LoginResponse.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/14/21.
//

import UIKit

struct LoginResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case user = "user"
    }
    var status: String
    var message: String?
    var user: User?
}
