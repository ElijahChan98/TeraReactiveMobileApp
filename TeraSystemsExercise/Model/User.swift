//
//  User.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/7/21.
//

import UIKit
import ReactiveSwift

class User: Codable{
    enum CodingKeys: String, CodingKey {
        case id = "userID"
        case email = "emailAddress"
        case idNumber
        case firstName
        case middleName
        case lastName
        case mobileNumber
        case landline
    }
    var id: String
    var idNumber: String
    var firstName: String
    var middleName: String?
    var lastName: String
    var email: String
    var mobileNumber: String
    var landline: String?
    
    var fullName: String {
        let fullName: [String] = [self.firstName, (self.middleName ?? ""), self.lastName].filter { $0.count > 0 }
        return fullName.joined(separator: " ")
    }
    
    var initials: String {
        let fullName: [String] = [self.firstName, self.lastName]
        return fullName.reduce("") { $0.uppercased() + $1.prefix(1).uppercased() }
    }
}
