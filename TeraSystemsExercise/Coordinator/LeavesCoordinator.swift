//
//  LeavesCoordinator.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/27/21.
//

import UIKit

class LeavesCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private var leavesVC: LeavesViewController!
    weak var parent: MenuTabBarCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = LeavesViewModel()
        self.leavesVC = LeavesViewController(viewModel: viewModel)
        self.leavesVC.delegate = self
        self.navigationController.pushViewController(leavesVC, animated: false)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
            }
        }
    }
}

extension LeavesCoordinator: LeavesDelegate {
    func fileLeave() {
        let viewModel = FileLeaveViewModel()
        let fileLeaveVC = FileLeaveViewController(viewModel: viewModel)
        self.navigationController.pushViewController(fileLeaveVC, animated: true)
    }
}
