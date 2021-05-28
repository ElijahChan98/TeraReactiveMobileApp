//
//  FileLeaveSuccessfulViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/28/21.
//

import UIKit
import ReactiveSwift

class FileLeaveSuccessfulViewModel {
    weak var leave: MutableProperty<Leaves>!
    
    init(leave: MutableProperty<Leaves>) {
        self.leave = leave
    }
    
    func fileLeave(completionObserver: Signal<String, NetworkError>.Observer) -> Action<Void, String, NetworkError> {
        return Action<Void, String, NetworkError> {
            let producer = SignalProducer<String, NetworkError> { observer, lifetime in
                RequestManager.shared.fileLeave(leave: self.leave.value) { success, response in
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
    
    func fileLeaveResponseObserver(actionOnSuccess: @escaping (_ message: String) -> (), actionOnFail: @escaping (_ message: String) -> ()) -> Signal<String, NetworkError>.Observer {
        return Signal<String, NetworkError>.Observer { message in
            actionOnSuccess(message)
        } failed: { error in
            actionOnFail(error.description)
        } completed: {
            
        } interrupted: {
            
        }
    }
}

extension Leaves {
    func typeFullValue() -> String {
        if self.typeValue == "VL" {
            return "Vacation Leave"
        }
        else if self.typeValue == "SL" {
            return "Sick Leave"
        }
        else {
            return "Error Type"
        }
    }
}
