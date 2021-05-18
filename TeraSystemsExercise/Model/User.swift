//
//  User.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/7/21.
//

import UIKit

struct User: Codable{
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
}

extension User {
    init(userProperty: UserProperty) {
        self.id = userProperty.idProperty.value
        self.idNumber = userProperty.idNumberProperty.value
        self.firstName = userProperty.firstNameProperty.value
        self.middleName = userProperty.middleNameProperty.value
        self.lastName = userProperty.lastNameProperty.value
        self.email = userProperty.emailProperty.value
        self.mobileNumber = userProperty.mobileNumberProperty.value
        self.landline = userProperty.landlineProperty.value
    }
}
