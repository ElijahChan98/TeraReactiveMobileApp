//
//  RemainingLeavesTableController.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 6/1/21.
//

import UIKit
import ReactiveSwift

class LeavesRemainingTableController: NSObject, UITableViewDelegate, UITableViewDataSource {
    var viewModel: LeavesViewModel!
    
    init(viewModel: LeavesViewModel) {
        self.viewModel = viewModel
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.remainingLeaves.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RemainingLeavesCell
        let leave = viewModel.remainingLeaves.value[indexPath.row]
        
        for (type, amount) in leave {
            cell.type.text = type
            cell.amount.text = amount
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 41.0
    }
}
