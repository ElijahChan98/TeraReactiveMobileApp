//
//  UpdateProfileViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/10/21.
//

import UIKit
import ReactiveSwift

class UpdateProfileViewModel {
    private(set) var user: User!
    var userProperty: UserProperty!
    
    init(user: User) {
        self.user = user
        self.userProperty = UserProperty(user: user)
    }
    
    func updateUserValues() {
        self.user = User(userProperty: self.userProperty)
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
        return Property.combineLatest(userProperty.firstNameProperty, userProperty.lastNameProperty, userProperty.idNumberProperty, userProperty.emailProperty, userProperty.mobileNumberProperty).map { firstName, lastName, idNumber, email, mobileNumber in
            return !firstName.isEmpty && !lastName.isEmpty && !idNumber.isEmpty && !email.isEmpty && !mobileNumber.isEmpty
        }
    }
    
    func update(completion: @escaping  (_ success: Bool, _ message: String) -> ()) -> Action<Void, Void, Never> {
        return Action<Void, Void, Never> {
            return SignalProducer<Void, Never> { observer, lifetime in
                self.updateUserValues()
                RequestManager.shared.update(user: self.user) { success, response in
                    guard success, let message = response?["message"] as? String else {
                        completion(false, "Something went wrong, please try again later")
                        return
                    }
                    completion(true, message)
                }
                observer.sendCompleted()
            }
        }
    }
}
