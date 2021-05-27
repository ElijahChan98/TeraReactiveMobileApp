//
//  LeavesViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/27/21.
//

import UIKit
import ReactiveSwift

class LeavesViewModel {
    var leaves: [MutableProperty<Leaves?>]?
    
    func getLeaves(completion: @escaping ()->()) {
        RequestManager.shared.getLeaves() { success, response in
            guard let payload = response,
                  let loginResponse: LoginResponse = CodableObjectFactory.objectFromPayload(payload) else {
                return
            }
            guard loginResponse.status == "0" else {
                return
            }
            self.leaves = loginResponse.leaves?.map({return MutableProperty<Leaves?>($0)})
            completion()
        }
    }
}
