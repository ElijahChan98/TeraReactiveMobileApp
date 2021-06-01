//
//  FileLeaveViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/27/21.
//

import UIKit
import ReactiveSwift

class FileLeaveViewModel {
    var choices: [LeaveType] = [
        .WholeDay,
        .Afternoon,
        .Morning
    ]
    var leaveType = MutableProperty<String>("1")
    var timeSpan = MutableProperty<String>(LeaveType.WholeDay.rawValue)
    var startDate = MutableProperty<String>("Date")
    var endDate = MutableProperty<String>("Date")
    
    private var start: Date {
        return DateFormatter().date(from: startDate.value) ?? Date()
    }
    private var end: Date {
        return DateFormatter().date(from: endDate.value) ?? Date()
    }
    
    var leave = MutableProperty<Leaves>(Leaves())
    
    init() {
        self.mapLeave()
    }
    
    func mapLeave() {
        self.leave <~ Property.combineLatest(leaveType, timeSpan, startDate, endDate).map({ (type, time, start, end) in
            var createdLeave = Leaves()
            createdLeave.type = type
            createdLeave.time = time
            createdLeave.dateFrom = start
            if createdLeave.timeValue == "1" {
                createdLeave.dateTo = end
            }
            
            return createdLeave
        })
    }
    
    var doneButtonEnabled: Property<Bool> {
        return Property.combineLatest(startDate, endDate, timeSpan).map { start, end, span in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy"
            return span != LeaveType.WholeDay.rawValue || formatter.date(from: start)! < formatter.date(from: end)!
        }
    }
    
    func fileLeave(completionObserver: Signal<String, NetworkError>.Observer) -> Action<Void, String, NetworkError> {
        return Action<Void, String, NetworkError>(enabledIf: self.doneButtonEnabled) {
            let producer = SignalProducer<String, NetworkError> { observer, lifetime in
                RequestManager.shared.fileLeave(leave: self.leave.value) { _, response in
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
    var typeValue: String {
        switch typeAbbreviation {
        case "VL":
            return "Vacation Leave"
        case "SL":
            return "Sick Leave"
        default:
            return "N/A"
        }
    }
}
