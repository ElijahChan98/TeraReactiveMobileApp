//
//  LoginViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/7/21.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class LoginViewModel {
    var user: User!
    var usernameProperty = MutableProperty<String>("")
    var passwordProperty = MutableProperty<String>("")
    
    func login(completion: @escaping  (_ success: Bool, _ message: String) -> ()) {
        let valuesNotEmpty: SignalProducer<Bool, Never> = SignalProducer { observer, lifetime in
            guard !lifetime.hasEnded else {
                observer.sendInterrupted()
                return
            }
            observer.send(value: self.usernameProperty.value.count > 0 && self.passwordProperty.value.count > 0)
            observer.sendCompleted()
        }
        
        let action = Action<(String, String), Void, Never> { username, password in
            return SignalProducer<Void, Never> { observer, _ in
                RequestManager.shared.login(username: username, password: password) { success, response in
                    guard success, let response = response else {
                        completion(false, "Something went wrong, please try again later")
                        return
                    }
                    guard let payload = response["user"] as? [String: Any], let user: User = CodableObjectFactory.objectFromPayload(payload) else {
                        completion(false, response["message"] as? String ?? "Something went wrong, please try again later")
                        return
                    }
                    self.user = user
                    completion(true, "Login Success")
                }
            }
        }
        
        let valuesEmptyObserver = Signal<Bool, Never>.Observer { success in
            if success {
                action.apply((self.usernameProperty.value, self.passwordProperty.value)).start()
            }
            else {
                completion(false, "Please fill out all of the required fields")
            }
        } completed: {
            print("completed")
        } interrupted: {
            print("interrupted")
        }
        
        valuesNotEmpty.start(valuesEmptyObserver)
    }
}
