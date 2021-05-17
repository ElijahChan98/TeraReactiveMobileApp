//
//  UserProperty.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/17/21.
//

import ReactiveSwift

struct UserProperty {
    var idProperty: MutableProperty<String>
    var idNumberProperty: MutableProperty<String>
    var firstNameProperty: MutableProperty<String>
    var middleNameProperty: MutableProperty<String?>
    var lastNameProperty: MutableProperty<String>
    var emailProperty: MutableProperty<String>
    var mobileNumberProperty: MutableProperty<String>
    var landlineProperty: MutableProperty<String?>
    
    init(user: User) {
        self.idProperty = MutableProperty<String>(user.id)
        self.idNumberProperty = MutableProperty<String>(user.idNumber)
        self.firstNameProperty = MutableProperty<String>(user.firstName)
        self.middleNameProperty = MutableProperty<String?>(user.middleName)
        self.lastNameProperty = MutableProperty<String>(user.lastName)
        self.emailProperty = MutableProperty<String>(user.email)
        self.mobileNumberProperty = MutableProperty<String>(user.mobileNumber)
        self.landlineProperty = MutableProperty<String?>(user.landline)
    }
    
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
