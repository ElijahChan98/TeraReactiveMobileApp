//
//  TimeLogsViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/24/21.
//

import UIKit
import ReactiveSwift

class TimeLogsViewModel {
    var timeLogs: [MutableProperty<TimeLog?>]?
    
    func fetchTimeLogs(completion: @escaping ()->()) {
        guard let userId = RequestManager.shared.currentUserId else {
            return
        }
        RequestManager.shared.fetchTimeLogs(userId: userId) { success, response in
            guard let payload = response,
                  let loginResponse: LoginResponse = CodableObjectFactory.objectFromPayload(payload) else {
                return
            }
            guard loginResponse.status == "0" else {
                return
            }
            self.timeLogs = loginResponse.timeLogs?.map({return MutableProperty<TimeLog?>($0)})
            completion()
        }
    }
}
