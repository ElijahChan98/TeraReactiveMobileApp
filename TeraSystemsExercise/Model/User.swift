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
    
    var idProperty = MutableProperty<String>("")
    var idNumberProperty = MutableProperty<String>("")
    var firstNameProperty = MutableProperty<String>("")
    var middleNameProperty = MutableProperty<String?>("")
    var lastNameProperty = MutableProperty<String>("")
    var emailProperty = MutableProperty<String>("")
    var mobileNumberProperty = MutableProperty<String>("")
    var landlineProperty = MutableProperty<String?>("")
}

extension User {
    func update(user: User) {
        self.idProperty.value = user.id
        self.idNumberProperty.value = user.idNumber
        self.firstNameProperty.value = user.firstName
        self.middleNameProperty.value = user.middleName
        self.lastNameProperty.value = user.lastName
        self.emailProperty.value = user.email
        self.mobileNumberProperty.value = user.mobileNumber
        self.landlineProperty.value = user.landline
    }
}
