//
//  ProfileViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/7/21.
//

import UIKit
import ReactiveSwift

class ProfileViewModel {
    private var user: User!
    var userProperty: UserProperty!
    
    init(user: User) {
        self.user = user
        self.userProperty = UserProperty(user: user)
    }
    
    func updateUser(user: User) {
        self.user = user
        self.userProperty.update(user: user)
    }
    
    var fullNameProducer: SignalProducer<String, Never> {
        let signalProducer: SignalProducer<String, Never>
        
        signalProducer = SignalProducer.combineLatest(userProperty.firstNameProperty, userProperty.middleNameProperty, userProperty.lastNameProperty).map { firstname, middlename, lastname in
            let fullName: [String] = [firstname, (middlename ?? ""), lastname].filter { $0.count > 0 }
            return fullName.joined(separator: " ")
        }
        return signalProducer
    }
    
    var initialsProducer: SignalProducer<String, Never> {
        let signalProducer: SignalProducer<String, Never>
        
        signalProducer = SignalProducer.combineLatest(userProperty.firstNameProperty, userProperty.lastNameProperty).map { firstname, lastname in
            let fullName: [String] = [firstname, lastname]
            return fullName.reduce("") { $0 + $1.prefix(1) }
        }
        return signalProducer
    }
}
