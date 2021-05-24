//
//  TimeLogsViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/24/21.
//

import UIKit

class TimeLogsViewModel {
    var user: User!
    var timeLogs: [TimeLog]?
    
    init(user: User) {
        self.user = user
    }
    //obviously, make this reactive
    func fetchTimeLogs(completion: @escaping ()->()) {
        RequestManager.shared.fetchTimeLogs(userId: user.id) { success, response in
            guard let payload = response,
                  let loginResponse: LoginResponse = CodableObjectFactory.objectFromPayload(payload) else {
                return
            }
            guard loginResponse.status == "0" else {
                return
            }
            self.timeLogs = loginResponse.timeLogs
            completion()
        }
    }
}
