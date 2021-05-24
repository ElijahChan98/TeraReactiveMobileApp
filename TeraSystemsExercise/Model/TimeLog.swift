//
//  TimeLog.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/24/21.
//

import UIKit

struct TimeLog: Codable {
    enum CodingKeys: String, CodingKey {
        case date
        case timeIn
        case breakOut
        case breakIn
        case timeOut
    }
    var date: String
    var timeIn: String?
    var breakOut: String?
    var breakIn: String?
    var timeOut: String?
}
