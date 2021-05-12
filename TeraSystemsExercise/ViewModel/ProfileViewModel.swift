//
//  ProfileViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/7/21.
//

import UIKit
import ReactiveSwift

class ProfileViewModel {
    var user: User!
    weak var delegate: ProfileViewModelProtocol?
    
    init(user: User) {
        self.user = user
    }
    
    func updateUser(user: User) {
        self.user = user
        delegate?.reloadUserLabels()
    }
    
    var fullName: Property<String> {
        let fullName = [user.firstName, user.middleName ?? "", user.lastName]
        let fullNameSignalProducer: SignalProducer<String, Never> = SignalProducer<String, Never> { observer, lifetime in
            observer.send(value: fullName.joined(separator: " "))
            observer.sendCompleted()
        }
        return Property<String>(initial: "", then: fullNameSignalProducer)
    }
    
    var initials: Property<String>{
        let fullName = [user.firstName, user.middleName ?? "", user.lastName]
        let initialsSignalProducer: SignalProducer<String, Never> = SignalProducer<String, Never> { observer, lifetime in
            observer.send(value: fullName.reduce("") { $0 + $1.prefix(1) })
            observer.sendCompleted()
        }
        return Property<String>(initial: "", then: initialsSignalProducer)
    }
}

protocol ProfileViewModelProtocol: AnyObject {
    func reloadUserLabels()
}
