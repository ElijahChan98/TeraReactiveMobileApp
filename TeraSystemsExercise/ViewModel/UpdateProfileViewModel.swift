//
//  UpdateProfileViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/10/21.
//

import UIKit
import ReactiveSwift

class UpdateProfileViewModel {
    var user: User!
    
    init(user: User) {
        self.user = user
    }
    
    func updateUserValues() {
        user.idNumber = user.idNumberProperty.value
        user.firstName = user.firstNameProperty.value
        user.middleName = user.middleNameProperty.value
        user.lastName = user.lastNameProperty.value
        user.email = user.emailProperty.value
        user.mobileNumber = user.mobileNumberProperty.value
        user.landline = user.landlineProperty.value
    }
    
    func updateButtonObserver(actionIfEnabled: @escaping () -> (), actionIfDisabled: @escaping () -> ()) -> Signal<Bool,Never>.Observer {
        return Signal<Bool, Never>.Observer { enabled in
            if enabled {
                actionIfEnabled()
            }
            else {
                actionIfDisabled()
            }
        } completed: {
            print("completed")
        } interrupted: {
            print("interrupted")
        }

    }
    
    var updateButtonEnabled: Property<Bool>{
        return Property.combineLatest(user.firstNameProperty, user.lastNameProperty, user.idNumberProperty, user.emailProperty, user.mobileNumberProperty).map { firstName, lastName, idNumber, email, mobileNumber in
            return !firstName.isEmpty && !lastName.isEmpty && !idNumber.isEmpty && !email.isEmpty && !mobileNumber.isEmpty
        }
    }
    
    func update(completion: @escaping  (_ success: Bool, _ message: String) -> ()) {
        self.updateUserValues()
        RequestManager.shared.update(user: self.user) { success, response in
            guard success, let message = response?["message"] as? String else {
                completion(false, "Something went wrong, please try again later")
                return
            }
            completion(true, message)
        }
    }
}
