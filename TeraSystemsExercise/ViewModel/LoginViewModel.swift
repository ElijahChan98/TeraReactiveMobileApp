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
    unowned var user: User!
    var usernameProperty = MutableProperty<String>("")
    var passwordProperty = MutableProperty<String>("")
    
    func loginAction(onStart: @escaping (() -> ()), completionObserver: Signal<User, NetworkError>.Observer) -> Action<Void, User, NetworkError>{
        return Action<Void, User, NetworkError>(enabledIf: self.validator) {
            let producer = SignalProducer<User, NetworkError> { observer, lifetime in
                RequestManager.shared.login(username: self.usernameProperty.value, password: self.passwordProperty.value) { success, response in
                    guard let payload = response,
                          let loginResponse: LoginResponse = CodableObjectFactory.objectFromPayload(payload) else {
                        observer.send(error: .failed(nil))
                        return
                    }
                    guard loginResponse.status == "0" else {
                        observer.send(error: .failed(loginResponse.message!))
                        return
                    }
                    self.user = loginResponse.user
                    observer.send(value: loginResponse.user!)
                    observer.sendCompleted()
                }
            }
            producer.on(starting: onStart).start(completionObserver)
            return producer
        }
    }
    
    func loginResponseObserver(actionOnSuccess: @escaping (_ user: User) -> (), actionOnFail: @escaping (_ message: String) -> ()) -> Signal<User, NetworkError>.Observer {
        return Signal<User, NetworkError>.Observer { user in
            actionOnSuccess(user)
        } failed: { error in
            actionOnFail(error.description)
        } completed: {
            
        } interrupted: {
            
        }

    }
    
    var validator: Property<Bool> {
        return Property.combineLatest(usernameProperty, passwordProperty).map { username, password in
            return username.count > 0 && password.count > 0
        }
    }
}
