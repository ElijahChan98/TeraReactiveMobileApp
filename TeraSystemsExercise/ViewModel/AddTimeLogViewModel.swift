//
//  AddTimeLogViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/25/21.
//

import UIKit
import ReactiveSwift

class AddTimeLogViewModel {
    var type = MutableProperty<String>("")
    let timeLogTypes: [String] = ["Time Out" ,
                                  "Break In",
                                  "Break Out",
                                  "Time In"
    ]
    
    func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: Date())
    }
    
    private func getTypeCode() -> String {
        switch type.value {
        case "Time In":
            return "1"
        case "Break Out":
            return "2"
        case "Break In":
            return "3"
        case "Time Out":
            return "4"
        default:
            return "Unknown type"
        }
    }
    
    func addTimeLog(completionObserver: Signal<String, NetworkError>.Observer) -> Action<Void, String, NetworkError> {
        return Action<Void, String, NetworkError> {
            let producer = SignalProducer<String, NetworkError> { observer, lifetime in
                let code = self.getTypeCode()
                let userId = RequestManager.shared.currentUserId!
                RequestManager.shared.addTimeLog(userId: userId, type: code) { _, response in
                    guard let payload = response,
                          let loginResponse: LoginResponse = CodableObjectFactory.objectFromPayload(payload) else {
                        observer.send(error: .failed(nil))
                        return
                    }
                    if loginResponse.status == "0" {
                        observer.send(value: loginResponse.message ?? "Success")
                        observer.sendCompleted()
                    }
                        else {
                        observer.send(error: .failed(loginResponse.message ?? "Something went wrong, please try again later"))
                    }
                }
            }
            producer.start(completionObserver)
            return producer
        }
    }
    
    func addTimeLogResponseObserver(actionOnSuccess: @escaping (_ message: String) -> (), actionOnFail: @escaping (_ message: String) -> ()) -> Signal<String, NetworkError>.Observer {
        return Signal<String, NetworkError>.Observer { message in
            actionOnSuccess(message)
        } failed: { error in
            actionOnFail(error.description)
        } completed: {
            
        } interrupted: {
            
        }
    }
}
