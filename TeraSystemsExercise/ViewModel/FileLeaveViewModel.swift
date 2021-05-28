//
//  FileLeaveViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/27/21.
//

import UIKit
import ReactiveSwift

class FileLeaveViewModel {
    var choices = [
        "Whole Day",
        "Afternoon",
        "Morning"
    ]
    var leaveType = MutableProperty<String>("1")
    var timeSpan = MutableProperty<String>("Whole Day")
    var startDate = MutableProperty<String>("Date")
    var endDate = MutableProperty<String>("Date")
    
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
}
