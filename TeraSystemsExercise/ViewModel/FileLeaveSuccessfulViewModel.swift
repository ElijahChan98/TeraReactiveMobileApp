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
}
