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
    
    func update(stateObserver: Signal<Bool,Never>.Observer, completionObserver: Signal<String, NetworkError>.Observer) -> Action<Void, String, NetworkError> {
        let validator = self.updateButtonEnabled
        validator.producer.start(stateObserver)
        
        return Action<Void, String, NetworkError>(enabledIf: validator) {
            let producer = SignalProducer<String, NetworkError> { observer, lifetime in
                self.updateUserValues()
                RequestManager.shared.update(user: self.user) { success, response in
                    guard success, let message = response?["message"] as? String else {
                        observer.send(error: .failed(nil))
                        observer.sendInterrupted()
                        return
                    }
                    if success {
                        observer.send(value: message)
                        observer.sendCompleted()
                    }
                    else {
                        observer.send(error: .failed(message))
                        observer.sendInterrupted()
                    }
                }
            }
            producer.start(completionObserver)
            return producer
        }
    }
    
    func updateResponseObserver(actionOnSuccess: @escaping (_ message: String) -> (), actionOnFail: @escaping (_ message: String) -> ()) -> Signal<String, NetworkError>.Observer {
        return Signal<String, NetworkError>.Observer { message in
            actionOnSuccess(message)
        } failed: { error in
            actionOnFail(error.description)
        } completed: {
            
        } interrupted: {
            
        }

    }
}
