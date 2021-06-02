//
//  LeavesViewModel.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/27/21.
//

import UIKit
import ReactiveSwift

class LeavesViewModel {
    private var maxSickLeaves = 13.0
    private var maxVacationLeaves = 15.0
    var leaves: [MutableProperty<Leaves?>]?
    var remainingLeaves = MutableProperty<[[String : String]]?>( [[:],
                                                                  [:]] )
    private var totalSickLeaves: String = ""
    private var totalVacationLeaves: String = ""
    
    func getLeaves(completion: @escaping ()->()) {
        RequestManager.shared.getLeaves() { success, response in
            guard let payload = response,
                  let loginResponse: LoginResponse = CodableObjectFactory.objectFromPayload(payload) else {
                return
            }
            guard loginResponse.status == "0" else {
                return
            }
            self.leaves = loginResponse.leaves?.map({return MutableProperty<Leaves?>($0)})
            self.mapTotalLeaves()
            completion()
        }
    }
    
    func mapTotalLeaves() {
        self.leaves.map { allLeaves in
            for leave in allLeaves {
                leave.map { [weak self] value in
                    guard let self = self else {return}
                    let days = Double(value?.totalNumberOfDays() ?? "0") ?? 0.0
                    switch value?.type {
                    case "1":
                        self.totalVacationLeaves = "\(self.maxVacationLeaves - days)"
                        break
                    case "2":
                        self.totalSickLeaves = "\(self.maxSickLeaves - days)"
                        break
                    default:
                        break
                    }
                    self.remainingLeaves.value = [
                        ["Vacation Leaves" : self.totalVacationLeaves],
                        ["Sick Leaves" : self.totalSickLeaves]
                    ]
                }
            }
        }
    }
}
