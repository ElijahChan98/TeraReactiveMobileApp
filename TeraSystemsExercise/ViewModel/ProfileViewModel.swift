//
//  ProfileViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/7/21.
//

import UIKit
import ReactiveSwift

class ProfileViewModel {
    let user: MutableProperty<User>!
    
    init(user: User) {
        self.user = MutableProperty<User>(user)
    }
    
    func updateUser(user: User) {
        self.user.value = user
    }
}
