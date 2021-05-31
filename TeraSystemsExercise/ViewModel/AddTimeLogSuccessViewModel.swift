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
}
