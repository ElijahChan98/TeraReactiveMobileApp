//
//  UpdateProfileViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/10/21.
//

import UIKit
import ReactiveSwift

class UpdateProfileViewModel {
    unowned private(set) var user: User!
    var idProperty = MutableProperty<String>("")
    var idNumberProperty = MutableProperty<String>("")
    var firstNameProperty = MutableProperty<String>("")
    var middleNameProperty = MutableProperty<String?>("")
    var lastNameProperty = MutableProperty<String>("")
    var emailProperty = MutableProperty<String>("")
    var mobileNumberProperty = MutableProperty<String>("")
    var landlineProperty = MutableProperty<String?>("")
    
    init(user: User) {
        self.user = user
        idProperty.value = user.id
        idNumberProperty.value = user.idNumber
        firstNameProperty.value = user.firstName
        middleNameProperty.value = user.middleName
        lastNameProperty.value = user.lastName
        emailProperty.value = user.email
        mobileNumberProperty.value = user.mobileNumber
        landlineProperty.value = user.landline
    }
    
    func updateUserValues() {
        user.id = self.idProperty.value
        user.idNumber = self.idNumberProperty.value
        user.firstName = self.firstNameProperty.value
        user.middleName = self.middleNameProperty.value
        user.lastName = self.lastNameProperty.value
        user.email = self.emailProperty.value
        user.mobileNumber = self.mobileNumberProperty.value
        user.landline = self.landlineProperty.value
    }
    
    var updateButtonEnabled: Property<Bool>{
        return Property.combineLatest(firstNameProperty, lastNameProperty, idNumberProperty, emailProperty, mobileNumberProperty).map { firstName, lastName, idNumber, email, mobileNumber in
            return !firstName.isEmpty && !lastName.isEmpty && !idNumber.isEmpty && !email.isEmpty && !mobileNumber.isEmpty
        }
    }
    
    func update(onStart: @escaping (() -> ()), completionObserver: Signal<String, NetworkError>.Observer) -> Action<Void, String, NetworkError> {
        return Action<Void, String, NetworkError>(enabledIf: self.updateButtonEnabled) {
            let producer = SignalProducer<String, NetworkError> { observer, lifetime in
                self.updateUserValues()
                RequestManager.shared.update(user: self.user) { success, response in
                    guard success, let message = response?["message"] as? String else {
                        observer.send(error: .failed(nil))
                        return
                    }
                    if success {
                        observer.send(value: message)
                        observer.sendCompleted()
                    }
                    else {
                        observer.send(error: .failed(message))
                    }
                }
            }
            producer.on(starting: onStart).start(completionObserver)
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
