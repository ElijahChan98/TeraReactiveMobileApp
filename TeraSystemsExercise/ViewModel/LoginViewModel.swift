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
    
    func loginAction(completion: @escaping  (_ success: Bool, _ message: String) -> ()) ->  Action<Void, Void, Never>{
        return Action<Void, Void, Never> {
            return SignalProducer<Void, Never> { observer, lifetime in
                RequestManager.shared.login(username: self.usernameProperty.value, password: self.passwordProperty.value) { success, response in
                    guard let payload = response,
                          let loginResponse: LoginResponse = CodableObjectFactory.objectFromPayload(payload) else {
                        completion(false, "Something went wrong, please try again later")
                        observer.sendCompleted()
                        return
                    }
                    guard loginResponse.status == "0" else {
                        completion(false, loginResponse.message!)
                        observer.sendCompleted()
                        return
                    }
                    self.user = loginResponse.user
                    completion(success, "Success")
                    observer.sendCompleted()
                }
            }
        }
    }
    
    var validator: Property<Bool> {
        return Property.combineLatest(usernameProperty, passwordProperty).map { username, password in
            return username.count > 0 && password.count > 0
        }
    }
    
    func loginButtonObserver(actionIfEnabled: @escaping () -> (), actionIfDisabled: @escaping () -> ()) -> Signal<Bool,Never>.Observer {
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
}
