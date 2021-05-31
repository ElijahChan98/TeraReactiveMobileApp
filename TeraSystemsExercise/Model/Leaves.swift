//
//  Leaves.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/27/21.
//

import UIKit

struct Leaves: Codable{
    enum CodingKeys: String, CodingKey {
        case type
        case dateFrom
        case dateTo
        case time
    }
    var type: String
    var dateFrom: String
    var dateTo: String?
    var time: String
    
    var typeAbbreviation: String {
        switch type {
        case "1":
            return "VL"
        case "2":
            return "SL"
        default:
            return "N/A"
        }
    }
    
    var timeValue: String {
        switch time {
        case "Whole Day":
            return "1"
        case "Afternoon":
            return "2"
        case "Morning":
            return "3"
        default:
            return "0"
        }
    }
    
    func totalNumberOfDays() -> String {
        guard self.time == "1" else {
            return "0.5"
        }
        guard let dateTo = self.dateTo else {
            return "1"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        if let to = formatter.date(from: dateTo), let from = formatter.date(from: dateFrom) {
            let numberOfDays = Calendar.current.dateComponents([.day], from: from, to: to)
            return "\(numberOfDays.day! + 1)"
        }
        else {
            return "0"
        }
    }
    
    init() {
        self.type = ""
        self.dateFrom = ""
        self.dateTo = ""
        self.time = ""
    }
}
