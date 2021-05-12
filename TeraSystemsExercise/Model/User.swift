//
//  User.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/7/21.
//

import UIKit
import ReactiveSwift

struct User: Codable{
    enum CodingKeys: String, CodingKey {
        case id = "userID"
        case idNumber = "idNumber"
        case firstName = "firstName"
        case middleName = "middleName"
        case lastName = "lastName"
        case email = "emailAddress"
        case mobileNumber = "mobileNumber"
        case landline = "landline"
    }
    var id: String
    var idNumber: String
    var firstName: String
    var middleName: String?
    var lastName: String
    var email: String
    var mobileNumber: String
    var landline: String?
    
    lazy var idProperty = MutableProperty<String>(self.id)
    lazy var idNumberProperty = MutableProperty<String>(self.idNumber)
    lazy var firstNameProperty = MutableProperty<String>(self.firstName)
    lazy var middleNameProperty = MutableProperty<String?>(self.middleName)
    lazy var lastNameProperty = MutableProperty<String>(self.lastName)
    lazy var emailProperty = MutableProperty<String>(self.email)
    lazy var mobileNumberProperty = MutableProperty<String>(self.mobileNumber)
    lazy var landlineProperty = MutableProperty<String?>(self.landline)
    
}

