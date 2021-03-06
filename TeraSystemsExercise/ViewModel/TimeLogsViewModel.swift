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
        RequestManager.shared.fetchTimeLogs() { success, response in
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
