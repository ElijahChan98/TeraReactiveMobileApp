//
//  FileLeaveCoordinator.swift
//  TeraSystemsExercise
//
//  Created by Elijah Tristan H. Chan on 5/28/21.
//

import UIKit
import ReactiveSwift

class FileLeaveCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var parent: LeavesCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = FileLeaveViewModel()
        let fileLeaveVC = FileLeaveViewController(viewModel: viewModel)
        fileLeaveVC.delegate = self
        let nav = UINavigationController(rootViewController: fileLeaveVC)
        nav.modalPresentationStyle = .fullScreen
        self.navigationController = nav
        parent?.navigationController.present(nav, animated: true, completion: nil)
    }
}

extension FileLeaveCoordinator: FileLeaveDelegate {
    func closeFileLeave(reloadLeaves: Bool) {
        parent?.navigationController.dismiss(animated: true) { [weak self] in
            if reloadLeaves {
                self?.parent?.reloadLeaves()
            }
            self?.parent?.childDidFinish(self)
        }
    }
    
    func fileLeaveDone(leave: MutableProperty<Leaves>) {
        let viewModel = FileLeaveSuccessfulViewModel(leave: leave)
        let fileLeaveSuccessfulVC = FileLeaveSuccessfulViewController(viewModel: viewModel)
        fileLeaveSuccessfulVC.delegate = self
        self.navigationController.pushViewController(fileLeaveSuccessfulVC, animated: true)
    }
}
