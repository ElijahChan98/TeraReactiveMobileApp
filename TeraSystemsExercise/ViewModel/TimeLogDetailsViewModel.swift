//
//  TimeLogDetailsViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/25/21.
//

import UIKit
import ReactiveSwift

class TimeLogDetailsViewModel {
    var timeLog: MutableProperty<TimeLog>!
    
    init(timeLog: TimeLog) {
        self.timeLog = MutableProperty<TimeLog>(timeLog)
    }
    
    func getDateInFormat(_ stringFormat: String) -> String{
        return timeLog.value.date.stringDate(in: "MM/dd/yyyy", out: "MMMM d")
    }
}
