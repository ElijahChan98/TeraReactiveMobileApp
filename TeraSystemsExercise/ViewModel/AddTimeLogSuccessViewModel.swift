//
//  AddTimeLogSuccessViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/25/21.
//

import UIKit
import ReactiveSwift

class AddTimeLogSuccessViewModel {
    var type: MutableProperty<String>!
    var time: MutableProperty<String>!
    
    init(type: String, time: String) {
        self.type = MutableProperty<String>(type)
        self.time = MutableProperty<String>(time)
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
                RequestManager.shared.addTimeLog(userId: userId, type: code) { success, response in
                    guard success, let message = response?["message"] as? String else {
                        observer.send(error: .failed(nil))
                        return
                    }
                    if success {
                        observer.send(value: message)
                        observer.sendCompleted()
                    }
                    else {
                        observer.send(error: .failed(message))
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
