//
//  AddTimeLogViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/25/21.
//

import UIKit
import ReactiveSwift

class AddTimeLogViewModel {
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
}
