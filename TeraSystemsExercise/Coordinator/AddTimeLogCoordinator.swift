//
//  AddTimeLogCoordinator.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/25/21.
//

import UIKit

class AddTimeLogCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parent: TimeLogsCoordinator?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let addTimeLogVC = AddTimeLogViewController()
        addTimeLogVC.delegate = self
        let testNav = UINavigationController(rootViewController: addTimeLogVC)
        testNav.modalPresentationStyle = .fullScreen
        self.navigationController = testNav
        parent?.navigationController.present(testNav, animated: true, completion: nil)
    }
}

extension AddTimeLogCoordinator: AddTimeLogDelegate {
    func addTimeLogDone(type: String, time: String) {
        let viewModel = AddTimeLogSuccessViewModel(type: type, time: time)
        let addTimeLogSuccessVC = AddTimeLogSuccessViewController(viewModel: viewModel)
        addTimeLogSuccessVC.delegate = self
        self.navigationController.pushViewController(addTimeLogSuccessVC, animated: true)
    }
    func closeAddTimeLog(reloadLogs: Bool) {
        parent?.navigationController.dismiss(animated: true) { [weak self] in
            if reloadLogs {
                self?.parent?.reloadLogs()
            }
            self?.parent?.childDidFinish(self)
        }
    }
}
